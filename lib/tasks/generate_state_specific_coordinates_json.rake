# takes 3 letter country code as an argument and generates a JSON file containing
# state code as key and it's coordinates as value
namespace :generate_json do
  desc "Generates json file containing coordinates for each state of supplier country, using Google Geocoding API"
  task :state_coordinates_mapping, [:country_code] => :environment do |task, options|
    base_uri = "https://maps.googleapis.com/maps/api/geocode/json"
    country = Country.find_country_by_alpha3(options.country_code)
    country_2_code = country.data['alpha2'].downcase

    if country.present?
      hsh = {}

      country.states.each do |state|
        state_2_code = state[0].downcase
        query_string = "?components=country:#{country_2_code}|administrative_area:#{state_2_code}&key=AIzaSyA6r8I9Ng8PHHGOBiOqiKiH8Xo2UKWQYlM"

        result = HTTParty.get(URI.parse(URI.encode("#{base_uri}#{query_string}")))

        if result.parsed_response['status'] == 'OK'
          coordinates_hsh = result.parsed_response['results'][0]['geometry']['location']

          hsh.merge!({ "#{state_2_code}" => "#{coordinates_hsh['lat']},#{coordinates_hsh['lng']}" })
        end
      end

      output_file_url = "#{Rails.root}/public/countries/#{country_2_code}.json"

      File.open(output_file_url, "w+") do |file|
        file.write(hsh.to_json)
      end
    else
      p 'Cannot continue without a valid country'
    end
  end
end
