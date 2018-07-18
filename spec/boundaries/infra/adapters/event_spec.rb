require './boundaries/infra/adapters/event/'

describe Boundaries::Infra::Adapters::Event do
  context 'when delegating to original google calendar event' do
    it 'delegates method start to google event' do
      google_event = double('google_event', start: Time.now)

      subject = described_class.new(google_event)

      expect(subject.start).to eq google_event.start
    end

    it 'delegates method end to google event' do
      google_event = double('google_event', end: Time.now)

      subject = described_class.new(google_event)

      expect(subject.end).to eq google_event.end
    end

    it 'delegates method summary to google event' do
      google_event = double('google_event', summary: 'Refining')

      subject = described_class.new(google_event)

      expect(subject.summary).to eq google_event.summary
    end
  end
end
