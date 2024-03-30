#!/usr/bin/env ruby
# frozen_string_literal: true

require 'selenium-webdriver'
require 'json'
require 'open-uri'
require 'fileutils'
require 'pry-byebug'

images_path = File.join(Dir.pwd, 'images')
data_path = File.join(Dir.pwd, 'data')

# create images_path dir if not exists
FileUtils.mkdir_p(images_path)
Dir.chdir(File.dirname(__FILE__))

file_paths = Dir.glob(File.join(data_path, 'output_*.json')).sort_by { |path| path.scan(/\d+/).map(&:to_i) }
json_data = file_paths.map { |path| JSON.parse(File.read(path)) }.flatten

driver = Selenium::WebDriver.for :chrome

json_data.each do |data|
  id = data['id']

  # Uncomment this line if you need to rerun to fetch product images outside of Bling.
  # next if data['images'].any? { |link| link =~ %r{^https?://orgbling\.s3\.amazonaws\.com} }

  data['images'].each_with_index do |link, index|
    driver.get(link)
    sleep 1
    begin
      uri = URI.parse(link)
      imagem_temporaria = uri.open
    rescue StandardError => e
      puts "Error: #{e.message}"
      next
    end
    image_name = File.basename(link)

    begin
      File.open("#{images_path}/#{id}-id-#{index}-#{image_name}", 'wb') do |file|
        IO.copy_stream(imagem_temporaria, file)
      end
      puts "Imagem do produto id #{id} baixada e salva com sucesso!"
    ensure
      imagem_temporaria&.close
    end

    sleep 1
  end
end

driver.quit
