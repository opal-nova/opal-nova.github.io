defmodule FileWatcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:ok, pid} = FileSystem.start_link(dirs: ["/home/josh/Dev/barebones/content_src/"])
    FileSystem.subscribe(pid)
    {:ok, %{watcher_pid: pid}}
  end

  def handle_info(
        {:file_event, watcher_pid, {_path, [:modified, :closed]}},
        %{watcher_pid: watcher_pid} = state
      ) do
    # Your own logic for path and events
    if Code.ensure_loaded?(Mix) do
      # Running the site.build task without any arguments
      {micro, :ok} =
        :timer.tc(fn ->
          Mix.Task.run("site.build")
          Mix.Task.reenable("site.build")
        end)

      ms = micro / 1000
      IO.puts("BUILT in #{ms}ms")
    else
      IO.puts("Mix is not available")
    end

    {:noreply, state}
  end

  def handle_info(
        {:file_event, watcher_pid, {_path, events}},
        %{watcher_pid: watcher_pid} = state
      ) do
    dbg(events)
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    # Your own logic when monitor stop
    {:noreply, state}
  end
end
