defmodule Discuss.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Comments.Comment

  @derive {Poison.Encoder, only: [:content, :id, :user]}

  schema "comments" do
    field(:content, :string)
    belongs_to(:user, Discuss.Users.User)
    belongs_to(:topic, Discuss.Topics.Topic)

    timestamps()
  end

  def changeset(%Comment{} = user, params \\ %{}) do
    user
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
