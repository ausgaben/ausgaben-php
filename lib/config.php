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

    $CONFIG = parse_ini_file('lib/config.ini', true);
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

    setlocale(LC_ALL, $CONFIG['misc']['locale']);

?>