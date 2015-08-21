require 'spec_helper'
require_relative 'shared_tests'
describe Nekoposu::Model::ShippingLabel do
  let(:klass) { Nekoposu::Model::ShippingLabel }
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
    '<?xml version="1.0" encoding="UTF-8"?><InvoiceInfoRegistResponse><invoiceInfoRegistInput><anonymityFlg>0</anonymityFlg><baggDesc2>アクセサリー</baggDesc2><baggHandling1></baggHandling1><baggHandling2></baggHandling2><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><delivDate></delivDate><delivTime></delivTime><dstAddress1>東京都</dstAddress1><dstAddress2>江東区豊洲</dstAddress2><dstAddress3>５－４－９</dstAddress3><dstAddress4>ＫＲ豊洲ビル７階</dstAddress4><dstCoNm></dstCoNm><dstDivNm></dstDivNm><dstFirstNm>太郎</dstFirstNm><dstJigyoshoCd></dstJigyoshoCd><dstJigyoshoNm></dstJigyoshoNm><dstKb></dstKb><dstLastNm>日本</dstLastNm><dstMailAddr></dstMailAddr><dstMailFlg></dstMailFlg><dstMailFlgToukan></dstMailFlgToukan><dstMailKb></dstMailKb><dstTel1></dstTel1><dstTel2></dstTel2><dstTel3></dstTel3><dstZipCd>1350061</dstZipCd><invoiceKb>13</invoiceKb><iraiDatetime>2015-07-10T10:38:29.012+09:00</iraiDatetime><payKb>1</payKb><reservePwd>123456</reservePwd><shipDate></shipDate><srcAddress1>神奈川県</srcAddress1><srcAddress2>川崎市中原区新丸子東</srcAddress2><srcAddress3>３－１２００</srcAddress3><srcAddress4>ＫＤＸ武蔵小杉ビル</srcAddress4><srcCoNm></srcCoNm><srcDivNm></srcDivNm><srcFirstNm>次郎</srcFirstNm><srcLastNm>大和</srcLastNm><srcMailAddr></srcMailAddr><srcMailFlg></srcMailFlg><srcMailKb></srcMailKb><srcTel1>090</srcTel1><srcTel2>1234</srcTel2><srcTel3>5678</srcTel3><srcZipCd>2110004</srcZipCd><tradingId>20150701</tradingId></invoiceInfoRegistInput><invoiceInfoRegistOutput><tradingInfo><reserveDt>2015-07-10T10:39:50.000+09:00</reserveDt><reserveLimitDate>2015-08-09T00:00:00.000+09:00</reserveLimitDate><reserveNo>5487630063</reserveNo></tradingInfo></invoiceInfoRegistOutput><responseHeader><rtnCd>0</rtnCd><rtnDatetime>2015-07-10T10:39:51.332+09:00</rtnDatetime></responseHeader></InvoiceInfoRegistResponse>'
  end

  let(:xml_failure) do
    '<?xml version="1.0" encoding="UTF-8"?><InvoiceInfoRegistResponse><invoiceInfoRegistInput><anonymityFlg>0</anonymityFlg><baggDesc2></baggDesc2><baggHandling1></baggHandling1><baggHandling2></baggHandling2><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><delivDate></delivDate><delivTime></delivTime><dstAddress1>東京都</dstAddress1><dstAddress2>江東区豊洲</dstAddress2><dstAddress3>５－４－９</dstAddress3><dstAddress4>ＫＲ豊洲ビル７階</dstAddress4><dstCoNm></dstCoNm><dstDivNm></dstDivNm><dstFirstNm>太郎</dstFirstNm><dstJigyoshoCd></dstJigyoshoCd><dstJigyoshoNm></dstJigyoshoNm><dstKb></dstKb><dstLastNm>日本</dstLastNm><dstMailAddr></dstMailAddr><dstMailFlg></dstMailFlg><dstMailFlgToukan></dstMailFlgToukan><dstMailKb></dstMailKb><dstTel1></dstTel1><dstTel2></dstTel2><dstTel3></dstTel3><dstZipCd>1350061</dstZipCd><invoiceKb>13</invoiceKb><iraiDatetime>2015-07-10T10:38:29.012+09:00</iraiDatetime><payKb>1</payKb><reservePwd>123456</reservePwd><shipDate></shipDate><srcAddress1>神奈川県</srcAddress1><srcAddress2>川崎市中原区新丸子東</srcAddress2><srcAddress3>３－１２００</srcAddress3><srcAddress4>ＫＤＸ武蔵小杉ビル</srcAddress4><srcCoNm></srcCoNm><srcDivNm></srcDivNm><srcFirstNm>次郎</srcFirstNm><srcLastNm>大和</srcLastNm><srcMailAddr></srcMailAddr><srcMailFlg></srcMailFlg><srcMailKb></srcMailKb><srcTel1>090</srcTel1><srcTel2>1234</srcTel2><srcTel3>5678</srcTel3><srcZipCd>2110004</srcZipCd><tradingId>20150701</tradingId></invoiceInfoRegistInput><responseHeader><errorInfoList><errorInfo><msg>品名を指定してください。</msg><msgId>ERROR_REQUIRED</msgId></errorInfo></errorInfoList><rtnCd>2</rtnCd><rtnDatetime>2015-07-10T10:40:16.600+09:00</rtnDatetime></responseHeader></InvoiceInfoRegistResponse>'
  end

  let(:expected_failure_return_code) { 2 }
  let(:expected_failure_error_infos) do
    [{ message: '品名を指定してください。', message_id: 'ERROR_REQUIRED' }]
  end

  let(:model) { klass.new }

  it_behaves_like 'base class behavier'

  context 'success' do
    before do
      allow_any_instance_of(klass).to receive(:body).and_return(xml_success)
    end

    # todo

  end

  describe '#destination_telephone_number=' do
    subject { model.destination_telephone_number = number }
    context 'input propery' do
      context 'just 10 digits' do
        let(:number) { '0123456789' }
        it { should eq number }
      end

      context 'over 10 digits' do
        let(:number) { '123456789010' }
        it { should eq number }
      end
    end

    context 'input not propery' do
      let(:number) { '456789' }
      subject { model.destination_telephone_number = number }
      it 'raise an exception' do
        expect { subject }.to raise_error(
          RuntimeError,
          'destination_telephone_number should be over 10 digits number string'
        )
      end
    end
  end

  describe '#destination_telephone_number3' do
    let(:number) { '0123456789' }
    before { model.destination_telephone_number = number }
    subject { model.send(:destination_telephone_number3) }
    it { should eq '6789' }
  end

  describe '#destination_telephone_number2' do
    let(:number) { '0123456789' }
    before { model.destination_telephone_number = number }
    subject { model.send(:destination_telephone_number2) }
    it { should eq '2345' }
  end

  describe '#destination_telephone_number1' do
    let(:number) { '0123456789' }
    before { model.destination_telephone_number = number }
    subject { model.send(:destination_telephone_number1) }
    it { should eq '01' }
  end

  describe '#source_telephone_number=' do
    subject { model.source_telephone_number = number }
    context 'input propery' do
      context 'just 10 digits' do
        let(:number) { '0123456789' }
        it { should eq number }
      end

      context 'over 10 digits' do
        let(:number) { '123456789010' }
        it { should eq number }
      end
    end

    context 'input not propery' do
      let(:number) { '456789' }
      subject { model.source_telephone_number = number }
      it 'raise an exception' do
        expect { subject }.to raise_error(
          RuntimeError,
          'source_telephone_number should be over 10 digits number string'
        )
      end
    end
  end

  describe '#source_telephone_number3' do
    let(:number) { '0123456789' }
    before { model.source_telephone_number = number }
    subject { model.send(:source_telephone_number3) }
    it { should eq '6789' }
  end

  describe '#source_telephone_number2' do
    let(:number) { '0123456789' }
    before { model.source_telephone_number = number }
    subject { model.send(:source_telephone_number2) }
    it { should eq '2345' }
  end

  describe '#source_telephone_number1' do
    let(:number) { '0123456789' }
    before { model.source_telephone_number = number }
    subject { model.send(:source_telephone_number1) }
    it { should eq '01' }
  end

  describe '#destination_zipcode=' do
    subject { model.destination_zipcode = zipcode }
    context 'proper zipcode' do
      context 'just 7 digits' do
        let(:zipcode) { '1234567' }
        it { should eq zipcode }
      end
    end

    context 'input not propery' do
      let(:zipcode) { '123456' }
      it 'raise an exception' do
        expect { subject }.to raise_error(
          RuntimeError,
          'destination_zipcode should be 7 digits number string'
        )
      end
    end
  end

  describe '#source_zipcode=' do
    subject { model.source_zipcode = zipcode }
    context 'proper zipcode' do
      context 'just 7 digits' do
        let(:zipcode) { '1234567' }
        it { should eq zipcode }
      end
    end

    context 'input not propery' do
      let(:zipcode) { '123456' }
      it 'raise an exception' do
        expect { subject }.to raise_error(
          RuntimeError,
          'source_zipcode should be 7 digits number string'
        )
      end
    end
  end

  describe '#baggage_handling1' do
    subject { model.baggage_handling1 = handling_sym }

    context '精密機器' do
      let(:handling_sym) { :precision }
      it 'returns 01' do
        expect(subject).to eq :precision
        expect(model.baggage_handling1).to eq '01'
      end
    end

    context '壊れ物' do
      let(:handling_sym) { :fragile }
      it 'returns 02' do
        expect(subject).to eq :fragile
        expect(model.baggage_handling1).to eq '02'
      end
    end

    context '上積禁止' do
      let(:handling_sym) { :do_not_stack }
      it 'returns 03' do
        expect(subject).to eq :do_not_stack
        expect(model.baggage_handling1).to eq '03'
      end
    end

    context '天地無用' do
      let(:handling_sym) { :do_not_turn_upside_down }
      it 'returns 04' do
        expect(subject).to eq :do_not_turn_upside_down
        expect(model.baggage_handling1).to eq '04'
      end
    end

    context 'ナマモノ' do
      let(:handling_sym) { :perishable }
      it 'returns 05' do
        expect(subject).to eq :perishable
        expect(model.baggage_handling1).to eq '05'
      end
    end

    context 'no acceptable' do
      let(:handling_sym) { 1 }
      it 'returns nil' do
        expect(subject).to eq 1
        expect(model.baggage_handling1).to be_nil
      end
    end
  end

  describe '#baggage_handling2' do
    subject { model.baggage_handling2 = handling_sym }

    context '精密機器' do
      let(:handling_sym) { :precision }
      it 'returns 01' do
        expect(subject).to eq :precision
        expect(model.baggage_handling2).to eq '01'
      end
    end

    context '壊れ物' do
      let(:handling_sym) { :fragile }
      it 'returns 02' do
        expect(subject).to eq :fragile
        expect(model.baggage_handling2).to eq '02'
      end
    end

    context '上積禁止' do
      let(:handling_sym) { :do_not_stack }
      it 'returns 03' do
        expect(subject).to eq :do_not_stack
        expect(model.baggage_handling2).to eq '03'
      end
    end

    context '天地無用' do
      let(:handling_sym) { :do_not_turn_upside_down }
      it 'returns 04' do
        expect(subject).to eq :do_not_turn_upside_down
        expect(model.baggage_handling2).to eq '04'
      end
    end

    context 'ナマモノ' do
      let(:handling_sym) { :perishable }
      it 'returns 05' do
        expect(subject).to eq :perishable
        expect(model.baggage_handling2).to eq '05'
      end
    end

    context 'no acceptable' do
      let(:handling_sym) { 1 }
      it 'returns nil' do
        expect(subject).to eq 1
        expect(model.baggage_handling2).to be_nil
      end
    end
  end

  describe 'ship_date' do
    subject { model.ship_date = date }
    context 'input date type' do
      let(:date) { Date.parse('2015-07-30') }
      it 'returns string' do
        expect(subject).to eq date
        expect(model.ship_date).to eq '2015-07-30'
      end
    end

    context 'input not date type' do
      let(:date) { '2015-07-30' }
      it 'returns string' do
        expect { subject }.to raise_error(RuntimeError, 'ship_date should be Date instance')
      end
    end
  end
end
