class AddAccountsBalanceToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :account_balance,    :integer, :null => false
    add_column :transfers, :to_account_balance, :integer, :null => false
  end
end
