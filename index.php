<?php

    /**
    * Main application file
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Frontend
    */

    /**
    * Include required files
    */
    require_once 'lib/config.php';
    require_once 'lib/functions/getVar.php';
    require_once 'lib/classes/SmartyPage.php';
    require_once 'Auth.php';
    require_once 'DB/DataObject.php';

    /**
    * Pull some vars from the request
    */
    $do               = getVar(&$_REQUEST['do'], 'start');
    $action           = getVar(&$_REQUEST['action'], '');
    $ifsubmit         = getVar(&$_REQUEST['ifsubmit'], false);
    $ifdelete         = getVar(&$_REQUEST['ifdelete'], false);
    $logout           = getVar(&$_REQUEST['logout'], false);
    $display_month    = getVar(&$_REQUEST['display_month'], strftime('%Y%m01000000'));

    /**
    * Auth
    */
    $Auth = new Auth('DB', $CONFIG['auth'], '', false);
    $Auth->start();
    if ($logout) {
        session_destroy();
        header("Location: http://{$_SERVER['HTTP_HOST']}{$_SERVER['SCRIPT_NAME']}");
    }
    $ifauthed = $Auth->getAuth();
    $DISPLAYDATA['AUTH'] = $ifauthed;
    $DISPLAYDATA['AUTH_STATUS'] = $Auth->getStatus();
    if ($ifauthed and !isset($_SESSION['user'])) {
        $User = DB_DataObject::factory('user');
        $User->whereAdd("email='".$Auth->getUsername()."'");
        if ($User->find(true)) $_SESSION['user'] = $User->toArray();
    }

    /**
    * Action
    */
    switch ($do) {
    case 'spendings':
        if(!$ifauthed) break;
        $account_id = getVar(&$_REQUEST['account_id'], 0);
        if ($account_id) {
            $_SESSION['account_id'] = $account_id;
        } else {
            $account_id = $_SESSION['account_id'];
        }
        // Load Accounts
        $Account = DB_DataObject::factory('account');
        $Account->orderBy('name');
        if (!$Account->find()) break;
        while ($Account->fetch()) {
            $DISPLAYDATA['accounts'][$Account->account_id] = $Account->toArray();
        }
        if(!$account_id) break;
        // Insert new spending
        if ($ifsubmit) {
            $spending_id       = getVar(&$_REQUEST['spending_id'], 0);
            $spendinggroup_id   = getVar(&$_REQUEST['spendinggroup_id'], 0);
            $spendinggroup_name = getVar(&$_REQUEST['spendinggroup_name'], '');
            $Spending = DB_DataObject::factory('spending');
            if ($spending_id) {
                if (!$Spending->get($spending_id)) {
                    break;
                }
            }
            $Spending->setFrom($_REQUEST);
            $Spending->value = str_replace(',', '.', $Spending->value);
            $Spending->date = sprintf('%04d%02d%02d', $_REQUEST['date_y'], $_REQUEST['date_m'], $_REQUEST['date_d']);
            // If no spendinggroup_id isset maybe we should create a new one?
            // -> spendinggroup_name must be set
            if (empty($spendinggroup_id) and !empty($spendinggroup_name)) {
                $Spendinggroup = DB_DataObject::factory('spendinggroup');
                $Spendinggroup->name = trim($spendinggroup_name);
                $result = $Spendinggroup->find();
                if ($result <= 0) {
                    $result = $Spendinggroup->insert();
                    if (!$result) {
                        echo "Failed to create new spendinggroup";
                        die();
                    }
                    $spendinggroup_id = $result;
                } else {
                    $Spendinggroup->fetch();
                    $spendinggroup_id = $Spendinggroup->spendinggroup_id;
                }
                $Spending->spendinggroup_id = $spendinggroup_id;
            }
            if ($spending_id) {
                $result = $Spending->update();
            } else {
                $result = $Spending->insert();
            }
            if (!$result) {
                echo "Failed to insert spending.";
                die();
            }
            $relocateDo = 'spendings';
        }
        // Actions
        switch ($action) {
        case 'delete':
            $Spending = DB_DataObject::factory('spending');
            if (!$Spending->get($_REQUEST['spending_id'])) {
                break;
            }
            if ($Spending->user_id == $_SESSION['user']['user_id']) {
                $Spending->delete();
            }
            $relocateDo = 'spendings';
            break;
        }
        // Load Spendinggroups
        $Spendinggroup = DB_DataObject::factory('spendinggroup');
        $Spendinggroup->orderBy('name');
        if ($Spendinggroup->find()) {
            while($Spendinggroup->fetch()) {
                $DISPLAYDATA['spendinggroups'][$Spendinggroup->spendinggroup_id] = $Spendinggroup->toArray();
            }
        }
        // Load years
        $Spending = DB_DataObject::factory('spending');
        $Spending->orderBy('year desc');
        $Spending->orderBy('month desc');
        $Spending->groupBy('year, month');
        if ($Spending->find()) {
            while ($Spending->fetch()) {
                $DISPLAYDATA['months'][] = sprintf('%04d%02d01000000', $Spending->year, $Spending->month);
            }
        }
        // Load Spendings
        $Spending = DB_DataObject::factory('spending');
        $Spending->orderBy('type');
        $Spending->orderBy('spendinggroup_id');
        $Spending->orderBy('day desc');
        $Spending->whereAdd('month='.intval(substr($display_month, 4, 2)));
        $Spending->whereAdd('year='.substr($display_month, 0, 4));
        $Spending->whereAdd("account_id=$account_id");
        if ($Spending->find()) {
            $DISPLAYDATA['sum_type'] = array(0 => 0, 1 => 0, 2 => 0);
            while ($Spending->fetch()) {
                $spendingData = $Spending->toArray();
                // $spendingData['description'] = str_replace("\r\n", '-br-', $spendingData['description']);
                $spendingData['date'] = sprintf('%04d%02d%02d000000', $Spending->year, $Spending->month, $Spending->day);
                $DISPLAYDATA['spendings'][$Spending->type][] = $spendingData;
                if ($Spending->type == SPENDING_TYPE_IN) {
                    $DISPLAYDATA['sum_type'][$Spending->type]              += $Spending->value;
                    $DISPLAYDATA['sum_type'][0]                            += $Spending->value;
                    $DISPLAYDATA['sum_group'][$Spending->spendinggroup_id] += $Spending->value;
                } else {
                    $DISPLAYDATA['sum_type'][$Spending->type]              -= $Spending->value;
                    $DISPLAYDATA['sum_type'][0]                            -= $Spending->value;
                    $DISPLAYDATA['sum_group'][$Spending->spendinggroup_id] -= $Spending->value;
                }
            }
        }
        $DISPLAYDATA['display_month'] = $display_month;
        break;
    case 'statistics':
        if(!$ifauthed) break;
        // Lade Monate und Ausgaben
        $Spending = DB_DataObject::factory('spending');
        $Spending->selectAdd('SUM(value) as value');
        $Spending->orderBy('year desc');
        $Spending->orderBy('month desc');
        $Spending->groupBy('year, month');
        $Spending->find();
        while($Spending->fetch()) {
            $DISPLAYDATA['spendings'][] = array(
                'month' => sprintf('%04d%02d01000000', $Spending->year, $Spending->month, $Spending->day),
                'value' => $Spending->value,
            );
        }
        break;
    case 'import':
        if (!$ifauthed) break;
        if ($ifsubmit) {
            require_once 'HTTP/Upload.php';
            $upload = new HTTP_Upload('de');
            $file = $upload->getFiles('file');
            if (PEAR::isError($file)) {
                die ($file->getMessage());
            }
            if ($file->isValid()) {
                $file->setName('uniq');
                $dest_dir = './var/upload/';
                $dest_name = $file->moveTo($dest_dir);
                if (PEAR::isError($dest_name)) {
                    die ($dest_name->getMessage());
                }
                $real = $file->getProp('real');
                $cvs = "$dest_dir/$dest_name";
                $iffirstline = true;
                $line_append = '';
                $n_imported = 0;
                $n_failed = 0;
                foreach (file($cvs) as $line) {
                    if ($iffirstline) {
                        $iffirstline = false;
                        continue;
                    }
                    if ($line_append != '') {
                        $line = $line_append.$line;
                        $line_append = '';
                    }
                    $fields = explode(';', str_replace('"', '', $line));
                    if (count($fields) < 10) {
                        $line_append = $line;
                        continue;
                    }
                    $Spending = DB_DataObject::factory('spending');
                    $Spending->year  = 2000 + substr($fields[1], 6, 2);
                    $Spending->month = substr($fields[1], 3, 2);
                    $Spending->day   = substr($fields[1], 0, 2);
                    $Spending->spendinggroup_id = 15; // Importiert vom Kontoauszug
                    $Spending->description = preg_replace('/[0-9]{5,}/', '[n]', ucwords(strtolower((empty($fields[4])) ? $fields[3] : $fields[4].' - '.$fields[3])));
                    $Spending->user_id = $_SESSION['user']['user_id'];
                    $Spending->account_id = 1;
                    $value_pre  = str_replace('.', '', substr($fields[7], 1, -3));
                    $value_past = substr($fields[7], -2, 2);
                    $value = $value_pre.'.'.$value_past;
                    $Spending->value = $value;
                    if ($Spending->insert()) {
                        $n_imported++;
                    } else {
                        $n_failed++;
                    }
                    $DISPLAYDATA['n_imported'] = $n_imported;
                    $DISPLAYDATA['n_failed'] = $n_failed;
                }
            } elseif ($file->isError()) {
                echo $file->errorMsg() . "\n";
            }
        }
        break;
    case 'accounts':
        if(!$ifauthed) break;
        if ($ifsubmit) {
            $account_id = getVar(&$_REQUEST['account_id'], 0);
            $Account = DB_DataObject::factory('account');
            if ($account_id) {
                $Account->get($account_id);
            }
            if ($ifdelete) {
                $Account->delete();
            } else {
                $Account->setFrom($_REQUEST);
                if (!$Account->account_id) {
                    $Account->insert();
                } else {
                    $Account->update();
                }
            }
        }
        $Account = DB_DataObject::factory('account');
        $Account->orderBy('name');
        if ($Account->find()) {
            while ($Account->fetch()) {
                $DISPLAYDATA['accounts'][$Account->account_id] = $Account->toArray();
            }
        }
        break;
    default:
        // Benutzer zum Login laden
        $User = DB_DataObject::factory('user');
        if (!$User->find()) break;
        while ($User->fetch()) {
            $DISPLAYDATA['users'][] = $User->toArray();
        }
        $do = 'start';
    }

    /**
    * Relocate if required
    */
    if (isset($relocateDo)) {
        header("Location: http://{$_SERVER['HTTP_HOST']}{$_SERVER['SCRIPT_NAME']}?do=$relocateDo&display_month=$display_month");
        return;
    }

    /**
    * Display
    */
    $DISPLAYDATA['do'] = $do;
    $DISPLAYDATA['action'] = $action;
    $DISPLAYDATA['version'] = $CONFIG['version'];
    $Smarty = new SmartyPage;
    $Smarty->display("$do.tpl");

?>