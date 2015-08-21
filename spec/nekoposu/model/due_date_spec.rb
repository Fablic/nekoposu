require 'spec_helper'
require_relative 'shared_tests'
describe Nekoposu::Model::DueDate do
  let(:klass) { Nekoposu::Model::DueDate }
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
    '<?xml version="1.0" encoding="UTF-8"?><ServiceLevelResponse><responseHeader><rtnCd>0</rtnCd><rtnDatetime>2015-07-10T10:31:51.547+09:00</rtnDatetime></responseHeader><serviceLevelInput><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><dstZipCd>1810013</dstZipCd><iraiDatetime>2015-07-10T10:31:23.246+09:00</iraiDatetime><shipDate>2015-07-10</shipDate><srcZipCd>3702101</srcZipCd></serviceLevelInput><serviceLevelOutput><serviceLevel><delivDate>2015-02-23</delivDate><delivTime>2</delivTime></serviceLevel></serviceLevelOutput></ServiceLevelResponse>'
  end

  let(:xml_failure) do
    '<?xml version="1.0" encoding="UTF-8"?><ServiceLevelResponse><responseHeader><errorInfoList><errorInfo><msg>お届け先郵便番号を指定してください。</msg><msgId>ERROR_REQUIRED</msgId></errorInfo></errorInfoList><rtnCd>2</rtnCd><rtnDatetime>2015-07-10T10:32:57.241+09:00</rtnDatetime></responseHeader><serviceLevelInput><clientIp>192.168.100.100</clientIp><companyId>testCom</companyId><dstZipCd></dstZipCd><iraiDatetime>2015-07-10T10:31:23.246+09:00</iraiDatetime><shipDate>2015-07-10</shipDate><srcZipCd>3702101</srcZipCd></serviceLevelInput></ServiceLevelResponse>'
  end

  let(:expected_failure_return_code) { 2 }
  let(:expected_failure_error_infos) do
    [{ message: 'お届け先郵便番号を指定してください。', message_id: 'ERROR_REQUIRED' }]
  end

  let(:model) { klass.new }

  it_behaves_like 'base class behavier'

  context 'success' do
    before do
      allow_any_instance_of(klass).to receive(:body).and_return(xml_success)
    end

    describe '#delivery_time' do
      subject { model.delivery_time }
      it { should eq 2 }
    end

    describe '#delivery_time_text' do
      subject { model.delivery_time_text }
      it { should eq '12時〜14時' }
    end

    describe '#delivery_time_from' do
      subject { model.delivery_time_from }

      context 'relivery_time returns nil' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(nil)
        end
        it { should eq nil }
      end

      context 'relivery_time returns 1' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(1)
        end
        it { should eq 8 }
      end

      context 'relivery_time returns 2' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(2)
        end
        it { should eq 12 }
      end

      context 'relivery_time returns 3' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(3)
        end
        it { should eq 14 }
      end

      context 'relivery_time returns 4' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(4)
        end
        it { should eq 16 }
      end

      context 'relivery_time returns 5' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(5)
        end
        it { should eq 18 }
      end

      context 'relivery_time returns 6' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(6)
        end
        it { should eq 20 }
      end

      context 'relivery_time returns 7(over limit)' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(7)
        end
        it { should eq nil }
      end
    end

    describe '#delivery_time_to' do
      subject { model.delivery_time_to }

      context 'relivery_time returns nil' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(nil)
        end
        it { should eq nil }
      end

      context 'relivery_time returns 1' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(1)
        end
        it { should eq 12 }
      end

      context 'relivery_time returns 2' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(2)
        end
        it { should eq 14 }
      end

      context 'relivery_time returns 3' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(3)
        end
        it { should eq 16 }
      end

      context 'relivery_time returns 4' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(4)
        end
        it { should eq 18 }
      end

      context 'relivery_time returns 5' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(5)
        end
        it { should eq 20 }
      end

      context 'relivery_time returns 6' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(6)
        end
        it { should eq 21 }
      end

      context 'relivery_time returns 7(over limit)' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(7)
        end
        it { should eq nil }
      end
    end

    describe '#delivery_time_text' do
      subject { model.delivery_time_text }

      context 'relivery_time returns nil' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(nil)
        end
        it { should eq nil }
      end

      context 'relivery_time returns 0' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(0)
        end
        it { should eq '指定不能' }
      end


      context 'relivery_time returns 1' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(1)
        end
        it { should eq '午前中' }
      end

      context 'relivery_time returns 2' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(2)
        end
        it { should eq '12時〜14時' }
      end

      context 'relivery_time returns 3' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(3)
        end
        it { should eq '14時〜16時' }
      end

      context 'relivery_time returns 4' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(4)
        end
        it { should eq '16時〜18時' }
      end

      context 'relivery_time returns 5' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(5)
        end
        it { should eq '18時〜20時' }
      end

      context 'relivery_time returns 6' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(6)
        end
        it { should eq '20時〜21時' }
      end

      context 'relivery_time returns 7(over limit)' do
        before do
          allow_any_instance_of(klass).to receive(:delivery_time).and_return(7)
        end
        it { should eq nil }
      end
    end

    describe '#delivery_date' do
      subject { model.delivery_date }
      context 'normal' do
        it { should be_an_instance_of Date }
      end

      context 'nil' do
        before do
          allow_any_instance_of(klass).to receive(:content).and_return(nil)
        end
        it { should be_nil }
      end
    end

    describe '#ship_date' do
      subject { model.ship_date = obj }

      context 'assign date' do
        let(:obj) { Date.parse('2015-07-28') }
        it 'returns Date instance and return string' do
          expect(subject).to be_instance_of Date
          expect(model.ship_date).to eq '2015-07-28'
        end
      end

      context 'assign not date' do
        let(:obj) { '2015-07-28' }
        it 'raise exception' do
          expect { subject }.to raise_error(RuntimeError, 'ship_date should be Date instance')
        end
      end
    end

    describe '#source_zipcode' do
      subject { model.source_zipcode = obj }

      context 'assign 7 digits' do
        let(:obj) { '1234567' }
        it 'returns 7digits number string' do
          expect(subject).to match(/\d{7}/)
          expect(subject.size).to eq 7
          expect(subject).to eq '1234567'
          expect(model.source_zipcode).to eq '1234567'
        end
      end

      context 'assign not 7 digits' do
        let(:obj) { '12345678' }
        it 'raise exception' do
          expect { subject }.to raise_error(RuntimeError, 'source_zipcode should be 7 digits')
        end
      end
    end

    describe '#destination_zipcode' do
      subject { model.destination_zipcode = obj }

      context 'assign 7 digits' do
        let(:obj) { '1234567' }
        it 'returns 7digits number string' do
          expect(subject).to match(/\d{7}/)
          expect(subject.size).to eq 7
          expect(subject).to eq '1234567'
          expect(model.destination_zipcode).to eq '1234567'
        end
      end

      context 'assign not 7 digits' do
        let(:obj) { '12345678' }
        it 'raise exception' do
          expect { subject }.to raise_error(RuntimeError, 'destination_zipcode should be 7 digits')
        end
      end
    end
  end
end
