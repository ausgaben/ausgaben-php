<?php

    function javaScriptOut($str)
    {
        $str = str_replace("\n", '', $str);
        $str = str_replace("\r", '', $str);
        $str = addslashes($str);
        $str = str_replace('\\\\\\', '\\', $str); // Fix double slashes
        return $str;
    }

?>
