// x_img.js, X v3.15.2, Cross-Browser.com DHTML Library
// Copyright (c) 2004 Michael Foster, Licensed LGPL (gnu.org)

function xImgRollSetup(path, ovrSuffix, fileExt) 
{
  var ele, id;
  for (var i=3; i<arguments.length; ++i) {
    id = arguments[i];
    if (ele = xGetElementById(id)) {
      ele.xOutUrl = path + id + fileExt;
      ele.xOvrObj = new Image();
      ele.xOvrObj.src = path + id + ovrSuffix + fileExt;
      ele.onmouseout = xImgOnMouseout;
      ele.onmouseover = xImgOnMouseover;
    }
  }
}  
function xImgOnMouseout(e)
{
  if (this.xOutUrl) {
    this.src = this.xOutUrl;
  }
}
function xImgOnMouseover(e)
{
  if (this.xOvrObj && this.xOvrObj.complete) {
    this.src = this.xOvrObj.src;
  }
}
