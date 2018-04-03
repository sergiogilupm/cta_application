require 'httparty'

class TrainService

  include HTTParty
  base_uri 'http://lapi.transitchicago.com'

  def initialize(params)
    @train_number = params[:train_number]
  end

  def api_key
    '5cec5abdfba946af8afb0598606440bd'
      #ENV['PIXELPEEPER_API_KEY']
  end

  def base_path
    "/api/1.0/ttfollow.aspx?key=#{ api_key }"
  end

  def get_train_details
    url = "#{ base_path }&runnumber=#{ @train_number }&outputType=JSON"
    byebug
    response = self.class.get(url)
    #train_details = process_response(response.body)
    return response.body
  end

  private
  def process_response(json_file)
      parsed_json = JSON.parse(json_file)
      error_code = parsed_json["ctatt"]["errCd"]
      if error_code.to_i > 0
          return "Unavailable"
      end
      arrivals_raw = parsed_json["ctatt"]["eta"]
      arrivals_array = []
      if !arrivals_raw.nil?
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
          arrival = [ train_number, destination, line_name, arrival_time ]
          arrivals_array.push(arrival)
        end
      end
      return arrivals_array
  end
end
