// xMenu 3 v0.01, Cross-Browser DHTML Menu from Cross-Browser.com
// Copyright (c) 2003 Michael Foster (mike@cross-browser.com)
// This code is distributed under the terms of the LGPL (gnu.org)

var xMnuMgr = new xMenuManager();

////--- xMenuManager Object Prototype

function xMenuManager() {
  /// Properties
  this.activeMenu = null;
  this.firstLd = true;
  this.err = '';
  this.lblRE = new RegExp('\\bxmLbl\\b');
  this.boxRE = new RegExp('\\bxmBox\\b');
  /// Methods
  this.isLbl = function(ele) {
    if (ele && ele.className && ele.className.search(this.lblRE) != -1) return true;
    return false;
  }
  this.isBox = function(ele) {
    if (ele && ele.className && ele.className.search(this.boxRE) != -1) return true;
    return false;
  }
}

////--- xMenu Object Prototype

function xMenu(
  id, mnuType, verOfs, hrzOfs,
  lblClipT, lblClipR, lblClipB, lblClipL,
  boxClipT, boxClipR, boxClipB, boxClipL,
  barLblOutStyle, barLblOvrStyle, barLblOvrClosedStyle,
  lblOutStyle, lblOvrStyle, barStyle, boxStyle)
{
  /// Properties
  this.ele = null;
  this.activeBox = null;
  this.activeLbl = null;
  this.isOpen = false;
  this.id = id;
  this.mnuType = mnuType;
  this.verOfs = verOfs; this.hrzOfs = hrzOfs;
  this.lblClipT = lblClipT; this.lblClipR = lblClipR;
  this.lblClipB = lblClipB; this.lblClipL = lblClipL;
  this.boxClipT = boxClipT; this.boxClipR = boxClipR;
  this.boxClipB = boxClipB; this.boxClipL = boxClipL;
  this.barLblOutStyle = 'xmLbl ' + barLblOutStyle;
  this.barLblOvrStyle = 'xmLbl ' + barLblOvrStyle;
  this.barLblOvrClosedStyle = 'xmLbl ' + barLblOvrClosedStyle;
  this.lblOutStyle = 'xmLbl ' + lblOutStyle; this.lblOvrStyle = 'xmLbl ' + lblOvrStyle,
  this.barStyle = 'xmBox ' + barStyle; this.boxStyle = 'xmBox ' + boxStyle;
  /// Methods
  //    paint, load, createTree, traverseDown,
  //    activateBox, deactivateActive, deactivateAll
  //    moveToRightOrLeft, moveToBottomOrTop
  /// Constructor
}

////--- xMenu.load()

xMenu.prototype.load = function() {
  this.ele = xGetElementById(this.id);
  if (this.ele) {
    this.createTree(this, this.ele, null, null);
    if (xMnuMgr.err == '') {
      this.traverseDown(this.ele, xmStyleIterator);
      if (xMnuMgr.firstLd) {
        xAddEventListener(document, 'mousemove', xmDocOnMouseMove, false);
        xMnuMgr.firstLd = false;
      }
    }
  }
  else {
    xMnuMgr.err = 'Element ('+this.id+') does not exist';
  }
}

////--- xMenu.paint()

xMenu.prototype.paint = function() {
  this.traverseDown(this.ele, xmPaintIterator);
}

////--- xMenu.unload()

xMenu.prototype.unload = function() {
  // ...
}

////--- xmPaintIterator()

function xmPaintIterator(box) {
  if (box.xmObj.mnuType == 'horizontal') { // Horizontal menu bar
    if (box.xmLevel == 1) {
      box.xmObj.moveToBottomOrTop(box);
    }
    else if (box.xmLevel > 1) {
      box.xmObj.moveToRightOrLeft(box);
    }
  }
  else if (box.xmObj.mnuType == 'vertical') { // Vertical menu bar
    if (box.xmLevel > 0) {
      box.xmObj.moveToRightOrLeft(box);
    }
  }
  return true;
}

////--- xMenu.moveToBottomOrTop()

xMenu.prototype.moveToBottomOrTop = function(box) {
  var x, y, cw = xClientWidth(), ch = xClientHeight(), bw = xWidth(box), bh = xHeight(box);
  /// find x
  if (xPageX(box.xmParentLabel) + bw > cw + xScrollLeft()) {
    // align box right with label right
    x = xOffsetLeft(box.xmParentLabel) + xWidth(box.xmParentLabel) - bw;
  }
  else {
    // align box left with label left
    x = xOffsetLeft(box.xmParentLabel);
  }
  /// find y
  if (xPageY(box.xmParentLabel) + xHeight(box.xmParentLabel) + box.xmObj.verOfs + bh > ch + xScrollTop()) {
    // put box above label
    y = xOffsetTop(box.xmParentLabel) - box.xmObj.verOfs - bh;
  }
  else {
    // put box under label
    y = xOffsetTop(box.xmParentLabel) + xHeight(box.xmParentLabel) + box.xmObj.verOfs;
  }
  xMoveTo(box, x, y);
}

////--- xMenu.moveToRightOrLeft()

xMenu.prototype.moveToRightOrLeft = function(box) {
  var x, y, cw = xClientWidth(), ch = xClientHeight(), bw = xWidth(box), bh = xHeight(box);
  /// find x
  if (xPageX(box.xmParent) + xWidth(box.xmParent) + box.xmObj.hrzOfs + bw > cw + xScrollLeft()) {
    // put box to left of label
    x = -box.xmObj.hrzOfs - bw;
  }
  else {
    // put box to right of label
    x = xWidth(box.xmParent) + box.xmObj.hrzOfs;
  }
  /// find y
  if (xPageY(box.xmParentLabel) + bh > ch + xScrollTop()) {
    // put box above label
    y = xOffsetTop(box.xmParentLabel) + xHeight(box.xmParentLabel) - bh;
  }
  else {
    // put box under label
    y = xOffsetTop(box.xmParentLabel);
  }
  xMoveTo(box, x, y);
}

////--- xmStyleIterator()

function xmStyleIterator(box) {
  if (box.xmLevel == 0) {
    box.className = box.xmObj.barStyle;
  }
  else if (box.xmLevel == 1) {
    box.className = box.xmObj.boxStyle;
    box.xmParentLabel.className = box.xmObj.barLblOutStyle;
  }
  else if (box.xmLevel > 1) {
    box.className = box.xmObj.boxStyle;
    box.xmParentLabel.className = box.xmObj.lblOutStyle;
  }
  return true;
}

////--- xmLblOnClick()

function xmLblOnClick(e) {
  if (xMnuMgr.activeMenu && !xMnuMgr.activeMenu.isOpen) {
    var evnt = new xEvent(e);
    var ele = evnt.target;
    while (ele && !ele.xmIsLabel && !ele.xmIsBox) {
      ele = xParent(ele);
    }
    if (ele && ele.xmIsLabel) {
      xMnuMgr.activeMenu.activeLbl = ele;
      xMnuMgr.activeMenu.isOpen = true;
      xMnuMgr.activeMenu.activateBox(ele.xmChildBox);
    }
  }
}

////--- xmDocOnMouseMove()

function xmDocOnMouseMove(e) {
  var evnt = new xEvent(e);
  var ele = evnt.target;
  while (ele && !ele.xmIsLabel && !ele.xmIsBox) {ele = xParent(ele);}
  if (ele) {
    var xmObj = ele.xmIsLabel ? ele.xmChildBox.xmObj : ele.xmObj;
    if (xMnuMgr.activeMenu && xMnuMgr.activeMenu != xmObj) {
      xMnuMgr.activeMenu.deactivateAll();
    }
    xMnuMgr.activeMenu = xmObj;
    xMnuMgr.activeMenu.activeBox = xmObj.activeBox ? xmObj.activeBox : xmObj.ele;
    if (xmObj.isOpen) {
      if (ele.xmIsLabel) {
        if (ele.xmChildBox != xMnuMgr.activeMenu.activeBox) {
          if (xMnuMgr.activeMenu.activeBox  && xMnuMgr.activeMenu.activeBox.xmLevel != 0) {// not just going from bar to barLbl
            if (ele.xmChildBox.xmSubTreeNum != xMnuMgr.activeMenu.activeBox.xmSubTreeNum) {// changing subtrees
              xMnuMgr.activeMenu.deactivateSubTree(xMnuMgr.activeMenu.activeBox, 1);
            }
            else if (ele.xmChildBox.xmParent != xMnuMgr.activeMenu.activeBox) {// mouse is not on active box
              xMnuMgr.activeMenu.deactivateActive();
            }
          }
          if (xMnuMgr.activeMenu) {
            xMnuMgr.activeMenu.activateBox(ele.xmChildBox);
          }
        }
      }                                                                                        
      else if (ele.xmIsBox) {
        if (xMnuMgr.activeMenu.activeBox && ele != xMnuMgr.activeMenu.activeBox) {
          if (!xHasPoint( // not on label but close to it
                xMnuMgr.activeMenu.activeBox.xmParentLabel, evnt.pageX, evnt.pageY,
                ele.xmObj.lblClipT, ele.xmObj.lblClipR, ele.xmObj.lblClipB, ele.xmObj.lblClipL))
          {
            xMnuMgr.activeMenu.deactivateActive();
          }
        }
      }
    } // end if (xmObj.isOpen)
    else {
      if (ele.xmIsLabel) {
        if (xmObj.activeLabel) {
          xmObj.activeLabel.className = xmObj.barLblOutStyle;
        }
        xmObj.activeLabel = ele;
        xmObj.activeLabel.className = xmObj.barLblOvrClosedStyle;
      }
      else if (ele.xmIsBox) {
        if (xmObj.activeLabel) {
          xmObj.activeLabel.className = xmObj.barLblOutStyle;
        }
        xmObj.activeLabel = null;
      }
    }
  }
  else { // if(!ele)
    if (xMnuMgr.activeMenu && xMnuMgr.activeMenu.activeBox) {
      if (xMnuMgr.activeMenu.isOpen) {
        if (!xHasPoint( // not on box but close to it
              xMnuMgr.activeMenu.activeBox, evnt.pageX, evnt.pageY,
              xMnuMgr.activeMenu.boxClipT, xMnuMgr.activeMenu.boxClipR,
              xMnuMgr.activeMenu.boxClipB, xMnuMgr.activeMenu.boxClipL))
        {
          xMnuMgr.activeMenu.deactivateActive();
        }
      }
      else {
        if (xMnuMgr.activeMenu.activeLabel) {
          xMnuMgr.activeMenu.activeLabel.className = xMnuMgr.activeMenu.barLblOutStyle;
        }
        xMnuMgr.activeMenu.activeLabel = null;
      }
    }
  }
  /***************** debug
  if (ele) {
    if (ele.xmIsLabel) {
      window.status =
        'activeMenu: ' + (xMnuMgr.activeMenu ? xName(xMnuMgr.activeMenu.ele) : 'none') + ', ' +
        'activeBox: ' + xName(ele.xmChildBox.xmObj.activeBox) + ', ' +
        'label: ' + xName(ele);
    }
    else if (ele.xmIsBox) {
      window.status =
        'activeMenu: ' + (xMnuMgr.activeMenu ? xName(xMnuMgr.activeMenu.ele) : 'none') + ', ' +
        'activeBox: ' + xName(ele.xmObj.activeBox) + ', ' +
        'box: ' + xName(ele);
    }
    else {
      window.status =
        'activeMenu: ' + (xMnuMgr.activeMenu ? xName(xMnuMgr.activeMenu.ele) : 'none') + ', ' +
        'activeBox: ' + xName(ele.xmObj.activeBox) + ', ' +
        'error';
    }
  }
  else {
    window.status = 
        'activeMenu: ' + (xMnuMgr.activeMenu ? xName(xMnuMgr.activeMenu.ele) : 'none') + ', ' +
        'activeBox: ' + ((xMnuMgr.activeMenu && xMnuMgr.activeMenu.activeBox) ? xName(xMnuMgr.activeMenu.activeBox) : 'none') + ', ' +
        'not over label nor box';
  }
  */
}

////--- xMenu.activateBox()

xMenu.prototype.activateBox = function(box) {
  if (!box) return;
  if (box.xmLevel != 0) {
    xShow(box);
    if (box.xmParentLabel) {
      box.xmParentLabel.className = (box.xmLevel == 1 ? this.barLblOvrStyle : this.lblOvrStyle);
    }
  }
  this.activeBox = box;
}

////--- xMenu.deactivateActive()

xMenu.prototype.deactivateActive = function() {
  if (this.activeBox) {
    var box = this.activeBox;
    if (box.xmLevel != 0) {
      xHide(box);
      if (box.xmParentLabel) {
        box.xmParentLabel.className = (box.xmLevel == 1 ? this.barLblOutStyle : this.lblOutStyle);
      }
    }
    this.activeBox = box.xmParent;
  }
  if (!this.activeBox) {
    xMnuMgr.activeMenu.activeLbl = null;
    xMnuMgr.activeMenu.isOpen = false;
    xMnuMgr.activeMenu = null;
  }
}

////--- xMenu.deactivateAll()

xMenu.prototype.deactivateAll = function() {
  xMnuMgr.activeMenu.deactivateSubTree(xMnuMgr.activeMenu.activeBox, 0);
  this.activeLbl = null;
  this.isOpen = false;
  xMnuMgr.activeMenu = null;
}

////--- xMenu.deactivateSubTree()

xMenu.prototype.deactivateSubTree = function(box, level) {
  var root = box;
  while (root && root.xmLevel > level) {
    root = root.xmParent;
  }
  if (root) {
    this.traverseDown(root, xmDeactivateIterator);
  }
}

////--- xmDeactivateIterator()

function xmDeactivateIterator(box) {
  if (box) {
    if (box.xmLevel != 0) {
      xHide(box);
      if (box.xmParentLabel) {
        box.xmParentLabel.className = (box.xmLevel == 1 ? box.xmObj.barLblOutStyle : box.xmObj.lblOutStyle);
      }
    }
  }
  return true;
}

////--- xMenu.traverseDown()

xMenu.prototype.traverseDown = function(boxEle, func) {
  var box;
  if (boxEle) {
    if (!func(boxEle)) {return false;}// stop traversal
    box = boxEle.xmFirstChild;
    while (box) {
      if (!this.traverseDown(box, func)) {return false;} // stop traversal
      box = box.xmNextSib;
    }
  }
  return true; // continue traversal
}

/*
  xMenu.createTree()
  Creates and initializes the following properties
  on elements of class xmBox and xmLbl:

  xmBox:
    xmIsBox
    xmParentLabel
    xmParent
    xmPrevSib
    xmNextSib
    xmObj
    xmFirstChild
    xmLevel
    xmSubTreeNum

  xmLbl:
    xmIsLabel
    xmChildBox
*/
xmTempSubTreeNum=0;
xMenu.prototype.createTree = function(mnuObj, thisBox, parentBox, parentLbl) {
  var thisLbl, childBox, prvBox=null, firstLbl=true;
  thisBox.xmIsBox = true;
  thisBox.xmParent = parentBox;
  thisBox.xmParentLabel = parentLbl;
  thisBox.xmObj = mnuObj;
  thisBox.xmFirstChild = null;
  // level
  if (parentBox) {thisBox.xmLevel = parentBox.xmLevel + 1;}
  else {
    thisBox.xmPrevSib = null;
    thisBox.xmNextSib = null;
    thisBox.xmLevel = 0;
  }
  // sub tree num
  if (thisBox.xmLevel == 0) {thisBox.xmSubTreeNum = 0;}
  else if (thisBox.xmLevel == 1) {thisBox.xmSubTreeNum = ++xmTempSubTreeNum;}
  else {thisBox.xmSubTreeNum = parentBox.xmSubTreeNum;}
  // child boxes
  thisLbl = thisBox.firstChild;
  while (thisLbl) {
    while (thisLbl && !xMnuMgr.isLbl(thisLbl)) thisLbl = thisLbl.nextSibling;
    if (thisLbl) {
      if (thisBox.xmLevel == 0) {
        xAddEventListener(thisLbl, 'click', xmLblOnClick, false);
      }
      thisLbl.xmIsLabel = true;
      childBox = thisLbl.nextSibling;
      while (childBox && !xMnuMgr.isBox(childBox)) childBox = childBox.nextSibling;//???
      if (!childBox) {
        xMnuMgr.err = 'Label ('+thisLbl.id+') has no box';
        return false;
      }
      // sibs
      childBox.xmPrevSib = prvBox;
      childBox.xmNextSib = null;
      if (prvBox) {prvBox.xmNextSib = childBox;}
      prvBox = childBox;
      // first child
      if (firstLbl) {
        thisBox.xmFirstChild = childBox;
        firstLbl = false;
      }
      thisLbl.xmChildBox = childBox;
      // recursive call
      if (!mnuObj.createTree(mnuObj, childBox, thisBox, thisLbl)) {return false;}
      // next label
      thisLbl = thisLbl.nextSibling;
    }
  }
  return true;
}

// end xMenu.js

