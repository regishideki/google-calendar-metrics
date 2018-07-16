require 'google/apis/calendar_v3'
require './boundaries/infra/authorization'
require './boundaries/infra/gateway'

events = Boundaries::Infra::Gateway.new.list_events

puts 'Upcoming events:'
puts 'No upcoming events found' if events.empty?

events.each do |event|
  duration = (event.end.date_time - event.start.date_time).to_f * 24
  puts "- #{event.summary} (#{duration}) #{event.refining?}"
end
