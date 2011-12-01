get %r{/environments/([a-zA-Z]+)} do |environment_name|

	environment = settings.db.collection(:environments).find_one(:name => environment_name)
	
	content_type :json
	environment.to_json
end

get '/environments' do

	environments = settings.db.collection(:environments).find().to_a
	
	content_type :json	
	{ :environments => environments}.to_json
end

post '/environments' do
	name = params[:name]
	
	environment = settings.db.collection(:environments).find_one(:name => name)

	if not environment.nil?
		return error "existing environment name #{name}"
	end

	description = params[:description]
	image = params[:image]
	
	environment = {'name' => name, 'description' => description, 'image' => image} 
	
	settings.db.collection(:environments).insert(environment)
	
	environment = settings.db.collection(:environments).find_one(:name => name)
	content_type :json	
	environment.to_json
end


