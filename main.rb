require 'google/apis/calendar_v3'
require './boundaries/infra/gateway'

events = Boundaries::Infra::Gateway.new.list_events

puts 'Upcoming events:'
puts 'No upcoming events found' if events.empty?

events.each do |event|
  puts "- #{event.summary} (#{event.duration}) #{event.refining?}"
end
