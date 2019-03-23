defmodule Discuss.Web.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.Comments

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)

    topic = Comments.get!(topic_id)

    {
      :ok,
      %{comments: topic.comments},
      assign(socket, :topic, topic)
    }
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    case Comments.create(topic, content, user_id) do
      {:ok, comment} ->
        broadcast!(
          socket,
          "comments:#{socket.assigns.topic.id}:new",
          %{comment: comment}
        )

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
