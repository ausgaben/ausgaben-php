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
    class SpendingFilter_M extends SpendingFilter
    {
        function filterDescriptions (&$descriptions)
        {
            foreach ($descriptions as $spendinggroup_id => $array) {
                // Array durchgehen
                foreach ($array as $key => $val) {
                    // Suche nach '-'
                    $pos = strpos($val, ' - ');
                    if ($pos !== false) {
                        $val = trim(substr($val, 0, $pos));
                    }
                    // Kleine Korrekturen: Doppelter whitespace
                    $val = preg_replace('/\s{2,}/', ' ', $val);
                    // Veränderten Wert zuweisen
                    $array[$key] = $val;
                }
                // Doppelte entfernen
                $array = array_unique($array);
                // Natürlich sortieren
                natcasesort($array);
                // Keys normalisieren
                $array = array_values($array);
                // Wieder dem Haupt-Array zuweisen
                $descriptions[$spendinggroup_id] = $array;
            }
        }
    }

?>
