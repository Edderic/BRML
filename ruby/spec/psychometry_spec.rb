require 'spec_helper'

describe Psychometry do
  describe 'when there are five pairs to be matched' do
    describe '#absolute_frequencies_of_matches' do
      it 'should return an array of absolute frequencies' do
        # 0 matches occurs 44 times, 1 match occurs 45 times, etc.
        psychometry = Psychometry.new

        abs_freq = [44, 45, 20, 10, 0, 1]
        expect(psychometry.absolute_frequencies_of_matches).to eq abs_freq
      end
    end

    describe '#permutations' do
      before {@psychometry = Psychometry.new}

      it 'should include ABCDE, EBACD' do
        expect( @psychometry.permutations).
          to include(['A', 'B', 'C', 'D', 'E'])
        expect( @psychometry.permutations).
          to include(['E', 'B', 'A', 'C', 'D'])
      end

      it 'should not include AAAAA' do
        expect( @psychometry.permutations).
          not_to include(['A', 'A', 'A', 'A', 'A'])
      end
    end
  end
end

