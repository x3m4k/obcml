-- tested version: 5.3.5
local table = {
  ["1"] = -1, ["2"] = -1, ["3"] = -1,
  ["4"] = -1, ["5"] = -1, ["6"] = -1,
  ["7"] = -1, ["8"] = -1, ["9"] = -1
}

local function TableCopy(table)
  -- do not provides deep copy mechanism
  new = {}

  for k, v in pairs(table) do
    new[k] = v
  end

  return new
end

local empty_table = TableCopy(table)

local player = false

local function GetPlayerNum()
  if player then return 1 else return 0 end
end

local function PrintTable()
  function Format(x, i)
    if x == 0 then
      return "O"
    elseif x == 1 then
      return "X"
    end
    return tostring(i)
  end

  buffer = ""

  for i=1, 9 do

    newline = ""
    if i % 3 == 0 then
      newline = "\n"
    end

    buffer = buffer .. "|" .. Format(table[tostring(i)], i) .. "|" .. newline
  end

  print(buffer)
end

local function CheckForWin()
  pnum = GetPlayerNum()

  function CheckVertical(offset)
    return (
      table[tostring(offset)] == pnum and
      table[tostring(offset + 3)] == pnum and
      table[tostring(offset + 6)] == pnum
    )
  end

  function CheckHorizontal(offset)
    return (
      table[tostring(offset)] == pnum and
      table[tostring(offset + 1)] == pnum and
      table[tostring(offset + 2)] == pnum
    )
  end

  function CheckDiagonal()
    return (
      table["1"] == pnum and table["5"] == pnum and table["9"] == pnum
    ) or (
      table["3"] == pnum and table["5"] == pnum and table["7"] == pnum
    )
  end

  vertical = false
  horizontal = false
  diagonal = CheckDiagonal()

  for i=1, 4 do
    if CheckVertical(i) then
      vertical = true
      break
    end
  end

  for i=1, 10, 3 do
    if CheckHorizontal(i) then
      horizontal = true
      break
    end
  end

  return vertical or horizontal or diagonal

end

local function HasValue(tb, value)
  for i, v in ipairs(tb) do
    if value == v then return true end
  end
  return false
end

local function CheckForTie()
  for i=1, 9 do
    if table[tostring(i)] == -1 then
      return false
    end
  end
  return true
end

local loop = true

while loop do
  while true do

    PrintTable()

    print("Turn: Player " .. GetPlayerNum() + 1 .. ".")
    print("\nPos: ")

    -- repeat
    x = io.read()
    -- until HasValue({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, x)

    if not HasValue({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, x) then
      print("Err: Invalid pos.")
    else

      field = table[x]

      if field ~= -1 then
        print("Err: This field is taken.")
      else

        table[x] = GetPlayerNum()

        if CheckForWin() then
          PrintTable()
          print("Player " .. GetPlayerNum()+1 .. " wins!")
          break
        end

        if CheckForTie() then
          PrintTable()
          print("Tie!")
          break
        end

        player = not player

      end

    end
  end

  while true do
    print("Play again? (1/0): ")
    x = io.read()

    if x == "1" then
      table = TableCopy(empty_table)
      player = false
      break
    elseif x == "0" then
      loop = false
      print("Goodbye!")
      break
    end
  end
end
