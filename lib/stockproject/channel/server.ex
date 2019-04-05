defmodule Stockproject.Server do
  use GenServer

  def start(name) do
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [name]},
      restart: :permanent,
      type: :worker,
    }
  #  Stockproject.Sup.start_child(spec)
  end

  def reg(name) do
    {:via, Registry, {Stockproject.Reg, name}}
  end

  def start_link(name) do
    state = get_state(name) || %{}
    GenServer.start_link(__MODULE__, state, name: reg(name))
  end

  def get_state(name) do
    GenServer.call(reg(name), :get_state)
  end

  def user_join(name) do
    GenServer.call(reg(name), :user_join)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_state, _from, states) do
    {:reply, states, states}
  end

  def handle_call({:user_join, stock}, _from, states) do
    if (states[stock]) do
      state = Map.put(states, stock, states[stock]+1)
      {:reply, state, state}
    else
      state = Map.put(states, stock, 1)
      {:reply, state, state}
    end
  end
end
