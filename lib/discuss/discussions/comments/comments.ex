defmodule Discuss.Comments do
  import Ecto.Query, warn: false
  alias Discuss.Repo
  alias Discuss.Comments.Comment
  alias Discuss.Topics

  def create(topic, comment, user_id) do
    changeset =
      topic
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: comment})

    changeset
    |> Repo.insert()
    |> case do
      {:ok, comment} -> {:ok, comment |> Repo.preload(:user)}
      {:error, _reason} -> {:error, changeset}
    end
  end

  # def update(topic_id, topic) do
  #   Repo.get(Topic, topic_id)
  #   |> Topic.changeset(topic)
  #   |> Repo.update()
  # end

  # def delete!(topic_id) do
  #   Repo.get!(Topic, topic_id)
  #   |> Repo.delete!()
  # end

  def get!(topic_id) do
    Topics.get!(topic_id)
    |> Repo.preload(comments: [:user])
  end

  def list do
    Repo.all(Comment)
  end

  # def owner(topic_id) do
  #   Repo.get(Topic, topic_id).user_id
  # end
end
