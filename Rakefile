require 'rake'
require 'mongo'
require 'net/http'

require './configs.rb'

def build_application application
        uri = URI("#{LOCAL_URI}/applications")
        res = Net::HTTP.post_form(uri, 'name' => application)
        res.body
end

def build_environment environment
        uri = URI("#{LOCAL_URI}/environments")
        res = Net::HTTP.post_form(uri, 'name' => environment)
        res.body
end

def build_service service_name, application, environment, url, hostname
        uri = URI("#{LOCAL_URI}/services")

        encoded_service_name = service_name.gsub(" ", "-")

        res = Net::HTTP.post_form(uri, 'name' => encoded_service_name, 'description' => service_name, 'environment' => environment, 'url' => url, 'hostname'=>hostname, 'application' => application)

        res.body
end

task :clean_all do
	db = Mongo::Connection.new.db("mydb")
	db.collection(:statuses).remove
	db.collection(:applications).remove
	db.collection(:environments).remove
	db.collection(:services).remove
	db.collection(:events).remove
end

task :build_statuses do
	uri = URI("#{LOCAL_URI}/statuses")
	
	res = Net::HTTP.post_form(uri, 'name' => 'Up', 'description' => 'service is working normally', 'image' => '/images/tick-circle.png')
	puts res.body
	res = Net::HTTP.post_form(uri, 'name' => 'Down', 'description' => 'service is not responding', 'image' => '/images/cross-circle.png')
	puts res.body
        res = Net::HTTP.post_form(uri, 'name' => 'BadResponse', 'description' => 'service is not responding OK', 'image' => '/images/exclamation.png')
	puts res.body
end

task :build_environments do
	puts build_environment 'SysTest'
	puts build_environment 'UAT'
	puts build_environment 'Live'
end

task :build_example do

	puts build_application 'API'
	
	puts build_service 'API Live Machine 1', 'API', 'Live', 'http://api.7digital.com/1.2/status?oauth_consumer_key=YOUR_KEY_HERE','api.7digital.com'

	uri = URI("#{LOCAL_URI}/services/API-Live-Machine-1/events")
        res = Net::HTTP.post_form(uri, 'status' => 'Up')
        puts res.body

end	

