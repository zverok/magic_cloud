# encoding: utf-8
describe MagicCloud::Rotate do
  let(:source){
    10.times.map{
      {text: Faker::Lorem.word, font_size: rand(200)}
    }
  }

  shared_context 'rotate checker' do
    let(:result){described_class.send(method, source)}

    describe 'result range' do
      subject{result.map{|h| h[:rotate]}}
      it{should all(be >= -180)}
      it{should all(be <= 180)}

      it{should all(be_one_of(accepted))}
    end
    
    context 'when array of arrays' do
      let(:source){
        10.times.map{
          [Faker::Lorem.word, rand(200)]
        }
      }
      subject{result}

      it{should all( be_a(Hash) )}
    end
  end

  describe '#none' do
    let(:method){:none}
    let(:accepted){[0]}

    include_context 'rotate checker'
  end

  describe '#square' do
    let(:method){:square}
    let(:accepted){[-90, 0, 90]}

    include_context 'rotate checker'
  end

  describe '#free' do
    let(:method){:free}
    let(:accepted){(-180..180)}

    include_context 'rotate checker'
  end

  describe '#arbitrary' do
    let(:accepted){[5, 10, 15, 20, 25, 30]}

    include_context 'rotate checker'

    let(:result){described_class.arbitrary(source, *accepted)}
  end

  describe '#angles' do
    let(:from){-60}
    let(:to){60}
    let(:count){5}
    subject{described_class.angles(from, to, count)}
    it{should == [-60, -30, 0, 30, 60]}
  end
end
