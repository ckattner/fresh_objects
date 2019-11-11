# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'lookup'

module FreshObjects
  # This class can do a "row/timestamp-based semantic merge".  In other words:
  # you can use this class to dump any number of arrays of objects into and it will sift
  # through them and only keep the latest, non-stale copies of the objects.
  class Filter
    extend Forwardable
    include Enumerable

    attr_reader :id_key,
                :lookup,
                :resolver,
                :timestamp_key

    def_delegators :lookup, :timestamps_by_id

    def_delegators :objects, :each

    def initialize(lookup: {}, id_key: :id, timestamp_key: nil, resolver: Objectable.resolver)
      @lookup        = Lookup.make(lookup)
      @id_key        = id_key
      @timestamp_key = timestamp_key
      @resolver      = resolver
      @objects_by_id = {}
    end

    def add_each(objects, default_timestamp: Time.now.utc)
      tap { objects.each { |o| add(o, default_timestamp: default_timestamp) } }
    end

    def add(object, default_timestamp: Time.now.utc)
      id        = resolver.get(object, id_key).to_s
      timestamp = resolve_timestamp(object, default_timestamp)

      objects_by_id[id] = object if lookup.fresh_set?(id, timestamp)

      self
    end

    private

    attr_reader :objects_by_id

    def objects
      objects_by_id.values
    end

    def resolve_timestamp(object, default_timestamp)
      # If we have a timestamp key then lets try and get it from the record.
      # If we don't then we can defer to the default.
      retrieved = timestamp_key ? resolver.get(object, timestamp_key) : default_timestamp

      # One last check, just in case the record returned back something "null-like" like a blank
      # string, lets treat that as nil.
      return default_timestamp if retrieved.to_s.empty?

      retrieved
    end
  end
end
