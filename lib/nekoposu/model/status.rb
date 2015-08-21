module Nekoposu
  module Model
    class Status < Base
      attr_accessor :tracking_number

      def status_code
        @status_code ||= xml.xpath('//statusCode').first.content.to_i
      end

      def status_name
        @status_name ||= xml.xpath('//status').first.content
      end

      def package_size
        @package_size ||= xml.xpath('//size').first.content.to_i
      end

      def appointed_date
        return @appointed_date if defined? @appointed_date
        date = xml.xpath('//delivDate').first.content
        return @appointed_date = nil if date.nil? || date == ''
        @appointed_date = Date.parse(date)
      end

      def appointed_time
        return @appointed_time if defined? @appointed_time
        time = xml.xpath('//delivTimeZone').first.content
        return @appointed_time = nil if time.nil? || time == '' || time == '0000'
        @appointed_time = time
      end

      def histories
        @histories ||= xml.xpath('//historyInfo').map do |obj|
          h = History.new
          h.type = content('//historyDataKb', object: obj)
          h.date = content('//historyDelivDate', object: obj)
          h.status_code = content('//historyStatusCode', object: obj)
          h.status_name = content('//historyStatus', object: obj)
          h.shop_code = content('//historyJigyoCode', object: obj)
          h.shop_name = content('//historyJigyoName', object: obj)
          h
        end
      end

      private

      def params
        return @params unless @params.nil?
        fail unless default_paramater_exist?
        fail unless tracking_number
        h = {
          companyId: company_id,
          iraiDatetime: request_datetime,
          denpyoNo: tracking_number
        }
        h[:clientIp] = client_ip unless client_ip.nil?
        @params = h
      end

      def action
        'confirmStatus'
      end
    end
  end
end
