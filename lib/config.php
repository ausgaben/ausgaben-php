<?php

    /**
    * Global configuration file
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Configuration
    */
    
    require_once 'PEAR.php';
    
    $CONFIG['DSN'] = 'mysql://ausgaben:HBkYXw_F@localhost/ausgaben';
    $CONFIG['path'] = array(
        'home' => '/var/www/tacker.org/www/htdoc/ausgaben',
        'smarty' => '/usr/lib/php/Smarty/',
    );
    $CONFIG['DataObject'] = array(
        'database'        => $CONFIG['DSN'],
        'schema_location' => "{$CONFIG['path']['home']}/lib/dataobjects",
        'class_location'  => "{$CONFIG['path']['home']}/lib/dataobjects",
        'require_prefix'  => "{$CONFIG['path']['home']}/lib/dataobjects",
        'class_prefix'    => 'DataObject_',
    );
    $CONFIG['auth'] = array(
        'dsn'         => $CONFIG['DSN'],
        'table'       => 'user',
        'usernamecol' => 'email',
        'passwordcol' => 'password',
    );
    $CONFIG['secret'] = 'aWvFssAV9R8YyuZhX#Bm_FxU*Qed4!ad';
    $DOOptions = &PEAR::getStaticProperty('DB_DataObject', 'options');
    $DOOptions = $CONFIG['DataObject'];
    
    setlocale(LC_ALL, 'de_DE@euro');
    
?>