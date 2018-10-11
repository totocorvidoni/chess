require 'player'
require 'pieces'

describe Player do
  subject(:player) { Player.new('Pupe') }
  
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:pieces) }

  describe '#king_position' do
    context 'when king is [0, 4]' do
      before { player.pieces << King.new('king', [0, 4]) }

      it 'returns [0, 4]' do
        expect(player.king_site).to eq([0, 4])      
      end
    end
  end
end