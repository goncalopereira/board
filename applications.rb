get %r{/applications/([a-zA-Z]+)} do |application_name|

	application = settings.db.collection(:applications).find_one(:name => application_name)
	
	content_type :json
	application.to_json
end

get '/applications' do

	applications = settings.db.collection(:applications).find().to_a
	
	content_type :json	
	{ :applications => applications}.to_json
end

post '/applications' do
	name = params[:name]
	
	application = settings.db.collection(:applications).find_one(:name => name)

	if not application.nil?
		return error "existing application name #{name}"
	end

	description = params[:description]
	image = params[:image]
	
	application = {'name' => name, 'description' => description, 'image' => image} 
	
	settings.db.collection(:applications).insert(application)
	
	application = settings.db.collection(:applications).find_one(:name => name)
	content_type :json	
	application.to_json
end


