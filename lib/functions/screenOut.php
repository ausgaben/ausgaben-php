<?php

    function screenOut($str)
    {
        $str = stripslashes($str);
        $str = stripslashes($str);
        $str = htmlspecialchars($str);
        return $str;
    }

?>
