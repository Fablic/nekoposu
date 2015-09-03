require 'time'
require 'base64'
require 'securerandom'
require 'digest/sha2'
require 'nokogiri'

require 'nekoposu/version'
require 'nekoposu/configuration'
require 'nekoposu/authentication_key'
require 'nekoposu/model/base'
require 'nekoposu/model/status'
require 'nekoposu/model/status/history'
require 'nekoposu/model/due_date'
require 'nekoposu/model/tracking_number'
require 'nekoposu/model/shipping_label'
require 'nekoposu/model/qr_code'

begin
  require 'pry'
rescue LoadError
end

module Nekoposu
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
