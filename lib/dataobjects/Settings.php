<?php
/**
 * Table Definition for settings
 */
require_once 'DB/DataObject.php';

class DataObject_Settings extends DB_DataObject 
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    var $__table = 'settings';                        // table name
    var $scope;                           // int(11)  not_null
    var $name;                            // blob(255)  not_null blob
    var $value;                           // blob(65535)  not_null blob

    /* ZE2 compatibility trick*/
    function __clone() { return $this;}

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('DataObject_Settings',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
}
