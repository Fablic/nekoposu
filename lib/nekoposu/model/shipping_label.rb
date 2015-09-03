module Nekoposu
  module Model
    class ShippingLabel < Base
      attr_accessor(
        :trading_id, :password, :destination_prefecture,
        :destination_city, :destination_street, :destination_building,
        :destination_company, :destination_division,
        :destination_last_name, :destination_first_name,
        :source_prefecture, :source_city, :source_street, :source_building,
        :source_company, :source_division,
        :source_last_name, :source_first_name,
        :baggage_name, :pickup
      )

      attr_reader(
        :destination_telephone_number, :source_telephone_number,
        :destination_zipcode, :source_zipcode,
        :baggage_handling1, :baggage_handling2,
        :ship_date
      )

      BAGGAGE_HANDLING = {
        precision: '01',
        fragile: '02',
        do_not_stack: '03',
        do_not_turn_upside_down: '04',
        perishable: '05'
      }

      REQUIRED_PARAMATERS = [
        :iraiDatetime,
        :trading_id,
        :password,
        :anonymous_flag,
        :shipping_type,
        :payment_type,
        :destination_type,
        :destination_zipcode,
        :destination_prefecture,
        :destination_city,
        :destination_last_name,
        :source_telephone_number1,
        :source_telephone_number2,
        :source_telephone_number3,
        :source_zipcode,
        :source_prefecture,
        :source_city,
        :source_last_name,
        :source_first_name,
        :baggage_description
      ]

      def anonymous_flag
        0
      end

      def shipping_type
        '13' # nekopos: 13, taqbin: 01, taqbin compact: 12
      end

      def payment_type
        1 # 発払
      end

      def destination_type
        ''
      end

      def destination_telephone_number=(number)
        err_str = 'destination_telephone_number should be over 10 digits number string'
        fail err_str unless number =~ /^\d+$/
        fail err_str unless number =~ /\d{10}$/
        @destination_telephone_number = number
      end

      def source_telephone_number=(number)
        err_str = 'source_telephone_number should be over 10 digits number string'
        fail err_str unless number =~ /^\d+$/
        fail err_str unless number =~ /\d{10}$/
        @source_telephone_number = number
      end

      def destination_zipcode=(zipcode)
        fail 'destination_zipcode should be 7 digits number string' unless zipcode =~ /^\d{7}$/
        @destination_zipcode = zipcode
      end

      def source_zipcode=(zipcode)
        fail 'source_zipcode should be 7 digits number string' unless zipcode =~ /^\d{7}$/
        @source_zipcode = zipcode
      end

      def baggage_handling1=(handling_sym)
        @baggage_handling1 = BAGGAGE_HANDLING[handling_sym]
      end

      def baggage_handling2=(handling_sym)
        @baggage_handling2 = BAGGAGE_HANDLING[handling_sym]
      end

      def pickup?
        !!@pickup
      end

      def ship_date=(date)
        fail 'ship_date should be Date instance' unless date.instance_of? Date
        @ship_date = date
      end

      def ship_date
        return unless defined? @ship_date
        @ship_date.to_s
      end

      # responce
      def reserve_number
        content('//reserveNo')
      end

      def reserve_date
        content('//reserveDt')
      end

      def reserve_expiry_date
        content('//reserveLimitDate')
      end

      private

      def destination_telephone_number1
        return unless defined? @destination_telephone_number
        return if @destination_telephone_number.nil?
        @destination_telephone_number[0..-9]
      end

      def destination_telephone_number2
        return unless defined? @destination_telephone_number
        return if @destination_telephone_number.nil?
        @destination_telephone_number[-8..-5]
      end

      def destination_telephone_number3
        return unless defined? @destination_telephone_number
        return if @destination_telephone_number.nil?
        @destination_telephone_number[-4..-1]
      end

      def source_telephone_number1
        return unless defined? @source_telephone_number
        return if @source_telephone_number.nil?
        @source_telephone_number[0..-9]
      end

      def source_telephone_number2
        return unless defined? @source_telephone_number
        return if @source_telephone_number.nil?
        @source_telephone_number[-8..-5]
      end

      def source_telephone_number3
        return unless defined? @source_telephone_number
        return if @source_telephone_number.nil?
        @source_telephone_number3 ||= @source_telephone_number[-4..-1]
      end

      def params
        return @params unless @params.nil?
        @params = optional_params(base_hash)
      end

      def optional_params(hash)
        hash[:clientIp] = client_ip unless client_ip.nil?
        hash[:dstTel1] = destination_telephone_number1 unless destination_telephone_number1.nil?
        hash[:dstTel2] = destination_telephone_number2 unless destination_telephone_number2.nil?
        hash[:dstTel3] = destination_telephone_number3 unless destination_telephone_number3.nil?
        hash[:dstAddress3] = destination_street unless destination_street.nil?
        hash[:dstAddress4] = destination_building unless destination_building.nil?
        hash[:dstCoNm] = destination_company unless destination_company.nil?
        hash[:dstDivNm] = destination_division unless destination_division.nil?
        hash[:dstFirstNm] = destination_first_name unless destination_first_name.nil?
        hash[:srcAddress3] = source_street unless source_street.nil?
        hash[:srcAddress4] = source_building unless source_building.nil?
        hash[:srcCoNm] = source_company unless source_company.nil?
        hash[:srcDivNm] = source_division unless source_division.nil?
        hash[:baggHandling1] = baggage_handling1 unless baggage_handling1.nil?
        hash[:baggHandling2] = baggage_handling2 unless baggage_handling2.nil?
        hash[:shipDate] = ship_date unless ship_date.nil?
        hash
      end

      def base_hash
       {
          iraiDatetime: request_datetime,
          tradingId: trading_id,
          reservePwd: password,
          anonymityFlg: anonymous_flag,
          invoiceKb: shipping_type,
          payKb: payment_type,
          dstKb: destination_type,
          dstZipCd: destination_zipcode,
          dstAddress1: destination_prefecture,
          dstAddress2: destination_city,
          dstLastNm: destination_last_name,
          srcTel1: source_telephone_number1,
          srcTel2: source_telephone_number2,
          srcTel3: source_telephone_number3,
          srcZipCd: source_zipcode,
          srcAddress1: source_prefecture,
          srcAddress2: source_city,
          srcLastNm: source_last_name,
          srcFirstNm: source_first_name,
          baggDesc2: baggage_name,
          shukaFlg: pickup? ? '1' : '0'
        }
      end

      def proper_parametaters?
        return false unless default_parameter_exist?
        return REQUIRED_PARAMATERS.all? do |param_name_sym|
          send(param_name_sym)
        end
      end

      def action
        'regInvoiceInfo'
      end
    end
  end
end
