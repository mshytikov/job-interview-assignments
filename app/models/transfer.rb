class Transfer < ActiveRecord::Base
  attr_accessible :amount, :to_account_id

  belongs_to :account
  belongs_to :to_account, :class_name => 'Account', :foreign_key => 'to_account_id'

  validates_numericality_of :amount, :only_integer => true, :greater_than => 0
  validates_presence_of :to_account_id
  validate :positive_account_balance

  before_create :transfer_founds

  private 

  def transfer_founds
    from_account = Account.find(self.account_id, :lock => true)
    to_account = Account.find(self.to_account_id, :lock => true)

    from_account.balance -= self.amount
    to_account.balance += self.amount

    to_account.save!
    from_account.save!
  end

  def positive_account_balance
    if (account.balance - self.amount) < 0
      errors.add(:amount, "greater than balance. Can't run a deficit")
    end
  end

end
