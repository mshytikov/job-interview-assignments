class Account < ActiveRecord::Base
  belongs_to :user, :inverse_of => :account

  validates_numericality_of :balance, :only_integer => true, :greater_than => 0
end
