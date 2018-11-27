class GeoIpService

  def initialize(params)
    @ip = params[:ip]
    @host = 'https://ipinfo.io/' + @ip + '?token=e2926f8a3c9e4f'
    @service_url = @host
  end

  def get_location
    uri = URI(@service_url)
    #binding.pry
    location = get_data(uri)
    return location
  end

  private 
    attr_reader :ip

    def get_data(uri)
      data = JSON.load( open(uri) )
    end

end
