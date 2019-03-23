defmodule Discuss.Web.AuthController do
  use Discuss.Web, :controller
  plug(Ueberauth)

  alias Discuss.Users

  def callback(conn, %{"provider" => provider}) do
    %{assigns: %{ueberauth_auth: auth}} = conn

    case Users.signin(auth, provider) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end
end
