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

        encoded_service_name = service_name.gsub(" ", "-")

        res = Net::HTTP.post_form(uri, 'name' => encoded_service_name, 'description' => service_name, 'environment' => environment, 'url' => url, 'hostname'=>hostname, 'application' => application)

        res.body
end

