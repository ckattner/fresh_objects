# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

RSpec.describe Timestampd::Filter do
  let(:lookup) do
    {
      'rizzo': '1950-01-03 12:00:00 UTC'
    }
  end

  subject { described_class.new(lookup: lookup, timestamp_key: :timestamp) }

  specify '#timestamps_by_id returns the underlying lookup hash' do
    expected = {
      'rizzo' => Time.parse('1950-01-03 12:00:00 UTC').utc
    }

    expect(subject.timestamps_by_id).to eq(expected)
  end

  context 'using default_timestamp' do
    it 'skips existing objects before timestamp' do
      object = {
        id: :rizzo,
        first: :frank
      }

      subject.add(object, default_timestamp: '1950-01-03 11:59:59 UTC')

      expect(subject.objects).to eq([])
    end

    it 'adds existing objects after timestamp' do
      object = {
        id: :rizzo,
        first: :frank
      }

      subject.add(object, default_timestamp: '1950-01-03 12:00:01 UTC')

      expect(subject.objects).to eq([object])
    end

    it 'adds new objects' do
      object = {
        id: :bozo,
        first: 'the clown'
      }

      subject.add(object, default_timestamp: '1950-01-03 12:00:01 UTC')

      expect(subject.objects).to eq([object])
    end
  end

  context 'using object timestamp' do
    it 'skips existing objects before timestamp' do
      object = {
        id: :rizzo,
        first: :frank,
        timestamp: '1950-01-03 11:59:59 UTC'
      }

      subject.add(object)

      expect(subject.objects).to eq([])
    end

    it 'adds existing objects after timestamp' do
      object = {
        id: :rizzo,
        first: :frank,
        timestamp: '1950-01-03 12:00:01 UTC'
      }

      subject.add(object)

      expect(subject.objects).to eq([object])
    end
  end

  context 'overriding objects' do
    let(:object1) do
      {
        id: :rizzo,
        first: :frank1,
        timestamp: '1950-01-03 12:00:01 UTC'
      }
    end

    let(:object2) do
      {
        id: :rizzo,
        first: :frank2,
        timestamp: '1950-01-03 12:00:02 UTC'
      }
    end

    context 'in chonological add order' do
      before(:each) { subject.add_each([object1, object2]) }

      it 'keeps latest object' do
        expect(subject.objects).to eq([object2])
      end
    end

    context 'in chonological add order' do
      before(:each) { subject.add_each([object2, object1]) }

      it 'keeps latest object' do
        expect(subject.objects).to eq([object2])
      end
    end
  end
end
