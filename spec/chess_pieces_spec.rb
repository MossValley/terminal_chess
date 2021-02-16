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
  let(:node1) {
    @init_node = double("BoardNode1") #initilal_node
    allow(@init_node).to receive_messages(:data => @i_data, 
      :is_occupied => true,
      :update_node => nil)
    }
  let(:node2) {
    @mid_node = double("BoardNode2") #intermediate_node
    allow(@mid_node).to receive_messages(:data => @m_data, 
      :is_occupied => @m_occupied,
      :update_node => nil)
  }
  let(:node3) {
    @dest_node = double("BoardNode3") #destination_node
    allow(@dest_node).to receive_messages(:data => @d_data, 
      :is_occupied => @d_occupied,
      :update_node => nil)
  }
  
  before do 
    @i_data = [7, 1]
    @icon = "r"
    node1
    @w_pawn = WhitePawn.new(@icon, @init_node)
  end

  describe "#self_description" do
    it "prints its icon and start position" do
      expect(@w_pawn.self_description).to eql("#{@icon}\n#{@i_data}")
    end
  end

  describe "#move_this_piece" do
    let(:move_pawn) { 
        node2
        node3
        allow(@init_node).to receive(:up) { @mid_node }
        allow(@mid_node).to receive(:up) { @dest_node }
      }
    let(:path_empty) {
      @m_occupied = false
      @d_occupied = false
    }
    let(:path_blocked) {
      @m_occupied = true
      @d_occupied = false
    }
    let(:enemy_block) {
      @m_occupied = true
      allow(@init_node).to receive(:up_r) {@mid_node}
    }

    context "when given one space ahead" do
      it "should move the pawn up one space" do
        @m_data = [6, 1]
        path_empty
        move_pawn
        @w_pawn.move_this_piece(@mid_node)

        expect(@w_pawn.current_node).to eql(@mid_node)
      end
    end

    context "when given two spaces ahead" do
      it "should move the pawn two places" do
        @m_data = [6, 1]
        @d_data = [5, 1]
        path_empty
        move_pawn
        @w_pawn.move_this_piece(@dest_node)

        expect(@w_pawn.current_node).to eql(@dest_node)
      end
    end

    context "when given three spaces ahead" do
      it "should not move" do
        @d_data = [4, 1]
        path_empty
        move_pawn
        @w_pawn.move_this_piece(@dest_node)

        expect(@w_pawn.current_node).to eql(@init_node)
      end
    end

    context "when given two spaces ahead but path is blocked" do
      it "should not move" do
        @m_data = [6, 1]
        @d_data = [5, 1]
        path_blocked
        move_pawn
        @w_pawn.move_this_piece(@dest_node)

        expect(@w_pawn.current_node).to eql(@init_node)
      end
    end

    context "when told to attack enemy up-right of it" do
      it "should attack enemy" do
        @m_data = [6, 2]
        enemy_block
        move_pawn

        @enemy = WhitePawn.new("e", @mid_node, false)
        allow(@mid_node).to receive(:piece) { @enemy }
        @w_pawn.move_this_piece(@mid_node)

        expect(@w_pawn.current_node).to eql(@mid_node)
      end
    end
  end
end

describe Rook do
  let(:node1) {
    @init_node = double("BoardNode1") #initilal_node
    allow(@init_node).to receive_messages(:data => @i_data, 
      :is_occupied => @i_occupied,
      :update_node => nil)
    }
  let(:node2) {
    @dest_node = double("BoardNode2") #destination_node
    allow(@dest_node).to receive_messages(:data => @d_data, 
      :is_occupied => @d_occupied,
      :update_node => nil)
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
        @d_data = [6, 1]
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

describe Bishop do
  let(:node1) {
    @init_node = double("BoardNode1") #initilal_node
    allow(@init_node).to receive_messages(:data => @i_data, 
      :is_occupied => @i_occupied,
      :update_node => nil)
    }
  let(:node2) {
    @dest_node = double("BoardNode2") #destination_node
    allow(@dest_node).to receive_messages(:data => @d_data, 
      :is_occupied => @d_occupied,
      :update_node => nil)
  }
  
    before do 
      @i_data = [7, 1]
      @icon = "b"
      node1
      @bishop = Bishop.new(@icon, @init_node)
    end

  describe "#move_this_piece" do
    let(:move_bishop) { 
      @d_occupied = false
      node2
      allow(@init_node).to receive(:up_r) { @dest_node }
      @bishop.move_this_piece(@dest_node)
    }
    
    context "when given a location it can move to" do
      it "should move update the bishop's location" do
        @d_data = [6, 2]
        move_bishop

        expect(@bishop.current_node).to eql(@dest_node)
      end
    end

    context "when given a location it cannot move to" do
      it "doesn't update the bishop's location" do
        @d_data = [3, 1]
        move_bishop

        expect(@bishop.move_this_piece(@dest_node)).to eql('Move not valid')
        expect(@bishop.current_node).to eql(@init_node)
      end
    end

    context "when given it's current location" do
      it "returns error message" do
        @d_data = [7, 1]
        move_bishop
        
        expect(@bishop.move_this_piece(@dest_node)).to eql('Bishop is at this location')
      end
    end
  end
end