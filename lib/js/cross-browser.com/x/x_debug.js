// x_debug.js, X v3.15.2, Cross-Browser.com DHTML Library
// Copyright (c) 2004 Michael Foster, Licensed LGPL (gnu.org)

function xName(e) {
  if (!e) return e;
  else if (e.id && e.id != "") return e.id;
  else if (e.name && e.name != "") return e.name;
  else if (e.nodeName && e.nodeName != "") return e.nodeName;
  else if (e.tagName && e.tagName != "") return e.tagName;
  else return e;
}
function xParentChain(e,delim,bNode) {
  if (!(e=xGetElementById(e))) return;
  var lim=100, s = "", d = delim || "\n";
  while(e) {
    s += xName(e) + ', ofsL:'+e.offsetLeft + ', ofsT:'+e.offsetTop + d;
    e = xParent(e,bNode);
    if (!lim--) break;
  }
  return s;
}
function xLoadScript(url)
{
  if (document.createElement && document.getElementsByTagName) {
    var s = document.createElement('script');
    var h = document.getElementsByTagName('head');
    if (s && h.length) {
      s.src = url;
      h[0].appendChild(s);
    }
  }
}
function xEvalTextarea()
{
  var f = document.createElement('FORM');
  f.onsubmit = 'return false';
  var t = document.createElement('TEXTAREA');
  t.id='xDebugTA';
  t.name='xDebugTA';
  t.rows='20';
  t.cols='60';
  var b = document.createElement('INPUT');
  b.type = 'button';
  b.value = 'Evaluate';
  b.onclick = function() {eval(this.form.xDebugTA.value);};
  f.appendChild(t);
  f.appendChild(b);
  document.body.appendChild(f);
}
// keepieapart.js from PPK
if (document.all)
{
var detect = navigator.userAgent.toLowerCase();
var browser,thestring;
var version = 0;
if (checkIt('msie')) 
{
browser = "IE "
browser += detect.substr(place + thestring.length,3);
document.title = browser + ' - ' + document.title;
}
}
function checkIt(string)
{
place = detect.indexOf(string) + 1;
thestring = string;
return place;
}
