defmodule Discuss.Web.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topics
  alias Discuss.Topics.Topic

  plug(Discuss.Web.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete])
  plug(:check_topic_owner when action in [:update, :edit, :delete])

  def index(conn, _params) do
    render(conn, "index.html", topics: Topics.list())
  end

  def new(conn, _params) do
    changeset =
      Topic.changeset(
        %Topic{},
        %{}
      )

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    case Topics.create(topic, conn.assigns.user) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "There was an error saving the Topic. Please try again.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    case Topics.update(topic_id, topic) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated Successfully!")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "There was an error saving the Topic. Please try again.")
        |> render("edit.html", changeset: changeset, topic: Topics.get!(topic_id))
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Topics.delete!(topic_id)

    conn
    |> put_flash(:info, "Topic Deleted Successfully")
    |> redirect(to: topic_path(conn, :index))
  end

  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Topics.is_owner?(topic_id, conn.assigns.user.id) do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that topic")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end

  def show(conn, %{"id" => topic_id}) do
    render(conn, "show.html", topic: Topics.get!(topic_id))
  end
end
