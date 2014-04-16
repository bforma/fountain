require 'spec_helper'

module Fountain::Command
  describe InterceptorChain do

    let(:unit) { Object.new }
    let(:handler) { double }
    let(:command) { Object.new }

    describe '#proceed' do
      context 'with interceptors' do
        subject { described_class.new(unit, [interceptor], handler) }
        let(:interceptor) { double }

        it 'calls the next interceptor' do
          result = Object.new
          expect(interceptor).to receive(:call).with(subject, command, unit) do |subject, command|
            subject.proceed(command)
          end
          expect(handler).to receive(:call).with(command, unit) do |command|
            result
          end
          expect(subject.proceed(command)).to be(result)
        end
      end

      context 'without interceptors' do
        subject { described_class.new(unit, [], handler) }

        it 'calls the handler directly' do
          result = Object.new
          expect(handler).to receive(:call).with(command, unit) do |command|
            result
          end
          expect(subject.proceed(command)).to be(result)
        end
      end
    end

  end
end
