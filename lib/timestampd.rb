# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'objectable'
require 'time'

require_relative 'timestampd/filter'

# Top-level namespace
module Timestampd
  class << self
    # Syntactic sugary proxy for easy building of Filter instances.
    def filter(*args)
      Filter.new(*args)
    end
  end
end
