defmodule StaticSite.HttpHandler do
  use Plug.Router

  # plug Static.RequestLogger
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  plug(Plug.Static, at: "/", from: {:static_site, "./output"}, only: ~w{js})

  get "/" do
    send_resp(conn, 200, File.read!("output/index.html"))
  end

  # Handling requests for static files not caught by Plug.Static, such as HTML files not named index.html
  get "/*path" do
    path = conn.params["path"] |> Enum.join("/")

    static_file_path = Path.join([File.cwd!(), "output", path])

    if File.exists?(static_file_path) do
      send_file(conn, 200, static_file_path)
    else
      send_resp(conn, 404, "Not Found")
    end
  end
end
