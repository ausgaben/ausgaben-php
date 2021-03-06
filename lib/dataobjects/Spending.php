<?php
/**
 * Table Definition for spending
 */
require_once 'DB/DataObject.php';

define('SPENDING_TYPE_ACCOUNT',    	0);
define('SPENDING_TYPE_OUT',    		1); // Abbuchung
define('SPENDING_TYPE_IN',     		2); // Eingang
define('SPENDING_TYPE_CASH',   		3); // Bar-Ausgabe
define('SPENDING_TYPE_WITHDRAWAL',  4); // Bar-Abhebung

$GLOBALS['spending_config'] = array(
	SPENDING_TYPE_ACCOUNT => array(
		'value' => 0,
		'sign'	=> '',
	),
	SPENDING_TYPE_OUT => array(
		'value' => -1,
		'sign'	=> '-',
	),
	SPENDING_TYPE_IN => array(
		'value' => 1,
		'sign'	=> '',
	),
	SPENDING_TYPE_CASH => array(
		'value' => -1,
		'sign'	=> '-',
	),
	SPENDING_TYPE_WITHDRAWAL => array(
		'value' => -1,
		'sign'	=> '-',
	),
);

class DataObject_Spending extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'spending';                        // table name
    var $spending_id;                     // int(11)  not_null primary_key unsigned auto_increment
    var $type;                            // int(1)  not_null unsigned
    var $year;                            // int(4)  not_null unsigned
    var $month;                           // int(2)  not_null unsigned
    var $day;                             // int(2)  not_null unsigned
    var $spendinggroup_id;                // int(11)  not_null unsigned
    var $description;                     // blob(65535)  not_null blob
    var $user_id;                         // int(11)  not_null unsigned
    var $account_id;                      // int(11)  not_null unsigned
    var $value;                           // blob(255)  not_null blob
    var $booked;                          // int(1)  not_null unsigned
    var $timestamp;                       // timestamp(14)  not_null unsigned zerofill timestamp

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Spending',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
