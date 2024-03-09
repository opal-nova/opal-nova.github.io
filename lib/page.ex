defmodule StaticSite.Page do
  @enforce_keys [:id, :author, :title, :body, :description, :tags, :path]
  defstruct [:id, :author, :title, :body, :description, :tags, :path, :wrapper_class]

  def build(filename, attrs, body) do
    path = Path.rootname(filename)

    ["content_src" | ["pages" | split_path]] = path |> Path.split()
    id = split_path |> List.last()

    path = Enum.join(split_path, "/") <> ".html"

    struct!(__MODULE__, [id: id, body: body, path: path] ++ Map.to_list(attrs))
  end
end
