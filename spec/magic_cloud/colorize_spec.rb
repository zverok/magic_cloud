# encoding: utf-8
describe MagicCloud::Colorize do
  let(:source){
    100.times.map{
      {text: Faker::Lorem.word, font_size: rand(200)}
    }
  }

  describe 'existing palette' do
    let(:result){described_class.palette(source, :category20)}
    subject{result.map{|h| h[:color]}}

    it{should all(be_one_of(MagicCloud::PALETTES[:category20]))}

    context 'when palette unknown' do
      specify{
        expect{described_class.palette(source, :wtf)}.to raise_error
      }
    end
  end


  describe 'custom palette' do
    let(:result){described_class.palette(source, ['red', 'green', 'blue'])}
    subject{result.map{|h| h[:color]}}

    it{should all(be_one_of(['red', 'green', 'blue']))}
  end
end
