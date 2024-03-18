defmodule StaticSite.Index do
  alias StaticSite.Page

  use NimblePublisher,
    build: Page,
    from: "content_src/index.md",
    as: :index

  def content, do: @index
end
