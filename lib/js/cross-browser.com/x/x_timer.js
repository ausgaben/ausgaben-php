// x_timer.js, X v3.15.2, Cross-Browser.com DHTML Library
// Copyright (c) 2004 Michael Foster, Licensed LGPL (gnu.org)

function xTimerMgr()
{
  // Public Methods
  this.set = function(type, obj, sMethod, uTime, data) // type: 'interval' or 'timeout'
  {
    return (this.timers[this.timers.length] = new xTimerObj(type, obj, sMethod, uTime, data));
  }
  // Private Properties
  this.timers = new Array();
  // Private Methods
  this.run = function()
  {
    var i, t, d = new Date(), now = d.getTime();
    for (i = 0; i < this.timers.length; ++i) {
      t = this.timers[i];
      if (t && t.running) {
        t.elapsed = now - t.time0;
        if (t.elapsed >= t.preset) { // timer event on t
          t.obj[t.mthd](t); // pass listener this xTimerObj
          if (t.type.charAt(0) == 'i') { t.time0 = now; }
          else { t.stop(); }
        }  
      }
    }
  }
  // Private Object Prototype
  function xTimerObj(type, obj, mthd, preset, data)
  {
    // Public Methods
    this.stop = function() { this.running = false; }
    this.start = function() { this.running = true; } // continue after a stop
    this.reset = function()
    {
      var d = new Date();
      this.time0 = d.getTime();
      this.elapsed = 0;
      this.running = true;
    }
    // Public Properties
    this.data = data;
    // Read-only Properties
    this.type = type; // 'interval' or 'timeout'
    this.obj = obj;
    this.mthd = mthd; // string
    this.preset = preset;
    this.reset();
  } // end xTimerObj
} // end xTimerMgr

var xTimer = new xTimerMgr(); // applications assume global name is 'xTimer'
setInterval('xTimer.run()', 250);
