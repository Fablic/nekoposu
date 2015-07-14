require 'spec_helper'
describe Nekoposu::AuthenticationKey do
  before do
    Nekoposu.configure do |config|
      config.common_key = common_key
    end
  end
  let(:common_key) { 'common_common_common' }
  let(:key_maker) { Nekoposu::AuthenticationKey.new }

  describe '#random_key' do
    subject { key_maker.random_key }
    it 'always returns same random_key' do
      expect(subject).to eq key_maker.random_key
      expect(subject.size).to eq 17
    end
  end

  describe '#auth_key' do
    subject { key_maker.auth_key }
    it 'always returns same random_key' do
      expect(subject).to eq key_maker.random_key
      expect(subject.size).to eq 17
    end
  end

  describe '#common_key' do
    subject { key_maker.common_key }

    it 'always returns configured common_key' do
      expect(subject).to eq common_key
      expect(subject).to eq Nekoposu::AuthenticationKey.new.common_key
    end
  end

  describe '#hash_value' do
    subject { key_maker.hash_value }
    let(:expected_value) do
      Digest::SHA256.digest("#{key_maker.common_key}#{key_maker.random_key}")
    end
    it 'returns binary data' do
      expect(subject).to eq expected_value
    end
  end

  describe '#base64_value' do
    subject { key_maker.hash_value }
    let(:expected_value) do
      Digest::SHA256.digest("#{key_maker.common_key}#{key_maker.random_key}")
    end
    it 'returns binary data' do
      expect(subject).to eq expected_value
    end
  end

  describe '#base64_value' do
    subject { key_maker.base64_value }
    it 'returns base_64_value' do
      expect(subject).to eq Base64.encode64(key_maker.hash_value)
      expect(Base64.decode64(subject)).to eq key_maker.hash_value
    end
  end

  describe '#auth_cd' do
    subject { key_maker.auth_cd }
    it 'returns base_64_value' do
      expect(subject).to eq Base64.encode64(key_maker.hash_value)
      expect(Base64.decode64(subject)).to eq key_maker.hash_value
    end
  end
end
