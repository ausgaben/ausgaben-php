+-----------------+-----------------+----------+-----------------+--------+
| Konto           | Art             | Datum    | Beschreibung    | Betrag |
+-----------------+-----------------+----------+-----------------+--------+
{foreach from=$spendings name=spendings item=spending}
| {$spending._account_id.name|truncate:15|str_pad:15} | {$spending._spendinggroup_id.name|truncate:15|str_pad:15} | {$spending.date|date_format:'%d.%m.%y'} | {$spending.description|truncate:15|str_pad:15} | {$spending.value|string_format:'%.2f'|str_pad:6} |
{/foreach}
+-----------------+-----------------+----------+-----------------+--------+

AUSGABEN {$version.major}.{$version.minor} - {$smarty.now|date_format:'%A, %d. %B %Y, %H:%M Uhr'}