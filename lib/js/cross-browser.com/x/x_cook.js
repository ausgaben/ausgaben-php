// x_cook.js, X v3.15.2, Cross-Browser.com DHTML Library
// Copyright (c) 2004 Michael Foster, Licensed LGPL (gnu.org)

// cookie implementations based on code from Netscape Javascript Guide
function xSetCookie(name, value, expire, path) {
  document.cookie = name + "=" + escape(value) + ((!expire) ? "" : ("; expires=" + expire.toGMTString())) + "; path=/";
}
function xGetCookie(name) {
  var value=null, search=name+"=";
  if (document.cookie.length > 0) {
    var offset = document.cookie.indexOf(search);
    if (offset != -1) {
      offset += search.length;
      var end = document.cookie.indexOf(";", offset);
      if (end == -1) end = document.cookie.length;
      value = unescape(document.cookie.substring(offset, end));
    }
  }
  return value;
}
