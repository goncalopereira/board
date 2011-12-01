
get %r{/services/([a-zA-Z0-9\-]+)/events} do |service_name|

	puts 'get events'
	events = settings.db.collection(:events).find(:name => service_name).to_a
	
	content_type :json
	events.to_json
end


post %r{/services/([a-zA-Z0-9\-]+)/events} do |service_name|

        service = settings.db.collection(:services).find_one(:name => service_name)

        if service.nil?
                return error "non existing service name #{service_name}"
        end

        url = params[:url]
	timestamp = Time.now
	status_name = params[:status]
	message = params[:message]

	status = settings.db.collection(:statuses).find_one(:name => status_name)	

	if status.nil?
		return error "non existing status name #{status_name}"
	end
	
        event = {'name' => service_name, 'url' => url, 'timestamp' => timestamp, "message" => message, "status" => status}

        event_id = settings.db.collection(:events).insert(event)

        event = settings.db.collection(:events).find_one("_id" => event_id)
	
	settings.db.collection(:services).update( {"_id" => service["_id"] }, '$set' => { "current-event" => event})

        content_type :json
        event.to_jsoni
end

