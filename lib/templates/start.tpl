{include file='html_head.tpl'}
    {if $AUTH}
    {else}
        {section loop=$users name=users}
            {if $smarty.section.users.first}
                <form method="post" name="loginform" action="{$SCRIPT_NAME}">
                    <input type="hidden" name="username" />
                    <div class="loginbox">
                        <div class="boxtitle">AUSGABEN</div>
                        <div class="boxsubtitle">Login</div>
                        <div class="boxcontent">
                            <p>
                                Bitte einen Benutzer auswählen und dann das Passwort eingeben.
                            </p>
                {/if}
                <p class="large">
                    <a href="#" class="login" onclick="doLogin('{$users[users].email}', this);">
                        <img src="lib/images/users/{$users[users].user_id}.png" width="48" height="48" align="middle" /> <strong>{$users[users].prename}</strong>
                    </a>
                </p>
            {if $smarty.section.users.last}
                        {if $smarty.request.username}
                            <p class="error">
                                Login fehlgeschlagen!
                            </p>
                        {/if}
                        </div>
                        <div class="boxfooter">&copy; 2004 Markus Tacker</div>
                    </div>
                    <div id="loginpassword">
                        <input type="password" name="password" />
                    </div>
                </form>
                <script type="text/javascript">
                <!--
                    loginpassword = xGetElementById('loginpassword');
                    
                    xHide(loginpassword);
                    
                    function doLogin(username, clicked) 
                    {literal}{{/literal}
                        document.loginform.username.value = username;
                        var x = xPageX(clicked) + 56;
                        var y = xPageY(clicked) + xHeight(clicked) - xHeight(loginpassword);
                        xMoveTo(loginpassword, x, y);
                        xShow(loginpassword);
                        document.loginform.password.focus();
                    {literal}}{/literal}
                // -->
                </script>
            {/if}
        {/section}
    {/if}
{include file='html_foot.tpl'}