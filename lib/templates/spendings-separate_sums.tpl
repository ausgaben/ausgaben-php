{foreach from=$spendings item=spendings_by_type key=type name=spendings_by_type}
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr>
        <td class="sum-{$type}" align="right">&raquo;</td>
        <td class="sum-{$type}" colspan="2">{if $type eq 1}Ausgaben{else}Einnahmen{/if}</td>
        <td class="sum-{$type}" align="right" nowrap="true">{$sum_type[$type]|mf}</td>
    </tr>
    {foreach from=$spendings_by_type item=spending name=spending}
        {if $smarty.foreach.spending.first}
            {assign var=lastgroup value=0}
        {/if}
        {if $lastgroup ne $spending.spendinggroup_id}
            <tr>
                <td colspan="3" class="subheader">{$spendinggroups[$spending.spendinggroup_id].name}</td>
                <td class="subheader" align="right">{$sum_group[$type][$spending.spendinggroup_id]|mf}</td>
            </tr>
            {assign var=lastgroup value=$spending.spendinggroup_id}
        {/if}
        {if $smarty.foreach.spending.iteration is odd}
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
            <td align="right" nowrap="true"><a name="{$spending.spending_id}"><span class="type-{$type}">{if $type eq 1}-{/if}{$spending.value|mf}</span></a></td>
        </tr>
        {if $smarty.foreach.spendings_out.last}{/if}
    {/foreach}
{/foreach}
<script type="text/javascript">
<!--

    var Spendings = new Array();
    {foreach from=$spendings key=spending_type name=spendings item=spendings_by_type}
        {foreach from=$spendings[$spending_type] item=spending}
            Spendings[{$spending.spending_id}] = new Array();
            {foreach from=$spending key=fieldname item=field_value}
                Spendings[{$spending.spending_id}]["{$fieldname}"] = "{$field_value|jso}";
            {/foreach}
        {/foreach}
    {/foreach}

// -->
</script>
<!-- $Id$ -->
<!-- separat -->
