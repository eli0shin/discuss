defmodule Discuss.Users do
  import Ecto.Query, warn: false
  alias Discuss.Repo
  alias Discuss.Users.User

  def signin(auth, provider) do
    user_params = create_user_params(auth, provider)

    User.changeset(%User{}, user_params)
    |> insert_or_update()
  end

  defp create_user_params(auth, provider) do
    %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: provider
    }
  end

  defp insert_or_update(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)

      user ->
        {:ok, user}
    end
  end
end
