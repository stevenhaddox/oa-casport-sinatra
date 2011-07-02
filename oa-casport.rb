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
require 'awesome_print'

module OaCasportSinatra
  class Application < Sinatra::Base

    use Rack::Session::Cookie
    use OmniAuth::Builder do
      provider :casport, {
        :setup  => true,
        :cas_server => 'http://cas.dev/users/'
        #:cas_server => 'http://oa-cas.slkdemos.com/users/'
      }
    end

    get '/' do
      unless session['auth_error'].nil?
        <<-HTML
          <div class='error'><strong>Error:</strong> #{session['auth_error']}</div>"
        HTML
      end
      unless session['auth_hash'].nil?
        <<-HTML
          <h3>Welcome #{session['auth_hash']['user_info']['name']}</h3>
          <p>You've logged in successfully via #{session['auth_hash']['provider']}!</p>
          Your login details are:<br>
          <pre><code>#{session['auth_hash']}</code></pre>
          <p><a href='signout'>Sign Out</a></p>
        HTML
      else
        <<-HTML
          <a href='/auth/casport'>Sign in with CASPORT</a>
        HTML
      end
    end

    get '/auth/:provider/setup' do
      request.env['omniauth.strategy'].options[:uid] = 1.to_s
      status 404
      body "Setup complete"
    end

    get '/auth/:provider/callback' do
      if request.env['omniauth.auth']
        session['auth_hash'] = request.env['omniauth.auth']
      else
        session['auth_error'] = "request.env['omniauth.auth'] is nil"
      end
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
      session['auth_hash']  = nil
      session['auth_error'] = nil
    end

  end
end
