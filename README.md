# Stockproject

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
  
## Current Status
  07/20/2019 Ziyi peng
  1. IEX Trading migrated its legacy endpoints from v1 to IEX Cloud, all api calls made to IEX needs to be updated. 
  2. All api calls made to IEX Cloud server need to include an iex token
  3. IEX Cloud charges its customers based on the number of request each of them make.  We will adopt Nebulex, a  
     caching library, to reduce number of api call made to IEX Cloud. Detail about Nebulex can be found here:
     https://hexdocs.pm/nebulex/getting-started.html#inserting-entries
  Status:
     Web application is no longer available. All endpoints except /api/stat and /api/logo are still functioning. 
     We will restore the application once the caching feature is finished
