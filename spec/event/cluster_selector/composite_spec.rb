require 'spec_helper'

module Fountain::Event
  describe CompositeClusterSelector do
    it 'uses the selection from the first matching selector' do
      cluster = Object.new
      listener = Object.new

      selectors = [
        proc {},
        proc { cluster },
        proc { fail }
      ]

      selector = described_class.new(selectors);

      expect(selector.call(listener)).to be(cluster)
    end
  end
end
