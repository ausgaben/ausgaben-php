<?php

    /**
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Backend
    */
    
    /**
    * Class which sends spendings created by an user to other users of the accounts
    *
    * @author Markus Tacker <m@tacker.org>
    * @package Ausgaben
    * @subpackage Backend
    */
    class SpendingMailer
    {
        /**
        * @var object       User DataObject
        */
        var $_user;

        /**
        * @var array        User's accounts
        */
        var $_accounts = array();
        
        /**
        * Sets the active user
        *
        * @param int        user id
        * @return bool
        */
        function setUser($user_id)
        {
            // Load user
            $User = DB_DataObject::factory('user');
            if (!$User->get($user_id)) {
                PEAR::raiseError("SpendingMailer::setUser() - User not found '$user_id'");
                return false;
            }
            $this->_user = $User;
            // Load users accounts
            $User2Account = DB_DataObject::factory('user2account');
            $User2Account->user_id = $user_id;
            if (!$User2Account->find()) {
                PEAR::raiseError("SpendingMailer::setUser() - User '$user_id' has no accounts.");
                return false;
            }
            while ($User2Account->fetch()) {
                $Account = DB_DataObject::factory('account');
                if(!$Account->get($User2Account->account_id)) {
                    PEAR::raiseError("SpendingMailer::setUser() - Failed to fetch account '{$User2Account->account_id}'");
                    return false;
                }
                $this->_accounts[$Account->account_id] = $Account->toArray();
            }
            // Load spendings made by this user since his last login
            $Spending = DB_DataObject::factory('spending');
            $Spending->user_id = $user_id;
            $Spending->whereAdd('account_id IN ('.join(',', array_keys($this->_accounts)).')');
            $Spending->whereAdd("timestamp > {$User->last_login}");
            if (!$Spending->find()) {
                PEAR::raiseError("SpendingMailer::setUser() - User '$user_id' has no spendings.");
                return false;
            }
            while ($Spending->fetch()) {
                $Spending->getLinks();
                $this->_spendings[] = $Spending->toArray();
            }
            return true;
        }

        /**
        * Starts the sending process
        *
        * @return bool
        */
        function send()
        {
            if (empty($this->_user)) {
                PEAR::raiseError("SpendingMailer::send() - Load a user first.");
                return false;
            }
            // 
        }
    }

?>
