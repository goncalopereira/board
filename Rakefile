require 'rake'
require 'mongo'
require 'net/http'

require './configs.rb'

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
        uri = URI("#{LOCAL_URI}/environments")

        res = Net::HTTP.post_form(uri, 'name' => 'SysTest', 'description' => 'SysTest')
        puts res.body
        res = Net::HTTP.post_form(uri, 'name' => 'UAT', 'description' => 'UAT')
        puts res.body
        res = Net::HTTP.post_form(uri, 'name' => 'Live', 'description' => 'Live')
        puts res.body
end

