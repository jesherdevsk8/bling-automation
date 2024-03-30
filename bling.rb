#!usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/bling/request'

APIKEY = 'APIKEY HERE'

(1..105).each do |num|
  response = Bling::Request.new(page: num, apikey: APIKEY)

  File.open("./data/output_#{num}.json", 'w') do |file|
    file.puts JSON.pretty_generate(response.result)
  end

  sleep(1)
rescue StandardError => e
  e.message

  sleep(1)
end
