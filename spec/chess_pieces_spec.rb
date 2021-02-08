require "./chess_pieces"

describe ChessPiece do
  before do 
    @node = double("BoardNode")
    allow(@node).to receive(:data) {[7, 1]}
    @piece = ChessPiece.new("X", @node)
  end

  describe "self" do
    it "prints its icon and start position" do
      allow($stdout).to receive(:write)
      expect(@piece.self).to eql("X\n[7, 1]")
    end
  end
end

describe WhitePawn do
  before do 
    @node = double("BoardNode")
    allow(@node).to receive(:data) {[7, 1]}
    @w_pawn = WhitePawn.new("p", @node)
  end

  describe "#self" do
    it "prints its icon and start position" do
      allow($stdout).to receive(:write)
      expect(@w_pawn.self).to eql("p\n[7, 1]")
    end
  end

  describe "@move_set" do
    it "shows possible moves from start position" do
      expect(@w_pawn.move_set).to eql([[5, 1], [6, 1]])
    end 
  end

  describe "@attack_set" do
    it "shows possibe moves to attack" do
      expect(@w_pawn.attack_set).to eql([[6, 0], [6, 2]])
    end
  end

end