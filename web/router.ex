defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Discuss.Plugs.SetUser)
  end

  scope "/", Discuss do
    pipe_through(:browser)

    resources("/", TopicController)
  end

  scope "/auth", Discuss do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end
end
