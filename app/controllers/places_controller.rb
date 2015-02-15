class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.place(params[:id])
    if @place.empty?
      redirect_to places_path, notice: "No location found for id #{params[:id]}"
    else
      @iframe_src = iframe_src_for_place(@place)
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

  private

  def iframe_src_for_place(place)
    return nil unless place['street'] && place['city']

    query = "#{place['street']}, #{place['zip']}, #{place['city']}"

    "#{baseurl}#{ERB::Util.url_encode(query)}"
  end

  def baseurl
    "https://www.google.com/maps/embed/v1/place?key=#{apikey}&q="
  end

  def apikey
    Rails.application.secrets.google_apikey || (fail 'Google APIKEY is not defined')
  end
end
