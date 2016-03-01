require 'spec_helper'
require_relative 'shared_tests'
describe Nekoposu::Model::QrCode do
  subject { obj.send(:params) }
  let(:klass) { Nekoposu::Model::QrCode }
  let!(:obj) { klass.new }

  context '@paramsがnilでない時' do
    let(:params) { { tradingId: '1234', qrcodeType: '01' } }

    before do
      obj.qrcode_type = :famiport
      obj.instance_variable_set('@params', params)
    end

    it '@paramsに変更を加えない' do
      expect(subject).to eq params
    end
  end

  context '@paramsがnilでcompany_idまたはtrading_idがnilの時' do
    before do
      obj.qrcode_type = :famiport
    end

    it 'RuntimeErrorを投げる。' do
      expect{ subject }.to raise_error(RuntimeError)
    end
  end

  context '@paramsがnilでcompany_id,trading_idがnilでない時' do
    let(:result) { { tradingId: '1234', qrcodeType: '01' } }

    before do
      allow_any_instance_of(Nekoposu::Model::QrCode).to receive(:company_id).and_return('5678')
      obj.qrcode_type = :famiport
      obj.trading_id =  '1234'
    end

    it '@paramsを作って返す' do
      expect(subject).to eq result
    end
  end
end
