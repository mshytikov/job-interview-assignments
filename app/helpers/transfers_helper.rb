module TransfersHelper

  def hystory_row(t)
    row = (current_user.id == t.account_id ? income_row(t) : outcome_row(t) )
    row << t.amount
  end

  def income_row(t)
    ["&darr;".html_safe, t.account.user_id]
  end

  def outcome_row(t)
    ["&uarr;".html_safe, t.to_account.user_id]
  end

end
