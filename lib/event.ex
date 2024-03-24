defmodule StaticSite.Event do
  @enforce_keys [
    :id,
    :title,
    :start_datetime,
    :end_datetime,
    :location,
    :description,
    :tags,
    :path,
    :body,
    :all_day,
    :repeating
  ]
  defstruct [
    :id,
    :title,
    :start_datetime,
    :end_datetime,
    :location,
    :description,
    :tags,
    :path,
    :body,
    :all_day,
    :repeating,
    :wrapper_class
  ]

  def build(filename, attrs, body) do
    path = Path.rootname(filename)

    case path |> Path.split() do
      [_src | split_path] ->
        path = Enum.join(split_path, "/") <> ".html"
        id = split_path |> List.last()
        struct!(__MODULE__, [id: id, body: body, path: path] ++ Map.to_list(attrs))

      [_src, "index"] ->
        struct!(__MODULE__, [id: "index", body: body, path: "index.html"] ++ Map.to_list(attrs))
    end
  end
end
