begin
  require 'sinatra'
  require 'oa-core'
  require 'oa-casport'
rescue LoadError
  require 'rubygems'
  require 'sinatra'
  require 'oa-core'
  require 'oa-casport'
end

#log = File.new('log/application.log')
#STDOUT.reopen(log)
#STDERR.reopen(log)

requier File.dirname(__FILE__) + '/oa-casport.rb'

run OaCasportSinatra::Application

