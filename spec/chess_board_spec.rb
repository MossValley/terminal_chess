require './chess_board'

describe "BoardSquare" do
  before do
    @square = BoardSquare.new([7, 1], true)
    @piece = double("chess piece")
    allow(@piece).to receive(:icon) { "p" }
  end

  describe "#update_node" do
    it "should return name of piece and the icon" do
      expect(@square.update_node(@piece)).to eql("p")
    end
  end
end


describe "Board" do
  let(:board) { Board.new }

  describe "@movement_hash" do
    context "when checking a certain node in the hash" do
      before { @node = board.movement_hash[[7, 1]] }

      it "should return its own location" do
        expect(@node.data).to eql([7, 1])
      end

      it "should return a datapoint above it" do
        expect(@node.up.data).to eql([6, 1])
      end

      it "should return a datapoint to the right of it" do
        expect(@node.right.data).to eql([7, 2])
      end

      it "should return a datapoint below it" do
        expect(@node.down.data).to eql([8, 1])
      end

      it "should return a datapoint up_right of it" do
        expect(@node.up_r.data).to eql([6, 2])
      end
    end
  end
end