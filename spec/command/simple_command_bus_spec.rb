require 'spec_helper'

module Fountain::Command
  describe SimpleCommandBus do

    before do
      stub_const('ParentCommand', Class.new)
      stub_const('SubCommand', Class.new(ParentCommand))
      stub_const('ExampleCommand', Class.new)
    end

    describe '#dispatch' do
      it 'notifies the callback of successful dispatch' do
        command = Fountain::Envelope.build do |builder|
          builder.payload = ExampleCommand.new
        end

        result = Object.new

        callback = double
        handler = double

        expect(handler).to receive(:call).with(command, anything).and_return(result)
        expect(callback).to receive(:on_success).with(result)

        subject.subscribe(ExampleCommand, handler)
        subject.dispatch(command, callback)
      end

      it 'notifies the callback of failed dispatch' do
        command = Fountain::Envelope.build do |builder|
          builder.payload = ExampleCommand.new
        end

        callback = double
        handler = double

        expect(handler).to receive(:call).with(command, anything) do
          raise RuntimeError
        end
        expect(callback).to receive(:on_failure).with(an_instance_of(RuntimeError))

        subject.subscribe(ExampleCommand, handler)
        subject.dispatch(command, callback)
      end

      it 'notifies the callback if no suitable handler subscribed' do
        command = Fountain::Envelope.build do |builder|
          builder.payload = ExampleCommand.new
        end

        callback = double
        expect(callback).to receive(:on_failure).with(an_instance_of(NoHandlerError))

        subject.dispatch(command, callback)
      end
    end

  end
end
