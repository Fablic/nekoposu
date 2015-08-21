module Nekoposu
  module Model
    class DueDate < Base
      attr_reader :source_zipcode, :destination_zipcode, :ship_date

      DELIVERABLE_TIME_TEXTS = %w( 指定不能 午前中 12時〜14時 14時〜16時 16時〜18時 18時〜20時 20時〜21時 )
      DELIVERABLE_TIME = {
       1 => { from: 8, to: 12 },
       2 => { from: 12, to: 14 },
       3 => { from: 14, to: 16 },
       4 => { from: 16, to: 18 },
       5 => { from: 18, to: 20 },
       6 => { from: 20, to: 21 },
      }

      def source_zipcode=(zipcode)
        fail 'source_zipcode should be 7 digits' unless zipcode =~ /^\d{7}$/
        @source_zipcode = zipcode
      end

      def destination_zipcode=(zipcode)
        fail 'destination_zipcode should be 7 digits' unless zipcode =~ /^\d{7}$/
        @destination_zipcode = zipcode
      end

      def ship_date=(date)
        fail 'ship_date should be Date instance' unless date.instance_of? Date
        @ship_date = date
      end

      def ship_date
        @ship_date.to_s
      end

      def delivery_date
        return @delivery_date if defined? @delivery_date
        d_date = content('//delivDate')
        @delivery_date = d_date.nil? ? nil : Date.parse(d_date)
      end

      def delivery_time
        return @delivery_time if defined? @delivery_time
        d_time = content('//delivTime')
        @delivery_time = d_time.nil? ? nil : d_time.to_i
      end

      def delivery_time_from
        return @delivery_time_from if defined? @delivery_time_from
        return @delivery_time_from = nil if delivery_time.nil?
        time = DELIVERABLE_TIME[delivery_time]
        return @delivery_time_from = nil if time.nil?
        @delivery_time_from = time[:from]
      end

      def delivery_time_to
        return @delivery_time_to if defined? @delivery_time_to
        return @delivery_time_to = nil if delivery_time.nil?
        time = DELIVERABLE_TIME[delivery_time]
        return @delivery_time_to = nil if time.nil?
        @delivery_time_to = time[:to]
      end

      def delivery_time_text
        return @delivery_time_text if defined? @delivery_time_text
        return @delivery_time_text = nil if delivery_time.nil?
        DELIVERABLE_TIME_TEXTS[delivery_time]
      end

      private

      def action
        'noticeDelivDate'
      end

      def params
        return @params unless @params.nil?
        fail unless default_paramater_exist?
        unless source_zipcode && destination_zipcode && ship_date
          fail
        end
        h = {
          companyId: company_id,
          iraiDatetime: request_datetime,
          dstZipCd: destination_zipcode,
          srcZipCd: source_zipcode,
          shipDate: ship_date
        }
        h[:clientIp] = client_ip unless client_ip.nil?
        @params = h
      end
    end
  end
end
