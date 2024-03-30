defmodule StaticSite do
  use Phoenix.Component
  import Phoenix.HTML

  embed_templates("../content_src/html/*")

  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  def build() do
    site_config = site_config()

    posts = StaticSite.Blog.all_posts()
    pages = StaticSite.Pages.all_pages()
    tags = StaticSite.Blog.all_tags()
    events = StaticSite.Events.all_events()
    [index_html] = StaticSite.Index.content()

    render_file(
      "index.html",
      index(%{
        index_html: index_html.body,
        posts: posts,
        site_config: site_config,
        wrapper_class: nil,
        tags: tags,
        description: index_html.description
      })
    )

    render_file(
      "blog.html",
      blog(%{
        posts: posts,
        site_config: site_config,
        wrapper_class: nil,
        tags: tags,
        description: "Blog posts"
      })
    )

    render_file(
      "tags.html",
      tags(%{site_config: site_config, tags: tags, description: "Tags"})
    )

    File.mkdir_p!(Path.join([@output_dir, "tags"]))

    Enum.each(
      tags,
      fn {tag, _} ->
        render_file(
          "/tags/#{tag}.html",
          tag(%{
            posts: StaticSite.Blog.filter_posts_by_tag(tag),
            site_config: site_config,
            wrapper_class: nil,
            tag: tag,
            tags: tags,
            description: "Posts tagged as #{tag |> String.capitalize()}"
          })
        )
      end
    )

    for post <- posts do
      dir = Path.dirname(post.path)

      if dir != "." do
        File.mkdir_p!(Path.join([@output_dir, dir]))
      end

      render_file(
        post.path,
        post(%{
          post: post,
          site_config: site_config,
          wrapper_class:
            Map.get(post, :wrapper_class, nil) ||
              "prose lg:prose-lg mx-auto p-10 sm:px-20 md:px-0"
        })
      )
    end

    for page <- pages do
      dir = Path.dirname(page.path)

      if dir != "." do
        File.mkdir_p!(Path.join([@output_dir, dir]))
      end

      render_file(
        page.path,
        page(%{
          page: page,
          site_config: site_config,
          wrapper_class:
            Map.get(page, :wrapper_class, nil) ||
              "prose lg:prose-lg mx-auto p-10 sm:px-20 md:px-0"
        })
      )
    end

    render_file(
      "events.html",
      events(%{
        events: events,
        site_config: site_config,
        wrapper_class: "mx-auto p-6 xl:w-8/12",
        description: "Events Calendar"
      })
    )

    for event <- events do
      dir = Path.dirname(event.path)

      if dir != "." do
        File.mkdir_p!(Path.join([@output_dir, dir]))
      end

      render_file(
        event.path,
        event(%{
          event: event,
          site_config: site_config,
          wrapper_class:
            Map.get(event, :wrapper_class, nil) ||
              "prose lg:prose-lg mx-auto p-10 sm:px-20 md:px-0"
        })
      )
    end

    :ok
  end

  def render_file(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    output = Path.join([@output_dir, path])
    File.write!(output, safe)
  end

  def site_config do
    path = Path.join(File.cwd!(), "content_src/site_config.yml")

    case YamlElixir.read_from_file(path) do
      {:ok, config} ->
        config

      _ ->
        raise("failed to parse config")
    end
  end

  defp render_sub_or_link(%{"url" => url, "label" => label}) do
    "<li><a class='font-bold' href='#{url}'>#{label}</a></li>"
  end

  defp render_sub_or_link(%{"children" => children, "label" => label}) do
    """
    <li class="dropdown dropdown-hover mt-[2px]">
      <div tabindex="0" role="button" class="btn btn-ghost rounded-btn btn-sm">#{label}</div>
      <ul tabindex="0" class="dropdown-content bg-base-100 p-3 pt-4">
        #{for %{"url" => _url} = link <- children do
      render_sub_or_link(link)
    end}
      </ul>
    </li>
    """
  end

  defp render_sub_or_link_mobile(%{"url" => url, "label" => label}) do
    "<li><a href='#{url}'>#{label}</a></li>"
  end

  defp render_sub_or_link_mobile(%{"children" => children, "label" => label}) do
    """
    <li>
      <a>#{label}</a>
      <ul class="p-2">
        #{for %{"url" => _url} = link <- children do
      render_sub_or_link_mobile(link)
    end}
      </ul>
    </li>
    """
  end

  defp render_tags(assigns) do
    ~H"""
    <%= for tag <- @tags do %>
      <a
        href={"/tags/#{tag}.html"}
        class="my-2 no-underline hover:bg-primary hover:text-primary-content badge badge-outline hover:badge-primary-content"
      >
        <%= tag %>
      </a>
    <% end %>
    """
  end

  defp render_post(assigns) do
    ~H"""
    <article class="flex flex-col items-start">
      <div class="max-w-xl">
        <div class="relative">
          <h3 class="my-4 text-2xl font-black leading-6">
            <a class="hover:text-secondary" href={"/#{@post.path}"}>
              <%= @post.title %>
            </a>
          </h3>
          <.render_tags tags={@post.tags} />
          <div>
            <span class="text-accent">Published:</span>
            <time datetime={@post.date}><%= @post.date %></time>
          </div>
          <p class="mt-5 line-clamp-3 text-sm leading-6 "><%= @post.description %></p>
        </div>
      </div>
    </article>
    """
  end

  defp render_tag_list(assigns) do
    ~H"""
    <div class="flex flex-wrap my-2">
      <%= for {tag, count} <- @tags do %>
        <a class={["m-2 btn btn-sm", @tag == tag && "btn-primary"]} href={"/tags/#{tag}.html"}>
          <%= tag |> String.capitalize() %>
          <div class="badge"><%= count %></div>
        </a>
      <% end %>
    </div>
    """
  end
end
