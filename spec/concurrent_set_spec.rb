require 'spec_helper'

describe Fountain::ConcurrentSet do
  it 'supports basic set operations' do
    expect(subject).to be_empty

    expect(subject.add?(:a)).to be_true
    expect(subject.add?(:a)).to be_false
    expect(subject.add?(:b)).to be_true

    expect(subject).to_not be_empty
    expect(subject.size).to eql(2)

    expect(subject.delete?(:a)).to be_true
    expect(subject.delete?(:a)).to be_false

    expect(subject.size).to eql(1)
  end
end
