module Pagosonline
  class Client
    attr_accessor :account_id, :key
    def initialize(options = {})
      self.account_id   = options[:account_id]
      self.key          = options[:key]
      self.test         = !!options[:test]
    end

    def payment(options)
      Pagosonline::Payment.new(options).tap do |payment|
        payment.client = self
      end
    end

    def response(options)
      Pagosonline::Response.new(options).tap do |response|
        response.client = self
      end
    end

    def test?
      @test
    end

    def test=(test)
      @test = test
    end
  end
end
