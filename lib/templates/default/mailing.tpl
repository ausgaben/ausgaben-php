{include file='html_head.tpl' mailing=true}
<div class="boxcontent">
    <p>
        <img src="lib/images/users/{$user.avatar}" align="middle" /> {$user.prename} hat folgende Ausgaben eingetragen oder bestehende verändert:
    </p>
    <table cellspacing="0" cellpadding="2" width="100%">
        <thead>
            <tr>
                <td>Konto</td>
                <td>Art</td>
                <td>Datum</td>
                <td>Beschreibung</td>
                <td colspan="2" align="right">Betrag</td>
            </tr>
        </thead>
        <tbody>
            {foreach from=$spendings name=spendings item=spending}
                {if $smarty.foreach.spendings.iteration is odd}
                    <tr class="alt">
                {else}
                    <tr>
                {/if}
                    <td>{$spending._account_id.name}</td>
                    <td>{$spending._spendinggroup_id.name}</td>
                    <td>{$spending.date|date_format:'%d.%m.%y'}</td>
                    <td>{$spending.description|so}</td>
                    <td align="right">{if $spending.spendingmethod_id > 0}<img src="lib/images/icons/spendingmethod/{$spending._spendingmethod_id.icon}" width="11" height="11" hspace="2" />{/if}</td>
                    <td align="right" nowrap="true"><span class="type-{$spending.type}">{if $spending.type eq 1}-{/if}{$spending.value|string_format:'%.2f'}</span></td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>
{include file='html_foot.tpl'}
