// layout1.js
// mfoster, cross-browser.com

var pg = {
  hh:45,   // header height
  mw:100,  // menu width
  bm:45,   // bottom margin
  rm:100,  // right margin
  irm:100, // inner right margin
  fh:45    // footer height
};

window.onload = function() {
  winOnResize(); // initial positioning
  xAddEventListener(window, 'resize', winOnResize, false);
}

function winOnResize() {
  var cw = xClientWidth(), ch = xClientHeight();
  xResizeTo('header', cw, pg.hh);
  xMoveTo('header', 0, 0);
  xWidth('menu', pg.mw);
  xMoveTo('menu', 0, pg.hh);
  // set width to let text reflow
  xWidth('what', cw-pg.mw-pg.rm);
  xMoveTo('what', pg.mw, pg.hh);
  // set width to let text reflow
  xWidth('how', xWidth('what')-pg.irm);
  // marker's Y is end of text
  xMoveTo('how', pg.mw, xPageY('endOfWhat'));
  // after text reflows we can determine heights
  xHeight('what', xPageY('how')+xHeight('how')-xPageY('what'));
  xResizeTo('footer', cw, pg.fh);
  xMoveTo('footer', 0, xPageY('how')+xHeight('how')+pg.bm);
  // now show everything
  xShow('header');
  xShow('menu');
  xShow('what');
  xShow('how');
  xShow('footer');
}
