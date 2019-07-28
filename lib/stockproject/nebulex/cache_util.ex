defmodule CacheUtil do
  alias Stockproject.Cache

  #filter data received to reduce size of the cache
  def data_filter(type, data) do
    case type do
      # "close", "date"
      "history" ->
        Enum.map(data, fn x -> %{close: x["close"], date: x["date"]} end)
      #beta, year1ChangePercent, companyName
      "stats" -> #beta, companyName
        %{beta: data["beta"], year1ChangePercent: data["year1ChangePercent"], companyName: data["companyName"]}
    end
  end

  #key: %{abbrev: “abbrev”, type: “history/stats”, time_span: “1y/2y...”}

  def get_or_search(key, url) do
    key = Map.update!(key, :type, fn x -> String.downcase(key.type) end)
    if Cache.has_key?(key) do
      Cache.get(key)
    else
      token=Application.fetch_env!(:stockproject, :iex_token)
      url = url <> "?token=#{token}"
      resp = HTTPoison.get!(url)
      data = Jason.decode!(resp.body)
      data = data_filter(Map.fetch!(key, :type), data)
      Cache.set(key, data)
      data
    end
  end

end
