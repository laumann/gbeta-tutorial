/*
 * gbeta syntax lexer/parser for CodeMirror2.
 * 
 * What we're interested in:
 * 
 *  - syntax highlighting of keywords, fragment language, 
 */
CodeMirror.defineMode('gbeta', function(config, parserConfig) {

  // Keywords
  var keywords = function() {
    function kw(type) { return { type: type, style: 'gb-keyword'};}
    var keyWord  = kw('keyword');
    var operator = kw('operator');
    var atom     = kw('atom');
    return {
      // First-class keywords
      'label': keyWord, 'leave':   keyWord, 'restart': keyWord,
      'inner': keyWord, 'suspend': keyWord, 'for':     keyWord,
      'while': keyWord, 'if':      keyWord, 'case':    keyWord,
      'this':  keyWord,
      
      // 'Lesser' keywords (cannot begin a statement)
      'do': keyWord, 'else': keyWord, 'then': keyWord,
      
      // Word operators
      'div': operator, 'mod': operator, 'and': operator,
      'not': operator, 'new': operator, 'xor': operator,
      'or':  operator,
      
      // Atoms
      'null': atom, 'true': atom, 'false': atom,
      
      // Fragment language
      'ORIGIN':  keyWord, 'BODY':    keyWord, 'MDBODY':  keyWord,
      'INCLUDE': keyWord, 'LIBFILE': keyWord, 'LINKOPT': keyWord,
      'OBJFILE': keyWord, 'MAKE':    keyWord, 'BUILD':   keyWord
    };
  }();

  // var isOperatorChar = /[+=<>-&?$`|]/;

  var SLOTappl = /<<SLOT\s+\w+\:\w+\s?>>/;
  var SLOTdecl = /--\s?\w+\:\w+\s?--/;
  
  function gbTokenBase(stream, state) {
    var ch = stream.peek(); // Don't eat the next token!

    /* literal string */
    if (ch == "'") {
      stream.eat("'");
      return chain(stream, state, gbLiteralString());
    }    
    /* minus can either be operator or beginning SLOTdecl */
    else if (ch == '-') {
      console.log('slot declaration?');
      if (stream.match(SLOTdecl))
	return ret('gb-slotdecl');
      stream.eat('-');
      return ret(null);
    }
    /* single-line comment */
    else if (ch == '/') {
      stream.eat('/');
      if (stream.eat('/')) {
	stream.skipToEnd();
	console.log('Read token: ' + stream.current());
	return ret('gb-comment');
      }
    }
    /* '<' */
    else if (ch == '<') {
      if (stream.match(SLOTappl))
	return ret('gb-slotappl');
      stream.eat('<');
      return ret(null);
    }
    /* '#' means change from attributes to statements */
    else if (ch == '#') {
      stream.eat('#');
      return ret(null);
    }
    /* try the fragment language */
    else if (/OIBLM/.test(ch)) {
      if (stream.match(/(ORIGIN|INCLUDE|BODY|MDBODY|LIBFILE|LINKOPT|OBJFILE|MAKE|BUILD)/)) {
	console.log('Matched fragment language begin');
	state.tokenize = gbFragmentLang;
	return 'gb-keyword';
      }
      stream.eat(/OIBLM/);
    }
    else {
      stream.skipToEnd();
      return ret(null);
    }
  }
  
  /**
   * Fragment language (enters this state after reading ORIGIN, BODY, INCLUDE, etc...
   * 
   * Do: Read list of strings until eol() or ';'
   */
  function gbFragmentLang() {
    console.log('Entering fragment language');
    return function(stream, state) {
      if (stream.eol()) {
	state.tokenize = gbTokenBase;
	return null;
      }
      var ch = stream.next();
      if (ch == ';') {
	state.tokenize = gbTokenBase;
	return null;
      }
      else if (ch == "'") {
	var next;
	while ((next = stream.next()) != null) {
	  if (stream.eol() || next == ";") {
	    state.tokenize = gbTokenBase;
	    return ret('gb-string');
	  }
	  if (next == "'") { // look for termination
	    return ret('gb-string');
	  }
	}
      }
      state.tokenize = gbTokenBase;
      return null;
    };
  }
  
  /**
   * chain(...) sets the current tokenizer, then calls the tokenizer
   * with the given stream and state.
   */
  function chain(stream, state, tokenizer_f) {
    state.tokenize = tokenizer_f;
    return tokenizer_f(stream, state);
  }

  /** 
   * So far only single quoted string literals in gbeta
   */
  function gbLiteralString() {
    return function(stream, state) {
      var next;
      while ((next = stream.next()) != null) {
	if (next == "'") {
	  state.tokenize = gbTokenBase;
	  break;
	}
      }
      // Passes the stream to nextUntilUnescaped(stream)
      // if (!nextUntilUnescaped(stream))
      //   state.tokenize = gbTokenBase;
      return ret("gb-string");
    };
  }

  /**
   * 
   */
  function nextUntilUnescaped(stream) {
    var escaped = false, next;
    while ((next = stream.next()) != null) {
      if (next == "'" && !escaped)
        return false;
      // backslash indicates on next line
      escaped = !escaped && next == "\\"; 
    }
    return escaped;
  }

  /**
   * laumann: ret is used to return type, style and content (three
   * things instead of one).
   */
  var type, content;
  function ret(tp, style, cont) {
    type = tp; content = cont;
    return style;
  }

  // Parser

  function parseGbeta(state, style, type, content, stream) {
    return null;
  }


  /**
   * Here is what the anonymous function opened in
   * CodeMirror.defineMode(..) actually returns.
   * 
   *   { startState, token, indent }
   */
  return {
    startState: function(basecolumn){
      return {
	tokenize: gbTokenBase,
	context: null,
	indented: 0
      };
    },

    /**
     * The stream object encapsulates one line of code and our current
     * position in that line.
     * 
     * Simply call tokenize(stream, state) 
     */
    token: function(stream, state) {
      if (stream.sol()) {
	state.indented = stream.indentation();
      }
      /* Begin by eating all leading white-space */
      if (stream.eatSpace()) return null;

      /* style, type and content from ret(...) */
      var style = state.tokenize(stream, state);
      if (type == 'gb-comment')	 return 'gb-comment';
      if (type == 'gb-slotdecl') return 'gb-slotdecl';
      if (type == 'gb-slotappl') return 'gb-slotappl';
      if (type == 'gb-string')   return 'gb-string';

      console.log('style: ' + style + ', type: '+ type);
      return parseGbeta(state, style, type, content, stream);
    },

    indent: function(state, textAfter) {
      /* Not implemented yet */
      return 0;
    }
  }
});