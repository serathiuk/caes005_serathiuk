defmodule TakeANumberDeluxe do
  use GenServer
  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @impl GenServer
  def init(init_arg) do
    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)
    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)

    case TakeANumberDeluxe.State.new(min_number, max_number, auto_shutdown_timeout) do
      {:ok, state} -> {:ok, state, auto_shutdown_timeout}
      {:error, error} -> {:stop, error}
    end
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.call(machine, :reset_state)
  end

  # Server callbacks
  @impl GenServer
  def handle_call(:report_state, _from, state = %{auto_shutdown_timeout: auto_shutdown_timeout}) do
    {:reply, state, state, auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state = %{auto_shutdown_timeout: auto_shutdown_timeout}) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:error, error} -> {:reply, {:error, error}, state, auto_shutdown_timeout}
      {:ok, new_number, new_state} -> {:reply, {:ok, new_number}, new_state, auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state = %{auto_shutdown_timeout: auto_shutdown_timeout}) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:error, error} -> {:reply, {:error, error}, state, auto_shutdown_timeout}
      {:ok, new_number, new_state} -> {:reply, {:ok, new_number}, new_state, auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call(:reset_state, _from, %{min_number: minn, max_number: maxn, auto_shutdown_timeout: asd}) do
    {:ok, new_state} = TakeANumberDeluxe.State.new(minn, maxn, asd)
    {:reply, :ok, new_state, asd}
  end

  @impl GenServer
  def handle_info(:timeout, _) do
    exit(:normal)
  end

  @impl GenServer
  def handle_info(_, state = %{auto_shutdown_timeout: auto_shutdown_timeout}) do
    {:noreply, state, auto_shutdown_timeout}
  end

end
