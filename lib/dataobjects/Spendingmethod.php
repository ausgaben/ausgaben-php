<?php
/**
 * Table Definition for spendingmethod
 */
require_once 'DB/DataObject.php';

class DataObject_Spendingmethod extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'spendingmethod';                  // table name
    var $spendingmethod_id;               // int(4)  not_null primary_key unique_key auto_increment
    var $name;                            // blob(255)  not_null blob
    var $icon;                            // blob(255)  not_null blob

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Spendingmethod',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
