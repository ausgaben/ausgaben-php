// xmenu4_1.js
// xMenu4 Demo 1, Cascading menus from nested ULs!
// Copyright (c) 2002,2003 Michael Foster (mike@cross-browser.com)
// This code is distributed under the terms of the LGPL (gnu.org)

////--- Loader

if (!xIE4 && !xNN4) {
  document.write("<"+"link rel='stylesheet' type='text/css' href='xmenu4_1_dhtml.css'>");
  window.onload = xOnload;
}

////--- Load Event Listener

function xOnload()
{
  var me = xGetElementById('myMenu1');
  if (!xDef(me.nodeName, me.firstChild, me.nextSibling)) {
    return;
  }
  
  var mo = new xMenu4(
    me,                       // id str or ele obj of outermost UL
    true,                     // outer UL position: true=absolute, false=static
    true,                     // main label positioning: true=horizontal, false=vertical
    0, 1,                     // box horizontal and vertical offsets
    [-3, -10, -6, -10],       // lbl focus clip array
    [-30, null, null, null],  // box focus clip array
    // css class names:
    'xmBar', 'xmBox',
    'xmBarLbl', 'xmBarLblHvr',
    'xmBarItm', 'xmBarItmHvr',
    'xmBoxLbl', 'xmBoxLblHvr',
    'xmBoxItm', 'xmBoxItmHvr'
  );

  xMnuMgr.add(mo);
  xMnuMgr.load();
  xmWinOnResize();
  xAddEventListener(window, 'resize', xmWinOnResize, false);
}

////--- Window Resize Event Listener

function xmWinOnResize()
{
  // !!!
  var me = xMnuMgr.activeMenu.ele;
  var rc = xGetElementById('rightColumn');
  var mm = xGetElementById('menuMarker');
  var mmp = xParent(mm);
  xMoveTo(me, xPageX(mm)-xPageX(rc), xPageY(mm)-xPageY(rc));
  xMnuMgr.paint();
}

