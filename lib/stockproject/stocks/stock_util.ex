defmodule StockUtil do

#use close prices in one year to calculate stock's risk
  def calc_risk(abbreviation) do
    url = "https://api.iextrading.com/1.0/stock/#{abbreviation}/chart/1y"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    close = Enum.map(data, fn x -> x["close"] end)
    risk = Float.round(Statistics.stdev(close), 2)
    risk
  end

  #get the annual rate of return
  def get_annual_ror(abbreviation) do
    url = "https://api.iextrading.com/1.0/stock/#{abbreviation}/chart/1y"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    ror=List.last(data)["changeOverTime"]
    Float.round(ror, 5)
  end

#get stock's beta and name
  def get_info(abbreviation) do
    resp = Stoxir.key_stats(abbreviation)
    %{beta: resp.beta, name: resp.company_name}
  end

  def get_logo(abbrev) do
    resp = HTTPoison.get!("https://api.iextrading.com/1.0/stock/#{abbrev}/logo")
    data = Jason.decode!(resp.body)
    data["url"]
  end

  def get_current_price(abbrev) do
    url = "https://api.iextrading.com/1.0/stock/#{abbrev}/price"
    resp = HTTPoison.get!(url)
    Jason.decode!(resp.body)
  end

  def get_history(abbrev, time_span) do
    url = "https://api.iextrading.com/1.0/stock/#{abbrev}/chart/#{time_span}"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    Enum.map(data, fn x -> %{close: x["close"], date: x["date"]} end)
  end
  
end
