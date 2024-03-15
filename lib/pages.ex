defmodule StaticSite.Pages do
  alias StaticSite.Page

  use NimblePublisher,
    build: Page,
    from: "./content_src/pages/**/*.md",
    as: :pages,
    highlighters: [:makeup_elixir, :makeup_erlang]

  # And finally export them
  def all_pages, do: @pages
end
