require 'httparty'

class StationService

  include HTTParty
  base_uri 'http://lapi.transitchicago.com'

  def initialize(params)
    @cta_identifier = params[:cta_identifier]
  end

  def api_key
      ENV['CTA_API_KEY']
  end

  def base_path
    "/api/1.0/ttarrivals.aspx?key=#{ api_key }"
  end

  def get_arrivals
    url = "#{ base_path }&mapid=#{ @cta_identifier }&outputType=JSON"
    response = self.class.get(url)
    process_arrivals(response.body)
  end

  private
  def process_arrivals(json_file)
      parsed_json = JSON.parse(json_file)
      error_code = parsed_json["ctatt"]["errCd"]
      if error_code.to_i > 0
          return "Unavailable"
      end
      arrivals_raw = parsed_json["ctatt"]["eta"]
      arrivals_array = []
      unless arrivals_raw.nil?
        arrivals_raw.each do |arrival_raw_hash|
          train_number = arrival_raw_hash["rn"]
          destination = arrival_raw_hash["destNm"]
          line_name = arrival_raw_hash["rt"]
          is_train_due = arrival_raw_hash["isApp"].to_i
          if is_train_due == 1
            arrival_time = "Now approaching"
          else
            current_date = DateTime.parse(arrival_raw_hash["prdt"])
            arrival_date = DateTime.parse(arrival_raw_hash["arrT"])
            arrival_time = ((arrival_date - current_date) * 24 * 60).to_i
          end
          arrival = [train_number, destination, line_name, arrival_time]
          arrivals_array.push(arrival)
        end
      end
      arrivals_array
  end
end
