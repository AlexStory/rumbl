defmodule Rumbl.Accounts do
  @moduledoc """
  Accounts Context.
  """

  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  @spec get_user_by(Keyword.t) :: User | nil
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  @spec list_users() :: list(User)
  def list_users do
    Repo.all(User)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)
    verify_user(user, given_pass)
  end

  defp verify_user(nil, _pass) do
    Pbkdf2.no_user_verify()
    {:error, :not_found}
  end
  defp verify_user(user, given_pass), do: verify_pass(user, Pbkdf2.verify_pass(given_pass, user.password_hash))

  defp verify_pass(user, _pass_valid = true), do: {:ok, user}
  defp verify_pass(_user, _pass_valid), do: {:error, :unauthorized}

end
