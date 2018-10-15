defmodule ApiWeb.SessionController do
  use ApiWeb, :controller

  alias Api.Users

  def create(conn, %{"email" => email, "password" => password}) do
    user = Users.find_by_email(email)

    case Users.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("show.json", user: user, jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end
end
