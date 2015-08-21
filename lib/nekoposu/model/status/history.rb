module Nekoposu
  module Model
    class Status
      class History
        attr_accessor :type, :status_code, :status_code, :status_name, :shop_code, :shop_name

        def date=(date_str)
          @date = Date.parse(date_str)
        end

        def date
          @date
        end

        def to_h
          {
            history_type: type,
            date: date,
            status_code: status_code,
            status_name: status_name,
            shop_code: shop_code,
            shop_name: shop_name
          }
        end
      end
    end
  end
end
