<?php
/**
 * Table Definition for user2account
 */
require_once 'DB/DataObject.php';

class DataObject_User2account extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'user2account';                    // table name
    var $user_id;                         // int(11)  not_null unsigned
    var $account_id;                      // int(11)  not_null unsigned

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_User2account',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
