<?php
/**
 * Table Definition for spending
 */
require_once 'DB/DataObject.php';

define('SPENDING_TYPE_OUT',    1);
define('SPENDING_TYPE_IN',     2);

class DataObject_Spending extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'spending';                        // table name
    var $spending_id;                     // int(11)  not_null primary_key auto_increment
    var $type;                            // int(1)  not_null
    var $year;                            // int(4)  not_null
    var $month;                           // int(2)  not_null
    var $day;                             // int(2)  not_null
    var $spendinggroup_id;                // int(11)  not_null
    var $description;                     // blob(65535)  not_null blob
    var $user_id;                         // int(11)  not_null
    var $account_id;                      // int(11)  not_null
    var $value;                           // real(12)  not_null
    var $booked;                          // int(1)  not_null
    var $spendingmethod_id;               // int(4)  not_null
    var $timestamp;                       // timestamp(14)  not_null unsigned zerofill timestamp

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Spending',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
