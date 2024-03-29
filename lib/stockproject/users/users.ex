defmodule Stockproject.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Stockproject.Repo

  alias Stockproject.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all from p in User, preload: [:portfolio]
  end

  def get_user_by_name(name) do
    Repo.one from p in User,
      where: p.name == ^name,
      preload: [:portfolio]
  end

  def authenticate_user(name, password) do
    Repo.get_by(User, name: name)
    |> IO.inspect()
    |> Comeonin.Argon2.check_pass(password)
  end

  def get_and_auth_user(name, password) do
    user = get_user_by_name(name)
    case Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    Repo.one from p in User,
      where: p.id == ^id,
      preload: [:portfolio]
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    user = User.changeset(%User{}, attrs)
    user = Repo.insert!(user)
    id = user.id
    portfolio = elem(Stockproject.Portfolios.create_portfolio(%{name: user.name, user_id: id}),1)
    IO.inspect(portfolio)
    user
    |> Repo.preload([:portfolio])
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:portfolio, portfolio)
    |> Repo.update
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

end
