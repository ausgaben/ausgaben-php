{include file='html_head.tpl'}
{section loop=$spendings name=spendings}
    {if $smarty.section.spendings.first}
        <div class="box">
            <h1>Statistik</h1>
            <table>
                <thead>
                    <tr>
                        <td>Monat</td>
                        <td>Summe</td>
                    </tr>
                </thead>
                <tbody>
    {/if}
    <tr>
        <td>{$spendings[spendings].month|date_format:'%B %Y'}&nbsp;</td>
        <td>&nbsp;{$spendings[spendings].value|string_format:'%0.2f'} &euro;</td>
    </tr>
    {if $smarty.section.spendings.last}
                </tbody>
            </table>
        </div>
    {/if}
{/section}
{include file='html_foot.tpl'}