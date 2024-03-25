defmodule CalendarGenerator do
  def generate_calendar_year(year, events) do
    1..12
    |> Enum.map(fn month -> generate_calendar_days(month, year, events) end)
  end

  defp generate_calendar_days(month, year, events) do
    {:ok, first_day} = Date.new(year, month, 1)
    last_day = Date.end_of_month(first_day)
    start_day_of_calendar = first_day |> Date.add(-(Date.day_of_week(first_day) |> rem(7)))
    end_day_of_calendar = last_day |> Date.add(6 - rem(Date.day_of_week(last_day), 7))
    days = Enum.to_list(Date.range(start_day_of_calendar, end_day_of_calendar))

    Enum.map(days, fn day ->
      if Date.compare(day, first_day) in [:lt] or Date.compare(day, last_day) in [:gt] do
        {:outside, day.day, nil}
      else
        cond do
          has_event?(day, events) -> {:event, day.day, set_events(day, events)}
          true -> {:inside, day.day, nil}
        end
      end
    end)
  end

  defp set_events(day, events) do
    Enum.filter(events, fn event ->
      start_date = parse_iso8601_to_date(event.start_datetime)
      end_date = parse_iso8601_to_date(event.end_datetime)
      Date.compare(day, start_date) in [:eq, :gt] and Date.compare(day, end_date) in [:eq, :lt]
    end)
    |> dbg()
  end

  defp has_event?(day, events) do
    Enum.any?(events, fn event ->
      dbg(day)
      start_date = parse_iso8601_to_date(event.start_datetime) |> dbg()
      end_date = parse_iso8601_to_date(event.end_datetime) |> dbg()
      (Date.compare(day, start_date) in [:eq, :gt] and Date.compare(day, end_date) in [:eq, :lt])
      |> dbg()
    end)
  end

  defp parse_iso8601_to_date(iso8601_string) do
    case DateTime.from_iso8601(iso8601_string) do
      {:ok, datetime, _offset} -> DateTime.to_date(datetime)
      _error -> nil
    end
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

  def day_of_week_to_string(day_of_week) do
    ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    |> Enum.at(day_of_week - 1)
  end

  def ordinal(day) do
    case [day, rem(day, 10), rem(day, 100)] do
      [1, 1, _] -> "1st"
      [2, 2, _] -> "2nd"
      [3, 3, _] -> "3rd"
      [_, 1, 11] -> "#{day}th"
      [_, 2, 12] -> "#{day}th"
      [_, 3, 13] -> "#{day}th"
      _ -> "#{day}th"
    end
  end

  def format_datetime_iso8601(iso8601_string) do
    {:ok, datetime, 0} = DateTime.from_iso8601(iso8601_string) |> dbg()
    Calendar.strftime(datetime, "%A, %B %d %Y %I:%M %p")
  end

  # def parse_and_format(datetime_string) do
  #   case parse_simple_datetime(datetime_string) do
  #     {:ok, datetime} ->
  #       Calendar.strftime(datetime, "%a, %b %d %Y at %H:%M %Z")
  #     :error ->
  #       {:error, "Invalid datetime format"}
  #   end
  # end

  # Parses a "YYYY-MM-DD HH:MM" formatted string into a DateTime struct
  # defp parse_simple_datetime(datetime_string) do
  #   with [date_part, time_part] <- String.split(datetime_string, " "),
  #        [year, month, day] <- String.split(date_part, "-") |> Enum.map(&String.to_integer/1),
  #        [hour, minute] <- String.split(time_part, ":") |> Enum.map(&String.to_integer/1),
  #        {:ok, date} <- Date.new(year, month, day),
  #        true <- Time.validate(hour, minute, 0) do
  #     datetime = DateTime.new(date, Time.new!(hour, minute, 0), "Etc/UTC")
  #     {:ok, datetime}
  #   else
  #     _ -> :error
  #   end
  # end
end
