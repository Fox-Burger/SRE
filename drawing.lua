function draw_ui(w, h, p, l)
	for i = 1, h, 1 do
		for j = 1, w, 1 do
			if i == 1 and j == 1 or i == h and j == w then
				io.write("/")
			elseif i == 1 and j == w or i == h and j == 1 then
				io.write("\\")
			elseif i == 42 and j == 1 or i == 42 and j == 82 or i == 1 and j == 82 or i == h and j == 82 then
				io.write("+")
			elseif i == 1 or i == 42 and j < 82 or i == h then
				io.write("-")
			elseif j == 1 or j == 82 or j == w then
				io.write("|")
			else
				io.write(" ")
			end
		end
		io.write("\n")
	end
	os.execute("tput cup 42 2")
	print("health: " .. p.health .. "%")
	os.execute("tput cup 42 41")
	print("money: " .. p.money .. "$")
	os.execute("tput cup 43 2")
	print("Location: " .. l)
end

-- There are probably better ways of doing it, but for now it will do.
function term_test(d)
	local term_size = tonumber(cmd_result("tput cols")) - 83
	local dialog_size = 0
	if #d == 1 then
		dialog_size = 1
	elseif #d == 2 then
		if term_size >= 32 and term_size < 48 then
			dialog_size = 1
		else
			dialog_size = 2
		end
	elseif #d == 3 then
		if term_size >= 32 and term_size < 48 then
			dialog_size = 1
		elseif term_size >= 48 and term_size < 64 then
			dialog_size = 2
		else
			dialog_size = 3
		end
	elseif #d == 4 then
		if term_size >= 32 and term_size < 48 then
			dialog_size = 1
		elseif term_size >= 48 and term_size < 64 then
			dialog_size = 2
		elseif term_size >= 64 and term_size < 80 then
			dialog_size = 3
		else
			dialog_size = 4
		end
	elseif #d == 5 then
		if term_size >= 32 and term_size < 48 then
			dialog_size = 1
		elseif term_size >= 48 and term_size < 64 then
			dialog_size = 2
		elseif term_size >= 64 and term_size < 80 then
			dialog_size = 3
		elseif term_size >= 80 and term_size < 98 then
			dialog_size = 4
		else
			dialog_size = 5
		end
	end
	for i = 1, #d[dialog_size], 1 do
		os.execute("tput cup " .. i .. " 82")
		print(d[dialog_size][i])
	end
end

function draw_map(m, p)
	for i = 1, #m, 1 do
		for j = 1, #m[i], 1 do
			if p.x == j and p.y == i then
				io.write("@")
			elseif m[i][j][1] == 2 then
				io.write("$")
			elseif m[i][j][1] == 3 then
				io.write("=")
			elseif m[i][j][1] == 4 then
				io.write("&")
			elseif m[i][j][1] == 0 or m[i][j][1] == 1 or m[i][j][1] == 5 then
				io.write(m[i][j][2])
			end
		end
		io.write("\n|")
	end
end

function draw_inv(p, c)
	local temp = 1
	local print_loc = 2
	os.execute("tput cup " .. print_loc .. " 2")
	if #p.inventory == 0 then
		print("There are no items in the inventory.")
	else
		print("Inventory:")
		print_loc = print_loc + 1
		for i = 1, #p.inventory, 1 do
			os.execute("tput cup " .. print_loc .. " 2")
			if temp == c then
				print("-> " .. p.inventory[i][1] .. ": " .. p.inventory[i][2])
			else
				print("   " .. p.inventory[i][1] .. ": " .. p.inventory[i][2])
			end
			temp = temp + 1
			print_loc = print_loc + 1
		end
	end
end

function draw_img(img)
	for i = 1, 40, 1 do
		os.execute("tput cup " .. i .. " 1")
		print(img[i])
	end
end

function draw_shop(o, c)
	local temp = 1
	local print_loc = 2
	os.execute("tput cup " .. print_loc .. " 2")
	print("Shop:")
	print_loc = print_loc + 1
	for i = 1, #o, 1 do
		os.execute("tput cup " .. print_loc .. " 2")
		if temp == c then
			print("-> " .. o[i][1] .. ":" .. o[i][2] .. "$")
		else
			print("   " .. o[i][1] .. ":" .. o[i][2] .. "$")
		end
		temp = temp + 1
		print_loc = print_loc + 1
	end
end
