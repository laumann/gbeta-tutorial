CodeMirror.defineMode("text", function() {
  return {
    token: function(stream) {
      var ch = stream.next();
      stream.skipToEnd();
      return "text";
    }
  };
});

CodeMirror.defineMIME("text/plain", "text");