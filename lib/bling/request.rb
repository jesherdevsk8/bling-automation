# frozen_string_literal: true

require_relative 'service'

module Bling
  class Request
    attr_reader :page, :apikey, :result

    def initialize(page:, apikey:)
      raise ArgumentError 'page must be nil' if page.nil? || page.to_s.empty?
      raise ArgumentError 'apikey must be nil' if apikey.nil? || apikey.empty?

      response = Service.get(page, apikey)

      @result = rows_from(response)
    end

    private

    def rows_from(response)
      products = response['retorno']['produtos']

      raise Bling::NoContent unless products

      products.map do |produto|
        {
          'id' => produto['produto']['id'],
          'images' => produto['produto']['imagem'].map { |img| img['link'] }
        }
      end
    end
  end
end
