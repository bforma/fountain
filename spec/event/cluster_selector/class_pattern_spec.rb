require 'spec_helper'

module Fountain::Event
  describe ClassPatternClusterSelector do
    before do
      stub_const('Foo', Class.new)
      stub_const('Bar', Class.new)
    end

    it 'selects a cluster when the class name matches a pattern' do
      cluster = Object.new
      pattern = /Foo/

      selector = described_class.new(cluster, pattern)

      expect(selector.call(Foo.new)).to be(cluster)
      expect(selector.call(Bar.new)).to be_nil
    end
  end
end
