{include file='html_head.tpl'}
<div class="box">
    <h1>Import</h1>
    {if $n_imported > 0}
        <p>{$n_imported} Einträge importiert.</p>
    {/if}
    {if $n_failed > 0}
        <p>{$n_failed} Einträge nicht importiert.</p>
    {/if}
    <form method="post" enctype="multipart/form-data">
        <input type="file" name="file" /><br />
        <input type="submit" name="ifsubmit" value="Importieren" />
    </form>
</div>
{include file='html_foot.tpl'}