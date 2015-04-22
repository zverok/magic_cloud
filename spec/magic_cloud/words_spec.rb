# encoding: utf-8
describe MagicCloud::Words do
  let(:source){
    10.times.map{
      {text: Faker::Lorem.word, font_size: rand(200)}
    }
  }

  describe '#initialize' do
    subject{described_class.new(source)}

    it{should be_kind_of(Array)}
    it{should be_a(MagicCloud::Words)}
    its(:size){should == source.size}

    context 'from array of arrays' do
      let(:source){
        10.times.map{
          [Faker::Lorem.word, rand(200)]
        }
      }

      it{should all(be_a(Hash))}
    end
  end

  let(:words){described_class.new(source)}

  describe '#colorize' do
    subject{words.colorize(:category20)}

    it{should all(have_key(:color))}
  end

  describe '#rotate' do
    subject{words.rotate(:square)}

    it{should all(have_key(:rotate))}
  end

  describe '#scale' do
    subject{words.scale(:log, 10, 100)}

    # FIXME: really, really dumb check
    it{should all(have_key(:font_size))}
  end

  describe '#to_cloud' do
    subject{words.to_cloud}

    it{should be_a(MagicCloud::Cloud)}
  end
end
