require 'google/apis/calendar_v3'
require './boundaries/infra/authorization'

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

class Event
  extend Forwardable

  def_delegators :@event, :start, :end, :summary

  def initialize(google_api_event)
    @event = google_api_event
  end

  def refining?
    !!(event.summary =~ /refining/i)
  end

  private

  attr_reader :event
end

response.items.each do |google_api_event|
  event = Event.new(google_api_event)
  duration = (event.end.date_time - event.start.date_time).to_f * 24
  puts "- #{event.summary} (#{duration}) #{event.refining?}"
end
