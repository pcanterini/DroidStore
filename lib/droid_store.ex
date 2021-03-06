defmodule DroidStore do
  use GenServer

  # Server API
  def start_link(droids) do
    GenServer.start_link(__MODULE__, droids)
  end

  def handle_call(:list, _from, current_droids) do
    {:reply, current_droids, current_droids}
  end

  def handle_call({:add, droid}, _from, current_droids) do
    droids = [ droid | current_droids ]
    {:reply, droids, droids}
  end

  def handle_call({:remove, droid}, _from, current_droids) do
    case droid in current_droids do
      true ->
         droids = List.delete(current_droids, droid)
        {:reply, {:ok, droids}, droids}
      false ->
        {:reply, :not_found, current_droids}
    end
  end

  def handle_cast({:stop, reason}, droids) do
    {:stop, reason, droids}
  end

  def terminate(reason, _droids) do
    # your final chance to do something
    IO.puts "Closing for #{reason}"
    :ok
  end

  # Client API
  def init(droids) do
    IO.puts "initializing store..."
    {:ok, droids}
  end

  def list(srv_pid) do
    GenServer.call(srv_pid, :list)
  end

  def add(srv_pid, droid) do
    GenServer.call(srv_pid, {:add, droid})  
  end

  def remove(srv_pid, droid) do
    GenServer.call(srv_pid, {:remove, droid})
  end

  def close(srv_pid, reason) do
    GenServer.cast(srv_pid, {:stop, reason}) 
  end
end
