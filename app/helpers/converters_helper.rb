module ConvertersHelper


  def convert_from_tag
    types = Converter.types.map(&:first).uniq
    select_tag "from", options_for_select(types)
  end

  def convert_to_tag
    types = Converter.types.map(&:last).uniq
    select_tag "to", options_for_select(types)
  end


end
