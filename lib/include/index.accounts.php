<?php

	/**
    * Handle Accounts
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Frontend
    */

	$account_id = getVar($_REQUEST['account_id'], 0);
    if ($ifsubmit) {
        $user2account = getVar($_REQUEST['user2account'], array());
        $Account = DB_DataObject::factory('account');
        if ($account_id) {
            $Account->get($account_id);
        }
        if ($ifdelete) {
            $result = $Account->delete();
            if ($result) {
                // Spendings löschen
                $Spending =  DB_DataObject::factory('spending');
                $Spending->account_id = $account_id;
                $Spending->delete();
                // User zuordnung löschen
                $User2Account  = DB_DataObject::factory('user2account');
                $User2Account->account_id = $account_id;
                $User2Account->delete();
                // ABF löschen
                $Account_Abf = DB_DataObject::factory('account_abf');
                $Account_Abf->account_id = $account_id;
                $Account_Abf->delete();
            }
        } else {
            $Account->setFrom($_REQUEST);
            if (!$Account->account_id) {
                $result = $Account->insert();
                $account_id = $result;
            } else {
                $result = $Account->update();
            }
            if ($result) {
                updateAbf($Account->account_id);
            }
            $User2Account  = DB_DataObject::factory('user2account');
            $User2Account->account_id = $account_id;
            $User2Account->delete();
            if (!empty($user2account)) {
                foreach ($user2account as $user_id) {
                    $User2Account = DB_DataObject::factory('user2account');
                    $User2Account->account_id = $account_id;
                    $User2Account->user_id = $user_id;
                    $User2Account->insert();
                }
            }
        }
    }
    // Load users
    $User = DB_DataObject::factory('user');
    $User->orderBy('name');
    $User->orderBy('prename');
    if ($User->find()) {
        while ($User->fetch()) {
            $DISPLAYDATA['users'][] = $User->toArray();
        }
    }
    // Load users to account
    if ($account_id) {
        $User2Account  = DB_DataObject::factory('user2account');
        $User2Account->account_id = $account_id;
        if ($User2Account->find()) {
            while ($User2Account->fetch()) {
                $DISPLAYDATA['user2account'][$User2Account->user_id] = true;
            }
        }
    }
    // Load account
    $Account = DB_DataObject::factory('account');
    $Account->orderBy('name');
    if ($Account->find()) {
        while ($Account->fetch()) {
            $DISPLAYDATA['accounts'][$Account->account_id] = $Account->toArray();
        }
    }
?>
