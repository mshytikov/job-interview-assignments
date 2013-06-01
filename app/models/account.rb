class Account < ActiveRecord::Base
  belongs_to :user, :inverse_of => :account
  has_many :transfers

  has_many :incomes, :class_name => 'Transfer', :foreign_key => 'to_account_id'

  validates_numericality_of :balance, :only_integer => true, :greater_than => -1
end
