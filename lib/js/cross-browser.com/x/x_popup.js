// x_popup.js, X v3.15.2, Cross-Browser.com DHTML Library
// Copyright (c) 2004 Michael Foster, Licensed LGPL (gnu.org)

function xPopup(sTmrType, uTimeout, sPosition, sStyle, sId, sUrl) // sTmrType: 'timeout' or 'interval'
{
  if (document.getElementById && document.createElement && document.body && document.body.appendChild)
  { 
    // create popup element
    //var e = document.createElement('DIV');
    var e = document.createElement('IFRAME');
    this.ele = e;
    e.id = sId;
    e.style.position = 'absolute';
    e.className = sStyle;
    //e.innerHTML = sHtml;
    e.src = sUrl
    document.body.appendChild(e);
    xShow(e);
    this.tmr = xTimer.set(sTmrType, this, sTmrType, uTimeout);
    // timer event listeners
    this.timeout = function() // hide popup
    {
      var e = this.ele;
      xSlideTo(e, -xWidth(e), -xHeight(e), this.slideTime);
    }
    this.interval = function() // size, position and show popup
    {
      var x=0, y=0, e = this.ele;
      var ew = xWidth(e), eh = xHeight(e);
      var cw = xClientWidth(), ch = xClientHeight();
      switch (this.pos) {
        case 'e':
          x = cw - ew - this.margin;
          y = (ch - eh)/2;
          break;
        case 'se':
          x = cw - ew - this.margin;
          y = ch - eh - this.margin;
          break;
        case 'w':
          x = this.margin;
          y = (ch - eh)/2;
          break;
        case 'cen': default:
          x = (cw - ew)/2;
          y = (ch - eh)/2;
          break;
      } // end switch    
      xSlideTo(e, xScrollLeft() + x, xScrollTop() + y, this.slideTime);
    }
    // init
    this.margin = 10;
    this.pos = sPosition;
    this.slideTime = 500; // slide time in ms
    this.interval();
  } 
} // end xPopup
