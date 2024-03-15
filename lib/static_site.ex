defmodule StaticSite do
  use Phoenix.Component
  import Phoenix.HTML

  embed_templates("html/*")

  def post(assigns) do
    ~H"""
    <.layout site_config={@site_config} wrapper_class={@wrapper_class} title={@post.title} description={@post.description}>
      <h1><%= @post.title %></h1>
      <p>
        <.render_tags tags={@post.tags} />
        <span class="block">Publish: <%= raw @post.date |> Calendar.strftime("%a, %B %d %Y") %></span>
      </p>
      <hr />
      <%= raw @post.body %>
    </.layout>
    """
  end

  def page(assigns) do
    ~H"""
    <.layout site_config={@site_config} wrapper_class={@wrapper_class} title={@page.title} description={@page.description}>
      <%= raw @page.body %>
    </.layout>
    """
  end

  @spec index(any()) :: Phoenix.LiveView.Rendered.t()
  def index(assigns) do
    ~H"""
    <.layout site_config={@site_config} wrapper_class={@wrapper_class} title="Home Page" description="A cultural wasteland for my narcissism" >
      <!-- Hero content -->
      <div class="relative isolate overflow-hidden h-screen">
        <img src="/assets/images/dog.webp" alt=""
          class="absolute inset-0 -z-10 h-full w-full object-top object-cover opacity-[.15] h-screen" />
        <div class="mx-auto max-w-3xl pt-8 pt-64">
          <div class="text-center">
            <h1 class="text-4xl font-black text-base-content tracking-tight sm:text-4xl">
              A little garden
            </h1>
          </div>
        </div>
      </div>

      <!-- Blog section -->
      <div class="py-24 sm:py-42 mb-52">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">Latest Posts</h2>
          </div>

          <.render_tag_list tags={@tags} tag={nil}/>

          <div class="mx-auto mt-16 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-20 lg:mx-0 lg:max-w-none lg:grid-cols-3">
            <%= for post <- @posts do %>
              <.render_post post={post} />
            <% end %>
          </div>
        </div>
      </div>

      <!-- temp button for drawer -->
      <%!-- <label for="mobile-drawer" class="btn btn-primary drawer-button">Open drawer</label> --%>
    </.layout>
    """
  end

  def blog(assigns) do
    ~H"""
    <.layout site_config={@site_config} wrapper_class={@wrapper_class} title="Blog" description="The latest rants of a idiot">

      <!-- Blog section -->
      <div class="py-24 sm:py-42 mb-52">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">Latest Posts</h2>
          </div>

          <.render_tag_list tags={@tags} tag={nil} />

          <div class="mx-auto mt-16 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-20 lg:mx-0 lg:max-w-none lg:grid-cols-3">

            <%= for post <- @posts do %>
              <.render_post post={post} />
            <% end %>

          </div>
        </div>
      </div>

      <!-- temp button for drawer -->
      <%!-- <label for="mobile-drawer" class="btn btn-primary drawer-button">Open drawer</label> --%>
    </.layout>
    """
  end

  def tag(assigns) do
    ~H"""
    <.layout site_config={@site_config} wrapper_class={@wrapper_class} title={"#{@tag |> String.capitalize()} Tag"} description={"Posts taged as #{@tag |> String.capitalize()}"}>

      <!-- Blog section -->
      <div class="py-24 sm:py-42 mb-52">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">Latest Posts tagged <%= @tag %></h2>
          </div>
          <.render_tag_list tags={@tags} tag={@tag} />
          <div class="mx-auto mt-16 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-20 lg:mx-0 lg:max-w-none lg:grid-cols-3">
            <%= for post <- @posts do %>
              <.render_post post={post} />
            <% end %>
          </div>
        </div>
      </div>

      <!-- temp button for drawer -->
      <%!-- <label for="mobile-drawer" class="btn btn-primary drawer-button">Open drawer</label> --%>
    </.layout>
    """
  end

  def tags(assigns) do
    ~H"""
    <.layout site_config={@site_config} wrapper_class={""} title="Tags" description="Tags">

      <!-- Blog section -->
      <div class="py-24 sm:py-42 mb-52">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">Tags:</h2>
          </div>
          <div class="mx-auto mt-16 max-w-2xl">

            <%= for {tag, count} <- @tags do %>
            <article class="flex flex-col items-start">
              <div class="max-w-xl">
                <div class="group relative">
                  <h3 class="mt-3 text-lg font-semibold leading-6 group-hover:text-base-300">
                    <a href={"/tags/#{tag}.html"}>
                    <div class="badge"><%= count %></div> <%=  tag |> String.capitalize() %>
                    </a>
                  </h3>
                </div>
              </div>
            </article>
            <% end %>

          </div>
        </div>
      </div>

      <!-- temp button for drawer -->
      <%!-- <label for="mobile-drawer" class="btn btn-primary drawer-button">Open drawer</label> --%>
    </.layout>
    """
  end

  @output_dir "./output"
  File.mkdir_p!(@output_dir)

  def build() do
    posts = StaticSite.Blog.all_posts()
    pages = StaticSite.Pages.all_pages()
    site_config = site_config()
    tags = StaticSite.Blog.all_tags()

    render_file(
      "index.html",
      index(%{
        posts: posts,
        pages: pages,
        site_config: site_config,
        wrapper_class: nil,
        tags: tags
      })
    )

    render_file(
      "blog.html",
      blog(%{posts: posts, pages: pages, site_config: site_config, wrapper_class: nil, tags: tags})
    )

    render_file(
      "tags.html",
      tags(%{site_config: site_config, tags: tags})
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
            tags: tags
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
              "prose lg:prose-lg mx-auto p-10 md:px-20 md:px-0"
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
              "prose lg:prose-lg mx-auto p-10 md:px-20 md:px-0"
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
      <a href={"/tags/#{tag}.html"} class="my-2 no-underline hover:bg-primary hover:text-primary-content badge badge-outline hover:badge-primary-content"><%= tag %></a>
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
          <.render_tags tags={@post.tags}/>
          <div><span class="text-accent">Published:</span> <time datetime={ @post.date }><%= @post.date %></time></div>
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
      <a class={["m-2 btn btn-sm", @tag == tag && "btn-primary"]} href={"/tags/#{tag}.html"}><%= tag |> String.capitalize() %><div class="badge"><%= count %></div></a>
    <% end %>
    </div>
    """
  end
end
