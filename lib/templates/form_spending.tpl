<form name="addspending" method="post" action="{$SCRIPT_NAME}">
<input type="hidden" name="do" value="{$do}" />
<input type="hidden" name="household_id" value="{$smarty.session.household.household_id}" />
<input type="hidden" name="user_id" value="{$smarty.session.user.user_id}" />
{if isset($spending)}
	<input type="hidden" name="spending_id" value="{$spending.spending_id}" />
{/if}
	<tr {if isset($class)}class="{$class}"{/if}>
		<td colspan="4">
			<script type="text/javascript">
			<!--
				spendingtypes = new Array();
				{foreach from=$spendingtypes item=spendingtype}
				spendingtypes[{$spendingtype.spendingtype_id}] = '{$spendingtype.name}';
				{/foreach}
			// -->
			</script>
			<input type="text" name="spendingtype_name" class="medium" tabindex="1" {if isset($spending)}value="{$spendingtypes[$spending.spendingtype_id].name}"{/if} />
			<select name="spendingtype_id" onChange="document.addspending.spendingtype_name.value=spendingtypes[this.value];">
				<option value="">( Art wählen )</option>
				{foreach from=$spendingtypes item=spendingtype}
				<option value="{$spendingtype.spendingtype_id}">{$spendingtype.name}</option>
				{/foreach}
			</select>
		</td>
	</tr>
	<tr {if isset($class)}class="{$class}"{/if}>
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
		<td class="row">Beschreibung</td>
		<td class="row" align="right">Kosten</td>
		<td class="row">&nbsp;</td>
	</tr>
	<tr {if isset($class)}class="{$class}"{/if}>
		<td><input type="text" name="day" class="tiny" tabindex="2" value="{if isset($spending)}{$spending.day}{else}{$smarty.now|date_format:'%d'}{/if}" />.<input type="text" name="month" class="tiny" tabindex="3" value="{if isset($spending)}{$spending.month}{else}{$smarty.now|date_format:'%m'}{/if}" />.<input type="text" name="year" class="small" tabindex="4" value="{if isset($spending)}{$spending.year}{else}{$smarty.now|date_format:'%Y'}{/if}" /></td>
		<td><input type="text" name="description" class="large" tabindex="6" {if isset($spending)}value="{$spending.description}"{/if} /></td>
		<td align="right" class="row"><input type="text" name="value" class="small" tabindex="5" size="5" {if isset($spending)}value="{$spending.value}"{/if} /> &euro;&nbsp;</td>
		<td><input type="submit" name="ifsubmit" value="Eintragen" /></td>
	</tr>
</form>