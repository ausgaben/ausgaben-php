<?php

    /**
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Utilities
    */

    /**
    * Liefert den Wert der Variable `$var` zurück
    * Falls diese nicht gesetzt ist, den Wert `$default`.
    * Ist `$var` vorhanden wird der Typ von `$default`
    * ermittelt und `$var` entsprechend zurückgegeben.
    *
    * @param mixed zu prüfenden Variable
    * @param mixed default-wert
    * @return mixed
    */
    function getVar($var, $default)
    {
        if(!isset($var)) return $default;
        if(empty($var)) return $default;
        switch(gettype($default)) {
        case 'integer':
            return intval($var);
            break;
        case 'boolean':
            if($var) {
                return true;
            } else {
                return false;
            }
            break;
        case 'string':
            return strval($var);
            break;
        case 'array':
            if(!is_array($var)) {
                return $default;
            } else {
                return $var;
            }
            break;
        case 'object':
            if(!is_a($var, get_class($default))) {
                return $default;
            } else {
                return $var;
            }
            break;
        default:
            return $var;
        }
    }

?>