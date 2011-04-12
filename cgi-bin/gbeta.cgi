#!/usr/bin/env ruby
require 'cgi'

## Init and get program variable
cgi = CGI.new
program = cgi['program']

output = ""

## Do everything a bit further up
Dir.chdir('..') do
  Dir.chdir('playground') do 
    File.open('tmp.gb', 'w') { |f| f.write(program) }
  end

  ## These variables MUST be set
  ENV['GBETA_BASEDIR'] = File.join(Dir.pwd, 'gbeta')
  ENV['HOME'] = '/home/dorthe'
  ENV['USER'] = `whoami`

  ## Run gbeta
  output = `gbeta/bin/gbeta -u playground/tmp.gb`
end

print "Content-type: text/plain\n\n"
print CGI.escapeHTML(output)
