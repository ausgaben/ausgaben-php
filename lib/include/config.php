<?php

    /**
    * Global configuration file
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Configuration
    */

    error_reporting(E_ALL);

    require_once 'PEAR.php';
    require_once 'lib/include/config_local.php';

    $CONFIG['DataObject'] = array(
        'database'        => $CONFIG['database']['dsn'],
        'schema_location' => "{$CONFIG['path']['home']}/lib/dataobjects",
        'class_location'  => "{$CONFIG['path']['home']}/lib/dataobjects",
        'require_prefix'  => "{$CONFIG['path']['home']}/lib/dataobjects",
        'class_prefix'    => 'DataObject_',
    );
    $CONFIG['auth'] = array(
        'dsn'         => $CONFIG['database']['dsn'],
        'table'       => 'user',
        'usernamecol' => 'email',
        'passwordcol' => 'password',
    );
    $CONFIG['version'] = array(
        'major'        => 0,
        'minor'        => 2,
    );
    $DOOptions = &PEAR::getStaticProperty('DB_DataObject', 'options');
    $DOOptions = $CONFIG['DataObject'];

    ini_set('session.cookie_path', dirname($_SERVER['SCRIPT_NAME']));

?>
