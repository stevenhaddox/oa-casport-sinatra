begin
  require 'sinatra'
  require 'oa-casport'
rescue LoadError
  require 'rubygems'
  require 'sinatra'
  require 'oa-casport'
end

#log = File.new('log/application.log')
#STDOUT.reopen(log)
#STDERR.reopen(log)

require File.dirname(__FILE__) + '/oa-casport.rb'

run OaCasportSinatra::Application

