<?php
/**
 * Table Definition for account_abf
 */
require_once 'DB/DataObject.php';

class DataObject_Account_abf extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'account_abf';                     // table name
    var $account_id;                      // int(10)  not_null unsigned
    var $year;                            // int(4)  not_null unsigned
    var $month;                           // int(2)  not_null unsigned
    var $value;                           // blob(255)  not_null blob

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Account_abf',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
