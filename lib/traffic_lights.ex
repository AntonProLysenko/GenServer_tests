defmodule TrafficLights do

  defmodule Lights do
    use GenServer
    @lights [:green, :yellow, :red]
    @moduledoc """
    Documentation for `TrafficLights`.
    """

    def start(_cond) do
      GenServer.start_link(__MODULE__, 0)
    end

    def transition(pid) do
      GenServer.cast(pid, :next)
    end

    def read(pid) do
      GenServer.call(pid, :read)
    end


    ##################################################

    @impl true
    @spec init(any()) :: {:ok, any()}
    def init(state\\0) do
      {:ok, state}
    end

    @impl true
    @spec handle_cast(:next, number()) :: {:noreply, number()}
    def handle_cast(:next, state) do
      next_state =
        if state <=1 do
          state+1
        else
          0
        end
      {:noreply, next_state}
    end


    @impl true
    @spec handle_call(:read, any(), integer()) :: {:reply, any(), integer()}
    def handle_call(:read, _sender, state)do
      light_color = Enum.at(@lights,state)
      {:reply, light_color, state}
    end


  end

  defmodule Grid do
    use GenServer
    def start(_opts)do
      GenServer.start_link(__MODULE__, 0)
    end

    def transition(pid) do
      GenServer.cast(pid, :next)
    end

    def read(pid) do
      GenServer.call(pid, :read)
    end
    #######################################

    @impl true
    def init(_state) do
      light_pids =
        Enum.map(1..5, fn _tr_light->
          {:ok, pid} = TrafficLights.Lights.start([])
          pid
        end)
        {:ok, %{pids: light_pids, idx: 0 }}
    end

    @impl true
    def handle_cast(:next, state)do
      current_light = Enum.at(state.pids, state.idx)
      TrafficLights.Lights.transition(current_light)

      next_idx =
        if state.idx <4 do
        state.idx+1
        else
          0
        end
      {:noreply, %{pids: state.pids, idx: next_idx}}
    end

    @impl true
    def handle_call(:read, _from, state) do
      colors = Enum.map(state.pids, fn pid -> TrafficLights.Lights.read(pid)end)
      {:reply, colors, state}
    end


  end

end
