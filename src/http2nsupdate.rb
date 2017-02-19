#!/usr/bin/ruby

require 'rack'
require 'rack/lobster'

class Dynupdater

  PARAM_IP = 1
  PARAM_HOSTNAME = 2
  PARAM_WILDCARD = 4
  PARAM_MX = 8
  PARAM_BACKMX = 16
  PARAM_OFFLINE = 32
  PARAM_SYSTEM = 64
  PARAM_URL = 128

  def self.call(env)

    # check for nonempty username
    return ['400', {'Content-Type' => 'text/html'}, ['Error: Nonempty username required.']]  if $binduser == ""

    # check for nonempty password
    return ['400', {'Content-Type' => 'text/html'}, ['Error: Nonempty password required.']]  if $bindpwd == ""

    # need some parameters
    return ['400', {'Content-Type' => 'text/html'}, ['Error: No parameters in request.']]  if env["QUERY_STRING"] == ""

    syntax = 0

    # get querystring
    requestparams = Hash.new 

    env["QUERY_STRING"].split("&").each do |onetupel| 
      arr= onetupel.split("=")

      # need a parameter
      if arr[0] == NIL
	return ['400', {'Content-Type' => 'text/html'}, ['Error: Request contains empty parameter.']]
      end

      # parameter needs a value
      if arr[1] == NIL
	return ['400', {'Content-Type' => 'text/html'}, ['Error: Request parameter "' + arr[0] + '" must not have an empty value.']]
      end

      # syntax check
      singular = true
      parammap = 0
      case arr[0].chomp.downcase
        when "myip"
		parammap |= PARAM_IP
	when "hostname"
		parammap |= PARAM_HOSTNAME
	when "wildcard"
		parammap |= PARAM_WILDCARD
	when "mx"
		parammap |= PARAM_MX
	when "backmx"
		parammap |= PARAM_BACKMX
	when "offline"
		parammap |= PARAM_OFFLINE
	when "system"
		parammap |= PARAM_SYSTEM
	when "url"
		parammap |= PARAM_URL
	else
	  return ['400', {'Content-Type' => 'text/html'}, ['Error: Request contains illegal parameter "' + arr[0] ]]
	end

      # every parameter must only appear one time
      if singular && requestparams[arr[0].chomp.to_sym] != NIL
	return ['400', {'Content-Type' => 'text/html'}, ['Error: Request contains parameter "' + arr[0] + '" more than one time.']]
      	
      end


      requestparams[arr[0].chomp.to_sym]  = arr[1].chomp 
    end

    # check für https connection
    # to be implemented






    ['200', {'Content-Type' => 'text/html'}, ['Update OK.']]
  end
end





app = Rack::Builder.new do 
	#use Rack::CommonLogger
	use Rack::ShowExceptions
	map "/lobster" do
		#use Rack::Lint
		run Rack::Lobster.new
	end
	map "/update" do
	 	#run lambda { |env| ['200', {'Content-Type' => 'text/html'}, ['Hello World.']] }
	 	run Dynupdater
	end
	map "/" do
		#run Rack::Response.new('Dynamic DNS Update Bridge. Please see XXX for further informaton. ').finish
		#run Rack::Response.new.write('Dynamic DNS Update Bridge. Please see XXX for further informaton. ')
	 	run lambda { |env| ['400', {'Content-Type' => 'text/html'}, ['Dynamic DNS Update Bridge. Please see XXX for further informaton. ']] }
	end
end

protected_app = Rack::Auth::Basic.new(app) do |username, password|
  next if username == ""
  next if password == ""
  $binduser = username
  $bindpwd = password
  #Rack::Utils.secure_compare('secret', password);
end

protected_app.realm = 'appr 0.0'

pretty_protected_app = Rack::ShowStatus.new(Rack::ShowExceptions.new(protected_app))

#Rack::Server.start :app => pretty_protected_app, :Port => 9292
Rack::Server.start :app => protected_app, :Port => 9292
