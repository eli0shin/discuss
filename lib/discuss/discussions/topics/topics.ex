defmodule Discuss.Topics do
  import Ecto.Query, warn: false
  alias Discuss.Repo
  alias Discuss.Topics.Topic

  def create(topic, user) do
    user
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(topic)
    |> Repo.insert()
  end

  def update(topic_id, topic) do
    Repo.get(Topic, topic_id)
    |> Topic.changeset(topic)
    |> Repo.update()
  end

  def delete!(topic_id) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!()
  end

  def get!(topic_id) do
    Repo.get!(Topic, topic_id)
  end

  def list do
    Repo.all(Topic)
  end

  def owner(topic_id) do
    Repo.get(Topic, topic_id).user_id
  end

  def is_owner?(topic_id, user_id) do
    owner(topic_id) == user_id
  end
end
