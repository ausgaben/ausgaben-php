<?php
/**
 * Table Definition for user
 */
require_once 'DB/DataObject.php';

class DataObject_User extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'user';                            // table name
    var $user_id;                         // int(11)  not_null primary_key auto_increment
    var $email;                           // blob(255)  not_null blob
    var $password;                        // string(32)  not_null
    var $loginkey;                        // string(32)  not_null
    var $prename;                         // blob(255)  not_null blob
    var $name;                            // blob(255)  not_null blob
    var $admin;                           // int(4)  not_null
    var $last_account_id;                 // int(11)  not_null

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_User',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
