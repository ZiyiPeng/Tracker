require Integer
defmodule StockUtil do


  # if the IPO is atleast 2 years ago, use stdev of annual rate of Returns
  # if not enough data points can be found, use stdev of closing prices
  def calc_return_fluctuation(abbreviation) do
    url = "https://api.iextrading.com/1.0/stock/#{abbreviation}/chart/2y"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    closes = Enum.map(data, fn x -> x["close"] end)
    if length(closes) > 253 do
      IO.puts("valid")
      data = chunk_data(closes)
      divisor = length(hd(data))
      returns = prep_list_return(Enum.fetch!(data,0), Enum.fetch!(data,1), [], divisor)
      risk = Float.round(Statistics.stdev(returns), 4)
      IO.puts("Std")
      IO.puts(Statistics.mean(returns))
      risk
    else
      IO.puts("invalid")
      url = "https://api.iextrading.com/1.0/stock/#{abbreviation}/chart/1y"
      resp = HTTPoison.get!(url)
      data = Jason.decode!(resp.body)
      close = Enum.map(data, fn x -> x["close"] end)
      risk = Float.round(Statistics.stdev(close), 4)
      risk
    end
  end

  def calc_price_fluctuation(abbreviation) do
    url = "https://api.iextrading.com/1.0/stock/#{abbreviation}/chart/1y"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    close = Enum.map(data, fn x -> x["close"] end)
    risk = Float.round(Statistics.stdev(close), 4)
    risk
  end

  def get_annual_ror(abbrev) do
    url = "https://api.iextrading.com/1.0/stock/#{abbrev}/chart/2y"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    #start idx of second year data
    closes = Enum.map(data, fn x -> x["close"] end)
    if length(closes) > 500 do
      data = chunk_data(closes)
      divisor = length(hd(data))
      returns = prep_list_return(Enum.fetch!(data,0), Enum.fetch!(data,1), [], divisor)
      ror = Enum.reduce(returns, 0, fn x,acc -> x+acc end) / divisor
      Float.round(ror, 5)
    #some company's IPO is within 1 year
    else
      IO.puts("get_annual_change(abbrev)")
      get_annual_change(abbrev)
    end
  end

  def prep_list_return(l1, l2, acc, length) when length>0 do
    return = (hd(l2)-hd(l1))/hd(l1)
    prep_list_return(tl(l1), tl(l2), acc++[return], length-1)
  end

  def prep_list_return(_l1,_l2, acc, _length) do
    acc
  end

  def get_list_of_ror(abbrev) do
    url = "https://api.iextrading.com/1.0/stock/#{abbrev}/chart/2y"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    closes = Enum.map(data, fn x -> x["close"] end)
    data = chunk_data(closes)
    divisor = length(hd(data))
    returns = prep_list_return(Enum.fetch!(data,0), Enum.fetch!(data,1), [], divisor)
    if length(closes) >= 505 do
      IO.puts("valid")
      returns
    else
      number_of_data_point = max(0, length(closes)-253)
      IO.puts("invalid")
      Enum.take(returns, -number_of_data_point)
    end
  end

  #get the average annual rate of return
  def get_annual_change(abbreviation) do
    url = "https://api.iextrading.com/1.0/stock/#{abbreviation}/stats"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    ror=data["year1ChangePercent"]
    Float.round(ror, 5)
  end

  #chunk the stock history data into two lists of equal size
  #the first list is yr1 data, the second list is yr2 data
  def chunk_data(list) do
    size = length(list)
    mid_idx = Integer.floor_div(size, 2)
    if Integer.is_even(size) do
      [Enum.take(list, mid_idx)]++[Enum.take(list, -mid_idx)]
    else
      p1=Enum.take(list, mid_idx+1)
      p2=Enum.take(list, -(mid_idx+1))
      [p1,p2]
    end
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

  def search_suggestion(name) do
    key = "7E3XEF8EJVICCTXE"
    url = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=#{name}&apikey=#{key}"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    data["bestMatches"]
  end

#%{metadata: data.meta, price: data.price}
  def search_intraday(abbrev, time) do
    key = "7E3XEF8EJVICCTXE"
    url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{abbrev}&interval=5min&apikey=#{key}"
    resp = HTTPoison.get!(url)
    data = Jason.decode!(resp.body)
    #IO.inspect(data)
    IO.puts("Time Series (#{time})")
    %{metadata: data["Meta Data"], prices: data["Time Series (#{time})"]}
  end
end
