require 'player'

describe Player do
  subject(:player) { Player.new('Pupe') }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:pieces) }
end