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
    require_once 'lib/include/config.php';
    require_once 'lib/functions/getVar.php';
    require_once 'lib/functions/updateAbf.php';
    require_once 'lib/classes/SmartyPage.php';
    require_once 'lib/classes/SpendingMailer.php';
    require_once 'lib/classes/SpendingFilter.php';
    require_once 'lib/classes/Settings.php';
    require_once 'Auth.php';
    require_once 'Date.php';
    require_once 'DB/DataObject.php';
    require_once 'Net/UserAgent/Detect.php';

    /**
    * Pull some vars from the request
    */
    $do               = getVar(&$_REQUEST['do'], 'start');
    $action           = getVar(&$_REQUEST['action'], '');
    $ifsubmit         = getVar(&$_REQUEST['ifsubmit'], false);
    $ifdelete         = getVar(&$_REQUEST['ifdelete'], false);
    $ifduplicate      = getVar(&$_REQUEST['ifduplicate'], false);
    $logout           = getVar(&$_REQUEST['logout'], false);
    session_start();
    $display_month    = getVar(&$_REQUEST['display_month'], (isset($_SESSION['display_month'])) ? $_SESSION['display_month'] : strftime('%Y%m01000000'));

    /**
    * Get Browser
    */
    $Browser = new Net_Useragent_Detect;
    
    // Login User
    $Auth = new Auth('DB', $CONFIG['auth'], '', false);
    $Auth->start();
    $ifauthed = $Auth->getAuth();
    $DISPLAYDATA['AUTH'] = $ifauthed;
    $DISPLAYDATA['AUTH_STATUS'] = $Auth->getStatus();
    if ($ifauthed and isset($_REQUEST['password'])) {
        $User = DB_DataObject::factory('user');
        $User->whereAdd("email='".$Auth->getUsername()."'");
        if ($User->find(true)) {
            $_SESSION['user'] = $User->toArray();
        }
        // Update last_login
        $User->last_login = strftime('%Y%m%d%H%M%S');
        $User->update();
    }
    if (isset($_SESSION['user']) and isset($_SESSION['user']['locale'])) {
        setlocale(LC_ALL, $_SESSION['user']['locale']);
    }
    
    // Settings for the current User
    $Settings = new Settings();
    if ($ifauthed) {
    	$Settings->init($_SESSION['user']['user_id']);
    	$_SESSION['user']['settings'] = $Settings->get();
    }

    if ($logout) {
        // Einstellungen speichern
        $Settings->save();
        // Neue Ausgaben senden
        if (isset($_SESSION['user'])) {
            $SpendingMailer = new SpendingMailer;
            $SpendingMailer->setUser($_SESSION['user']['user_id']);
            $SpendingMailer->send();
        }
        // Ausloggen
        session_destroy();
        header("Location: http://{$_SERVER['HTTP_HOST']}{$_SERVER['SCRIPT_NAME']}");
        return;
    }

    if ($ifauthed and $do == 'start') $do = 'spendings';
    if (!$ifauthed) $do = 'start';

    // Selected Account
    $account_id = getVar(&$_REQUEST['account_id'], 0);
    if ($account_id) {
        $Settings->set('last_account_id', $account_id);
    } else {
    	$account_id = intval($Settings->get('last_account_id'));
    }
    $_SESSION['account_id'] = $account_id;
    $_SESSION['display_month'] = $display_month;

    // Load Settings for the app
    $settings = array();
    $AppSettings = DB_DataObject::factory('settings');
    $AppSettings->scope = 0;
    if ($AppSettings->find()) {
        while ($AppSettings->fetch()) {
            $settings[$AppSettings->name] = $AppSettings->value;
        }
    }
    $DISPLAYDATA['settings'] = $settings;
    
    /**
    * Action
    */
    switch ($do) {
    // User has to be logged in to view these
    case 'spendings':
    case 'import':
        if(!$ifauthed) break;
        require_once 'lib/include/index.' . $do . '.php';
        break;
    // User has to be logged in and admin to view these
    case 'accounts':
        if(!$ifauthed) break;
        if (!$_SESSION['user']['admin']) break;
        require_once 'lib/include/index.' . $do . '.php';
        break;
    // May be accessed by everyone
    case 'update_abf':
        $relocateDo ='spendings';
        updateAbf($account_id);
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

    $_SESSION['do'] = $do;
    
    /**
    * Relocate if required
    */
    if (isset($relocateDo)) {
        $_SESSION['do'] = $relocateDo;
        $target = $proto . $_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME'] . '?do=' . $relocateDo;
        if (isset($relocateId)) $target .= '#' . $relocateId;
        header('Location: ' . $target);
        return;
    }

    /**
    * Display
    */
    $DISPLAYDATA['locale_conv'] = localeconv();
    $DISPLAYDATA['isIE'] = $Browser->isIE();
    $DISPLAYDATA['do'] = $do;
    $DISPLAYDATA['action'] = $action;
    $DISPLAYDATA['version'] = $CONFIG['version'];
    $Smarty = new SmartyPage;
    $Smarty->template_dir .= '/' . $settings['theme'];
    $Smarty->display($do. '.tpl');

?>