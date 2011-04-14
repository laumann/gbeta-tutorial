/**
 * This code is VERY MUCH inspired by the Go programming language's
 * playground. The playground can be found here:
 *
 *   http://golang.org/doc/playground.html
 *
 * However, no code has (so far) been stolen from it.
 *
 * Algorithm: find the TextAreas beginning with 'gbeta_program_' -
 * hook them up with CodeMirror and compile buttons.
 */
$(function() { // find the TextAreas - hook them up with CodeMirror and
	       // compile buttons
	$('textarea[name^="gbeta_program_"]').each(function(index) {
		// set up the CodeMirror
		var codeMirror = CodeMirror.fromTextArea($(this)[0], { lineNumbers: true });

		// Get the id number
		var i = $(this)[0].name.slice(14);

		$('#compile_'+i).unbind('click').bind('click', function() {
			compile(i, codeMirror.getValue());
		    });

		$('#hide_'+i).unbind('click').bind('click', function() {
			hide(i);
		    });
		
		hide(i);
	    });
    });

function compile(i, program) {
    $('#error_'+i).hide();

    display(i, "Compiling and running...", true);

    $.ajax({
	    url: '/cgi-bin/gbeta.cgi',
	    processData: false,
	    data: 'program='+encodeURIComponent(program),
	    type: 'POST',
	    success: function(data) {
		var iOf  = data.indexOf('#');
		var stat = data.substring(0, iOf);
		var out  = data.substring(iOf+1, data.length);
		display(i, out, (stat == 'true'));
	    },
	});
}

function display(i, data, success) {
    var output = null;
    if (success) {        /* Success! */
	output = $('#output_'+i);
	$('#error_'+i).hide();
    }
    else {                /* Fail */
	output = $('#error_'+i);
	$('#output_'+i).hide();
    }
    output.html('<pre>'+data+'</pre>');
    output.show();
    $('#hide_'+i).show();
}

function hide(i) {
    $('#output_'+i).hide();
    $('#error_'+i).hide();
    $('#hide_'+i).hide();    
}