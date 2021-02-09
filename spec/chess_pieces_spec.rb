require "./chess_pieces"

describe ChessPiece do
  before do 
    @node = double("BoardNode")
    allow(@node).to receive(:data) { [7, 1] }
    @piece = ChessPiece.new("X", @node)
  end

  describe "self_description" do
    it "prints its icon and start position" do
      expect(@piece.self_description).to eql("X\n[7, 1]")
    end
  end
end

describe WhitePawn do
  before do 
    @node = double("BoardNode")
    allow(@node).to receive(:data) { [7, 1] }
    @w_pawn = WhitePawn.new("p", @node)
  end

  describe "#self_description" do
    it "prints its icon and start position" do
      expect(@w_pawn.self_description).to eql("p\n[7, 1]")
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

describe Rook do
  before do 
    @node = double("BoardNode")
    allow(@node).to receive(:data) { [8, 1] }
    @rook = Rook.new("r", @node)
  end

  describe "@moveset" do 
    it "should only mention upward and right movements" do
      node_x = @node.data[0]
      node_y = @node.data[-1]
      range = (1..7).to_a

      rook_moves = []
      range.each { |i| rook_moves << [node_x -i, node_y] }
      range.each { |i| rook_moves << [node_x, node_y+i] }

      expect(@rook.move_set).to eql(rook_moves)
    end

    it "should include [2, 1]" do
      expect(@rook.move_set.include?([2, 1])).to eq(true)
    end
  end

  describe "#move_this_piece" do
    let(:rook_move) { 
      @node2 = double("BoardNode") 
      allow(@node2).to receive(:is_occupied) { false }
      allow(@node2).to receive(:update_piece) { true }
      allow(@node2).to receive(:data) { @node_data } 
      @rook.move_this_piece(@node2)
    }
    
    context "when given a location it can move to" do
      it "should move update the rook's location" do
        @node_data = [2, 1]
        rook_move

        expect(@rook.current_node).to eql(@node2)
      end
    end

    context "when given a location it cannot move to" do
      it "doesn't update the rook's location" do
        @node_data = [3, 2]
        rook_move

        expect(@rook.move_this_piece(@node2)).to eql('Move not valid')
        expect(@rook.current_node).to eql(@node)
      end
    end
  end

end