{include file='html_head.tpl'}
<table cellpadding="4" cellspacing="0" class="spendings">
{assign var=spendingtype_last value=0}
{section loop=$spendings name=spendings}
    {if $smarty.section.spendings.first}
        <tr class="header-a">
            <td colspan="3">
                {$spendings[spendings].date|date_format:'%B %Y'} ({$smarty.session.household.name})
            </td>
            <td align="right">
                {section loop=$months name=months}
                    {if $smarty.section.months.first}
                        <select onChange="document.location.href='{$SCRIPT_NAME}?do={$smarty.request.do}&amp;display_month=' + this.value;">
                    {/if}
                    <option value="{$months[months]}" {if $month eq $months[months]}selected="true"{/if}>{$months[months]|date_format:'%B %Y'}</option>
                    {if $smarty.section.months.last}
                        </select>
                    {/if}
                {/section}
            </td>
        </tr>
        {if $action eq ''}
            {include file='form_spending.tpl' class="header-a"}
        {/if}
    {/if}
    {if $spendings[spendings].spendingtype_id ne $spendingtype_last}
        {assign var=spendingtype_last value=$spendings[spendings].spendingtype_id}
        <tr class="header-b">
            <td class="header-b" colspan="2">{$spendingtypes[$spendingtype_last].name}&nbsp;</td>
            <td align="right" class="header-b">&nbsp;{$spendingsums[$spendingtype_last]|string_format:'%0.2f'} &euro;&nbsp;</td>
            <td class="header-b">&nbsp;</td>
        </tr>
    {/if}
    {assign var=user_id value=$spendings[spendings].user_id}
    {if $action eq 'edit' and $smarty.request.spending_id eq $spendings[spendings].spending_id}
        {include file='form_spending.tpl' spending=$spendings[spendings] class="row-`$smarty.section.spendings.iteration%2+1`"}
    {else}
        <tr class="row-{$smarty.section.spendings.iteration%2+1}">
            <td class="row">{$spendings[spendings].date|date_format:'%d. %B'}&nbsp;</td>
            <td class="row">&nbsp;{$spendings[spendings].description}&nbsp;</td>
            <td align="right" class="row">&nbsp;{$spendings[spendings].value|string_format:'%0.2f'} &euro;&nbsp;</td>
            <td class="row">&nbsp;{$users[$user_id].prename|truncate:1:''}{$users[$user_id].name|truncate:1:''} <a href="?do={$do}&amp;action=edit&spending_id={$spendings[spendings].spending_id}&display_month={$smarty.request.display_month}">[E]</a><a href="?do={$do}&amp;action=delete&spending_id={$spendings[spendings].spending_id}&display_month={$smarty.request.display_month}" onClick="return confirm('Sicher?!');">[X]</a></td>
        </tr>
    {/if}
    {if $smarty.section.spendings.last}
    <tr class="header-a">
        <td class="header-a" colspan="2">Summe</td>
        <td align="right" class="header-a">&nbsp;{$spendingsums.all|string_format:'%0.2f'} &euro;&nbsp;</td>
        <td class="header-a">&nbsp;</td>
    </tr>
    {/if}
{/section}
</table>
{include file='html_foot.tpl'}