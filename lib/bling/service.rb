# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require_relative 'exceptions'

module Bling
  class Service
    BASE_URL = 'https://bling.com.br/Api/v2/produtos/'

    def self.get(number, apikey)
      url = URI.parse("#{BASE_URL}page=#{number}/json/?apikey=#{apikey}&imagem=S")

      response = Net::HTTP.get_response(url)

      raise ApiRequestError, "The server responded with HTTP #{response.code}" unless response.code == '200'

      JSON.parse(response.body)
    end
  end
end
