<?php

    /**
    * Local configuration settings
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Configuration
    */

    $CONFIG = array(
        'path' => array(
            'smarty'    => '/usr/lib/php/Smarty', // Give the path to your smarty's libs directory
            'home'      => '/var/www/tacker.org/krotok/htdoc/ausgaben', // Installation dir
        ),
        'database' => array(
            'dsn' => 'mysql://ausgaben:HBkYXw_F@localhost/ausgaben',
        ),
    );

?>
