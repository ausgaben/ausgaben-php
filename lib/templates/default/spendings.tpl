{include file='html_head.tpl'}
{assign var=display_month value=$smarty.session.display_month}
<div id="loading"><img src="lib/images/icons/large/riot_time.png" alt="" align="left" width="40" height="40" />&nbsp;Bitte warten. Seite wird geladen.&nbsp;</div>
<script type="text/javascript">
<!--
    var loading = xGetElementById('loading');
    xTo = ((xClientWidth() - xWidth(loading)) / 2) + xScrollLeft();
    xMoveTo(loading, xTo, 150);
    window.onload = function () {ldelim}xHide(loading);{rdelim}
// -->
</script>
{if $smarty.session.account_id > 0}
    {assign var=account value=$accounts[$smarty.session.account_id]}
{/if}
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
            {if $smarty.foreach.list_account.first}<table cellpadding="0" cellspacing="0" width="100%">{/if}
            <tr>
                <td>{if $smarty.session.account_id eq $list_account.account_id}<strong>{/if}<a href="?account_id={$list_account.account_id}" {if $list_account.summarize_months}{popup text=$display_month|date_format:'im %B %Y'|utf8_encode}{/if}>{$list_account.name}</a>{if $smarty.session.account_id eq $list_account.account_id}</strong>{/if}</td>
                <td align="right">{if $list_account.sum_value >= 0}<span class="type-2">{else}<span class="type-1">{/if}{$list_account.sum_value|mf:0}</span></span></td>
            </tr>
            {if $smarty.foreach.list_account.last}
                </table>
                <p></p>
            {/if}
        {/foreach}
        {if $smarty.session.account_id > 0}
            {if $summarize_months}
                {foreach from=$months name=months item=month}
                    {if $smarty.foreach.months.first}
                        <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td class="tiny" style="text-align: left;">Monat</td>
                            <td class="tiny">Summe</td>
                            {if $account.enable_abf eq 1}<td class="tiny">Kontostand</td>{/if}
                        </tr>
                    {/if}
                    <tr>
                        <td>{if $display_month eq $month}<strong>{/if}<a href="{$smarty.server.PHP_SELF}?do={$smarty.request.do}&amp;display_month={$month}">{$month|date_format:"%b '%y"|utf8_encode}</a>{if $display_month eq $month}</strong>{/if}</td>
                        <td align="right">{if $month_sums[$month] >= 0}<span class="type-2">{else}<span class="type-1">{/if}{$month_sums[$month]|mf:0}</span></span></td>
                        {if $account.enable_abf eq 1}
                            <td align="right">{if $month_sums_abf[$month] >= 0}<span class="type-2">{else}<span class="type-1">{/if}{$month_sums_abf[$month]|mf:0}</span></span></td>
                        {/if}
                    </tr>
                    {if $smarty.foreach.months.last}
                        {if $account.enable_abf eq 0}
                            <tr>
                                <td colspan="2" align="right" class="leftsum">{if $month_sums._all >= 0}<span class="type-2">{else}<span class="type-1">{/if}{$month_sums._all|mf}</span></span></td>
                            </tr>
                        {/if}
                        </table><p></p>
                    {/if}
                {/foreach}
            {/if}
            <p class="frametitle">Ausgaben</p>
            <p><a href="javascript:showEditor();"><img src="lib/images/icons/small/riot_page.png" width="21" height="18" align="absmiddle" />Neu ...</a></p>
            <p class="frametitle">Ansicht</p>
            <form name="viewsettings" method="post" action="{$smarty.server.PHP_SELF}">
                <p>
                    <input type="radio" name="_set_order_by_date" value="0" {if !$smarty.session.user.settings.order_by_date}checked="true"{/if} onchange="document.viewsettings.submit();" id="order_by_date_1" /> <label for="order_by_date_1" {popup text="Gruppiert die Einnahmen und Ausgaben nach ihrer Art"}>Nach Art gruppieren</label><br />
                    <input type="radio" name="_set_order_by_date" value="1" {if $smarty.session.user.settings.order_by_date}checked="true"{/if} onchange="document.viewsettings.submit();" id="order_by_date_2" /> <label for="order_by_date_2" {popup text="Ordnet die Einnahmen und Ausgaben nach dem Datum"}>Nach Datum sortieren</label><br />
                </p>
            </form>
        {/if}
    </div>
</div>
{*
    Ausgaben anzeigen
*}
{if $smarty.session.account_id > 0}
    <div class="framecenter">
        <div class="boxsubtitle">{$account.name}{if $summarize_months} - {$display_month|date_format:'%B %Y'|utf8_encode}{/if}</div>
        <div class="boxcontent">
            <table {if $isIE}width="609"{else}width="100%"{/if} cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <tr colspan="4"><h3>Zusammenfassung</h3></td>
                    </tr>
                    {* Summen anzeigen *}
                    <tr class="alt">
                        <td colspan="3">Einnahmen</td>
                        <td align="right" nowrap="true">{$sum_type.2|mf}</td>
                    </tr>
                    <tr>
                        <td colspan="3">Ausgaben</td>
                        <td align="right" nowrap="true">{$sum_type.1|mf}</td>
                    </tr>
                    <tr class="sum">
                        <td class="sum" colspan="3"><strong>Summe</strong></td>
                        <td class="sum" align="right"><span class="type-{if $sum_type.0 < 0}1{else}2{/if}"><strong>{$sum_type.0|mf}</strong></class></td>
                    </tr>
                    {if $account.enable_abf and $abf}
                        <tr class="alt">
                            <td colspan="3">Übertrag aus {$abf.date|date_format:'%B %Y'|utf8_encode}</td>
                            <td align="right">{$abf.value|mf}</td>
                        </tr>
                        <tr class="sum">
                            <td class="sum" colspan="3"><strong>Kontostand (am {$sum_abf_date|date_format:'%d.%m.%Y'|utf8_encode})</strong></td>
                            <td class="sum" align="right"><span class="type-{if $sum_abf < 0}1{else}2{/if}"><strong>{$sum_abf|mf}</strong></span></td>
                        </tr>
                    {/if}

                    {* Nicht gebuchte Ausgaben anzeigen *}
                    {section loop=$spendings_notbooked name=notbooked}
                    	{assign var="spending" value=$spendings_notbooked[notbooked]}
                        {if $smarty.section.notbooked.first}
                            <tr>
                                <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="4"><h3>Noch nicht gebuchte Ausgaben</h3></td>
                            </tr>
                            {assign var=lastgroup value=0}
                        {/if}
                        {if $lastgroup ne $spending.spendinggroup_id}
                            <tr>
                                <td colspan="3" class="subheader">{$spendinggroups[$spending.spendinggroup_id].name}</td>
                                <td class="subheader-right"><span class="type-{if $spendinggroups[$spending.spendinggroup_id].sum_notbooked < 0}1{else}2{/if}"><strong>{$spendinggroups[$spending.spendinggroup_id].sum_notbooked|mf}</strong></span></td>
                            </tr>
                            {assign var=lastgroup value=$spending.spendinggroup_id}
                        {/if}
                        {if $smarty.section.notbooked.iteration is odd}
                            <tr class="alt">
                        {else}
                            <tr>
                        {/if}
                            <td colspan="2"><a href="javascript:javascript:showEditor({$spendings_notbooked[notbooked].spending_id});">{$spendings_notbooked[notbooked].description|so}</a> {if $spendings_notbooked[notbooked].is_new}<sup>NEU</sup>{/if}</td>
                            <td><img src="lib/images/icons/spendingtype/{$spendings_notbooked[notbooked].type}.gif" width="16" height="16" hspace="2" /></td>
                            <td align="right"><span class="type-{$spendings_notbooked[notbooked].type}">{if $spendings_notbooked[notbooked].type eq 1}-{/if}{$spendings_notbooked[notbooked].value|mf}</span></td>
                        </tr>
                        {if $smarty.section.notbooked.last}
                            <tr class="sum">
                                <td colspan="3" class="sum"><strong>Summe</strong></td>
                                <td colspan="3" class="sum" align="right"><span class="type-{if $sum_notbooked < 0}1{else}2{/if}"><strong>{if $sum_notbooked < 0}-{/if}{$sum_notbooked|mf}</strong></span></td>
                            </tr>
                            <!-- tr>
                                <td colspan="4">&nbsp;</td>
                            </tr -->
                        {/if}
                        {assign var=lastgroup value=$spending.spendinggroup_id}
                    {/section}

                    {* Ausgaben anzeigen *}
                    {assign var=order_by_date value=$smarty.session.user.settings.order_by_date}
                    {foreach from=$spendings item=spending name=spendings}
                        {if $smarty.foreach.spendings.first}
                            <tr><td colspan="4">&nbsp;</td></tr>
                            <tr><td colspan="4"><h3>Gebuchte Ausgaben</h3></td></tr>
                            {assign var=lastgroup value=0}
                        {/if}
                        {if !$order_by_date}
                            {if $lastgroup ne $spending.spendinggroup_id}
                                <tr>
                                    {if $summarize_months}
                                        <td colspan="3" class="subheader">{$spendinggroups[$spending.spendinggroup_id].name}</td>
                                        <td class="subheader-right"><span class="type-{if $spendinggroups[$spending.spendinggroup_id].sum < 0}1{else}2{/if}"><strong>{$spendinggroups[$spending.spendinggroup_id].sum|mf}</strong></span></td>
                                    {else}
                                        <td colspan="3" class="subheader">{$spendinggroups_sums[$spending.spendinggroup_id].name}</td>
                                        <td class="subheader-right"><span class="type-{if $spendinggroups_sums[$spending.spendinggroup_id].sum < 0}1{else}2{/if}"><strong>{$spendinggroups_sums[$spending.spendinggroup_id].sum|mf}</strong></span></td>
                                    {/if}
                                </tr>
                                {assign var=lastgroup value=$spending.spendinggroup_id}
                            {/if}
                        {/if}
                        {if $smarty.foreach.spendings.iteration is odd}
                            <tr class="alt">
                        {else}
                            <tr>
                        {/if}
                            {if $summarize_months}
                                <td>{$spending.date|date_format:'%d.'|utf8_encode}</td>
                            {else}
                                <td nowrap="true">{$spending.date|date_format:'%d.%m.%Y'|utf8_encode}</td>
                            {/if}
                            <td><a href="javascript:javascript:showEditor({$spending.spending_id});">{if $spending.description}{$spending.description|so}{else}&mdash;{/if}</a> {if $spending.is_new}<sup>NEU</sup>{/if}</td>
                            <td><img src="lib/images/icons/spendingtype/{$spending.type}.gif" width="16" height="16" hspace="2" /></td>
                            <td align="right" nowrap="true"><a name="{$spending.spending_id}"><span class="type-{$spending.type}">{$spending_config[$spending.type].sign}{$spending.value|mf}</span></a></td>
                        </tr>
                        {if $smarty.foreach.spendings.last}
                            <tr class="sum">
                                <td class="sum" colspan="3"><strong>Summe</strong></td>
                                <td class="sum" align="right"><span class="type-{if $sum_type.0 < 0}1{else}2{/if}"><strong>{$sum_type.0|mf}</strong></span></td>
                            </tr>
                        {/if}
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

                    {* Bar-Ausgaben anzeigen *}
                    {math equation='x*-1' assign=sum_withdrawal x=$sum_type.4}
                    {math equation='x+y' assign=sum_cash_all x=$sum_withdrawal y=$sum_type.3}
                    {section loop=$spendings_cash name=cash}
                        {if $smarty.section.cash.first}
                            <tr>
                                <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="4"><h3>Bar-Ausgaben</h3></td>
                            </tr>
                            <tr class="alt">
                                <td>&nbsp;</td>
                                <td>Bar-Abhebungen</td>
                                <td><img src="lib/images/icons/spendingtype/4.gif" width="16" height="16" hspace="2" /></td>
                                <td align="right"><span class="type-{if $sum_withdrawal < 0}1{else}2{/if}">{$sum_withdrawal|mf}</span></td>
                            </tr>
                        {/if}
                        {if $smarty.section.cash.iteration is odd}
                            <tr>
                        {else}
                            <tr class="alt">
                        {/if}
                            {if $summarize_months}
                                <td>{$spendings_cash[cash].date|date_format:'%d.'|utf8_encode}</td>
                            {else}
                                <td nowrap="true">{$spendings_cash[cash].date|date_format:'%d.%b.%y'|utf8_encode}</td>
                            {/if}
                            <td><a href="javascript:javascript:showEditor({$spendings_cash[cash].spending_id});">{$spendings_cash[cash].description|so}</a> {if $spendings_cash[cash].is_new}<sup>NEU</sup>{/if}</td>
                            <td><img src="lib/images/icons/spendingtype/3.gif" width="16" height="16" hspace="2" /></td>
                            <td align="right"><span class="type-{$spendings_cash[cash].type}">-{$spendings_cash[cash].value|mf}</span></td>
                        </tr>
                        {if $smarty.section.cash.last}
                            <tr class="sum">
                                <td colspan="3" class="sum"><strong>Summe</strong></td>
                                <td colspan="3" class="sum" align="right"><span class="type-{if $sum_cash_all < 0}1{else}2{/if}"><strong>{$sum_cash_all|mf}</strong></span></td>
                            </tr>

                            <!-- tr>
                                <td colspan="4">&nbsp;</td>
                            </tr -->
                        {/if}
                    {/section}

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
    <form name="addspending" method="post" action="{$smarty.server.PHP_SELF}">
        <input type="hidden" name="spending_id" value="0" />
        <table cellspacing="0" cellpadding="2">
            <tr>
                <td align="right"><label for="account_id">Konto</label></td>
                <td>
                    <select name="account_id" id="account_id">
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
                    <input type="radio" name="type" value="1" selected="true" id="type_1"> <label for="type_1"><img src="lib/images/icons/spendingtype/1.gif" width="32" height="32" alt="Ausgabe" title="Ausgabe" align="absmiddle" /> Ausgabe</label><br />
                    <input type="radio" name="type" value="2" id="type_2"> <label for="type_2"><img src="lib/images/icons/spendingtype/2.gif" width="32" height="32" alt="Einnahme" title="Einnahme" align="absmiddle" /> Einnahme</label><br />
                    <input type="radio" name="type" value="3" id="type_3"> <label for="type_3"><img src="lib/images/icons/spendingtype/3.gif" width="32" height="32" alt="Bar-Ausgabe" title="Bar-Ausgabe" align="absmiddle" /> Bar bezahlt</label><br />
                    <input type="radio" name="type" value="4" id="type_4"> <label for="type_4"><img src="lib/images/icons/spendingtype/4.gif" width="32" height="32" alt="Bargeld abheben" title="Bargeld abheben" align="absmiddle" /> Bargeld abgehoben</label><br />
                </td>
            </tr>
            <tr>
                <td>
                    <select onChange="document.addspending.day.value=this.value.substr(6,2);document.addspending.month.value=this.value.substr(4,2);document.addspending.year.value=this.value.substr(0,4);">
                            <option value="">( Datum )</option>
                            <option value="{$smarty.now|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now|date_format:'%d. Heute'|utf8_encode}</option>
                            <option value="{$smarty.now-86400|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now-86400|date_format:'%d. %A'|utf8_encode}</option>
                            <option value="{$smarty.now-86400*2|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now-86400*2|date_format:'%d. %A'|utf8_encode}</option>
                            <option value="{$smarty.now-86400*3|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now-86400*3|date_format:'%d. %A'|utf8_encode}</option>
                            <option value="{$smarty.now-86400*4|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now-86400*4|date_format:'%d. %A'|utf8_encode}</option>
                            <option value="{$smarty.now-86400*5|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now-86400*5|date_format:'%d. %A'|utf8_encode}</option>
                            <option value="{$smarty.now-86400*6|date_format:'%Y%m%d'|utf8_encode}">{$smarty.now-86400*6|date_format:'%d. %A'|utf8_encode}</option>
                    </select>
                </td>
                <td>
                    <input type="text" name="day" maxlength="2" class="tiny" tabindex="1" value="{$smarty.now|date_format:'%d'|utf8_encode}" />.<input type="text" name="month" maxlength="2" class="tiny" tabindex="2" value="{$smarty.now|date_format:'%m'|utf8_encode}" />.<input type="text" name="year" class="small" maxlength="4" tabindex="3" value="{$smarty.now|date_format:'%Y'|utf8_encode}" />
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
                    <select name="spendinggroup_id" onChange="document.addspending.spendinggroup_name.value=spendinggroups[this.value]; updateDescriptionSelector(this.value);">
                            <option value="">( Art )</option>
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
                <td align="right">
                    <select name="descriptionSelector" disabled="true" onchange="document.addspending.description.value = this.value;">
                        <option>( Beschreibung )</option>
                    </select>
                </td>
                <td><input type="text" name="description" class="text" tabindex="5" /></td>
            </tr>
            <tr>
                <td align="right"><label for="value">Betrag</label></td>
                <td><input type="text" name="value" class="text" tabindex="6" size="5" id="value" /></td>
            </tr>
            <tr>
                <td align="right">Bereits gebucht?</td>
                <td>
                    <input type="radio" name="booked" value="1" checked="true" id="booked_1" /> <label for="booked_1">Ja</label>
                    <input type="radio" name="booked" value="0" id="booked_0" /> <label for="booked_0">Nein</label>
                </td>
            </tr>
            <tr>
                <td align="right"><label for="ifduplicate"><u>N</u>euen Eintragen anlegen</label></td>
                <td><input type="checkbox" name="ifduplicate" value="1" accesskey="n" id="ifduplicate" /></td>
            </tr>
            <tr>
                <td align="right"><label for="ifdelete">Eintrag <u>l</u>öschen</label></td>
                <td><input type="checkbox" name="ifdelete" value="1" accesskey="l" id="ifdelete" /></td>
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

    {section loop=$spendings_notbooked name=notbooked}
        Spendings[{$spendings_notbooked[notbooked].spending_id}] = new Array();
        {foreach from=$spendings_notbooked[notbooked] key=fieldname item=field_value}
            Spendings[{$spendings_notbooked[notbooked].spending_id}]["{$fieldname}"] = "{$field_value|jso}";
        {/foreach}
    {/section}

    {section loop=$spendings_cash name=cash}
        Spendings[{$spendings_cash[cash].spending_id}] = new Array();
        {foreach from=$spendings_cash[cash] key=fieldname item=field_value}
            Spendings[{$spendings_cash[cash].spending_id}]["{$fieldname}"] = "{$field_value|jso}";
        {/foreach}
    {/section}

    var Descriptions = new Array();
    {foreach from=$descriptions name=descriptionpergroup key=spendinggroup_id item=descriptions}
        Descriptions[{$spendinggroup_id}] = new Array();
        {section loop=$descriptions name=descriptions}
            Descriptions[{$spendinggroup_id}][{$smarty.section.descriptions.index}] = "{$descriptions[descriptions]|jso}";
        {/section}
    {/foreach}

    var spendingform = xGetElementById('spendingform');

    function showEditor (spending_id)
    {ldelim}
        if (spending_id != null) {ldelim}
            for (var fieldname in Spendings[spending_id]) {ldelim}
                if (fieldname == "date") continue;
                if (fieldname == "user_id") continue;
                if (fieldname == "timestamp") continue;
                if (fieldname == "is_new") continue;
                if (fieldname == "booked") {ldelim}
                    if (Spendings[spending_id][fieldname] == "1") {ldelim}
                        document.addspending.booked[0].checked = true;
                    {rdelim} else {ldelim}
                        document.addspending.booked[1].checked = true;
                    {rdelim}
                    continue;
                {rdelim}
                if (fieldname == "type") {ldelim}
                    document.addspending.type[(Spendings[spending_id][fieldname] - 1)].checked = true;
                    continue;
                {rdelim}
                if (fieldname == "spendinggroup_id") {ldelim}
                    document.addspending.spendinggroup_name.value = spendinggroups[Spendings[spending_id][fieldname]];
                    updateDescriptionSelector(Spendings[spending_id][fieldname]);
                {rdelim}
                eval("document.addspending." + fieldname + ".value = '" + Spendings[spending_id][fieldname] + "';");
            {rdelim}
            document.addspending.ifduplicate.disabled = false;
        {rdelim} else {ldelim}
            document.addspending.reset();
            document.addspending.spending_id.value = 0;
            document.addspending.ifduplicate.disabled = true;
            updateDescriptionSelector('');
        {rdelim}
        xTo = ((xClientWidth() - xWidth(spendingform)) / 2) + xScrollLeft();
        yTo = (((xClientHeight() / 7) * 3) - (xHeight(spendingform) / 2)) + xScrollTop();
        xMoveTo(spendingform, xTo, yTo);
        xShow(spendingform);
    {rdelim}

    function updateDescriptionSelector (spendinggroup_id)
    {ldelim}
        document.addspending.descriptionSelector.length = 0;
        document.addspending.descriptionSelector.options[0] = new Option('( Beschreibung )');
        if (spendinggroup_id == '') {ldelim}
            document.addspending.descriptionSelector.disabled = true;
            return;
        {rdelim}
        document.addspending.descriptionSelector.disabled = false;
        var n = 1;
        for (var description_id in Descriptions[spendinggroup_id]) {ldelim}
            var description = Descriptions[spendinggroup_id][description_id];
            document.addspending.descriptionSelector.options[n] = new Option(description, description);
            n++;
        {rdelim}
    {rdelim}

// -->
</script>

{include file='html_foot.tpl'}


