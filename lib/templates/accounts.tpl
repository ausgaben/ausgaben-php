{include file='html_head.tpl'}
<div class="frameleft">
    <div class="boxcontent">
        <p class="frametitle">Konten</p>
        <p>
            <a href="?do={$do}"><img src="lib/images/icons/small/riot_page.png" width="21" height="18" align="absmiddle" />Neu ...</a>
        </p>
        {foreach from=$accounts name=list_account item=list_account}
            {if $smarty.foreach.list_account.first}<p>{/if}
            <a href="?do={$do}&amp;account_id={$list_account.account_id}"><img src="lib/images/icons/small/riot_edit_page.png" width="21" height="18" align="absmiddle" />{$list_account.name}</a><br />
            {if $smarty.foreach.list_account.last}</p>{/if}
        {/foreach}
    </div>
</div>
<div class="framecenter">
    <div class="boxsubtitle">Konten</div>
    <form method="post" action="{$SCRIPT_NAME}">
        {if $smarty.request.account_id}
            {assign var=account value=$accounts[$smarty.request.account_id]}
            <input type="hidden" name="account_id" value="{$account.account_id}" />
        {else}
            <input type="hidden" name="account_id" value="" />
        {/if}
        <input type="hidden" name="do" value="{$do}" />
        <div class="boxcontent">
            <p>
                Name des Kontos<br />
                <input type="text" name="name" value="{$account.name}" />
            </p>
            <p>
                Beschreibung<br />
                <textarea name="description">{$account.description}</textarea>
            </p>
            <p>
                Konto-Bewegungen monatlich zusammenfassen?<br />
                <input type="radio" name="summarize_months" value="1" {if $account.summarize_months eq 1 or !$account}checked="true"{/if} /> Ja
                <input type="radio" name="summarize_months" value="0" {if $account.summarize_months eq 0 and $account}checked="true"{/if} /> Nein
            </p>
            {if $smarty.request.account_id}
                <p>
                    <input type="checkbox" name="ifdelete" value="1" /> Konto l�schen
                </p>
            {/if}
            <p>
                <input type="submit" value="Speichern" name="ifsubmit" />
            </p>
        </div>
    </form>
</div>
<div class="clearall"></div>
{include file='html_foot.tpl'}