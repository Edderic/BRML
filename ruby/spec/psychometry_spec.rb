require 'spec_helper'

describe Psychometry do
  describe 'when there are three items' do
    describe '#prob_at_least_one_match' do
      it 'should return 3' do
      end
    end

    describe '#num_expected_matches' do
      it 'should return an array of absolute frequencies' do
        # p(match|ABC) = 1
        # p(match|ACB) = 1/3
        # p(match|BAC) = 1/3
        # p(match|BCA) = 0
        # p(match|CAB) = 0
        # p(match|CBA) = 1/3
        #
        # p(ABC) = p(ACB) = p(BAC) = p(BCA) = p(CAB) = p(CBA) = 1/6
        # p(match,ABC) = 1/6
        # p(match,ACB) = 1/18
        # p(match,BAC) = 1/18
        # p(match,BCA) = 0
        # p(match,CAB) = 0
        # p(match,CBA) = 1/18

        # ABC
        #
        # ABC,3
        # ACB,1
        # BAC,1
        # BCA,0
        # CAB,0
        # CBA,1
        psychometry = Psychometry.new(3)

        expect(psychometry.num_expected_matches).to eq [2, 3, 0, 1]
      end
    end
  end
end

