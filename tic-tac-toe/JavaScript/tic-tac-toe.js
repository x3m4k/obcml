// start this with your browser
let table = {
	"1": -1,
	"2": -1,
	"3": -1,
	"4": -1,
	"5": -1,
	"6": -1,
	"7": -1,
	"8": -1,
	"9": -1
}

let empty_table = {
	...table
}

let player = false

function str(x)
{
	return '' + x // any -> str
}

function getPlayerNum()
{
	return player ? 1 : 0
}

function printTable()
{
	function format(x, i)
	{
		if (x == 0)
		{
			return "O"
		}
		else if (x == 1)
		{
			return "X"
		}
		return str(i)
	}

	let buffer = ""

	for (let i = 1; i < 10; i++)
	{
		buffer = buffer + `|${format(table[str(i)], i)}|`

		if (i % 3 == 0)
		{
			console.log(buffer)
			buffer = ""
		}
	}
}

function checkForWin()
{
	let i
	let pnum = getPlayerNum()

	function checkVertical(offset)
	{
		return (
			table[str(offset)] == pnum &&
			table[str(offset + 3)] == pnum &&
			table[str(offset + 6)] == pnum
		)
	}

	function checkHorizontal(offset)
	{
		return (
			table[str(offset)] == pnum &&
			table[str(offset + 1)] == pnum &&
			table[str(offset + 2)] == pnum
		)
	}

	function checkDiagonal()
	{
		return (
			table["1"] == pnum && table["5"] == pnum && table["9"] == pnum
		) || (
			table["3"] == pnum && table["5"] == pnum && table["7"] == pnum
		)
	}

	let vertical, horizontal, diagonal

	for (i = 1; i < 5; i++)
	{
		if (checkVertical(i))
		{
			vertical = true
			break
		}
	}

	for (i = 1; i < 10; i = i + 3)
	{
		if (checkHorizontal(i))
		{
			horizontal = true
			break
		}
	}

	diagonal = checkDiagonal()

	return vertical || horizontal || diagonal
}

function checkForTie()
{
	for (var e in table)
	{
		if (table[e] == -1)
		{
			return false
		}
	}
	return true
}

let loop = true

while (loop)
{
	while (true)
	{
		printTable()

		console.log(`Turn: Player ${player+1}.`)
		let x = prompt("Pos: ")

		f = table[x]

		if (f == undefined)
		{
			console.log("Err: Invalid pos.")
			continue
		}

		if (f != -1)
		{
			console.log("Err: This field is taken.")
			continue
		}

		table[x] = getPlayerNum()

		if (checkForWin())
		{
			printTable()
			console.log(`Player ${player+1} wins!`)
			break
		}

		if (checkForTie())
		{
			printTable()
			console.log("Tie!")
			break
		}

		player = !player

	}

	while (true)
	{
		x = prompt("Play again? (1/0): ")

		if (x == "1")
		{
			table = {
				...empty_table
			}
			player = false
			break
		}
		else if (x == "0")
		{
			loop = false
			console.log("Goodbye!")
			break
		}
	}
}
