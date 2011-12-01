require 'rake'
require 'mongo'
require 'net/http'

task :clean_all do
	db = Mongo::Connection.new.db("mydb")
	db.collection(:statuses).remove
	db.collection(:applications).remove
	db.collection(:environments).remove
	db.collection(:services).remove
	db.collection(:events).remove
end

task :build_statuses do
	uri = URI('http://localhost:4567/statuses')
	
	res = Net::HTTP.post_form(uri, 'name' => 'Up', 'description' => 'service is working normally', 'image' => '/images/tick-circle.png')
	puts res.body
	res = Net::HTTP.post_form(uri, 'name' => 'Down', 'description' => 'service is not responding', 'image' => '/images/tick-cross.png')
	puts res.body
        res = Net::HTTP.post_form(uri, 'name' => 'BadResponse', 'description' => 'service is not responding OK', 'image' => '/images/exclamation.png')
	puts res.body
end
