require 'rubygems'
require'sinatra'
require 'net/http'
require 'uri'
require 'faster_csv'
require 'json'
require 'mongo'

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


get %r{/statuses/([a-zA-Z]+)} do |status_name|

	status_row = settings.db.collection(:statuses).find_one(:name => status_name)
	
	content_type :json
	status_row.to_json
end

get '/statuses' do

	statuses = settings.db.collection(:statuses).find().to_a
	
	content_type :json	
	{ :statuses => statuses}.to_json
end

post '/statuses' do

	name = params[:name]
	
	names = settings.db.collection(:statuses).find(:name => name)

	if names.count > 0
		return error "existing status name #{name}"
	end

	description = params[:description]
	level = params[:level]
	image = params[:image]
	
	status = {'name' => name, 'description' => description, 'level' => level, 'image' => image} 
	
	settings.db.statuses.insert(status)
	
	status_row = settings.db.collection(:statuses).find_one(:name => name)
	content_type :json	
	status_row.to_json
end

