var is_browser = (typeof(window) !== "undefined");
this['Module'] = {};
var Module = this['Module'];
Module['noInitialRun'] = is_browser;

var nodejs_runScriptFile = function(name) {
  this['Module'] = Module;
  var fs = require('fs');

  var filename = process['env'][name];
  var script = fs.readFileSync(filename);
  return eval(script);
};


Module['preInit'] = function() {
  if(!is_browser)
    return nodejs_runScriptFile('pdftex_preInit');
};


Module['preRun'] = function() {
  if(!is_browser)
    return nodejs_runScriptFile('pdftex_preRun');
};


Module['postRun'] = function() {
  if(!is_browser)
    return nodejs_runScriptFile('pdftex_postRun');
};


self.onmessage = function(ev) {
  var msg = JSON.parse(ev.data);
  var res;
  try {
    eval(msg);
  }
  catch(e) {
    self.postMessage(JSON.stringify(e));
  }
  self.postMessage(JSON.stringify(res));
};

