{include file='html_head.tpl'}
<div class="frameleft">&nbsp;</div>
<div class="framecenter">
    <div class="boxsubtitle">Import</div>
    <div class="boxcontent">
        {if $n_imported > 0}
            <p>{$n_imported} Einträge importiert.</p>
        {/if}
        {if $n_failed > 0}
            <p>{$n_failed} Einträge nicht importiert.</p>
        {/if}
        <form method="post" enctype="multipart/form-data">
            <p>
                Bitte das Konto wählen, in das Importiert werden soll:<br />
                {section loop=$accounts name=accounts}
                    <input type="radio" name="account_id" value="{$accounts[accounts].account_id}" {if $smarty.session.account_id eq $accounts[accounts].account_id}checked="true"{/if} id="account_id_{$accounts[accounts].account_id}" /><label for="account_id_{$accounts[accounts].account_id}">{$accounts[accounts].name}{if $accounts[accounts].last_import > 0} (Letzter Import: {$accounts[accounts].last_import|date_format:'%x'}){/if}</label><br />
                {/section}
            </p>
            <p>
                <input type="checkbox" name="ifignoredrawings" value="1" checked="true" /> Sollen Abhebungen per Geldautomaten ignoriert werden?
            </p>
            <p>
                Eine CSV-Datei mit den Daten auswählen:<br />
                <input type="file" name="file" />
            </p>
            <p>
                <input type="submit" class="button" name="ifsubmit" value="Importieren" />
            </p>
        </form>
    </div>
</div>
<div class="clearall"></div>
{include file='html_foot.tpl'}
