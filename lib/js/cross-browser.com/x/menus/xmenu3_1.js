/*
	xMenu3_1.js
	Cross-Browser.com
*/

var pg = null;
var xDowngrade = true;

if (xInclude('../x_core.js', '../x_event.js', '../x_dom.js', '../x_slide.js', 'xmenu3.js', 'xmenu3_1_dhtml.css'))
{
  xDowngrade = false;
}

window.onload = function() {
  if (!xDowngrade) {
    pg = new xPage();
  }
}

function winOnResize() {
  if (pg) pg.paint();
}

function winOnScroll() {
  if (pg) {
    var st = xScrollTop();
    // m1
    if (st > pg.m1Top) {xSlideTo(pg.m1.ele, xScrollLeft() + pg.m1Left, st, 700);}
    else {xSlideTo(pg.m1.ele, xScrollLeft() + pg.m1Left, pg.m1Top, 700);}
    // m2
    xSlideTo(pg.m2.ele, xScrollLeft() + pg.m2Left, xScrollTop() + pg.m2Top, 700);
  }
}

function xPage() { // object prototype

  /// xPage.paint() Method

  this.paint = function() {
    window.scrollTo(0,0);
    var x, w, cw;
    // Calculate column's width and x coord
    x = this.m2W;
    cw = xClientWidth() - 2 * x;
    if (cw < this.cMinW) {w = this.cMinW;}
    else if (cw > this.cMaxW) {
      w = this.cMaxW;
      x = (xClientWidth() - w) / 2; // center column in window
    }
    else {w = cw;}
    // Set widths
    xResizeTo(this.h, w, this.hH);              // header
    xWidth(this.c, w);                          // column
    xResizeTo(this.f, w, this.fH);              // footer
    xResizeTo(this.m1.ele, w, this.m1H);        // menu 1
    xResizeTo(this.m2.ele, this.m2W, this.m2H); // menu 2
    // set positions
    // header
    xMoveTo(this.h, x, 2);
    // m1
    xMoveTo(this.m1.ele, x, xPageY(this.h) + xHeight(this.h)); 
    // column
    xMoveTo(this.c, x, xPageY(this.m1.ele) + xHeight(this.m1.ele)); 
    // m2
    xMoveTo(this.m2.ele, x - xWidth(this.m2.ele), xClientHeight()-xHeight(this.m2.ele));
    // footer
    xMoveTo(this.f, x, xTop(this.c)+xHeight(this.c)); 
    // refresh menu positions
    this.m1.paint();
    this.m2.paint();
    // Show everything
    xShow(this.h);
    xShow(this.c);
    xShow(this.f);
    xShow(this.m1.ele);
    xShow(this.m2.ele);
    // Setup floater offsets
    this.m1Left = xPageX(this.m1.ele) - xScrollLeft();
    this.m1Top = xPageY(this.m1.ele) - xScrollTop();
    this.m2Left = xPageX(this.m2.ele) - xScrollLeft();
    this.m2Top = xPageY(this.m2.ele) - xScrollTop();
  }

  /// xPage Properties and Constructor

  // adjustable page parameters
  this.cMinW = 300; // column min width
  this.cMaxW = 600; // column max width
  this.m2W = 80;    // menu 2 width
  this.m2H = 250;   // menu 2 height
  this.m1H = 36;    // menu 1 height
  this.hH = 24;     // header height
  this.fH = 24;     // footer height

  // element references
  this.h = xGetElementById('xHead');
  this.c = xGetElementById('xColumn');
  this.f = xGetElementById('xFoot');

  // Create menu 1
  this.m1 = new xMenu('xMenu1',         // element id
    'horizontal', 2, -6,                // mnuType, verOfs, hrzOfs
    -12, -16, -20, -4,                  // lbl selection area clipping (top,right,bottom,left)
    -32, null, null, null,              // box selection area clipping
    'myHMBarLbl', 'myHMBarLblHvr',       // barLblOutStyle, barLblOvrStyle
    'myHMBarLblHvrClosed',                // barLblOvrClosedStyle
    'myMLbl', 'myMLblHvr',             // lblOutStyle, lblOvrStyle
    'myHMBar', 'myMBox');            // barStyle, boxStyle

  // Create menu 2
  this.m2 = new xMenu('xMenu2',         // element id
    'vertical', 2, -6,                  // mnuType, verOfs, hrzOfs
    -12, -4, -20, -12,                  // lbl selection area clipping (top,right,bottom,left)
    -32, null, null, null,              // box selection area clipping
    'myVMBarLbl', 'myVMBarLblHvr',       // barLblOutStyle, barLblOvrStyle
    'myVMBarLblHvrClosed',                // barLblOvrClosedStyle
    'myMLbl', 'myMLblHvr',             // lblOutStyle, lblOvrStyle
    'myVMBar', 'myMBox');            // barStyle, boxStyle
  
  //
  this.m1.load();
  this.m2.load();
  
  // Paint everything
  this.paint();
  
  // Set menu z's
  xZIndex(this.m1.ele, 30);
  xZIndex(this.m2.ele, 20);
  
  // Listen to resize and scroll events
  xAddEventListener(window, 'resize', winOnResize);
  xAddEventListener(window, 'scroll', winOnScroll);
}

