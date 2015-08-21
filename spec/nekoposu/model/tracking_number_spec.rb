require 'spec_helper'
require_relative 'shared_tests'
describe Nekoposu::Model::TrackingNumber do
  let(:klass) { Nekoposu::Model::TrackingNumber }
  before do
    Nekoposu.configure do |config|
      config.base_url = base_url
      config.company_id = company_id
      config.common_key = common_key
    end
  end

  let(:base_url) { 'http://www.yahoo.co.jp' }
  let(:common_key) { 'abcdef' }
  let(:company_id) { 'company' }
  let(:xml_success) do
    '<?xml version="1.0" encoding="UTF-8"?><StatusCooperationResponse><responseHeader><rtnCd>0</rtnCd><rtnDatetime>2015-07-10T10:49:53.527+09:00</rtnDatetime></responseHeader><statusCooperationInput><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><iraiDatetime>2015-07-10T10:49:45.880+09:00</iraiDatetime><tradingId>20150710</tradingId></statusCooperationInput><statusCooperationOutput><invoiceInfo><denpyoNo>768230001696</denpyoNo></invoiceInfo></statusCooperationOutput></StatusCooperationResponse>'
  end

  let(:xml_failure) do
    '<?xml version="1.0" encoding="UTF-8"?><StatusCooperationResponse><responseHeader><errorInfoList><errorInfo><msg>該当する伝票番号は存在しません。</msg><msgId>ERROR_NOT_FOUND</msgId></errorInfo></errorInfoList><rtnCd>2</rtnCd><rtnDatetime>2015-07-10T10:48:46.533+09:00</rtnDatetime></responseHeader><statusCooperationInput><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><iraiDatetime>2015-07-10T10:47:34.645+09:00</iraiDatetime><tradingId>20150710</tradingId></statusCooperationInput></StatusCooperationResponse>'
  end

  let(:expected_failure_return_code) { 2 }
  let(:expected_failure_error_infos) do
    [{ message: '該当する伝票番号は存在しません。', message_id: 'ERROR_NOT_FOUND' }]
  end

  let(:model) { klass.new }

  it_behaves_like 'base class behavier'

  context 'success' do
    before do
      allow_any_instance_of(klass).to receive(:body).and_return(xml_success)
    end

    describe '#number' do
      subject { model.number }
      it { should eq '768230001696' }
    end
  end
end
