module Nekoposu
  module Model
    class TrackingNumber < Base
      attr_accessor :trading_id

      def number
        @number ||= content('//denpyoNo')
      end

      private

      def params
        return @params unless @params.nil?
        fail unless default_parameter_exist?
        fail unless trading_id
        h = {
          iraiDatetime: request_datetime,
          tradingId: trading_id
        }
        h[:clientIp] = client_ip unless client_ip.nil?
        @params = h
      end

      def action
        'retDenpyoNo'
      end
    end
  end
end
