require 'nekoposu/version'
require 'nekoposu/configuration'
require 'nekoposu/authentication_key'

require 'time'
require 'base64'
require 'securerandom'
require 'digest/sha2'

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
