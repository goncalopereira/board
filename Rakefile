require 'rake'
require 'mongo'
require 'net/http'

require './configs.rb'
require './builds.rb'

task :clean_all do
	db = Mongo::Connection.new.db("mydb")
	db.collection(:statuses).remove
	db.collection(:applications).remove
	db.collection(:environments).remove
	db.collection(:services).remove
	db.collection(:events).remove
	puts 'deleted all data...'
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
	
	puts build_service 'API Live Machine Example', 'API', 'Live', 'http://api.7digital.com/1.2/status?oauth_consumer_key=YOUR_KEY_HERE','api.7digital.com'
	puts build_service 'API Bad Request Example', 'API', 'Live', 'http://api.7digital.com/1.2/something','api.7digital.com'
	puts build_service 'API Down Example', 'API', 'Live', 'http://nothing-here-example.com','nothing-here-example.7digital.com'
	
	uri = URI("#{LOCAL_URI}/services/API-Live-Machine-Example/events")
        res = Net::HTTP.post_form(uri, 'status' => 'Up')
        puts res.body
end	

task :example => [:clean_all, :build_statuses, :build_environments, :build_example]
