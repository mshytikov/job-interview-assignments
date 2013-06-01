class Transfer < ActiveRecord::Base
  belongs_to :account

  validates_numericality_of :amount, :only_integer => true, :greater_than => 0

end
