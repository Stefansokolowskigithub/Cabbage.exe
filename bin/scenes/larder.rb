def in_larder(thePlayer)
	# standard prompt
	if Prompts.larderPrompt
		puts "It's cold in your larder. Care to look around?"
		puts "Please enter a command: ", ""
	end
	Prompts.disable

	input = gets.strip.downcase

	if input =~ /(fuck|shit|cunt|bitch|ass|dick|piss|bastard)/
		swearing()
		in_larder(thePlayer)
	end

	if input.include? "take"
		input = input.gsub("take ", "").downcase
		check_inventory(thePlayer, input)
		in_larder(thePlayer)
	end

	if input =~ /eat/
		if input =~ /(journal|weight|knife|phone|jars)/
			puts "You can't eat that", ""
			in_larder(thePlayer)
		end
		input = input.gsub("eat ", "").downcase
		if thePlayer.inventory.has_key?(input)
			thePlayer.inventory.delete(input)
			puts "*chomp* ... #{input} consumed", ""
		else
			puts "You can't eat that", ""
		end
		in_larder(thePlayer)

	elsif input =~ /(larder|shelf|shelves)/
		update_larder_food(thePlayer)
		if thePlayer.larder.length == 0
			puts "Not much to see here, just some empty, worn out shelves...", ""
			puts in_larder(thePlayer), ""
		else
			puts "There are some worn out shelves where you find the following:"
			puts thePlayer.larder.keys.join(", ")
			puts
			puts in_larder(thePlayer), ""
		end

	elsif input =~ /inventory/
		read_inventory(thePlayer)
		in_larder(thePlayer)

	elsif input =~ /journal/
		journal(thePlayer)

	elsif input =~ /kitchen/
		move_room("left")
		Prompts.enable
		in_kitchen(thePlayer)

	elsif input =~ /about/
		about_menu()
		in_larder(thePlayer)

	elsif input =~ /phone/
		use_phone(thePlayer)

	elsif input =~ /save/
		save_game(thePlayer)
		puts "<< Game saved >>", ""
		in_larder(thePlayer)

	else
		no_sense()
		in_larder(thePlayer)
	end
end

