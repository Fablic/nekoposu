module Nekoposu
  module Model
    class Base
      attr_accessor :client_ip

      def initialize
        @auth_key = AuthenticationKey.new
      end

      def company_id
        Nekoposu.configuration.company_id
      end

      def auth_cd
        @auth_key.auth_cd
      end

      def auth_key
        @auth_key.auth_key
      end

      def request_datetime
        @request_datetime ||= Time.now.iso8601(3)
      end

      def uri
        @uri ||= URI.join(Nekoposu.configuration.base_url, action)
      end

      def return_code
        return @return_code if defined? @return_code
        return @return_code = nil if xml.nil?
        @return_code = xml.xpath('//rtnCd').first.content.to_i
      end

      def error_infos
        return @error_infos if defined? @error_infos
        return @error_infos = [] if xml.nil?
        @error_infos = xml.xpath('//errorInfoList').map do |obj|
          {
            message: obj.xpath('//msg').first.content,
            message_id: obj.xpath('//msgId').first.content,
          }
        end
      end

      private

      def xml
        return @xml if defined? @xml
        return @xml = nil if body.nil?
        @xml = Nokogiri::XML(body)
      end

      def body
        return unless success?
        response.body
      end

      def ssl?
        uri.scheme == 'https'
      end

      def success?
        @success ||= response.kind_of? Net::HTTPSuccess
      end

      def response
        @response ||= fetch_from_saas
      end

      def fetch_from_saas
        req = Net::HTTP::Post.new(uri.request_uri)
        merged_params = params.merge(
          companyId: company_id,
          auth_key: auth_key,
          auth_cd: auth_cd
        )
        req.set_form_data(merged_params)
        Net::HTTP.start(uri.host, uri.port, use_ssl: ssl?) do |http|
          http.request(req)
        end
      end

      def content(path, object: nil)
        object = xml if object.nil?
        element = object.xpath(path).children.first
        return nil if element.nil?
        element.content
      end

      def default_paramater_exist?
        company_id && request_datetime
      end
    end
  end
end
