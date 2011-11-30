get %r{/services/([a-zA-Z]+)} do |service_name|

        service_row = settings.db.collection(:services).find_one(:name => service_name)
	
        content_type :json
        service_row.to_json
end

get '/services' do

	services = settings.db.collection(:services).find().to_a
	
	content_type :json	
	{ :services => services}.to_json
end

post '/services' do

	name = params[:name]
	
	names = settings.db.collection(:services).find(:name => name)

	if names.count > 0
		return error "existing service name #{name}"
	end

	description = params[:description]
	url = params[:url]

	host_name = params[:hostname]
	environment = params[:environment]
	application = params[:application]
		
	service = {'name' => name, 'description' => description, 'url' => url, 'hostname' => host_name, 'current-event' => nil, 'environment' => environment, 'application' => application} 
	
	settings.db.collection(:services).insert(service)
	
	status_row = settings.db.collection(:services).find_one(:name => name)
	content_type :json	
	status_row.to_json
end
