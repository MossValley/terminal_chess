require "./chess_pieces"

describe ChessPiece do
  let(:piece) { ChessPiece.new("X", "7,1") }

  describe "self" do
    it "prints its icon and start position" do
      allow($stdout).to receive(:write)
      expect(piece.self).to eql("X\n7,1")
    end
  end
end

describe Pawn do
  let(:pawn) { Pawn.new }

  describe "#self" do
    it "prints its icon and start position" do
      allow($stdout).to receive(:write)
      expect(pawn.self).to eql("p\n[7, 1]")
    end
  end

  describe "@move_set" do
    it "shows possible moves from start position" do
      expect(pawn.move_set).to eql([[5, 1], [6, 1]])
    end 
  end

  describe "@attack_set" do
    it "shows possibe moves to attack" do
      expect(pawn.attack_set).to eql([[6, 0], [6, 2]])
    end
  end

end