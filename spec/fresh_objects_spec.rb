# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

RSpec.describe FreshObjects do
  describe 'class methods' do
    let(:arguments) do
      {
        lookup: { a: :b },
        id_key: :id_key,
        timestamp_key: :timestamp_key,
        resolver: Objectable.resolver
      }
    end

    specify '#filter delegates to Filter#new' do
      expect(described_class::Filter).to receive(:new).with(arguments)

      described_class.filter(arguments)
    end
  end
end
