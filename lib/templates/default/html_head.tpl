<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Ausgaben {$version.major}.{$version.minor}</title>
	{if $mailing}<style type="text/css">{$css}</style>{else}<link rel="stylesheet" type="text/css" href="lib/css/ausgaben.css" />{/if}
  	{if $isIE}<link rel="stylesheet" type="text/css" href="lib/css/ausgaben_ie.css" />{/if}
  	<script type="text/javascript" src="lib/js/cross-browser.com/x/x_core.js"></script>
</head>
<body>
    <div class="masterbox">
        <div class="boxtitle"><div class="floatright">{$smarty.now|date_format:'%A, %d. %B %Y, %H:%M Uhr'}</div>AUSGABEN {$version.major}.{$version.minor}</div>
        {if $AUTH and !$mailing}{include file='menu.tpl'}{/if}
