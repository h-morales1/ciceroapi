class PartsController < ApplicationController
  def index
    parts = Part.all 
    render json: parts
  end
end
