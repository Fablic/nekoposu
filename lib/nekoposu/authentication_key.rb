module Nekoposu
  class AuthenticationKey

    def common_key
      Nekoposu.configuration.common_key
    end

    def random_key
      @random_key ||= Time.new.strftime("%d%L%m%H%Y%M%S")
    end
    alias_method :auth_key, :random_key

    def hash_value
      @hash_value ||= Digest::SHA256.hexdigest("#{common_key}#{random_key}")
    end

    def base64_value
      @base64_value ||= Base64.encode64(hash_value)
    end
    alias_method :auth_cd, :base64_value
  end
end
