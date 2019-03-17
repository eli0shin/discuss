defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.{Comment, Topic}

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)

    topic =
      Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comments: [:user])

    {
      :ok,
      %{comments: topic.comments},
      assign(socket, :topic, topic)
    }
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset =
      topic
      |> build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        with_association = comment |> Repo.preload(:user)

        broadcast!(
          socket,
          "comments:#{socket.assigns.topic.id}:new",
          %{comment: with_association}
        )

        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
