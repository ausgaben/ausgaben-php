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
                <select name="account_id">
                    <option value="">( Konto wählen )</option>
                    {section loop=$accounts name=accounts}
                        <option value="{$accounts[accounts].account_id}" {if $smarty.session.account_id eq $accounts[accounts].account_id}selected="true"{/if}>{$accounts[accounts].name}</option>
                    {/section}
                </select>
            </p>
            <p>
                <input type="checkbox" name="ifignoredrawings" value="1" checked="true" /> Sollen Abhebungen per Geldautomaten ignoriert werden?
            </p>
            <p>
                Eine CSV-Datei mit den Daten auswählen:<br />
                <input type="file" name="file" />
            </p>
            <p>
                <input type="submit" name="ifsubmit" value="Importieren" />
            </p>
        </form>
    </div>
</div>
<div class="clearall"></div>
{include file='html_foot.tpl'}