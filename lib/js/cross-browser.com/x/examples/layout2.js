// layout2.js
// Cross-Browser.com & SitePoint.com - Equal Column Height Demo

if (document.getElementById || document.all) { // minimum dhtml support required
  document.write("<"+"script type='text/javascript' src='../x_core.js'><"+"/script>");
  document.write("<"+"script type='text/javascript' src='../x_event.js'><"+"/script>");
  document.write("<"+"style type='text/css'>#footer{visibility:hidden;}<"+"/style>");
  window.onload = winOnLoad;
}
function winOnLoad()
{
  var ele = xGetElementById('leftColumn');
  if (ele && xDef(ele.style, ele.offsetHeight)) { // another compatibility check
    adjustLayout();
    xAddEventListener(window, 'resize', winOnResize, false);
  }
}
function winOnResize()
{
  adjustLayout();
}
function adjustLayout()
{
  // Get content heights
  var cHeight = xHeight('centerColumnContent');
  var lHeight = xHeight('leftColumnContent');
  var rHeight = xHeight('rightColumnContent');

  // Find the maximum height
  var maxHeight = Math.max(cHeight, Math.max(lHeight, rHeight));

  // Assign maximum height to all columns
  xHeight('leftColumn', maxHeight);
  xHeight('centerColumn', maxHeight);
  xHeight('rightColumn', maxHeight);

  // Show the footer
  xShow('footer');
}
