module Nekoposu
  module Model
    class QrCode < Base
      attr_accessor :trading_id, :qrcode_type

      QRCODE_TYPE = {
        nekopit: '00',
        famiport: '01'
      }

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

      def qrcode_type=(type_sym)
        return @qrcode_type = type_sym if QRCODE_TYPE.key?(type_sym)
        @qrcode_type = :nekopit
      end

      def qrcode_type
        defined?(@qrcode_type) ? QRCODE_TYPE[@qrcode_type] : QRCODE_TYPE[:nekopit]
      end

      private

      def params
        return @params unless @params.nil?
        fail unless company_id && trading_id
        @params = { tradingId: trading_id, qrcodeType: qrcode_type }
      end

      def action
        'dispQRcode'
      end
    end
  end
end
