#!/usr/bin/env lua
-- This whole program is a fucking mess. I will later clean it up.
-- And no, I will not make it work on Windows. Fuck Windows.
-- It might work on Mac because both Mac and Linux are unix based.
-- modules
require("drawing")
require("world")
require("graphics")

-- Sadly, lua doesn't have anything similar to getchar from c.
function getchar()
	os.execute("stty -icanon")
	local owo = io.read(1)
	os.execute("stty icanon")
	return owo
end

-- os.execute doesn't return result of operation, only true or false.
function cmd_result(c)
	local r = io.popen(c)
	local o = r:read('*a')
	local f = o:gsub("[\n\r]", "")
	return f
end

function scripts(s)
	if s == 1 then
		game_state = 2
		cutscene = 1
	elseif s == 2 then
		if not executed[1] then
			player.money = player.money + 10
			diag_num = 6
			executed[1] = true
		end
	elseif s == 3 then
		if not executed[2] then
			player.money = player.money + 10
			diag_num = 6
			executed[2] = true
		end
	end
end

-- It will be moved to separate file.
dialogs = {
	{
		{
			"Movement:",
			"w = up",
			"s = down",
			"a = left",
			"d = right",
			"i = inventory",
			"q = exit game"
		}
	},
	{
		{
			"Inventory:",
			"w = cursor up",
			"s = cursor down",
			"q = close inventory"
		}
	},
	{
		{
			"Hello, and welcome to my little",
			"shop. What do you want?",
			"a)Show me your offer.",
			"b)Nothing. Just mining my own",
			"bisnuess."
		},
		{
			"Hello, and welcome to my little shop. What do",
			"you want?",
			"a)Show me your offer.",
			"b)Nothing. Just mining my own bisnuess."
		},
		{
			"Hello, and welcome to my little shop. What do you want?",
			"a)Show me your offer.",
			"b)Nothing. Just mining my own bisnuess."
		}
	},
	{
		{
			"Take a look and buy what you",
			"currently need.",
			"w = cursor up",
			"s = cursor down",
			"b = buy one",
			"q = exit shop"
		},
		{
			"Take a look and buy what you currently need.",
			"w = cursor up",
			"s = cursor down",
			"b = buy one",
			"q = exit shop"
		}
	},
	{
		{
			"Ok. Then have a nice day.",
			"a)Bye"
		}
	},
	{
		{
			"You found 10 bucks."
		}
	},
	{
		{
			"You bought one beer."
		}
	},
	{
		{
			"You bought one lighter."
		}
	},
	{
		{
			"You bought one bread."
		}
	},
	{
		{
			"You bought knife"
		}
	},
	{
		{
			"You bought cigarettes."
		}
	}
}

-- Player object
player = {
	x = 5,
	y = 10,
	health = 100,
	inventory = {
	},
	money = 0,
	move = function(dx, dy)
		local temp1 = 0
		local temp2 = 0
		local temp3 = 0
		player.x = player.x + dx
		player.y = player.y + dy
		diag_num = 1
		if map[sub_map][player.y][player.x][1] == 1 then
			player.x = player.x - dx
			player.y = player.y - dy
		elseif map[sub_map][player.y][player.x][1] == 2 then
			sub_map = map[sub_map][player.y][player.x][2]
		elseif map[sub_map][player.y][player.x][1] == 3 then
			temp1 = map[sub_map][player.y][player.x][2]
			temp2 = map[sub_map][player.y][player.x][3]
			player.x = temp1
			player.y = temp2
		elseif map[sub_map][player.y][player.x][1] == 4 then
			temp1 = map[sub_map][player.y][player.x][2]
			temp2 = map[sub_map][player.y][player.x][3]
			temp3 = map[sub_map][player.y][player.x][4]
			sub_map = temp1
			player.x = temp2
			player.y = temp3
		elseif map[sub_map][player.y][player.x][1] == 5 then
			temp1 = map[sub_map][player.y][player.x][3]
			temp2 = map[sub_map][player.y][player.x][4]
			if not temp1 then
				player.x = player.x - dx
				player.y = player.y - dy
			end
			scripts(temp2)
		end
	end,
	add_to_inv = function(it, a)
		local it_loc = 0
		for i = 1, #player.inventory, 1 do
			if player.inventory[i][1] == it then
				it_loc = i
				break
			end
		end
		if it_loc == 0 then
			table.insert(player.inventory, {it, a})
		else
			player.inventory[it_loc][2] = player.inventory[it_loc][2] + a
		end
	end
}

action = ""
width = 0
height = 0
sub_map = 1
game_state = 0
inv_cursor = 1
cutscene = 0
offers = {
	{
		{"beer", 5},
		{"lighter", 7},
		{"bread", 10},
		{"knife", 15},
		{"Cigarettes", 20}
	}
}
executed = {false, false}
diag_num = 1
it_bought_diags  = {
	{
		7, 8, 9, 10, 11
	}
}

-- This is a bit messy. Later I will clean it up.
while true do
-- Rendering part.
	width = tonumber(cmd_result("tput cols"))
	height = tonumber(cmd_result("tput lines")) - 1
	if width < 115 or height < 45 then
		os.execute("clear")
		print("Terminal window is too small for the game. Size should be 115 columns by 45 lines.")
		print("Press any key to exit")
		getchar()
		break
	end
	os.execute("clear")
	draw_ui(width, height, player, locname[sub_map])
	os.execute("tput cup 1 1")
	if game_state == 0 then
		draw_map(map[sub_map], player)
	elseif game_state == 1 then
		draw_inv(player, inv_cursor)
	elseif game_state == 2 then
		draw_img(images[cutscene])
		diag_num = cutscene_dialogs[cutscene]
	elseif game_state == 3 then
		draw_shop(offers[1], inv_cursor)
	end
	term_test(dialogs[diag_num])
-- Code responsible for all interactions.
	os.execute("tput cup " .. height .. " 1")
	action = getchar()
	if game_state == 0 then
		if action == "w" then
			player.move(0, -1)
		elseif action == "s" then
			player.move(0, 1)
		elseif action == "a" then
			player.move(-1, 0)
		elseif action == "d" then
			player.move(1, 0)
		elseif action == "q" then
			break
		elseif action == "i" then
			diag_num = 2
			game_state = 1
		end
	elseif game_state == 1 then
		if action == "w" then
			if inv_cursor ~= 1 then
				inv_cursor = inv_cursor - 1
			end
		elseif action == "s"  then
			if inv_cursor ~= #player.inventory then
				inv_cursor = inv_cursor + 1
			end
		elseif action == "q" then
			game_state = 0
			inv_cursor = 1
			diag_num = 1
		end
	elseif game_state == 2 then
		if cutscene == 1 then
			if action == "a" then
				diag_num = 4
				game_state = 3
			elseif action == "b" then
				cutscene = 2
			end
		elseif cutscene == 2 then
			if action == "a" then
				diag_num = 1
				game_state = 0
			end
		end
	elseif game_state == 3 then
		if action == "w" then
			if inv_cursor ~= 1 then
				inv_cursor = inv_cursor - 1
			end
			diag_num = 4
		elseif action == "s" then
			if inv_cursor ~= #offers[1] then
				inv_cursor = inv_cursor + 1
			end
			diag_num = 4
		elseif action == "b" then
			if offers[1][inv_cursor][2] <= player.money then
				player.money = player.money - offers[1][inv_cursor][2]
				player.add_to_inv(offers[1][inv_cursor][1], 1)
				diag_num = it_bought_diags[1][inv_cursor]
			else
				diag_num = 4
			end
		elseif action == "q" then
			inv_cursor = 1
			game_state = 0
			diag_num = 1
		end
	end
end
os.execute("clear")
