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
    $do       = getVar(&$_REQUEST['do'], 'start');
    $action   = getVar(&$_REQUEST['action'], '');
    $ifsubmit = getVar(&$_REQUEST['ifsubmit'], false);
    $logout   = getVar(&$_REQUEST['logout'], false);
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
        // Load Households
        if(!isset($_SESSION['household'])) {
            $Household = DB_DataObject::factory('household');
            $result = $Household->find();
            if (!$result) {
                echo "Failed to fetch households";
                die();
            }
            if ($result == 1) {
                $Household->fetch();
                $_SESSION['household'] = $Household->toArray();
            }
        }
        // Insert new spending
        if ($ifsubmit) {
            $spending_id       = getVar(&$_REQUEST['spending_id'], 0);
            $spendingtype_id   = getVar(&$_REQUEST['spendingtype_id'], 0);
            $spendingtype_name = getVar(&$_REQUEST['spendingtype_name'], '');
            $Spending = DB_DataObject::factory('spending');
            if ($spending_id) {
                if (!$Spending->get($spending_id)) {
                    break;
                }
            }
            $Spending->setFrom($_REQUEST);
            $Spending->value = str_replace(',', '.', $Spending->value);
            $Spending->date = sprintf('%04d%02d%02d', $_REQUEST['date_y'], $_REQUEST['date_m'], $_REQUEST['date_d']);
            // If no spendingtype_id isset maybe we should create a new one?
            // -> spendingtype_name must be set
            if (empty($spendingtype_id) and !empty($spendingtype_name)) {
                $Spendingtype = DB_DataObject::factory('spendingtype');
                $Spendingtype->name = trim($spendingtype_name);
                $result = $Spendingtype->find();
                if ($result <= 0) {
                    $result = $Spendingtype->insert(); 
                    if (!$result) {
                        echo "Failed to create new spendingtype";
                        die();
                    }
                    $spendingtype_id = $result;
                } else {
                    $Spendingtype->fetch();
                    $spendingtype_id = $Spendingtype->spendingtype_id;
                }
                $Spending->spendingtype_id = $spendingtype_id;
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
        // Load Spendingtypes
        $Spendingtype = DB_DataObject::factory('spendingtype');
        $Spendingtype->orderBy('name');
        if ($Spendingtype->find()) {
            while($Spendingtype->fetch()) {
                $DISPLAYDATA['spendingtypes'][$Spendingtype->spendingtype_id] = $Spendingtype->toArray();
            }
        }
        // Load Users
        $User = DB_DataObject::factory('user');
        if ($User->find()) {
            while($User->fetch()) {
                $DISPLAYDATA['users'][$User->user_id] = $User->toArray();
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
        $Spending->orderBy('spendingtype_id');
        $Spending->orderBy('day desc');
        $Spending->whereAdd('month='.intval(substr($display_month, 4, 2)));
        $Spending->whereAdd('year='.substr($display_month, 0, 4));
        if ($Spending->find()) {
            while ($Spending->fetch()) {
                $spendingData = $Spending->toArray();
                $spendingData['date'] = sprintf('%04d%02d%02d000000', $Spending->year, $Spending->month, $Spending->day);
                $DISPLAYDATA['spendings'][] = $spendingData;
                $DISPLAYDATA['spendingsums'][$Spending->spendingtype_id] += $Spending->value;
                $DISPLAYDATA['spendingsums']['all'] += $Spending->value;
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
                    $Spending->spendingtype_id = 15; // Importiert vom Kontoauszug
                    $Spending->description = preg_replace('/[0-9]{5,}/', '[n]', ucwords(strtolower((empty($fields[4])) ? $fields[3] : $fields[4].' - '.$fields[3])));
                    $Spending->user_id = $_SESSION['user']['user_id'];
                    $Spending->household_id = 1;
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
    $Smarty = new SmartyPage;
    $Smarty->display("$do.tpl");

?>