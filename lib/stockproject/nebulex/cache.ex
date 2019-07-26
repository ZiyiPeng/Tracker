# Stock closing price: key: {type: "data/ror", abbrev: "abbreviation", time-span: "time-span"}
# "data": %{"close": .., "date": ...}
# "ror": %{"ror": ..., "date": ...}
defmodule Stockproject.Cache do
  use Nebulex.Cache,
    otp_app: :stockproject,
    adapter: Nebulex.Adapters.Local
end
