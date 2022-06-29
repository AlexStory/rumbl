defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    handle_login(conn, Rumbl.Accounts.authenticate_by_username_and_pass(username, pass))
  end

  def delete(conn, _params) do
    conn
    |> RumblWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp handle_login(conn, {:ok, user}) do
    conn
    |> RumblWeb.Auth.login(user)
    |> put_flash(:info, "Welcome back!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp handle_login(conn, {:error, _reason}) do
    conn
    |> put_flash(:error, "Invalid username/password combination")
    |> render("new.html")
  end
end
