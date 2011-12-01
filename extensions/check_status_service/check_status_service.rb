require 'rubygems'
require 'net/http'
require 'json'
require 'uri'

LOCAL_URI = 'http://localhost:4567'

def get_request url, host_header
	uri = URI(url)
	http = Net::HTTP.new(uri.host, uri.port)
	path = uri.path.empty? ? "/" : uri.path
	query = uri.query.nil? ?  "" : "?" + uri.query	
	headers =  {"Host"  => host_header }
	puts "curl -v \"http://#{uri.host}#{path}#{query}\" -H \"Host: #{host_header}\""
	return http.get(path + query, headers)
end

def get_services
        uri = URI.parse(LOCAL_URI + '/services')
        Net::HTTP.get_response(uri).body
end

def post_event service_name, status_name, message = ''
	uri = URI.parse(LOCAL_URI + '/services/' + service_name + '/events')
    
	Net::HTTP.post_form(uri, 'status' => status_name, 'message' => message)
end


response_services = get_services
services_list = JSON.parse(response_services)['services']

services_list.each do |service|

	begin
		response = get_request service['url'], service['hostname']

		puts response.methods
		if response.code == '200'		
			puts post_event service['name'], 'Up'	
		else
			puts post_event service['name'], 'BadResponse', response.code + " " + response.body 
		end		
	rescue Exception => e
		puts post_event service['name'], 'Down', e.message
	end
end



