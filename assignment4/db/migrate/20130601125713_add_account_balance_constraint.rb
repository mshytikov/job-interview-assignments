class AddAccountBalanceConstraint < ActiveRecord::Migration
  def up
    execute "ALTER TABLE accounts ADD CONSTRAINT non_negative_balance CHECK (balance >= 0)"
  end

  def down
    execute "ALTER TABLE accounts DROP CONSTRAINT non_negative_balance"
  end
end
