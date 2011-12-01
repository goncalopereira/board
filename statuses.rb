get %r{/statuses/([a-zA-Z]+)} do |status_name|

	status_row = settings.db.collection(:statuses).find_one(:name => status_name)
	
	content_type :json
	status_row.to_json
end

get '/statuses' do

	statuses = settings.db.collection(:statuses).find().to_a
	
	content_type :json	
	{ :statuses => statuses}.to_json
end

post '/statuses' do
	name = params[:name]
	
	names = settings.db.collection(:statuses).find(:name => name)

	if names.count > 0
		return error "existing status name #{name}"
	end

	description = params[:description]
	image = params[:image]
	
	status = {'name' => name, 'description' => description, 'image' => image} 
	
	settings.db.collection(:statuses).insert(status)
	
	status_row = settings.db.collection(:statuses).find_one(:name => name)
	content_type :json	
	status_row.to_json
end


