module TransfersHelper

  def hystory_row(t)
    current_user.id == t.account_id ? income_row(t) : outcome_row(t) 
  end

  def income_row(t)
    ["&darr;".html_safe, t.account.user_id, t.amount, t.account_balance]
  end

  def outcome_row(t)
    ["&uarr;".html_safe, t.to_account.user_id, t.amount, t.to_account_balance]
  end

end
