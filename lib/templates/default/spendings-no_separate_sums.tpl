{foreach from=$spendings item=spending name=spendings}
    {if $smarty.foreach.spendings.first}
        <tr><td colspan="4">&nbsp;</td></tr>
        {assign var=lastgroup value=0}
    {/if}
    {if $lastgroup ne $spending.spendinggroup_id}
        <tr>
            <td colspan="3" class="subheader">{$spendinggroups[$spending.spendinggroup_id].name}</td>
            <td class="subheader" align="right">{$sum_group[$spending.spendinggroup_id]|mf}</td>
        </tr>
        {assign var=lastgroup value=$spending.spendinggroup_id}
    {/if}
    {if $smarty.foreach.spendings.iteration is odd}
        <tr>
    {else}
        <tr class="alt">
    {/if}
        {if $summarize_months}
            <td>{$spending.date|date_format:'%d.'}</td>
        {else}
            <td nowrap="true">{$spending.date|date_format:'%d.%b.%y'}</td>
        {/if}
        <td><a href="javascript:javascript:showEditor({$spending.spending_id});">{if $spending.description}{$spending.description|so}{else}&mdash;{/if}</a></td>
        <td>{if $spending.spendingmethod_id > 0}<img src="lib/images/icons/spendingmethod/{$spendingmethods[$spending.spendingmethod_id].icon}" width="11" height="11" hspace="2" />{/if}</td>
        <td align="right" nowrap="true"><a name="{$spending.spending_id}"><span class="type-{$spending.type}">{if $spending.type eq 1}-{/if}{$spending.value|mf}</span></a></td>
    </tr>
{/foreach}
<script type="text/javascript">
<!--

    var Spendings = new Array();
    {foreach from=$spendings item=spending name=spendings }
        Spendings[{$spending.spending_id}] = new Array();
        {foreach from=$spending key=fieldname item=field_value}
            Spendings[{$spending.spending_id}]["{$fieldname}"] = "{$field_value|jso}";
        {/foreach}
    {/foreach}

// -->
</script>
<!-- $Id$ -->
<!-- no-separat -->
