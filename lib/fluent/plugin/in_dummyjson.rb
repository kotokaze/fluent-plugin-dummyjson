#
# Copyright 2024- TODO: Write your name
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fluent/plugin/input'
require 'net/http'

module Fluent
  module Plugin
    class DummyjsonInput < Fluent::Plugin::Input
      Fluent::Plugin.register_input('dummyjson', self)

      helpers :thread

      config_param :tag, :string, default: ''

      desc 'The URL to fetch the JSON data from'
      config_param :url, :string, default: 'https://dummyjson.com/users'

      desc 'The query string (without `?`) to append to the URL'
      config_param :query, :string, default: ''

      desc 'The interval to fetch the data'
      config_param :interval, :time, default: 60

      def configure(conf)
        super
      end

      def start
        super

        @finished = false
        $log.debug 'Starting the thread'
        @thread = Thread.new(&method(:thread_main))
      end

      def shutdown
        @finished = true
        $log.debug 'Shutting down the thread'
        @thread.join

        super
      end

      def thread_main
        until @finished
          sleep @interval

          uri = URI.parse("#{@url}?#{@query}")
          res = Net::HTTP.get_response(uri)
          if res.is_a?(Net::HTTPSuccess)
            log.info "Fetched data from #{uri}"
            log.debug res.body
          else
            log.error "Failed to fetch data from #{uri}"
            log.error res.body
            next
          end

          # Parse the JSON data
          begin
            # Extract the `users` array from the JSON data
            users = JSON.parse(res.body)['users']
          rescue JSON::ParserError => e
            log.error 'Failed to parse the JSON data'
            log.error e
            next
          end

          # Create a new event stream
          es = MultiEventStream.new
          users.each do |record|
            es.add(Fluent::Engine.now, record)
          end

          router.emit_stream(@tag, es)
        end
      end

    end
  end
end
