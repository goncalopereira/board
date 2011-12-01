get %r{/services/([a-zA-Z0-9-]+)} do |service_name|

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

       	environment_name = params[:environment]
        application_name = params[:application]
	name = application_name + '-' + environment_name + '-' + params[:name]

	service = settings.db.collection(:services).find_one(:name => name)

	if not service.nil?
		return error "existing service name #{name}"
	end	

	description = params[:description]
	url = params[:url]

	host_name = params[:hostname]
	
	environment = settings.db.collection(:environments).find_one(:name => environment_name)

	if environment.nil?
		return error "non existing environment name #{environment_name}"
	end

	application = settings.db.collection(:applications).find_one(:name => application_name)
	
	if application.nil?
		return error "non existing application name #{application_name}"
	end
				
	service = {'name' => name, 'description' => description, 'url' => url, 'hostname' => host_name, 'current-event' => nil, 'environment' => environment_name, 'application' => application_name} 
	
	settings.db.collection(:services).insert(service)
	
	service = settings.db.collection(:services).find_one(:name => name)
	content_type :json	
	service.to_json
end
