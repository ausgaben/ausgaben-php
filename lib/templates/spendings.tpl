{include file='html_head.tpl'}
{*
    Kontos auswählen
*}
<div class="frameleft">
    <div class="boxcontent">
        <p class="frametitle">Konten</p>
        {if $smarty.session.account_id <= 0}
            <p>Ein Konto auswählen:</p>
        {/if}
        {foreach from=$accounts name=list_account item=list_account}
        {if $smarty.foreach.list_account.first}<p>{/if}
            {if $smarty.session.account_id eq $list_account.account_id}<strong>{/if}
            <a href="?do={$do}&amp;account_id={$list_account.account_id}">{$list_account.name}</a><br />
            {if $smarty.session.account_id eq $list_account.account_id}</strong>{/if}
            {if $smarty.foreach.list_account.last}</p>{/if}
        {/foreach}
        {if $smarty.session.account_id > 0}
            <p class="frametitle">Ausgaben</p>
            <p><a href="javascript:showEditor();"><img src="lib/images/icons/small/riot_page.png" width="21" height="18" align="absmiddle" />Neu ...</a></p>
        {/if}
    </div>
</div>
{*
    Ausgaben anzeigen
*}
{if $smarty.session.account_id > 0}
    {assign var=account value=$accounts[$smarty.session.account_id]}
    <div class="framecenter">
        <div class="boxsubtitle">{$account.name}</div>
        <div class="boxcontent">
            <h3>
                {section loop=$months name=months}
                    {if $smarty.section.months.first}
                        <select onChange="document.location.href='{$SCRIPT_NAME}?do={$smarty.request.do}&amp;display_month=' + this.value;" class="floatright">
                    {/if}
                    <option value="{$months[months]}" {if $display_month eq $months[months]}selected="true"{/if}>{$months[months]|date_format:'%B %Y'}</option>
                    {if $smarty.section.months.last}
                        </select>
                    {/if}
                {/section}
                {$display_month|date_format:'%B %Y'}
            </h3>
            {foreach from=$spendings item=spendings_by_type key=type name=spendings_by_type}
                {if $smarty.foreach.spendings_by_type.first}
                    <table width="100%" cellspacing="0" cellpadding="2">
                        <thead>
                            <tr>
                                <td>Tag</td>
                                <td>Zweck</td>
                                <td align="right">Betrag</td>
                                <td>&nbsp;</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="sum-all" colspan="2">Gesamt</td>
                                <td class="sum-all" align="right">{$sum_type.0|string_format:'%.2f'}</td>
                                <td class="sum-all">&nbsp;</td>
                            </tr>
                {/if}
                {foreach from=$spendings_by_type item=spending name=spending}
                    {if $smarty.foreach.spending.first}
                        <tr>
                            <td class="sum-{$type}" colspan="2">{if $type eq 1}Ausgaben{else}Einnahmen{/if}</td>
                            <td class="sum-{$type}" align="right">{$sum_type[$type]|string_format:'%.2f'}</td>
                            <td class="sum-{$type}">&nbsp;</td>
                        </tr>
                    {/if}
                    {if $lastgroup ne $spending.spendinggroup_id}
                        <tr>
                            <td colspan="2" class="subheader">{$spendinggroups[$spending.spendinggroup_id].name}</td>
                            <td class="subheader" align="right">{$sum_group[$spending.spendinggroup_id]|string_format:'%.2f'}</td>
                            <td class="subheader">&nbsp;</td>
                        </tr>
                        {assign var=lastgroup value=$spending.spendinggroup_id}
                    {/if}
                    {if $smarty.foreach.spending.iteration is odd}
                        <tr>
                    {else}
                        <tr class="alt">
                    {/if}
                        <td>{$spending.date|date_format:'%d.'}</td>
                        <td>{$spending.description}</td>
                        <td align="right">{$spending.value|string_format:'%.2f'}</td>
                        <td align="right"><a href="javascript:showEditor({$spending.spending_id});"><img src="lib/images/icons/small/riot_edit_page.png" width="21" height="18" align="absmiddle" /></a></td>
                    </tr>
                    {if $smarty.foreach.spendings_out.last}

                    {/if}
                {/foreach}
                {if $smarty.foreach.spendings_by_type.last}
                        </tbody>
                    </table>
                {/if}
            {/foreach}
        </div>
    </div>
{/if}
<div class="clearall"></div>
{*
    Ausgaben editieren
*}
<div id="spendingform">
    <form name="addspending" method="post" action="{$SCRIPT_NAME}">
        <input type="hidden" name="spending_id" value="0" />
        <table cellspacing="0" cellpadding="2">
            <tr>
                <td align="right">Konto</td>
                <td>
                    <select name="account_id">
                        <option value="">( Konto wählen )</option>
                        {foreach from=$accounts name=list_account item=list_account}
                            <option value="{$list_account.account_id}" {if $smarty.session.account_id eq $list_account.account_id}selected="true"{/if}>{$list_account.name}</option>
                        {/foreach}
                    </select>
                </td>
            </tr>
            <tr>
                <td align="right">Type</td>
                <td>
                    <select name="type">
                        <option>( Typ wählen )</option>
                        <option value="1">Ausgabe</option>
                        <option value="2">Einnahme</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <select onChange="document.addspending.day.value=this.value.substr(6,2);document.addspending.month.value=this.value.substr(4,2);document.addspending.year.value=this.value.substr(0,4);">
                            <option value="">( Datum wählen )</option>
                            <option value="{$smarty.now|date_format:'%Y%m%d'}">{$smarty.now|date_format:'%d.%m. - Heute'}</option>
                            <option value="{$smarty.now-86400|date_format:'%Y%m%d'}">{$smarty.now-86400|date_format:'%d.%m. - %A'}</option>
                            <option value="{$smarty.now-86400*2|date_format:'%Y%m%d'}">{$smarty.now-86400*2|date_format:'%d.%m. - %A'}</option>
                            <option value="{$smarty.now-86400*3|date_format:'%Y%m%d'}">{$smarty.now-86400*3|date_format:'%d.%m. - %A'}</option>
                            <option value="{$smarty.now-86400*4|date_format:'%Y%m%d'}">{$smarty.now-86400*4|date_format:'%d.%m. - %A'}</option>
                            <option value="{$smarty.now-86400*5|date_format:'%Y%m%d'}">{$smarty.now-86400*5|date_format:'%d.%m. - %A'}</option>
                            <option value="{$smarty.now-86400*6|date_format:'%Y%m%d'}">{$smarty.now-86400*6|date_format:'%d.%m. - %A'}</option>
                    </select>
                </td>
                <td>
                    <input type="text" name="day" maxlength="2" class="tiny" tabindex="1" value="{if isset($edit_spending)}{$edit_spending.day}{else}{$smarty.now|date_format:'%d'}{/if}" />.<input type="text" name="month" maxlength="2" class="tiny" tabindex="2" value="{if isset($edit_spending)}{$edit_spending.month}{else}{$smarty.now|date_format:'%m'}{/if}" />.<input type="text" name="year" class="small" maxlength="4" tabindex="3" value="{if isset($edit_spending)}{$edit_spending.year}{else}{$smarty.now|date_format:'%Y'}{/if}" />
                </td>
            </tr>
            <tr>
                <td>
                    <script type="text/javascript">
                    <!--
                            spendinggroups = new Array();
                            {foreach from=$spendinggroups item=spendinggroup}
                            spendinggroups[{$spendinggroup.spendinggroup_id}] = '{$spendinggroup.name}';
                            {/foreach}
                    // -->
                    </script>
                    <select name="spendinggroup_id" onChange="document.addspending.spendinggroup_name.value=spendinggroups[this.value];">
                            <option value="">( Art wählen )</option>
                            {foreach from=$spendinggroups item=spendinggroup}
                            <option value="{$spendinggroup.spendinggroup_id}">{$spendinggroup.name}</option>
                            {/foreach}
                    </select>
                </td>
                <td>
                    <input type="text" name="spendinggroup_name" class="medium" tabindex="4" {if isset($edit_spending)}value="{$spendinggroups[$edit_spending.spendinggroup_id].name}"{/if} />
                </td>
            </tr>
            <tr>
                <td align="right">Zweck</td>
                <td><input type="text" name="description" class="large" tabindex="5" {if isset($edit_spending)}value="{$edit_spending.description}"{/if} /></td>
            </tr>
            <tr>
                <td align="right">Betrag</td>
                <td><input type="text" name="value" class="small" tabindex="6" size="5" {if isset($edit_spending)}value="{$edit_spending.value}"{/if} /></td>
            </tr>
            <tr>
                <td align="right"><input type="button" value="Abbrechen" onclick="xHide(spendingform);" /></td>
                <td><input type="submit" value="Speichern" /></td>
            </tr>
        </table>
    </form>
</div>
<script type="text/javascript">
<!--

    {foreach from=$spendings key=spending_type name=spendings item=spendings_by_type}
        {if $smarty.foreach.spendings.first}var Spendings = new Array();{/if}
        {foreach from=$spendings[$spending_type] item=spending}
            Spendings[{$spending.spending_id}] = new Array();
            {foreach from=$spending key=fieldname item=field_value}
                Spendings[{$spending.spending_id}]["{$fieldname}"] = "{$field_value|replace:"\r\n":""}";
            {/foreach}
        {/foreach}
    {/foreach}

    var spendingform = xGetElementById('spendingform');

    xEnableDrag(spendingform, false, myOnDrag, false);

    function myOnDrag (ele, mdx, mdy)
    {ldelim}
        xMoveTo(ele, xLeft(ele) + mdx, xTop(ele) + mdy);
    {rdelim}

    function showEditor (spending_id)
    {ldelim}
        if (spending_id != null) {ldelim}
            for (var fieldname in Spendings[spending_id]) {ldelim}
                if (fieldname == "date") continue;
                if (fieldname == "user_id") continue;
                eval("document.addspending." + fieldname + ".value = '" + Spendings[spending_id][fieldname] + "';");
            {rdelim}
        {rdelim} else {ldelim}
            document.addspending.reset();
        {rdelim}
        xTo = ((xClientWidth() - xWidth(spendingform)) / 2) + xScrollLeft();
        yTo = (((xClientHeight() / 7) * 3) - (xHeight(spendingform) / 2)) + xScrollTop();
        xMoveTo(spendingform, xTo, yTo);
        xShow(spendingform);
    {rdelim}

// -->
</script>
{include file='html_foot.tpl'}