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

    /**
    * Auth
    */
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
            $_SESSION['user']['settings'] = unserialize($_SESSION['user']['settings']);
            if (!is_array($_SESSION['user']['settings'])) $_SESSION['user']['settings'] = array();
        }
        // Update last_login
        $User->last_login = strftime('%Y%m%d%H%M%S');
        $User->update();
    }
    if (isset($_SESSION['user']) and isset($_SESSION['user']['locale'])) {
        setlocale(LC_ALL, $_SESSION['user']['locale']);
    }

    if ($logout) {
        // Einstellungen speichern
        $User = DB_DataObject::factory('user');
        $User->get($_SESSION['user']['user_id']);
        $User->settings = serialize($_SESSION['user']['settings']);
        $User->update();
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
        $_SESSION['user']['settings']['last_account_id'] = $account_id;
    } else {
        if (isset($_SESSION['user']['settings']['last_account_id'])) {
            $account_id = $_SESSION['user']['settings']['last_account_id'];
        }
    }
    $_SESSION['account_id'] = $account_id;
    $_SESSION['display_month'] = $display_month;

    // Display settings
    $ifviewsettings = getVar(&$_REQUEST['ifviewsettings'], false);
    if ($ifauthed and $ifviewsettings) {
        $_SESSION['user']['settings']['separate_sums'] = getVar(&$_REQUEST['separate_sums'], true);
    }
    $_SESSION['user']['settings']['separate_sums'] = getVar(&$_SESSION['user']['settings']['separate_sums'], true);
    $separate_sums = $_SESSION['user']['settings']['separate_sums'];

    // Load Settings for the app
    $settings = array();
    $app_settings = DB_DataObject::factory('settings');
    $app_settings->scope = 0;
    if ($app_settings->find()) {
        while ($app_settings->fetch()) {
            $settings[$app_settings->name] = $app_settings->value;
        }
    }
    
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