require 'rubygems'
require'sinatra'
require 'net/http'
require 'uri'
require 'faster_csv'
require 'json'
require 'mongo'

require './configs.rb'

require './routes/events.rb'
require './routes/applications.rb'
require './routes/services.rb'
require './routes/environments.rb'
require './routes/statuses.rb'

configure do
	set :db, Mongo::Connection.new.db(MONGO_DB_NAME)

	set :raise_errors, false
	set :show_exceptions, true
end

def error message
	content_type :json
	error = { :message => message}
	error.to_json
end
