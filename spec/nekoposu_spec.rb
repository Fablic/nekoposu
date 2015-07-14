require 'spec_helper'
describe Nekoposu do
  describe '.configuration' do
    before do
      Nekoposu.configure do |config|
        config.base_url = 'http://www.yahoo.co.jp'
        config.common_key = 'abcdef'
      end
    end

    let(:base_url) { 'http://www.yahoo.co.jp' }
    let(:common_key) { 'abcdef' }

    subject { Nekoposu.configuration }

    it 'returns valid confguration' do
      expect(subject.base_url).to eq base_url
      expect(subject.common_key).to eq common_key
    end
  end
end
