<?php

    /**
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Backend
    */

    /**
    * Manage Settings
    *
    * @author Markus Tacker <m@tacker.org>
    * @package Ausgaben
    * @subpackage Backend
    */
    class Settings
    {
    	/**
		* @var		int		Scope ID
		*/
    	var $_scope = -1;
    	
    	/**
    	* @var 		string	Settings for the scope
    	*/
    	var $_session_var = '_Settings';
    	
    	/**
    	* @var 		string	Format of the request variables
    	*/
    	var $_request_format = '_set_%s';
    	
    	/**
    	* Konstruktor
    	* Create the needed session vars
    	*/
    	function Settings () 
    	{
    		if (!isset($_SESSION[$this->_session_var])) {
    			@session_start();
    			$_SESSION[$this->_session_var] = array();
    		}
    	}
    	
    	/**
    	* Initially load the settings for the scope
    	*
    	* @param 	int		Scope ID
    	*/
        function init ($scope) 
        {
        	$this->_scope = intval($scope);
        	if (!isset($_SESSION[$this->_session_var][$this->_scope])) {
        		$_SESSION[$this->_session_var][$this->_scope] = array();
	        	$Settings = DB_DataObject::factory('settings');
	            $Settings->scope = $this->_scope;
	            if ($Settings->find()) {
	            	while ($Settings->fetch()) {
	            		$_SESSION[$this->_session_var][$this->_scope][$Settings->name] = $Settings->value;
	            	}
	            }
        	}
        	$this->_updateFromRequest();
        }
        
        /**
        * Return an array of settings for this scope
        *
        * @param 	string		Name of the setting
        * @return 	array|false
        */
        function get ($name = false)
        {
        	if (!$name) {
        		if (isset($_SESSION[$this->_session_var][$this->_scope])) return $_SESSION[$this->_session_var][$this->_scope];
        		return array();
        	}
        	if (isset($_SESSION[$this->_session_var][$this->_scope][$name])) return $_SESSION[$this->_session_var][$this->_scope][$name];
        	return false;
        }
        
        /**
        * Save the current settings
        *
        * @return bool
        */
        function save ()
        {
        	$Settings = DB_DataObject::factory('settings');
	        $Settings->scope = $this->_scope;
	        $Settings->delete();
	        foreach ($_SESSION[$this->_session_var][$this->_scope] as $name => $value) {
	        	$Settings = DB_DataObject::factory('settings');
	        	$Settings->scope = $this->_scope;
	        	$Settings->name = $name;
        		$Settings->value = $value;
        		if (!$Settings->insert()) return false;
	        }
	        return true;
        }
        
        /**
        * Update settings from Request
        */
        function _updateFromRequest ()
        {
        	$rx = '/^' . str_replace('%s', '([a-z_]+)', $this->_request_format) . '$/';
        	foreach ($_REQUEST as $name => $value) {
        		if (!preg_match($rx, $name, $match)) continue;
        		$this->set($match[1], $value);
        	}
        }
        
        /**
        * Update a setting
        *
        * @param 	string		name
        * @param 	string		value
        * @return 	bool
        */
        function set ($name, $value) 
        {
        	$_SESSION[$this->_session_var][$this->_scope][$name] = $value;
        	return true;
        }
    }

?>
