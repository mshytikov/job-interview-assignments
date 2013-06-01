class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :password, :on => :create
  validates_presence_of :email


  has_one :account, :autosave => true, :inverse_of => :user

  after_initialize :init_account

  delegate :balance, :balance=, :to => :account

  def build_transfer(user, amount)
    account.transfers.build(to_account_id: user.account.id, amount: amount)
  end


  def init_account
    self.account ||= build_account
  end
end

