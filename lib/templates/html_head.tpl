<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <title>Ausgaben</title>
  <link rel="stylesheet" type="text/css" href="lib/css/ausgaben.css" />
</head>
<body>
        <div class="menu">
            {if $AUTH}
                <a href="?do=spendings">Ausgaben</a>
                |
                <a href="?do=statistics">Statistik</a>
                |
                <a href="?do=import">Import</a>
                |
                <a href="?logout=1">abmelden</a>
            {else}
                <form method="post" action="{$SCRIPT_NAME}">
                Bitte mit E-Mail-Adresse und Passwort einloggen.<br />
                <input type="text" name="username" />
                <input type="password" name="password" />
                <input type="submit" value="login" />
                </form>
            {/if}
        </div>