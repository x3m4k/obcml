defmodule Game do
  defp locale_pos(n, pos) do
    case n do
      -1 -> IO.ANSI.green() <> to_string(pos) <> IO.ANSI.reset()
      0 -> IO.ANSI.bright() <> "O" <> IO.ANSI.reset()
      1 -> IO.ANSI.bright() <> "X" <> IO.ANSI.reset()
    end
  end

  defp translate_pos(x) do
    String.to_atom(to_string(x))
  end

  defp translate_player(x) do
    if !x, do: 0, else: 1
  end

  defp tie?(table) do
    Enum.all?(
      table,
      fn x -> List.last(Tuple.to_list(x)) != -1 end
    )
  end

  defp to_green(string) do
    IO.ANSI.green() <> string <> IO.ANSI.reset()
  end

  defp to_red(string) do
    IO.ANSI.red() <> string <> IO.ANSI.reset()
  end

  defp vertical_win?(table, player, offset) do
    player_num = translate_player(player)

    table[translate_pos(offset)] == player_num &&
      table[translate_pos(offset + 3)] == player_num &&
      table[translate_pos(offset + 6)] == player_num
  end

  defp diagonal_win?(table, player) do
    player_num = translate_player(player)

    (table[translate_pos(1)] == player_num &&
       table[translate_pos(5)] == player_num &&
       table[translate_pos(9)] == player_num) ||
      (table[translate_pos(3)] == player_num &&
         table[translate_pos(5)] == player_num &&
         table[translate_pos(7)] == player_num)
  end

  defp horizontal_win?(table, player, offset) do
    player_num = translate_player(player)

    table[translate_pos(offset)] == player_num &&
      table[translate_pos(offset + 1)] == player_num &&
      table[translate_pos(offset + 2)] == player_num
  end

  defp player_won?(table, player) do
    vertical =
      vertical_win?(table, player, 1) ||
        vertical_win?(table, player, 2) ||
        vertical_win?(table, player, 3)

    horizontal =
      horizontal_win?(table, player, 1) ||
        horizontal_win?(table, player, 4) ||
        horizontal_win?(table, player, 7)

    diagonal = diagonal_win?(table, player)
    vertical || horizontal || diagonal
  end

  defp draw_table(table) do
    len = length(table)

    Enum.each(
      1..len,
      fn x ->
        newline = if rem(x, 3) == 0, do: "\n", else: ""

        IO.write("|#{locale_pos(table[translate_pos(x)], x)}|" <> newline)
      end
    )
  end

  def start(state \\ true) do
    if state do
      loop()
    else
      x = String.replace(IO.gets("Play again? (1/0): "), "\n", "")

      if x != "1" && x != "0" do
        IO.puts(to_red("Err: Enter 1 or 0."))
        start(false)
      else
        if x == "1" do
          loop()
        else
          IO.puts(to_green("Goodbye!"))
        end
      end
    end
  end

  defp loop(player \\ false, table \\ []) do
    table =
      if length(table) == 0,
        do: [
          "1": -1,
          "2": -1,
          "3": -1,
          "4": -1,
          "5": -1,
          "6": -1,
          "7": -1,
          "8": -1,
          "9": -1
        ],
        else: table

    draw_table(table)
    player_text = "Turn: Player " <> if !player, do: "1", else: "2"

    IO.puts(player_text)
    pos = String.replace(IO.gets("\nPos: "), "\n", "")

    check =
      try do
        String.to_integer(pos)
      rescue
        _ ->
          IO.puts(to_red("Err: Invalid pos."))
          :fail
      end

    table_check =
      if check != :fail do
        field = table[translate_pos(check)]

        if field != -1 do
          IO.puts(to_red("Err: This field is taken."))
          [table, player]
        else
          [Keyword.replace(table, translate_pos(pos), translate_player(player)), !player]
        end
      else
        [table, player]
      end

    table = List.first(table_check)

    won = player_won?(table, player)

    if won == true do
      draw_table(table)
      IO.puts(to_green("Player #{translate_player(player) + 1} wins!"))
    end

    end? = won

    end? =
      if !won and tie?(table) do
        draw_table(table)
        IO.puts("Tie!")
      else
        end?
      end

    player = List.last(table_check)

    IO.puts("---")

    if !end? do
      loop(player, table)
    else
      start(false)
    end
  end
end

Game.start()
