defmodule Discuss.Topics.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Topics.Topic

  schema "topics" do
    field(:title, :string)
    belongs_to(:user, Discuss.Users.User)
    has_many(:comments, Discuss.Comments.Comment, on_delete: :delete_all)
  end

  def changeset(%Topic{} = topic, params \\ %{}) do
    topic
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
