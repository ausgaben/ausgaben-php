// x_win.js, X v3.15.2, Cross-Browser.com DHTML Library
// Copyright (c) 2004 Michael Foster, Licensed LGPL (gnu.org)

function xWindow(name, w, h, x, y, loc, men, res, scr, sta, too)
{
  var f = '';
  if (w && h) {
    if (document.layers) f = 'screenX=' + x + ',screenY=' + y;
    else f = 'left=' + x + ',top=' + y;
    f += ',width=' + w + ',height=' + h + ',';
  }
  f += ('location='+loc+',menubar='+men+',resizable='+res
    +',scrollbars='+scr+',status='+sta+',toolbar='+too);
  this.features = f;
  this.name = name;
  this.load = function(sUrl) {
    if (this.wnd && !this.wnd.closed) this.wnd.location.href = sUrl;
    else this.wnd = window.open(sUrl, this.name, this.features);
    this.wnd.focus();
    return false;
  }
}

var xWinScrollWin = null;
function xWinScrollTo(win,x,y,uTime) {
  var e = win;
  if (!e.timeout) e.timeout = 25;
  e.xTarget = x; e.yTarget = y; e.slideTime = uTime; e.stop = false;
  e.yA = e.yTarget - xScrollTop();
  e.xA = e.xTarget - xScrollLeft(); // A = distance
  e.B = Math.PI / (2 * e.slideTime); // B = period
  e.yD = xScrollTop();
  e.xD = xScrollLeft(); // D = initial position
  var d = new Date(); e.C = d.getTime();
  if (!e.moving) {
    xWinScrollWin = e;
    xWinScroll();
  }
}
function xWinScroll() {
  var e = xWinScrollWin || window;
  var now, s, t, newY, newX;
  now = new Date();
  t = now.getTime() - e.C;
  if (e.stop) { e.moving = false; }
  else if (t < e.slideTime) {
    setTimeout("xWinScroll()", e.timeout);
    s = Math.sin(e.B * t);
    newX = Math.round(e.xA * s + e.xD);
    newY = Math.round(e.yA * s + e.yD);
    e.scrollTo(newX, newY);
    e.moving = true;
  }  
  else {
    e.scrollTo(e.xTarget, e.yTarget);
    xWinScrollWin = null;
    e.moving = false;
  }  
}
