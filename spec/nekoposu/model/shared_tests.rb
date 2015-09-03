require 'spec_helper'
shared_examples_for 'base class behavier' do
  describe '#auth_cd' do
    subject do
      Timecop.freeze(Date.today - 30) do
        model.auth_cd
      end
    end
    it 'returns auth_cd, all instances return same value' do
      expect(subject).to eq model.auth_cd
      expect(subject).not_to eq Nekoposu::Model::Status.new.auth_cd
    end
  end

  describe '#auth_key' do
    subject do
      Timecop.freeze(Date.today - 30) do
        model.auth_key
      end
    end
    it 'returns auth_key, all instances return same value' do
      expect(subject).to eq model.auth_key
      expect(subject).not_to eq Nekoposu::Model::Status.new.auth_key
    end
  end

  describe '#request_datetime' do
    subject do
      Timecop.freeze(Time.parse('2015-07-22 12:33:17 +0900')) do
        model.request_datetime
      end
    end
    it { should eq '2015-07-22T12:33:17.000+09:00' }
  end


  context 'success' do
    before do
      allow_any_instance_of(klass).to receive(:body).and_return(xml_success)
    end
    describe '#return_code' do
      subject { model.return_code }
      it { should eq 0 }
    end

    describe '#error_infos' do
      subject { model.error_infos }
      it { should eq [] }
    end

    describe '#error?' do
      subject { model.error? }
      it { should eq false }
    end
  end

  context 'failure' do
    before do
      allow_any_instance_of(klass).to receive(:body).and_return(xml_failure)
    end
    describe '#return_code' do
      subject { model.return_code }
      it { should eq expected_failure_return_code }
    end

    describe '#error_infos' do
      subject { model.error_infos }
      it { should eq expected_failure_error_infos }
    end

    describe '#error?' do
      subject { model.error? }
      it { should eq true }
    end
  end
end
