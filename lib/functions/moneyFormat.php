<?php

    function moneyFormat($float, $dec = 2)
    {
        $locale_conv = $GLOBALS['DISPLAYDATA']['locale_conv'];
        return number_format($float, $dec, $locale_conv['mon_decimal_point'], $locale_conv['mon_thousands_sep']);
    }

?>
