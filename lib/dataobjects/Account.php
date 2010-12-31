<?php
/**
 * Table Definition for account
 */
require_once 'DB/DataObject.php';

class DataObject_Account extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'account';                         // table name
    var $account_id;                      // int(11)  not_null primary_key unsigned auto_increment
    var $name;                            // blob(255)  not_null blob
    var $description;                     // blob(65535)  not_null blob
    var $summarize_months;                // int(1)  not_null unsigned
    var $summarize_years;                // int(1)  not_null unsigned
    var $enable_abf;                      // int(1)  not_null unsigned
    var $last_import;                     // string(14)  

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Account',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
