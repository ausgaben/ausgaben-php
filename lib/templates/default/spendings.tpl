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
                <td>{if $smarty.session.account_id eq $list_account.account_id}<strong>{/if}<a href="?account_id={$list_account.account_id}" {if $list_account.summarize_months}{popup text=$display_month|date_format:'im %B %Y'}{/if}>{$list_account.name}</a>{if $smarty.session.account_id eq $list_account.account_id}</strong>{/if}</td>
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
                        <td>{if $display_month eq $month}<strong>{/if}<a href="{$SCRIPT_NAME}?do={$smarty.request.do}&amp;display_month={$month}">{$month|date_format:"%b '%y"}</a>{if $display_month eq $month}</strong>{/if}</td>
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
            <form name="viewsettings" method="post" action="{$SCRIPT_NAME}">
                <input type="hidden" name="ifviewsettings" value="1" />
                <p>
                    <strong>Einnahmen und Ausgaben</strong><br />
                    <input type="radio" name="separate_sums" value="1" {if $smarty.session.user.settings.separate_sums}checked="true"{/if} onchange="document.viewsettings.submit();" id="separate_sums_1" /> <label for="separate_sums_1">getrennt anzeigen</label><br />
                    <input type="radio" name="separate_sums" value="0" {if !$smarty.session.user.settings.separate_sums}checked="true"{/if} onchange="document.viewsettings.submit();" id="separate_sums_2" /> <label for="separate_sums_2">zusammen anzeigen</label><br />
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
        <div class="boxsubtitle">{$account.name}</div>
        <div class="boxcontent">
            {if $summarize_months}
                <h3>{$display_month|date_format:'%B %Y'}</h3>
            {/if}
            <table {if $isIE}width="609"{else}width="100%"{/if} cellspacing="0" cellpadding="2">
                <tbody>
                    {* Summen anzeigen *}
                    <tr>
                        <td class="sum-2" align="right">&raquo;</td>
                        <td class="sum-2" colspan="2">Einnahmen</td>
                        <td class="sum-2" align="right" nowrap="true">{$sum_type.2|mf}</td>
                    </tr>
                    <tr>
                        <td class="sum-1" align="right">&raquo;</td>
                        <td class="sum-1" colspan="2">Ausgaben</td>
                        <td class="sum-1" align="right" nowrap="true">{$sum_type.1|mf}</td>
                    </tr>
                    <tr>
                        <td class="{if $sum_type.0 >= 0}sum-2{else}sum-1{/if}" colspan="3"><strong>Summe der Einnahmen und Ausgaben</strong></td>
                        <td class="{if $sum_type.0 >= 0}sum-2{else}sum-1{/if}" align="right"><strong>{$sum_type.0|mf}</strong></td>
                    </tr>
                    {if $account.enable_abf and $abf}
                        <tr>
                            <td class="{if $abf.value >= 0}sum-2{else}sum-1{/if}" align="right">&raquo;</td>
                            <td class="{if $abf.value >= 0}sum-2{else}sum-1{/if}" colspan="2">Übertrag aus {$abf.date|date_format:'%B %Y'}</td>
                            <td class="{if $abf.value >= 0}sum-2{else}sum-1{/if}" align="right">{$abf.value|mf}</td>
                        </tr>
                        <tr>
                            <td class="{if $sum_abf >= 0}sum-2{else}sum-1{/if}" colspan="3"><strong>Kontostand (am {$sum_abf_date|date_format:'%d.%m.%Y'})</strong></td>
                            <td class="{if $sum_abf >= 0}sum-2{else}sum-1{/if}" align="right"><strong>{$sum_abf|mf}</strong></td>
                        </tr>
                    {/if}

                    {* Nicht gebuchte Ausgaben anzeigen *}
                    {section loop=$spendings_notbooked name=notbooked}
                        {if $smarty.section.notbooked.first}
                            <tr>
                                <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="3" class="{if $sum_notbooked >= 0}sum-2{else}sum-1{/if}"><strong>Noch nicht gebucht</strong></td>
                                <td colspan="3" class="{if $sum_notbooked >= 0}sum-2{else}sum-1{/if}" align="right"><strong>{$sum_notbooked|mf}</strong></td>
                            </tr>
                        {/if}
                        {if $smarty.section.notbooked.iteration is odd}
                            <tr class="alt">
                        {else}
                            <tr>
                        {/if}
                            <td colspan="2"><a href="javascript:javascript:showEditor({$spendings_notbooked[notbooked].spending_id});">{$spendings_notbooked[notbooked].description|so}</a></td>
                            <td>{if $spendings_notbooked[notbooked].spendingmethod_id > 0}{assign var=spendingmethod_id value=$spendings_notbooked[notbooked].spendingmethod_id}<img src="lib/images/icons/spendingmethod/{$spendingmethods[$spendingmethod_id].icon}" width="11" height="11" hspace="2" />{/if}</td>
                            <td align="right"><span class="type-{$spendings_notbooked[notbooked].type}">{if $spendings_notbooked[notbooked].type eq 1}-{/if}{$spendings_notbooked[notbooked].value|mf}</span></td>
                        </tr>
                        {if $smarty.section.notbooked.last}
                            <!-- tr>
                                <td colspan="4">&nbsp;</td>
                            </tr -->
                        {/if}
                    {/section}

                    {* Ausgaben anzeigen *}
                    {if $smarty.session.user.settings.separate_sums}
                    {include file='spendings-separate_sums.tpl'}
                    {else}
                    {include file='spendings-no_separate_sums.tpl'}
                    {/if}
            
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
                <td align="right"><label for="type">Typ</label></td>
                <td>
                    <select name="type" id="type">
                        <option>( Typ wählen )</option>
                        <option value="1" selected="true">Ausgabe</option>
                        <option value="2">Einnahme</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <select onChange="document.addspending.day.value=this.value.substr(6,2);document.addspending.month.value=this.value.substr(4,2);document.addspending.year.value=this.value.substr(0,4);">
                            <option value="">( Datum )</option>
                            <option value="{$smarty.now|date_format:'%Y%m%d'}">{$smarty.now|date_format:'%d. Heute'}</option>
                            <option value="{$smarty.now-86400|date_format:'%Y%m%d'}">{$smarty.now-86400|date_format:'%d. %A'}</option>
                            <option value="{$smarty.now-86400*2|date_format:'%Y%m%d'}">{$smarty.now-86400*2|date_format:'%d. %A'}</option>
                            <option value="{$smarty.now-86400*3|date_format:'%Y%m%d'}">{$smarty.now-86400*3|date_format:'%d. %A'}</option>
                            <option value="{$smarty.now-86400*4|date_format:'%Y%m%d'}">{$smarty.now-86400*4|date_format:'%d. %A'}</option>
                            <option value="{$smarty.now-86400*5|date_format:'%Y%m%d'}">{$smarty.now-86400*5|date_format:'%d. %A'}</option>
                            <option value="{$smarty.now-86400*6|date_format:'%Y%m%d'}">{$smarty.now-86400*6|date_format:'%d. %A'}</option>
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
                <td align="right">Zahlungsmittel</td>
                <td>
                    <input type="radio" name="spendingmethod_id" value="0" checked="true" id="spendingmethod_id_0" /> <label for="spendingmethod_id_0">Kein</label><br />
                    {foreach from=$spendingmethods name=spendingmethods item=spendingmethod}
                        <input type="radio" name="spendingmethod_id" value="{$spendingmethod.spendingmethod_id}" id="spendingmethod_id_{$spendingmethod.spendingmethod_id}" /> <label for="spendingmethod_id_{$spendingmethod.spendingmethod_id}"><img src="lib/images/icons/spendingmethod/{$spendingmethod.icon}" width="11" height="11" /> {$spendingmethod.name}</label><br />
                    {/foreach}
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
                if (fieldname == "booked") {ldelim}
                    if (Spendings[spending_id][fieldname] == "1") {ldelim}
                        document.addspending.booked[0].checked = true;
                    {rdelim} else {ldelim}
                        document.addspending.booked[1].checked = true;
                    {rdelim}
                    continue;
                {rdelim}
                if (fieldname == "spendinggroup_id") {ldelim}
                    document.addspending.spendinggroup_name.value = spendinggroups[Spendings[spending_id][fieldname]];
                    updateDescriptionSelector(Spendings[spending_id][fieldname]);
                {rdelim}
                if (fieldname == "spendingmethod_id") {ldelim}
                    for (var fieldId in document.addspending.spendingmethod_id) {ldelim}
                        if (document.addspending.spendingmethod_id[fieldId].value == Spendings[spending_id][fieldname]) {ldelim}
                            document.addspending.spendingmethod_id[fieldId].checked = true;
                        {rdelim}
                    {rdelim}
                    continue;
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
