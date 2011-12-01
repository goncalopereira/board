require 'net/http'

LOCAL_URI = 'http://localhost:4567'

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
	
	service_name = service_name.gsub(" ", "-")

	res = Net::HTTP.post_form(uri, 'name' => service_name, 'description' => service_name, 'environment' => environment, 'url' => url, 'hostname'=>hostname, 'application' => application)
	
	res.body
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



