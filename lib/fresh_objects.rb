# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'objectable'
require 'time'

require_relative 'fresh_objects/filter'

# Top-level namespace
module FreshObjects
  class << self
    # Syntactic sugary proxy for easy building of Filter instances.
    def filter(*args)
      Filter.new(*args)
    end
  end
end
