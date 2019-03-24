defmodule Lfeview.Cell do
  require Logger

  def create_board(width, height), do: {[], width - 1, height - 1}

  def alive?({_cells, max_x, max_y}, {x, y}) when x > max_x or y > max_y or x < 0 or y < 0,
    do: false

  def alive?({cells, _, _}, cell) do
    Enum.member?(cells, cell)
  end

  def swap(board, cell) do
    if alive?(board, cell) do
      let_die(board, cell)
    else
      make_alive(board, cell)
    end
  end

  def make_alive({_cells, max_x, max_y} = board, {x, y})
      when x > max_x or y > max_y or x < 0 or y < 0,
      do: board

  def make_alive(board, cell) do
    {cells, max_x, max_y} = let_die(board, cell)
    {[cell | cells], max_x, max_y}
  end

  def let_die({_cells, max_x, max_y} = board, {x, y})
      when x > max_x or y > max_y or x < 0 or y < 0,
      do: board

  def let_die({cells, max_x, max_y}, {x, y}) do
    {cells |> List.delete({x, y}), max_x, max_y}
  end

  def neighbors({x, y}) do
    [
      {x - 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  def alife_neighbor_count(board, cell) do
    {alive?(board, cell), neighbors(cell) |> Enum.count(fn cell -> alive?(board, cell) end)}
  end

  def all_cells({_cells, max_x, max_y}) do
    for x <- 0..max_x, y <- 0..max_y, do: {x, y}
  end

  def as_rows({_cells, max_x, _max_y} = board) do
    all_cells(board)
    |> Enum.map(fn {x, y} = cell -> {x, y, alive?(board, cell)} end)
    |> Enum.chunk_every(max_x + 1)
  end

  def tick({_cells, max_x, max_y} = board) do
    new_cells =
      all_cells(board)
      |> Enum.map(fn {x, y} = cell ->
        {x, y, alife_neighbor_count(board, cell) |> life_or_death}
      end)
      |> Enum.reject(fn {_x, _y, alive} -> !alive end)
      |> Enum.map(fn {x, y, _} -> {x, y} end)

    {new_cells, max_x, max_y}
  end

  def life_or_death({true, alife_neighbors}) when alife_neighbors < 2, do: false
  def life_or_death({true, 2}), do: true
  def life_or_death({true, 3}), do: true
  def life_or_death({true, alife_neighbors}) when alife_neighbors > 3, do: false
  def life_or_death({false, 3}), do: true
  def life_or_death(_alife_neighbors), do: false
end
