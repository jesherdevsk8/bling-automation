# frozen_string_literal: true

module Bling
  class Error < StandardError; end
  class ApiRequestError < Error; end

  class NoContent < Error
    def initialize(message = 'No content found')
      super(message)
    end
  end
end
