<?php

    /**
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Frontend
    */

    /**
    * Include smarty
    */
    require_once "{$CONFIG['path']['home']}/lib/functions/javaScriptOut.php";
    require_once "{$CONFIG['path']['home']}/lib/functions/screenOut.php";
    require_once "{$CONFIG['path']['home']}/lib/functions/moneyFormat.php";
	require_once 'Smarty.class.php';

    /**
    * Class which handles general smarty configuration
    *
    * @author Markus Tacker <m@tacker.org>
    * @package SuprMail
    * @subpackage Frontend
    */
    class SmartyPage extends Smarty
    {
        function SmartyPage()
        {
            $this->Smarty();

            $this->template_dir     = "{$GLOBALS['CONFIG']['path']['home']}/lib/templates";
            $this->compile_dir      = "{$GLOBALS['CONFIG']['path']['home']}/var/compile";
            $this->cache_dir        = "{$GLOBALS['CONFIG']['path']['home']}/var/cache";

            $this->caching          = false;
            $this->compile_check    = true;
            $this->debugging_ctrl   = 'URL';

            $this->error_reporting  = E_ALL ^ E_NOTICE;

            $this->register_modifier('so', 'screenOut');
            $this->register_modifier('jso', 'javaScriptOut');
            $this->register_modifier('mf', 'moneyFormat');

            if(isset($GLOBALS['DISPLAYDATA'])) $this->assign($GLOBALS['DISPLAYDATA']);
        }
    }

?>
