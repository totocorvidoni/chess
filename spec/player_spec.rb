require 'player'

describe Player do
  subject(:player) { Player.new('Pupe', 'white') }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:color) }
  it { is_expected.to respond_to(:pieces) }
end