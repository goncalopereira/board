require 'rubygems'
require'sinatra'
require 'net/http'
require 'uri'
require 'faster_csv'
require 'json'
require 'mongo'

require './statuses.rb'
require './events.rb'
require './services.rb'

configure do
	set :db, Mongo::Connection.new.db("mydb")

	set :raise_errors, false
	set :show_exceptions, true
end

def get_request url, host_header
	uri = URI(url)
	http = Net::HTTP.new(uri.host, uri.port)
	path = uri.path.empty? ? "/" : uri.path
	query = uri.query.nil? ?  "" : "?" + uri.query	
	headers =  {"Host"  => host_header }
	puts "curl -v \"http://#{uri.host}#{path}#{query}\" -H \"Host: #{host_header}\""
	return http.get(path + query, headers)
end

def error message
	content_type :json
	error = { :message => message}
	error.to_json
end




