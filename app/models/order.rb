class Order
  class Side
    BID = 'B'
    ASK = 'A'
    def self.opposite(side)
      case side
      when BID; ASK
      when ASK; BID
      end
    end
  end
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  referenced_in :user
  referenced_in :product
  references_many :executions
  
  # Public : Side of order B=bid or A=ask
  field :side, :default => Side::BID
  validates_inclusion_of :side, :in => [Side::BID, Side::ASK]
  
  # Public : price
  field :price, :type => Float, :default => 0.0
  validates_numericality_of :price, :greater_than_or_equal_to => 0.0
  
  # Public : quantity
  field :quantity, :type => Integer, :default => 1
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0, :only_integer => true
  
  # Public : reference of order, used for clearing
  field :ref
  validates_length_of :ref, :maximum => 20
  
  # Public : status of order
  field :status, :default => 'A'
  validates_inclusion_of :status, :in => ['A', 'P', 'F', 'C']
  
  def ask?; side == Side::ASK; end
  def bid?; side == Side::BID; end
  
  def executed
    executions.reduce(0){|acc, e| acc += e.quantity}
  end
  
  def remaining
    quantity - executed
  end
  
  def matches?(other)
    return false unless other
    return false if side == other.side
    return false if filled?
    bid?? price >= other.price : price <= other.price
  end  

  def active?
    status == 'A'
  end
  def partially_filled?
    status = 'P'
  end
  def filled?
    status == 'F'
  end

  def fill!(q, p)
    e = executions.build(:user => user, :product => product, :side => side, :quantity => q, :price => p, :ref => ref)
    self.status = (executed < quantity ? 'P' : 'F')
    e
  end

  class << self
    def opposite(order)
      order.dup.tap{|o| o.side = Side.opposite(order.side)}
    end    
  end
end