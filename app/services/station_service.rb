require 'httparty'

class StationService

  CTA_ROOT = "ctatt"
  ERROR_CODE = "errCd"
  ARRIVALS_ROOT = "eta"
  TRAIN_NUMBER = "rn"
  DESTINATION = "destNm"
  LINE = "rt"
  IS_APPROACHING = "isApp"
  CURRENT_TIME = "prdt"
  ARRIVAL_TIME = "arrT"
  APPROACHING_TEXT = "Now approaching"

  include HTTParty
  base_uri 'http://lapi.transitchicago.com'


  def initialize(params)
    @map_id = params[:map_id]
  end

  def api_key
      ENV['CTA_API_KEY']
  end

  def base_path
    "/api/1.0/ttarrivals.aspx?key=#{ api_key }"
  end

  def get_arrivals
    url = "#{ base_path }&mapid=#{ @map_id }&outputType=JSON"
    response = self.class.get(url)
    process_arrivals(response.body)
  end

  private
  def process_arrivals(response)
      json_response = JSON.parse(response)
      error_code = json_response[CTA_ROOT][ERROR_CODE]
      if error_code.to_i > 0
          return []
      end
      arrivals = json_response[CTA_ROOT][ARRIVALS_ROOT]
      processed_arrivals = []
      unless arrivals.nil?
        arrivals.each do |arrival|
          train_number = arrival[TRAIN_NUMBER]
          destination = arrival[DESTINATION]
          line_name = arrival[LINE]
          is_approaching = arrival[IS_APPROACHING].to_i
          if is_approaching == 1
            arrival_time = APPROACHING_TEXT
          else
            current_date = DateTime.parse(arrival[CURRENT_TIME])
            arrival_date = DateTime.parse(arrival[ARRIVAL_TIME])
            arrival_time = ((arrival_date - current_date) * 24 * 60).to_i
          end
          #processed_arrival = [train_number, destination, line_name, arrival_time]
          new_arrival = {
              "train_number" => train_number,
              "destination" => destination,
              "line_name" => line_name,
              "arrival_time" => arrival_time
          }
          processed_arrival = JSON.parse(new_arrival)
          processed_arrivals.push(processed_arrival)
        end
      end
      processed_arrivals
  end
end
