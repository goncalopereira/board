get %r{/applications/([a-zA-Z]+)} do |status_name|

	status_row = settings.db.collection(:applications).find_one(:name => status_name)
	
	content_type :json
	status_row.to_json
end

get '/applications' do

	applications = settings.db.collection(:applications).find().to_a
	
	content_type :json	
	{ :applications => statuses}.to_json
end

post '/applications' do
	name = params[:name]
	
	names = settings.db.collection(:applications).find(:name => name)

	if names.count > 0
		return error "existing application name #{name}"
	end

	description = params[:description]
	image = params[:image]
	
	status = {'name' => name, 'description' => description, 'image' => image} 
	
	settings.db.collection(:applications).insert(status)
	
	status_row = settings.db.collection(:applications).find_one(:name => name)
	content_type :json	
	status_row.to_json
end


