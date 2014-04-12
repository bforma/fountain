require 'spec_helper'

module Fountain::Router
  describe EnvelopeHandlerScore do
    before do
      stub_const('BasePayload', Class.new)
      stub_const('MiddlePayload', Class.new(BasePayload))
      stub_const('SpecificPayloadA', Class.new(MiddlePayload))
      stub_const('SpecificPayloadB', Class.new(MiddlePayload))
    end

    it 'measures the depth of the payload class hierarchy' do
      score_a = EnvelopeHandlerScore.new(BasePayload)
      score_b = EnvelopeHandlerScore.new(MiddlePayload)
      score_c = EnvelopeHandlerScore.new(SpecificPayloadA)

      base = score_a.payload_depth
      expect(score_b.payload_depth).to eql(base + 1)
      expect(score_c.payload_depth).to eql(base + 2)
    end

    it 'uses payload depth and name for comparison' do
      score_a = EnvelopeHandlerScore.new(BasePayload)
      score_b = EnvelopeHandlerScore.new(MiddlePayload)
      score_c = EnvelopeHandlerScore.new(SpecificPayloadA)
      score_d = EnvelopeHandlerScore.new(SpecificPayloadB)

      expect(score_a).to be < score_b
      expect(score_b).to be < score_c
      expect(score_c).to be < score_d
    end
  end
end
