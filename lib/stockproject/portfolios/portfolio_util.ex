defmodule PortfolioUtil do
  alias Stockproject.Records

  #calculate the networth of this portfolio
  def calc_portfolio_value(id) do
    portfolio = Stockproject.Portfolios.get_portfolio(id)
    Enum.reduce(portfolio.records, 0, fn x,acc -> acc + Records.calc_current_value(x.id) end)
  end

##%{composition: data.composition, risk: data.risk, beta: data.beta, rate_of_return: data.ror}
  def calc_portfolio_stats(id) do
    portfolio = Stockproject.Portfolios.get_portfolio(id)
    total = Enum.reduce(portfolio.records, 0, fn x, acc -> acc + x.amount end)
    #[%{name, risk, beta, ror, weight}]
    stats = Enum.reduce(portfolio.records, [], fn x, acc -> acc ++ [Records.calc_weighted_stats(x.id, total)] end)
    risk = Enum.reduce(stats, 0, fn x, acc -> x.risk + acc end)
    beta = Enum.reduce(stats, 0, fn x, acc -> x.beta + acc end)
    ror = Enum.reduce(stats, 0, fn x, acc -> x.ror + acc end)
    comp = Enum.reduce(stats, [], fn x, acc -> acc ++ [%{abbreviation: x.abbreviation, weight: x.weight}] end)
    %{composition: comp, risk: risk, beta: beta, rate_of_return: ror}
  end

#get the composition of this portfolio [%{abbreviation, weight}]
  def get_composition(id) do
    portfolio = Stockproject.Portfolios.get_portfolio(id)
    total = Enum.reduce(portfolio.records, 0, fn x, acc -> acc + x.amount end)
    Enum.reduce(portfolio.records, [], fn x, acc -> acc++[Records.calc_weight_in_portfolio(x.id, total)] end)
  end

#calculate historical portfolio value (1yr) [%{date: value}]
  def calc_historial_values(id) do
    portfolio = Stockproject.Portfolios.get_portfolio(id)
    #[[%{date, price}]]
    if length(portfolio.records) == 0 do
      []
    else
      all_data = Enum.map(portfolio.records, fn x -> Records.get_historical_value(x.id) end)
      Enum.reduce(tl(all_data), hd(all_data), fn x, acc -> sum_lists(x, acc) end)
    end
  end

  defp sum_lists(l1, l2) do
    combine_lists(l1, l2, [])
  end

  defp combine_lists([], _l2, acc) do
    acc
  end

  defp combine_lists(l1, l2, acc) do
    e1 = hd(l1)
    e2 = hd(l2)
    element = %{date: e2.date, value: e1.value + e2.value}
    combine_lists(tl(l1), tl(l2), acc++[element])
  end


end
