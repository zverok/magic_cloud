# encoding: utf-8
describe MagicCloud::Word do
  describe '#initalize' do
    let(:options){
      {text: 'Test', color: 'red', font_size: 12, font_family: 'Impact', rotate: 90}
    }

    subject{described_class.new(options)}

    it 'should be set up' do
      options.each do |key, val|
        expect(subject.send(key)).to eq val
      end
    end

    context 'default values' do
      let(:options){ {text: 'Test', font_size: 12} }

      its(:font_family){should == described_class::DEFAULT_FONT_FAMILY}
      its(:color){should be_one_of(described_class::DEFAULT_PALETTE)}
      its(:rotate){should be_one_of(described_class::DEFAULT_ANGLES)}
    end
  end

  describe '#draw' do
  end

  describe '#measure' do
  end
end
