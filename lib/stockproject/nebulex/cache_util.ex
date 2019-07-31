defmodule CacheUtil do
  alias Stockproject.Cache
  alias Stockproject.CompanyInfoCache

  #filter data received to reduce size of the cache
  def data_filter(type, data) do
    case type do
      # "close", "date"
      "history" ->
        Enum.map(data, fn x -> %{close: x["close"], date: x["date"]} end)
      #beta, year1ChangePercent, companyName
      "stats" -> #beta, companyName
        %{beta: data["beta"], year1ChangePercent: data["year1ChangePercent"], companyName: data["companyName"]}
      "company_info" ->
        %{ceo: data["CEO"], company_name: data["companyName"], description: data["description"],
          sector: data["sector"], symbol: data["symbol"], website: data["website"]}
      "logo" ->
        %{logo: data["url"]}
    end
  end

  # return the cache associated with the given key
  def determine_cache(key) do
    type = Map.fetch!(key, :type)
    case type do
      "history" -> Cache
      "stats" -> Cache
      "company_info" -> CompanyInfoCache
      "logo" -> CompanyInfoCache
    end
  end

  #key: %{abbrev: “abbrev”, type: “history/stats”, time_span: “1y/2y...”}
  #     %{abbrev: "abbrev", type: "company_info"}
  #     %{abbrev: "abbrev", type: "logo"}
  def get_or_search(key, url) do
    key = Map.update!(key, :type, &(String.downcase(&1)))
    cache = determine_cache(key)
    if cache.has_key?(key) do
      cache.get(key)
    else
      token=Application.fetch_env!(:stockproject, :iex_token)
      url = url <> "?token=#{token}"
      resp = HTTPoison.get!(url)
      data = Jason.decode!(resp.body)
      data = data_filter(Map.fetch!(key, :type), data)
      cache.set(key, data)
      data
    end
  end

end
