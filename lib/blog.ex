defmodule StaticSite.Blog do
  alias StaticSite.Post

  use NimblePublisher,
    build: Post,
    from: "./content_src/posts/**/*.md",
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
  @tags @posts |> Enum.map(& &1.tags) |> List.flatten() |> Enum.frequencies() |> Enum.sort()

  @spec all_posts() :: [
          %StaticSite.Post{
            author: <<_::104>>,
            body: <<_::64, _::_*8>>,
            date: Date.t(),
            description: <<_::64, _::_*8>>,
            id: <<_::64, _::_*8>>,
            path: <<_::64, _::_*8>>,
            tags: [<<_::32, _::_*8>>, ...],
            title: <<_::64, _::_*8>>,
            wrapper_class: <<_::376>>
          },
          ...
        ]
  def all_posts, do: @posts
  def all_tags, do: @tags

  def filter_posts_by_tag(tag) do
    Enum.filter(@posts, fn post ->
      tag in post.tags
    end)
  end

  def recent_posts(num \\ 3), do: Enum.take(all_posts(), num)
end
