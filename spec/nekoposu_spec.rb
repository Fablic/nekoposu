require 'spec_helper'
describe Nekoposu do
  describe '.configuration' do
    before do
      Nekoposu.configure do |config|
        config.base_url = base_url
        config.common_key = common_key
        config.company_id = company_id
      end
    end

    let(:base_url) { 'http://www.yahoo.co.jp' }
    let(:common_key) { 'abcdef' }
    let(:company_id) { 'company' }

    subject { Nekoposu.configuration }

    it 'returns valid confguration' do
      expect(subject.base_url).to eq base_url
      expect(subject.common_key).to eq common_key
      expect(subject.company_id).to eq company_id
    end
  end
end
