<?php
/**
 * Table Definition for spendingtype
 */
require_once 'DB/DataObject.php';

class DataObject_Spendingtype extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'spendingtype';                    // table name
    var $spendingtype_id;                 // int(11)  not_null primary_key auto_increment
    var $name;                            // blob(255)  not_null blob
    var $description;                     // blob(65535)  not_null blob

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Spendingtype',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
