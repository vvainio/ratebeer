class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place(params[:id])
    if @place.empty?
      redirect_to places_path, notice: "No location found for id #{params[:id]}"
    else
      render :show
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
