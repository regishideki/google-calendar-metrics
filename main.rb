require 'google/apis/calendar_v3'
require './boundaries/infra/authorization'
require './boundaries/infra/gateway'

APPLICATION_NAME = 'Google Calendar'.freeze

service = Google::Apis::CalendarV3::CalendarService.new
authorization = Boundaries::Infra::Authorization.new.authorize(service)
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorization

events = Boundaries::Infra::Gateway.new(service).list_events

puts 'Upcoming events:'
puts 'No upcoming events found' if events.empty?

events.each do |event|
  duration = (event.end.date_time - event.start.date_time).to_f * 24
  puts "- #{event.summary} (#{duration}) #{event.refining?}"
end
