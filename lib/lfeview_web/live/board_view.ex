defmodule LfeviewWeb.BoardView do
  use Phoenix.LiveView
  alias Lfeview.Cell
  require Logger

  @default_width 50
  @default_height 50

  def mount(_session, socket) do
    board = Cell.create_board(@default_width, @default_height)

    {:ok,
     socket
     |> assign(:board, board)
     |> assign(:running, false)
     |> assign(:timer, nil)
     |> assign(:generation, 0)}
  end

  def render(assigns) do
    ~L"""
     <h1>Game of Life</h1>
     <button phx-click="tick">Tick</button>
     <p>Generation: <%= @generation %></p>
     <button phx-click="clear">Clear</button>
     <button phx-click="start">Start</button>
     <button phx-click="stop">Stop</button>
     <table class="board">
      <%= for row <- Cell.as_rows(@board) do %>
        <tr>
          <%= for {x, y, alife} <- row do %>
          <td phx-click="swap-state-<%= x %>@<%= y %>" class="cell <%= if alife do "alife" else "dead" end %>"></td>
          <% end %>
        </tr>
      <% end %>
     </table>
    """
  end

  @spec handle_info(:tick, Phoenix.LiveView.Socket.t()) :: {:noreply, any()}
  def handle_info(:tick, socket) do
    if socket.assigns.running do
      {:noreply, do_tick(socket, true)}
    else
      {:noreply, do_tick(socket)}
    end
  end

  def handle_event("start", _, socket) do
    if not socket.assigns.running do
      :timer.send_after(10, self(), :tick)
      {:noreply, socket |> assign(:running, true)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("stop", _session, socket) do
    {:noreply, socket |> assign(:running, false)}
  end

  def handle_event("tick", _session, socket) do
    {:noreply, do_tick(socket)}
  end

  def handle_event("clear", _session, socket) do
    board = Cell.create_board(@default_width, @default_height)

    socket
    |> assign(:board, board)
    |> assign(:running, false)
    |> assign(:generation, 0)
  end

  def handle_event("swap-state-" <> xy, _session, socket),
    do: handle_swap(String.split(xy, "@"), socket)

  def handle_swap([x, y], socket) do
    old_board = socket.assigns.board
    cell = {String.to_integer(x), String.to_integer(y)}

    Logger.debug(fn ->
      "Will swap status of field. field=#{x}@#{y}, old_board=#{inspect(old_board)}"
    end)

    board = Cell.swap(old_board, cell)
    Logger.debug(fn -> "Did swap status of field. field=#{x}@#{y}, board=#{inspect(board)}" end)

    {:noreply,
     socket
     |> assign(:board, board)}
  end

  defp do_tick(socket, schedule_next_tick \\ false) do
    board = Cell.tick(socket.assigns.board)

    if schedule_next_tick do
      :timer.send_after(10, self(), :tick)
    end

    socket
    |> assign(:board, board)
    |> assign(:generation, socket.assigns.generation + 1)
  end
end
