{include file='html_head.tpl'}
    {if !$AUTH}
        <div class="boxsubtitle">Login</div>
        <div class="loginform">
        {section loop=$users name=users}
            {if $smarty.section.users.first}
                <form method="post" name="loginform" action="{$smarty.server.PHP_SELF}">
                    <input type="hidden" name="username" />
                    <p>
                        Bitte einen Benutzer auswählen und dann das Passwort eingeben.
                    </p>
                {/if}
                <p class="large" onclick="doLogin('{$users[users].email}', this);">
                    <img src="lib/images/users/{$users[users].avatar}" align="middle" /> <strong>{$users[users].prename}</strong>
                </p>
            {if $smarty.section.users.last}
                        {if $smarty.request.username}
                            <p class="error">
                                Login fehlgeschlagen!
                            </p>
                        {/if}
                    <div id="loginpassword">
                        <input type="password" name="password" class="text" />
                    </div>
                </form>
                <script type="text/javascript">
                <!--
                    loginpassword = xGetElementById('loginpassword');

                    xHide(loginpassword);

                    function doLogin(username, clicked)
                    {literal}{{/literal}
                        document.loginform.username.value = username;
                        var x = xPageX(clicked) + 65;
                        var y = xPageY(clicked) + xHeight(clicked) - xHeight(loginpassword);
                        xMoveTo(loginpassword, x, y);
                        xShow(loginpassword);
                        document.loginform.password.focus();
                    {literal}}{/literal}
                // -->
                </script>
            {/if}
        {/section}
        </div>
    {/if}
{include file='html_foot.tpl'}
