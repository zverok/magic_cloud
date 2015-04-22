# encoding: utf-8
describe MagicCloud::Cloud do
  describe '#initialize' do
    context 'with array of hashes' do
      let(:words){
        [
          {text: 'me', font_size: 10},
          {text: 'Test', font_size: 12},
        ]
      }
      
      let(:cloud){described_class.new(words)}

      describe 'instantiated words' do
        subject{cloud.words}

        its(:size){should == 2}
        it{should all(be_an(MagicCloud::Word))}

        it 'should sort words descending' do
          expect(subject.map(&:text)).to eq ['Test', 'me']
          expect(subject.map(&:font_size)).to eq  [12, 10]
        end
      end
    end

    context 'with array of arrays' do
      let(:words){
        [
          ['me', 10],
          ['Test', 12],
        ]
      }
      
      let(:cloud){described_class.new(words)}

      describe 'instantiated words' do
        subject{cloud.words}

        it 'should be processed like [word, size] pairs' do
          expect(subject.map(&:text)).to eq ['Test', 'me']
          expect(subject.map(&:font_size)).to eq  [12, 10]
        end
      end
    end
  end
end
