<?php

    /**
    * @author Markus Tacker <m@tacker.org>
    * @version $Id$
    * @package Ausgaben
    * @subpackage Backend
    */

    /**
    * Base class for filtering Spendings
    *
    * @author Markus Tacker <m@tacker.org>
    * @package Ausgaben
    * @subpackage Backend
    */
    class SpendingFilter
    {
        function &factory ($custom_name)
        {
            if (empty($custom_name)) {
                PEAR::raiseError('SpendingFilter::factory() - Please provide a custom filter name');
                return false;
            }
            $class_name = 'SpendingFilter_' . ucfirst(strtolower($custom_name));
            if (class_exists($class_name)) {
                return new $class_name;
            }
            @include_once $class_name . '.php';
            if (class_exists($class_name)) {
                return new $class_name;
            } else {
                return new SpendingFilter;
            }
        }

        function filterDescriptions (&$descriptions)
        {
            PEAR::raiseError(get_class($this) . '->filterDescriptions() - Not implemented!');
            return false;
        }
    }

?>
