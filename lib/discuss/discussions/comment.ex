defmodule Discuss.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Comment

  @derive {Poison.Encoder, only: [:content, :id, :user]}

  schema "comments" do
    field(:content, :string)
    belongs_to(:user, Discuss.User)
    belongs_to(:topic, Discuss.Topic)

    timestamps()
  end

  def changeset(%Comment{} = user, params \\ %{}) do
    user
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
