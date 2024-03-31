class CarsController < ApplicationController
  before_action :set_car, only: %i[show update destroy]
  # GET /cars
  def index
    cars = Car.all 
    render json: cars
  end

  # GET /cars/1
  def show
    render json: @car
  end

  # POST /cars/1
  def update 
    if @cars.update(car_params)
      render json: @car 
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cars/1
  def destroy
    @car.destroy
  end

  # POST /cars
  def create 
    @car = Car.new(car_params)
    
    if @car.save
      render json: @car, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:id, :make, :model, :year)
  end
end
