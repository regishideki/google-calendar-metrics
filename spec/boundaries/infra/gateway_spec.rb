require './boundaries/infra/gateway'
require 'timecop'

describe Boundaries::Infra::Gateway do
  context 'when listing events' do
    it 'calls service with default values when no parameter is provided and encapsulates the result in adapter' do
      Timecop.freeze do
        event_adapter_class = class_double(Boundaries::Infra::Adapters::Event)
        event_adapter_instance = instance_double(Boundaries::Infra::Adapters::Event)
        service = instance_spy(Boundaries::Infra::Services::Calendar)
        events = double('events', items: [event = double('event')])
        allow(service).to receive(:list_events).with(
          'primary',
          max_results: 10,
          single_events: true,
          order_by: 'startTime',
          time_min: Time.now.iso8601
        ).and_return(events)
        allow(event_adapter_class).to receive(:new).with(event).and_return(event_adapter_instance)

        subject = described_class.new(event_adapter_class: event_adapter_class, service: service)
        result = subject.list_events

        expect(result).to eq [event_adapter_instance]
      end
    end
  end
end
