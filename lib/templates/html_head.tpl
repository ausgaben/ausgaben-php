<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>Ausgaben</title>
  <link rel="stylesheet" type="text/css" href="lib/css/ausgaben.css" />
  <script type="text/javascript" src="lib/js/cross-browser.com/x/x_core.js"></script>
</head>
<body>
    <div class="masterbox">
        <div class="boxtitle">AUSGABEN {$version.major}.{$version.minor}</div>
    {if $AUTH}
        <div class="icons">
            <a href="?do=spendings" class="icon">
                <img src="lib/images/icons/large/riot_edit.png" width="40" height="40" /><br />
                Ausgaben
            </a>
            <a href="?do=accounts" class="icon">
                <img src="lib/images/icons/large/riot_projects.png" width="40" height="40" /><br />
                Konten
            </a>
            <a href="?do=statistics" class="icon">
                <img src="lib/images/icons/large/riot_statistics.png" width="40" height="40" /><br />
                Statistik
            </a>
            <a href="?logout=1" class="icon">
                <img src="lib/images/icons/large/riot_accounts.png" width="40" height="40" /><br />
                Abmelden
            </a>
        </div>
    {/if}