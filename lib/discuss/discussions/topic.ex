defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Topic

  schema "topics" do
    field(:title, :string)
    belongs_to(:user, Discuss.User)
    has_many(:comments, Discuss.Comment, on_delete: :delete_all)
  end

  def changeset(%Topic{} = topic, params \\ %{}) do
    topic
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
