# encoding: utf-8
describe MagicCloud::Scale do
  let(:source){
    10.times.map{
      {text: Faker::Lorem.word, font_size: rand(200)}
    }
  }
  let(:min){10}
  let(:max){100}

  
  shared_context 'scaler checker' do
    let(:result){described_class.send(method, source, min, max)}

    describe 'result range' do
      subject{result.map{|h| h[:font_size]}}
      its(:min){should == min}
      its(:max){should == max}
      it{should all( be_covered_with(min..max) )}
    end

    describe 'result order' do
      let(:sorted_source){source.sort_by{|h| h[:font_size]}}
      let(:sorted_result){result.sort_by{|h| h[:font_size]}}

      specify 'order should be preserved' do
        expect(sorted_source.map{|h| h[:text]}).to eq \
          sorted_result.map{|h| h[:text]}
      end
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

  describe '#log' do
    let(:method){:log}

    include_context 'scaler checker'
  end

  describe '#linear' do
    let(:method){:linear}

    include_context 'scaler checker'
  end
  
  describe '#sqrt' do
    let(:method){:sqrt}

    include_context 'scaler checker'
  end

  describe '#custom' do
    include_context 'scaler checker'

    let(:result){described_class.custom(source, min, max){|x| x**2}}
  end
  
end
