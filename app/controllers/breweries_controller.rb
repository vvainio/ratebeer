class BreweriesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :nglist]
  before_action :ensure_that_admin_user, only: [:destroy]
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :expire_cache, only: [:create, :update, :destroy, :nglist]
  before_action :skip_if_cached, only: [:index]

  def nglist
  end

  # GET /breweries
  # GET /breweries.json
  def index
    @breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired

    @active_breweries = case @order
                        when 'name' then @active_breweries.sort_by(&:name)
                        when 'year_asc' then @active_breweries.sort_by(&:year)
                        when 'year_desc' then @active_breweries.sort_by(&:year).reverse
    end

    @retired_breweries = case @order
                         when 'name' then @retired_breweries.sort_by(&:name)
                         when 'year_asc' then @retired_breweries.sort_by(&:year)
                         when 'year_desc' then @retired_breweries.sort_by(&:year).reverse
    end

    session[:last_breweries_sort] = nil if @order == 'year_desc'
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /breweries/1/toggle_activity
  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (!brewery.active)

    new_status = brewery.active? ? 'active' : 'retired'

    redirect_to :back, notice: "Brewery activity status changed to #{new_status}"
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def expire_cache
      ['brewerylist-name', 'brewerylist-brewery', 'brewerylist-style'].each { |f| expire_fragment(f) }
    end

    def skip_if_cached
      @order = session[:last_breweries_sort] = params[:order] || 'name'
      return render :index if fragment_exist?("brewerylist-#{@order}")
    end
end
