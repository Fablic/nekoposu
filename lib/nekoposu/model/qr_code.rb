module Nekoposu
  module Model
    class QrCode < Base
      attr_accessor :trading_id

      def image
        body
      end

      def embedded
        "data:#{type};base64,#{base64}"
      end

      def type
        'image/png'
      end

      def base64
        @base64 ||= Base64.encode64(image)
      end

      private

      def params
        return @params unless @params.nil?
        fail unless company_id && trading_id
        @params = { tradingId: trading_id }
      end

      def action
        'dispQRcode'
      end
    end
  end
end
