require 'spec_helper'
require_relative 'shared_tests'
describe Nekoposu::Model::Status do
  let(:klass) { Nekoposu::Model::Status }
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
    '<?xml version="1.0" encoding="UTF-8"?><StatusCooperationResponse><responseHeader><rtnCd>0</rtnCd><rtnDatetime>2015-07-10T10:56:36.321+09:00</rtnDatetime></responseHeader><statusCooperationInput><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><denpyoNo>768230001696</denpyoNo><iraiDatetime>2015-07-10T10:56:32.309+09:00</iraiDatetime></statusCooperationInput><statusCooperationOutput><historyInfoList><historyInfo><historyDataKb>01</historyDataKb><historyDelivDate>2015-07-10</historyDelivDate><historyJigyoCode>031300</historyJigyoCode><historyJigyoName>枝川センター</historyJigyoName><historyStatus>発送</historyStatus><historyStatusCode>01</historyStatusCode></historyInfo><historyInfo><historyDataKb>02</historyDataKb><historyDelivDate>2015-07-10</historyDelivDate><historyJigyoCode>031300</historyJigyoCode><historyJigyoName>枝川センター</historyJigyoName><historyStatus>配達完了</historyStatus><historyStatusCode>12</historyStatusCode></historyInfo></historyInfoList><packageInfo><delivDate>2015-07-12</delivDate><delivTimeZone>1618</delivTimeZone><invoiceKb>13</invoiceKb><size></size><status>配達完了</status><statusCode>12</statusCode></packageInfo></statusCooperationOutput></StatusCooperationResponse>'
  end

  let(:xml_failure) do
    '<?xml version="1.0" encoding="UTF-8"?><StatusCooperationResponse><responseHeader><errorInfoList><errorInfo><msg>伝票番号を正しく入力してください。</msg><msgId>ERROR_INVALID_ITEMS</msgId></errorInfo></errorInfoList><rtnCd>2</rtnCd><rtnDatetime>2015-07-10T10:51:16.679+09:00</rtnDatetime></responseHeader><statusCooperationInput><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><denpyoNo>768230001695</denpyoNo><iraiDatetime>2015-07-10T10:50:21.872+09:00</iraiDatetime></statusCooperationInput></StatusCooperationResponse>'
  end

  let(:expected_failure_return_code) { 2 }
  let(:expected_failure_error_infos) do
    [{ message: '伝票番号を正しく入力してください。', message_id: 'ERROR_INVALID_ITEMS' }]
  end

  let(:model) { klass.new }

  it_behaves_like 'base class behavier'

  context 'success' do
    before do
      allow_any_instance_of(klass).to receive(:body).and_return(xml_success)
    end

    describe '#status_code' do
      subject { model.status_code }
      it { should eq 12 }
    end

    describe '#status_name' do
      subject { model.status_name }
      it { should eq '配達完了' }
    end

    describe '#package_size' do
      subject { model.package_size }
      it { should eq 0 }
    end

    describe '#appointed_date' do
      subject { model.appointed_date }
      it { should be_a Date }
      it 'returns date time' do
        expect(subject.to_s).to eq '2015-07-12'
      end
    end

    describe '#appointed_time' do
      subject { model.appointed_time }
      it { should eq '1618' }
    end

    describe '#histories' do
      subject { model.histories }
      it { should be_a Array }
      it 'returns proper type' do
        expect(subject.size).to eq 2
        expect(subject.first).to be_a Nekoposu::Model::Status::History
        expect(subject.first.type).to eq '01'
        expect(subject.first.status_code).to eq '01'
        expect(subject.first.status_name).to eq '発送'
        expect(subject.first.shop_code).to eq '031300'
        expect(subject.first.shop_name).to eq '枝川センター'
        expect(subject.first.date).to be_a Date
        expect(subject.first.date.to_s).to eq '2015-07-10'
      end
    end
  end
end
