class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :password, :on => :create
  validates_presence_of :email


  has_one :account, :autosave => true

  before_create :build_account

  delegate :balance, :to => :account

end
