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
        posts: events,
        site_config: site_config,
        wrapper_class: "mx-auto p-6 xl:w-8/12",
        description: "Events Calendar"
      })
    )

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

  # def generate_calendar_days(month, year) do
  #   {:ok, first_day_of_month} = Date.new(year, month, 1)
  #   last_day_of_month = Date.end_of_month(first_day_of_month)
  #   last_day_of_month = Date.add(last_day_of_month, 1)

  #   # Calculate the first day to display on the calendar
  #   first_day_to_show = first_day_of_month
  #   |> Date.beginning_of_week(:sunday)

  #   # Calculate the last day to display on the calendar
  #   last_day_to_show = last_day_of_month
  #   |> Date.end_of_week(:sunday)

  #   Enum.map(Date.range(first_day_to_show, last_day_to_show), fn date ->
  #     date.day
  #   end)
  # end

  # def generate_calendar_days(month, year) do
  #   # Calculate the first and last day of the month
  #   {:ok, first_day_of_month} = Date.new(year, month, 1)
  #   last_day_of_month = Date.add(Date.end_of_month(first_day_of_month), 0)

  #   # Calculate padding for the start of the month
  #   first_day_padding = Enum.map(1..(first_day_of_month |> Date.day_of_week() |> rem(7)), fn _ -> :outside end)

  #   # Days of the month
  #   days_of_month = Enum.map(1..Calendar.ISO.days_in_month(year, month), fn day -> {:inside, day} end)

  #   # Calculate padding for the end of the month
  #   last_day_padding = Enum.map(1..(7 - rem(last_day_of_month |> Date.day_of_week(), 7)), fn _ -> :outside end)

  #   # Combine all parts
  #   Enum.concat([first_day_padding, days_of_month, last_day_padding])
  # end

  def generate_calendar_days(month, year) do
    # Determine the first and last date of the month
    {:ok, first_day} = Date.new(year, month, 1)
    last_day = Date.end_of_month(first_day)

    # Calculate start of the calendar view
    start_day_of_calendar = first_day |> Date.add(-(first_day |> Date.day_of_week() |> rem(7)))

    # Calculate end of the calendar view
    end_day_of_calendar = last_day |> Date.add(6 - rem(last_day |> Date.day_of_week(), 7))

    # Generate all days for the calendar view
    days = Enum.to_list(Date.range(start_day_of_calendar, end_day_of_calendar))

    # Mark each day as :inside or :outside the month
    Enum.map(days, fn day ->
      if Date.compare(day, first_day) in [:lt] or Date.compare(day, last_day) in [:gt] do
        {:outside, day.day}
      else
        {:inside, day.day}
      end
    end)
  end

  def month_number_from_name(name) do
    case name do
      "January" -> 1
      "February" -> 2
      "March" -> 3
      "April" -> 4
      "May" -> 5
      "June" -> 6
      "July" -> 7
      "August" -> 8
      "September" -> 9
      "October" -> 10
      "November" -> 11
      "December" -> 12
      _ -> raise ArgumentError, message: "#{name} is not a valid month name"
    end
  end

  def month_name_from_number(number) do
    case number do
      1 -> "January"
      2 -> "February"
      3 -> "March"
      4 -> "April"
      5 -> "May"
      6 -> "June"
      7 -> "July"
      8 -> "August"
      9 -> "September"
      10 -> "October"
      11 -> "November"
      12 -> "December"
      _ -> raise ArgumentError, message: "#{number} is not a valid month"
    end
  end
end
