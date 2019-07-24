# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stockproject.Repo.insert!(%Stockproject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Stockproject.Portfolios.Portfolio
alias Stockproject.Stocks.Stock
alias Stockproject.Users.User
alias Stockproject.Records.Record
alias Stockproject.Repo
time = DateTime.utc_now
time = DateTime.truncate(time, :second)
{:ok, time2} = DateTime.from_naive(~N[2016-05-24 13:26:08.003], "Etc/UTC")
time2 = DateTime.truncate(time2, :second)
pwhash = Argon2.hash_pwd_salt("P@ssw0rd")
peng = Repo.insert!(%User{name: "peng", password_hash: pwhash})
p1 = Repo.insert!(%Portfolio{name: "p1", user: peng})
#IO.inspect(p1)
s1 = Repo.insert!(%Stock{abbreviation: "AAPL", modified_date: time2, name: "apple", return_fluc: 5.25, price_fluc: 5.25, beta: 2.56, rate_of_return: 5.65})
#IO.inspect(s1)
r1=Repo.insert!(%Record{amount: 10.01, quantity: 10, purchased_price: 1.01, stock_id: 1, portfolio: p1})
#IO.inspect(r1)
