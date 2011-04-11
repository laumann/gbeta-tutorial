/**
 * This code is VERY MUCH inspired by the Go programming language's
 * playground. The playground can be found here:
 *
 *   http://golang.org/doc/playground.html
 *
 * However, no code has (so far) been stolen from it.
 */
$(function() {
	// find the TextAreas - hook them up with CodeMirror and
	// compile buttons
	$('textarea[name^="gbeta_program_"]').each(function(index) {
		// set up the CodeMirror
		var codeMirror = CodeMirror.fromTextArea($(this)[0], { lineNumbers: true });

		// Get the id number
		var i = $(this)[0].name.slice(14);
		var btnName = 'compile_'+i;
		// var outName = 'output_' +i;
		// var errName = 'error_'  +i;

		$('#'+btnName).unbind('click').bind('click', function() {
			alert('Hello, World - I am program number ' + i);
			compile(codeMirror.getValue(), i);
		    });
		
		// Hide divs
		$('#output_'+i).hide();
		$('#error_'+i).hide();
	    });
    });

function compile(program, i) {
    $.ajax({
	    url: '/cgi-bin/gbeta.cgi',
	    processData: false,
	    data: 'program='+escape(program),
	    type: 'POST',
	    success: function(data) {
		var out = $('#output_'+i);
		out.html('<pre>'+data+'</pre>');
		out.show();
	    },
	});
}