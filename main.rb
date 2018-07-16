require 'google/apis/calendar_v3'
require './boundaries/infra/authorization'
require './boundaries/infra/adapters/event'

APPLICATION_NAME = 'Google Calendar'.freeze

service = Google::Apis::CalendarV3::CalendarService.new
authorization = Boundaries::Infra::Authorization.new.authorize(service)
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorization

calendar_id = 'primary'
response = service.list_events(calendar_id,
                               max_results: 10,
                               single_events: true,
                               order_by: 'startTime',
                               time_min: Time.now.iso8601)
puts 'Upcoming events:'
puts 'No upcoming events found' if response.items.empty?

response.items.each do |google_api_event|
  event = Boundaries::Infra::Adapters::Event.new(google_api_event)
  duration = (event.end.date_time - event.start.date_time).to_f * 24
  puts "- #{event.summary} (#{duration}) #{event.refining?}"
end
