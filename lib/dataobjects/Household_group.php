<?php
/**
 * Table Definition for household_group
 */
require_once 'DB/DataObject.php';

class DataObject_Household_group extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'household_group';                 // table name
    var $household_id;                    // int(11)  not_null
    var $parent_household_id;             // int(11)  not_null

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Household_group',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
