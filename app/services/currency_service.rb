class CurrencyService

  def convert_to(from, to)
    url = build_url(from)
    data = Net::HTTP.get(url)
    parse(data, to)
  end

  private 

  def build_url(from)
    URI.parse("https://api.fixer.io/latest?base=#{from}")
  end

  def parse(str, to)
    data = JSON.parse(str)
    data["rates"][to]
  rescue
    false
  end
end
