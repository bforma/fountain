require 'spec_helper'

module Fountain::Event
  describe ClusteringEventBus do

    let(:cluster) { BaseCluster.new('default') }
    let(:selector) { DefaultClusterSelector.new(cluster) }
    let(:terminal) { LocalEventBusTerminal.new }

    let(:listener) { Object.new }
    let(:event) { Object.new }

    subject { described_class.new(selector, terminal) }

    it 'delegates publication to an event bus terminal' do
      expect(terminal).to receive(:on_cluster_creation).with(cluster)
      expect(terminal).to receive(:publish).with(event)

      subject.subscribe(listener)
      subject.publish(event)
    end

    it 'uses clusters for subscription management' do
      expect(cluster).to receive(:subscribe).with(listener)
      expect(cluster).to receive(:unsubscribe).with(listener)

      subject.subscribe(listener)
      subject.unsubscribe(listener)
    end

    it 'raises an error no cluster is selected for an event listener' do
      expect(selector).to receive(:call).with(listener).and_return(nil)

      expect {
        subject.subscribe(listener)
      }.to raise_error(SubscriptionError)
    end

    it 'only notifies the terminal of unknown clusters' do
      expect(terminal).to receive(:on_cluster_creation).with(cluster).once

      subject.subscribe(listener)
      subject.subscribe(listener)
    end

  end
end
