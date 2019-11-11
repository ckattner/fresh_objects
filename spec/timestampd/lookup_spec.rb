# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

RSpec.describe Timestampd::Lookup do
  let(:rizzo_stamp) { '1950-01-03 12:00:00 UTC' }

  let(:later_stamp) { '1950-01-03 12:00:01 UTC' }

  let(:timestamps_by_id) do
    {
      rizzo: rizzo_stamp
    }
  end

  subject { described_class.new(timestamps_by_id) }

  describe 'class methods' do
    describe '#make' do
      it 'returns argument if argument is a Lookup instance' do
        subject2 = described_class.make(subject)

        # #be for object equality
        expect(subject2).to be(subject)
      end

      it 'delegates to initializer if argument is not a Lookup instance' do
        expect(described_class).to receive(:new).with(timestamps_by_id)

        described_class.make(timestamps_by_id)
      end
    end
  end

  # This implicitly will test #fresh?, #stale?, #get, and #set.
  describe '#fresh_set?' do
    it 'is true for ids not present' do
      expect(subject.fresh_set?(:marsha, '2000-04-05 02:03:04 UTC')).to be true
    end

    it 'returns is false for ids already present that have equal timestamps' do
      expect(subject.fresh_set?(:rizzo, rizzo_stamp)).to be false
    end

    it 'returns false for ids already present that have earlier timestamps' do
      expect(subject.fresh_set?(:rizzo, '1950-01-03 11:59:59 UTC')).to be false
    end

    it 'returns true and updates timestamp for ids already present that have later timestamps' do
      expect(subject.fresh_set?(:rizzo, later_stamp)).to be true
      expect(subject.timestamps_by_id['rizzo']).to eq(Time.parse(later_stamp).utc)
    end
  end

  describe 'equality' do
    let(:subject2) { described_class.new(timestamps_by_id) }

    specify '#eql? compares class type and underlying hash' do
      expect(subject).to eql(subject2)
    end

    specify '#== compares class type and underlying hash' do
      expect(subject).to eq(subject2)
    end
  end
end
