#!/usr/bin/env ruby
require 'cgi'

# Init and get program variable
cgi = CGI.new
program = cgi['program']

output = ""
exit_value = 0

# Do everything from the top directory.
#
# chdir .. may not be the best way to go, but for now it works - but
# come deployment on a server, using '/' might be better. In any case,
# the intended destination is the root of this project (gbeta-tutorial).
Dir.chdir '..'  do
  Dir.chdir('playground') do 
    File.open('tmp.gb', 'w') { |f| f.write(program) }
  end

  # These variables MUST be set
  ENV['GBETA_BASEDIR'] = File.join(Dir.pwd, 'gbeta')
  ENV['HOME'] ||= '/home/dorthe'
  ENV['USER'] ||= `whoami`

  # Run gbeta
  output = `gbeta/bin/gbeta -u playground/tmp.gb`
  exit_value = $?.to_i
end

# Sending back the following format:
#
#  <true|false>#output
#
# The prepended boolean indicates whether or not gbeta ran
# successfully. There is probably a better way of doing this
print "Content-type: text/plain\n\n"
print "#{exit_value == 0}#"
print CGI.escapeHTML(output)
