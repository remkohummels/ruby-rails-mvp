class WeatherService
  def get(lat, lng)
    url = build_url(lat, lng)
    data = Net::HTTP.get(url)
    parse(data)
  end

  private

  ICONS = {
    'clear-day': 'day-sunny',
    'clear-night': 'night-clear',
    rain: 'rain',
    snow: 'snow',
    sleet: 'sleet',
    wind: 'windy',
    fot: 'fog',
    cloudy: 'cloudy',
    'partly-cloudy-day': 'day-cloudy',
    'partly-cloudy-night': 'night-partly-cloudy'
  }

  def build_url(lat, lng)
    URI.parse("https://api.darksky.net/forecast/#{ENV['WEATHER_API_KEY']}/#{lat},#{lng}")
  end

  def parse(str)
    data = JSON.parse(str)
    result = []

    current = get_info(data["currently"])
    time = current[:time]
    if !time.nil?
      data["hourly"].try(:[], "data").each do |obj|
        result << get_info(obj) if obj["time"] > time && result.length < 4
      end
    end

    {
      current: current,
      hours: result
    }
  end

  def get_info(obj)
    {
      time: obj["time"],
      icon: ICONS[obj["icon"].to_sym],
      summary: obj["summary"],
      temperature: (obj["temperature"].to_i - 32) * 5 / 9
    }
  end
end
