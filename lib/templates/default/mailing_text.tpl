+--------------+-------------+----------+-----------------------+---------+
| Konto        | Art         | Datum    | Beschreibung          | Betrag  |
+--------------+-------------+----------+-----------------------+---------+
{foreach from=$spendings name=spendings item=spending}
| {$spending._account_id.name|truncate:12|str_pad:12} | {$spending._spendinggroup_id.name|truncate:11|str_pad:11} | {$spending.date|date_format:'%d.%m.%y'} | {$spending.description|truncate:21|str_pad:21} | {$spending.value|string_format:'%.2f'|str_pad:7} |
{/foreach}
+--------------+-------------+----------+-----------------------+---------+

AUSGABEN {$version.major}.{$version.minor} - {$smarty.now|date_format:'%A, %d. %B %Y, %H:%M Uhr'}
