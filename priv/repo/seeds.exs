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
alias Stockproject.Portfolios
alias Stockproject.Stocks.Stock
alias Stockproject.Stocks
alias Stockproject.Users.User
alias Stockproject.Users

pwhash = Argon2.hash_pwd_salt("P@ssw0rd")
peng = %User{username: "peng", password: pwhash}
s1 = %Stock{abbreviation: "APPL", modified_date: DateTime.utc(), name: "apple", risk: 5.25, beta: 2.56, rate_of_return: 5.65}
#p1 = %Portfolio{name: "p1", user: peng}
