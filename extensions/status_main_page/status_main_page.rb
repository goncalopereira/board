require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'haml'

BOARD_URL = 'http://localhost:4567'

def get_services
	uri = URI.parse(BOARD_URL + '/services')
	Net::HTTP.get_response(uri).body
end

def get_statuses
	uri = URI.parse(BOARD_URL + '/statuses')
	Net::HTTP.get_response(uri).body
end

get '/'	do

	response_services = get_services 
	services_list = JSON.parse(response_services)['services']
	response_statuses = get_statuses
	statuses_list = JSON.parse(response_statuses)['statuses']

	haml :status_main_page, :locals => {:services => services_list, :statuses => statuses_list, :url => BOARD_URL}
	
end
