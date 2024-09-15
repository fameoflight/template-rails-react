# frozen_string_literal: true

module Services
  class City
    attr_reader :country

    def initialize(country)
      @country = country
    end

    def get
      country_filename = Rails.root.join("app/libs/country/country_#{country}.json")

      # check if country file exists
      if File.exist?(country_filename)
        JSON.parse(File.read(country_filename))
      else
        # calculate and save city data
        city_data = calculate_city_data

        File.write(country_filename, city_data.to_json(pretty: true))

        city_data
      end
    end

    def calculate_city_data
      city_filename = Rails.root.join('app/libs/country/cities.json')

      admin_filename = Rails.root.join('app/libs/country/admin1.json')

      city_data = JSON.parse(File.read(city_filename))

      city_data = city_data.select { |city| city['country'] == country }

      admin_data = JSON.parse(File.read(admin_filename))

      admin_data = admin_data.select { |admin| admin['code'].start_with?("#{country}.") }

      admin_data = admin_data.map { |admin| [admin['code'], admin['name']] }.to_h

      # add admin data to city data

      city_data.each do |city|
        admin_code = city['admin1']

        city['admin1_name'] = admin_data["#{country}.#{admin_code}"]
      end

      city_data
    end
  end
end
