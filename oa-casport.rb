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

require 'yaml'

module OaCasportSinatra
  class Application < Sinatra::Base

    enable :sessions
    use OmniAuth::Builder do
      provider :casport, {
        :setup  => true,
        :cas_server => 'http://oa-cas.slkdemos.com'
      }
    end

    get '/' do
      <<-HTML
        <a href='/auth/casport'>Sign in with CASPORT</a>
      HTML
    end

    get '/auth/:provider/setup' do
      request.env['omniauth.strategy'].options[:uid] = '1'
      status 404
      body "Setup complete"
    end

    get '/auth/:provider/callback' do
      session['casport_auth'] = request.env['omniauth.auth']
      session['casport_error'] = nil
      "Hello, #{session['casport_auth']['userinfo']['name']}, you logged in via #{params[:provider]}"
      "Your user details are: "
      "#{session['casport_auth'].to_yaml}" 
      redirect '/'
    end

    get '/auth/:provider/failure' do
      "<h1>FAIL!</h1>
      "#{params[:message]}"
    end 

    get '/signout' do
      clear_session
      redirect '/'
    end

    def clear_session
      session['casport_auth']  = nil
      session['casport_error'] = nil
    end

  end
end
