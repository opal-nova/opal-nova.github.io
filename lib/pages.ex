defmodule StaticSite.Pages do
  alias StaticSite.Page

  use NimblePublisher,
    build: Page,
    from: "./content_src/pages/**/*.md",
    as: :pages,
    highlighters: [:makeup_elixir, :makeup_erlang]

  # And finally export them
  def all_pages, do: @pages

  def full_nav do
    path = Path.join(File.cwd!(), "content_src/nav_config.yml")

    case YamlElixir.read_from_file(path) do
      {:ok, %{"items" => items}} ->
        items

      _ ->
        []
    end
  end
end
