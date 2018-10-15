defmodule ApiWeb.SessionController do
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Guardian

  def create(conn, %{"email" => email, "password" => password}) do
    user = Users.find_by_email(email)

    case Users.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("show.json", user: user, jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def refresh(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    token = Guardian.Plug.current_token(conn)

    case Guardian.refresh(token) do
      {:ok, _old_stuff, {new_token, _new_claims}} ->
        conn |> render("show.json", user: user, jwt: new_token)
      _ ->
        {:error, :unauthorized}
    end
  end
end
