(function(){
  window.PDFTeX = function() {
    var worker = new Worker('pdftex-webworker.js');
    var job_id = 0;
    var pending_jobs = 0;

    worker.onmessage = function(ev) {
      console.log(JSON.parse(ev.data));
    };

    this.addFile = function(real_url, pseudo_path, pseudo_name) {
    }

    this.injectCode = function(code) {
      worker.postMessage(code);
    }
    
    this.compile = function(code) {
      var cmd = {
        'cmd_id': job_id++,
        'cmd':    'compile',
        'code':   code,
      }

      worker.postMessage(JSON.stringify(cmd));

      return id;
    }
  }
})()
