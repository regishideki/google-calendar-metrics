require './boundaries/infra/adapters/event/'
require 'date'

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

  context 'when calculating the duration of an event' do
    it 'returns 0 when google event end date is not a date time' do
      google_event = double('google_event')
      allow(google_event).to receive_message_chain(:end, :date_time).and_return(nil)

      subject = described_class.new(google_event)

      expect(subject.duration).to eq 0
    end

    it 'returns the duration in hours' do
      google_event = double('google_event')
      allow(google_event).to receive_message_chain(:start, :date_time).and_return(DateTime.new(2000, 1, 2, 3))
      allow(google_event).to receive_message_chain(:end, :date_time).and_return(DateTime.new(2000, 1, 2, 4))

      subject = described_class.new(google_event)

      expect(subject.duration).to eq 1
    end
  end

  context 'when defining if it is a refining' do
    it 'returns true when summary has the word "refining" ignoring case' do
      google_event = double('google_event', summary: 'Today has a ReFiNinG!!!')

      subject = described_class.new(google_event)

      expect(subject).to be_refining
    end

    it 'returns false when summary has not the word "refining" ignoring case' do
      google_event = double('google_event', summary: 'Reffining enviado pelo Matheus')

      subject = described_class.new(google_event)

      expect(subject).not_to be_refining
    end
  end
end
