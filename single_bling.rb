#!usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/bling/request'
require 'fileutils'

APIKEY = 'APIKEY HERE'

ids = [ 12312 ]

data_path = File.join(Dir.pwd, 'data')
# create data_path dir if not exists
FileUtils.mkdir_p(data_path)

current_page = 0
loop do
  response = Bling::Request.new(page: current_page, apikey: APIKEY)
  found_results = response.result.select { |result| ids.include?(result['id'].to_i) }

  unless found_results.empty?
    File.open("#{data_path}/output_#{current_page}.json", 'w') do |file|
      puts 'Gravando...............'
      file.puts JSON.pretty_generate(found_results)
    end
  end

  sleep(1)
  current_page += 1
  puts "Página #{current_page}"
rescue Bling::NoContent => e
  puts "#{e}. Stopping the loop."
  break
rescue StandardError => e
  puts e.message

  sleep(1)
end
