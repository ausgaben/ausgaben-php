<?php

    /**
    * Create DataObjects
    *
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Backend
    */
    
    /**
    * Include required files
    */
    require_once 'lib/config.php';
	require_once 'DB/DataObject/Generator.php';

	DB_DataObject::debugLevel(1);
	$generator = new DB_DataObject_Generator;
	$generator->start();
	
?>
