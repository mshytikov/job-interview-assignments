class ConvertersController < ApplicationController
  def index
  end

  def convert
    from = params.fetch(:from)
    to = params.fetch(:to)
    values = Hash[params_fetch_values.map{|v| [v, Converter.convert(from, to,v)] }]

    @result =  { from: from, to: to, values: values}

    respond_to do |format|
      format.html
      format.any(:xml, :json) { render request.format.to_sym => @result }
    end
  end

  private

  def params_fetch_values
    values = params.fetch(:values)
    #support of different format for 'values' param: &values=1,2 or &values[]=1&values[]=2
    values = values.split(/,\s*/) unless values.is_a?(Array) 
    values.map{|v| Float(v) }
  end

end
