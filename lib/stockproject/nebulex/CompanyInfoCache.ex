#this cache will store company's information and logo
defmodule Stockproject.CompanyInfoCache do
  use Nebulex.Cache,
    otp_app: :stockproject,
    adapter: Nebulex.Adapters.Local
end
