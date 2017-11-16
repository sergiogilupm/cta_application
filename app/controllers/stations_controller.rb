require 'httparty'
require 'json'

class StationsController < ApplicationController
    before_action :set_station, only: [:show, :edit, :update, :destroy]
  
    include HTTParty
    base_uri 'http://lapi.transitchicago.com'

    def api_key
        #ENV['PIXELPEEPER_API_KEY']
    end

    def base_path
      "/api/1.0/ttarrivals.aspx?key=#{ api_key }"
    end
    
    # GET /stations
    # GET /stations.json
    def index
        @stations = Station.all
    end

    # GET /stations/1
    # GET /stations/1.json
    def show
        url = "#{ base_path }&mapid=#{ @station.cta_identifier }&outputType=JSON"
        response = self.class.get(url)
        @arrivals = JSON.parse(response.body)["ctatt"]["eta"]
        @arrivals_pretty = process_arrivals(response.body)
    end

    def process_arrivals(json_file)
        parsed_json = JSON.parse(json_file)
        error_code = parsed_json["ctatt"]["errCd"]
        if error_code.to_i > 0
            return "Unavailable"
        end
        arrivals_raw_hash = parsed_json["ctatt"]["eta"]
        arrivals_array = []
        arrivals_raw_hash.each do |arrival_raw_hash|
            hash = [ { :train_number => "test", :destination => "destTest", :line_name => "lineTestName", :arrival_time => "arrTestTime" } ]
            arrivals_array.push(hash)
        end
        return arrivals_array
    end

    # GET /stations/new
    def new
        @station = Station.new
    end

  # GET /stations/1/edit
  def edit
  end

  # POST /stations
  # POST /stations.json
  def create
    @station = Station.new(station_params)

    respond_to do |format|
      if @station.save
        format.html { redirect_to @station, notice: 'Station was successfully created.' }
        format.json { render :show, status: :created, location: @station }
      else
        format.html { render :new }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stations/1
  # PATCH/PUT /stations/1.json
  def update
    respond_to do |format|
      if @station.update(station_params)
        format.html { redirect_to @station, notice: 'Station was successfully updated.' }
        format.json { render :show, status: :ok, location: @station }
      else
        format.html { render :edit }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.json
  def destroy
    @station.destroy
    respond_to do |format|
      format.html { redirect_to stations_url, notice: 'Station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def station_params
      params.require(:station).permit(:name, :cta_identifier)
    end
end
