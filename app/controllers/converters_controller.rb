class ConvertersController < ApplicationController
  def index
  end

  def convert
    @result =  { 
      :from => params.fetch(:from),
      :to   => params.fetch(:to),
      :values => Hash[convert_values.map{|v| [v, v] }]
    }

    respond_to do |format|
      format.html
      format.any(:xml, :json) { render request.format.to_sym => @result }
    end
  end

  private

  def convert_values
    values = params.fetch(:values)
    values = values.split(/,\s*/) unless values.is_a?(Array)
    values.map{|v| Float(v) }
  end

end
