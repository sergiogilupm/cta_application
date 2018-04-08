require 'csv'   
require 'set' 
 
class Station
	attr_accessor :name, :map_id, :latitude, :longitude,
		:isRed, :isBlue, :isGreen, :isBrown, :isPurple,
		:isPurpleExp, :isYellow, :isPink, :isOrange
   def initialize(name, map_id, latitude, longitude,
   					isRed, isBlue, isGreen, isBrown, 
   					isPurple, isPurpleExp, isYellow,
   					isPink, isOrange)
      @name = name
      @map_id = map_id
      @latitude = latitude
      @longitude = longitude
      @isRed = isRed
	  @isBlue = isBlue
	  @isGreen = isGreen
	  @isBrown = isBrown
	  @isPurple = isPurple
	  @isPurpleExp = isPurpleExp
	  @isYellow = isYellow
	  @isPink = isPink
	  @isOrange = isOrange
   end
end

input_path = './cta_input.csv'
output_path = '../../db/seeds.rb'

puts 'Initializing script...'

map_ids = Set.new([])
stations = []
output_file = File.new(output_path, 'w')
File.truncate(output_path, 0)
input_file = File.read(input_path)
csv = CSV.parse(input_file, :headers => true)
csv.each do |row|
	name = row[3]
	map_id = row[5]
	if (!map_ids.include?(map_id)) then
		map_ids.add(map_id)
		location = row[16].gsub(/[()]/, "").strip.split(",")
		latitude = location[0]
		longitude = location[1]
		isRed = row[7]
		isBlue = row[8]
		isGreen = row[9]
		isBrown = row[10]
		isPurple = row[11]
		isPurpleExp = row[12]
		isYellow = row[13]
		isPink = row[14]
		isOrange = row[15]
		station = Station.new(name, map_id, latitude, longitude,
			isRed, isBlue, isGreen, isBrown, isPurple, isPurpleExp,
			isYellow, isPink, isOrange)
	    stations << station
	end
end

# Station creation in DB
print 'Creating Station information in seeds file...'
output_file.puts("#Station information")
stations.each do |station|
	new_query = "Station.create(" + "name: '" + station.name + "', " + 
				"map_id: " + station.map_id + ", " + 
				"latitude: " + station.latitude + ", " + 
				"longitude: " + station.longitude + ")\n"

	output_file.puts(new_query)
end
puts 'OK'

# Station details creation in DB
print 'Creating Station Details information in seeds file...'
output_file.puts("#Station Details information")
stations.each do |station|
	if(station.isRed == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Red')")
	end
	if(station.isBlue == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Blue')")
	end
	if(station.isBrown == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Brn')")
	end
	if(station.isGreen == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'G')")
	end
	if(station.isOrange == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Org')")
	end
	if(station.isPurple == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'P')")
	end
	if(station.isPurpleExp == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Pexp')")
	end
	if(station.isPink == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Pink')")
	end
	if(station.isYellow == 'true')
		output_file.puts("Station_details.create(map_id: " + station.map_id + ", " +
			"internal_line_name: 'Y')")
	end
end
puts 'OK'

# Line creation in DB - Manual
print 'Creating Line information in seeds file...'
output_file.puts("#Line information")
output_file.puts("Line.create(name: 'Red', internal_name: 'Red', _24H_service: true)")
output_file.puts("Line.create(name: 'Blue', internal_name: 'Blue', _24H_service: true)")
output_file.puts("Line.create(name: 'Brown', internal_name: 'Brn', _24H_service: false)")
output_file.puts("Line.create(name: 'Green', internal_name:  'G', _24H_service: false)")
output_file.puts("Line.create(name: 'Orange', internal_name:  'Org', _24H_service: false)")
output_file.puts("Line.create(name: 'Purple', internal_name:  'P', _24H_service: false)")
output_file.puts("Line.create(name: 'Purple Express', internal_name:  'Pexp', _24H_service: false)")
output_file.puts("Line.create(name: 'Pink', internal_name:  'Pink', _24H_service: false)")
output_file.puts("Line.create(name: 'Yellow', internal_name:  'Y', _24H_service: false)")
puts 'OK'

puts 'Parsing complete'

