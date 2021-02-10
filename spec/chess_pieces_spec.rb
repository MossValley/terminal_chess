require "./chess_pieces"

describe ChessPiece do
  let(:board_node) {
  @initial_node = double("BoardNode")
  allow(@initial_node).to receive_messages(:data => @i_data, 
    :is_occupied => @i_occupied)
  }

  before do 
    @i_data = [7, 1]
    @icon = "X"
    board_node
    @piece = ChessPiece.new(@icon, @initial_node)
  end

  describe "self_description" do
    it "prints its icon and start position" do
      expect(@piece.self_description).to eql("#{@icon}\n#{@i_data}")
    end
  end
end

describe WhitePawn do
  let(:board_node) {
  @initial_node = double("BoardNode1")
  allow(@initial_node).to receive_messages(:data => @i_data, 
    :is_occupied => @i_occupied,
    :update_piece => true)
  }

  before do 
    @i_data = [7, 1]
    @icon = "p"
    board_node
    @w_pawn = WhitePawn.new(@icon, @initial_node)
  end

  describe "#self_description" do
    it "prints its icon and start position" do
      expect(@w_pawn.self_description).to eql("#{@icon}\n#{@i_data}")
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
  let(:node1) {
    @init_node = double("BoardNode1") #initilal_node
    allow(@init_node).to receive_messages(:data => @i_data, 
      :is_occupied => @i_occupied,
      :update_piece => nil)
    }
  let(:node2) {
    @dest_node = double("BoardNode2") #destination_node
    allow(@dest_node).to receive_messages(:data => @d_data, 
      :is_occupied => @d_occupied,
      :update_piece => nil)
  }
  
    before do 
      @i_data = [7, 1]
      @icon = "r"
      node1
      @rook = Rook.new(@icon, @init_node)
    end

  describe "#move_this_piece" do
    let(:move_rook) { 
      @d_occupied = false
      node2
      allow(@init_node).to receive(:up) { @dest_node }
      @rook.move_this_piece(@dest_node)
    }
    
    context "when given a location it can move to" do
      it "should move update the rook's location" do
        @d_data = [2, 1]
        move_rook

        expect(@rook.current_node).to eql(@dest_node)
      end
    end

    context "when given a location it cannot move to" do
      it "doesn't update the rook's location" do
        @d_data = [3, 2]
        move_rook

        expect(@rook.move_this_piece(@dest_node)).to eql('Move not valid')
        expect(@rook.current_node).to eql(@init_node)
      end
    end

    context "when given it's current location" do
      it "returns error message" do
        @d_data = [7, 1]
        move_rook
        
        expect(@rook.move_this_piece(@dest_node)).to eql('Rook is at this location')
      end
    end
  end

end