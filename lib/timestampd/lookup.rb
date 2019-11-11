# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Timestampd
  # A data structure which holds a timestamp per ID.  It can then be used as a performant lookup
  # to see if an incoming timestamp is stale or new.  It is essentially backed by a hash
  # where the key is a string and the value is a Time object.
  # You can also pass in a hash into the constructor for configuration ease.
  class Lookup
    extend Forwardable

    class << self
      def make(timestamps_by_id = {})
        if timestamps_by_id.is_a?(self)
          timestamps_by_id
        else
          new(timestamps_by_id)
        end
      end
    end

    attr_reader :timestamps_by_id

    def_delegators :timestamps_by_id, :as_json, :to_json

    def initialize(timestamps_by_id = {})
      @timestamps_by_id = timestamps_by_id.map do |id, timestamp|
        [id.to_s, parse_time(timestamp)]
      end.to_h

      freeze
    end

    def fresh_set?(id, timestamp)
      fresh?(id, timestamp).tap do |fresh|
        set(id, timestamp) if fresh
      end
    end

    def fresh?(id, timestamp)
      !stale?(id, timestamp)
    end

    def stale?(id, timestamp)
      id        = id.to_s
      current   = get(id)
      timestamp = parse_time(timestamp)

      current && timestamp <= current
    end

    def get(id)
      timestamps_by_id[id.to_s]
    end

    def set(id, timestamp)
      tap { timestamps_by_id[id.to_s] = parse_time(timestamp) }
    end

    def ==(other)
      other.is_a?(self.class) && timestamps_by_id == other.timestamps_by_id
    end
    alias eql? ==

    private

    def parse_time(time)
      time.is_a?(Time) ? time : Time.parse(time.to_s).utc
    end
  end
end
