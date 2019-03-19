defmodule Discuss.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.User

  @derive {Poison.Encoder, only: [:email]}

  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)
    has_many(:topics, Discuss.Topic, on_delete: :delete_all)
    has_many(:comments, Discuss.Comment, on_delete: :delete_all)

    timestamps()
  end

  def changeset(%User{} = user, params \\ %{}) do
    user
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
