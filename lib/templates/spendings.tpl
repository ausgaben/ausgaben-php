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
            {if $smarty.session.account_id eq $list_account.account_id}<strong>{/if}<a href="?do={$do}&amp;account_id={$list_account.account_id}">{$list_account.name}</a>{if $smarty.session.account_id eq $list_account.account_id}</strong>{/if}&nbsp;({if $list_account.sum_value >= 0}<span class="type-2">{else}<span class="type-1">{/if}{$list_account.sum_value}</span>){if $list_account.summarize_months}&sup1;{/if}<br />
            {if $smarty.foreach.list_account.last}
                </p>
                <p class="tiny">
                    &sup1; im {$display_month|date_format:'%b. %Y'}
                </p> 
            {/if}
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
            {if $summarize_months}
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
            {/if}
            <table {if $isIE}width="609"{else}width="100%"{/if} cellspacing="0" cellpadding="2">
                <tbody>
                    {section loop=$spendings_notbooked name=notbooked}
                        {if $smarty.section.notbooked.first}
                            <tr>
                                <td colspan="3" class="subheader">Noch nicht gebucht</td>
                            </tr>
                        {/if}
                        {if $smarty.section.notbooked.iteration is odd}
                            <tr>
                        {else}
                            <tr class="alt">
                        {/if}
                            <td colspan="2"><a href="javascript:javascript:showEditor({$spendings_notbooked[notbooked].spending_id});">{$spendings_notbooked[notbooked].description}</a></td>
                            <td><span class="type-{$spendings_notbooked[notbooked].type}">{if $spendings_notbooked[notbooked].type eq 1}-{/if}{$spendings_notbooked[notbooked].value|string_format:'%.2f'}</span></td>
                        </tr>
                        {if $smarty.section.notbooked.last}
                            <tr>
                                <td colspan="3">&nbsp;</td>
                            </tr>
                        {/if}
                    {/section}
            {foreach from=$spendings item=spendings_by_type key=type name=spendings_by_type}
                {if $smarty.foreach.spendings_by_type.first}
                            <tr>
                                {if $sum_type.0 >= 0}
                                    {assign var=sumall_class value=sum-2}
                                {else}
                                    {assign var=sumall_class value=sum-1}
                                {/if}
                                <td class="{$sumall_class}" colspan="2"><strong>Gesamt</strong></td>
                                <td class="{$sumall_class}" align="right"><strong>{$sum_type.0|string_format:'%.2f'}</strong></td>
                            </tr>
                {/if}
                {foreach from=$spendings_by_type item=spending name=spending}
                    {if $smarty.foreach.spending.first}
                        <tr>
                            <td class="sum-{$type}" colspan="2">{if $type eq 1}Ausgaben{else}Einnahmen{/if}</td>
                            <td class="sum-{$type}" align="right">{$sum_type[$type]|string_format:'%.2f'}</td>
                        </tr>
                        {assign var=lastgroup value=0}
                    {/if}
                    {if $lastgroup ne $spending.spendinggroup_id}
                        <tr>
                            <td colspan="2" class="subheader">{$spendinggroups[$spending.spendinggroup_id].name}</td>
                            <td class="subheader" align="right">{$sum_group[$type][$spending.spendinggroup_id]|string_format:'%.2f'}</td>
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
                            <td>{$spending.date|date_format:'%d. %b. %y'}</td>
                        {/if}
                        <td><a href="javascript:javascript:showEditor({$spending.spending_id});">{$spending.description}</a></td>
                        <td align="right"><span class="type-{$type}">{if $type eq 1}-{/if}{$spending.value|string_format:'%.2f'}</span></td>
                    </tr>
                    {if $smarty.foreach.spendings_out.last}

                    {/if}
                {/foreach}
            {/foreach}
                </tbody>
            </table>
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
        <input type="hidden" name="display_month" value="{$display_month}" />
        <input type="hidden" name="do" value="{$do}" />
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
                <td align="right">Typ</td>
                <td>
                    <select name="type">
                        <option>( Typ wählen )</option>
                        <option value="1" selected="true">Ausgabe</option>
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
                    <input type="text" name="day" maxlength="2" class="tiny" tabindex="1" value="{$smarty.now|date_format:'%d'}" />.<input type="text" name="month" maxlength="2" class="tiny" tabindex="2" value="{$smarty.now|date_format:'%m'}" />.<input type="text" name="year" class="small" maxlength="4" tabindex="3" value="{$smarty.now|date_format:'%Y'}" />
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
                    <input type="text" name="spendinggroup_name" class="text" tabindex="4" />
                </td>
            </tr>
            <tr>
                <td align="right">Zweck</td>
                <td><input type="text" name="description" class="text" tabindex="5" /></td>
            </tr>
            <tr>
                <td align="right">Betrag</td>
                <td><input type="text" name="value" class="text" tabindex="6" size="5" /></td>
            </tr>
            <tr>
                <td align="right">Bereits gebucht?</td>
                <td>
                    <input type="radio" name="booked" value="1" checked="true" /> Ja
                    <input type="radio" name="booked" value="0" /> Nein 
                </td>
            </tr>
            <tr>
                <td align="right">Eintrag <u>l</u>öschen</td>
                <td><input type="checkbox" name="ifdelete" value="1" accesskey="l" /></td>
            </tr>
            <tr>
                <td align="right"><input type="button" class="button" value="Abbrechen" onclick="xHide(spendingform);" /></td>
                <td><input type="submit" class="button"  name="ifsubmit" value="Speichern" /></td>
            </tr>
        </table>
    </form>
</div>
<script type="text/javascript">
<!--

    var Spendings = new Array();
    {foreach from=$spendings key=spending_type name=spendings item=spendings_by_type}
        {foreach from=$spendings[$spending_type] item=spending}
            Spendings[{$spending.spending_id}] = new Array();
            {foreach from=$spending key=fieldname item=field_value}
                Spendings[{$spending.spending_id}]["{$fieldname}"] = "{$field_value|replace:"\r\n":""}";
            {/foreach}
        {/foreach}
    {/foreach}
    
    {section loop=$spendings_notbooked name=notbooked}
        Spendings[{$spendings_notbooked[notbooked].spending_id}] = new Array();
        {foreach from=$spendings_notbooked[notbooked] key=fieldname item=field_value}
            Spendings[{$spendings_notbooked[notbooked].spending_id}]["{$fieldname}"] = "{$field_value|replace:"\r\n":""}";
        {/foreach}
    {/section}

    var spendingform = xGetElementById('spendingform');

    function showEditor (spending_id)
    {ldelim}
        if (spending_id != null) {ldelim}
            for (var fieldname in Spendings[spending_id]) {ldelim}
                if (fieldname == "date") continue;
                if (fieldname == "user_id") continue;
                if (fieldname == "booked") {ldelim}
                    if (Spendings[spending_id][fieldname] == "1") {ldelim}
                        document.addspending.booked[0].checked = true;
                    {rdelim} else {ldelim}
                        document.addspending.booked[1].checked = true;
                    {rdelim}
                    continue;
                {rdelim}
                eval("document.addspending." + fieldname + ".value = '" + Spendings[spending_id][fieldname] + "';");
            {rdelim}
        {rdelim} else {ldelim}
            document.addspending.reset();
            document.addspending.spending_id.value = 0;
        {rdelim}
        xTo = ((xClientWidth() - xWidth(spendingform)) / 2) + xScrollLeft();
        yTo = (((xClientHeight() / 7) * 3) - (xHeight(spendingform) / 2)) + xScrollTop();
        xMoveTo(spendingform, xTo, yTo);
        xShow(spendingform);
    {rdelim}

// -->
</script>
{include file='html_foot.tpl'}
