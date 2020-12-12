def in_kitchen(thePlayer)

	# checks if the user has what they need to make sauerkraut
	def can_make_kraut?(thePlayer)
		puts "Would you like to make some sauerkraut?", ""
		input = gets.strip.downcase
		# can't make kraut unless they have the needed items
		if input =~ /yes/ 
		itemsNeeded = ["salt","jars","weight"].select { |item| !thePlayer.inventory.key?(item) }
			if !thePlayer.inventory.key?("cabbage") && !thePlayer.inventory.key?("purple_cabbage")
				itemsNeeded.push("cabbage")
			end
			if itemsNeeded.length == 0
				make_kraut(thePlayer)
				in_kitchen(thePlayer)
			else
				puts "To make sauerkraut you will need the following:"
				itemsNeeded.each { |item| puts "> #{item}" }
				puts "", "Come back when you have these items in your inventory.",""
				in_kitchen(thePlayer)
			end
		elsif input =~ /no/
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end
	end

	# standard prompt
	if Prompts.kitchenPrompt
		puts "You are in your kitchen. Care to look around?"
		puts "Please enter a command: ", ""
	end
	Prompts.disable
	input = gets.strip.downcase

	if input =~ /(fuck|shit|cunt|bitch|ass|dick|piss|bastard)/
		swearing()
		in_kitchen(thePlayer)
	end

	if input =~ /eat/
		if input =~ /(journal|weight|knife|phone|jars)/
			puts "You can't eat that", ""
			in_kitchen(thePlayer)
		end		
		input = input.gsub("eat ", "").downcase
		if thePlayer.inventory.has_key?(input)
			thePlayer.inventory.delete(input)
			puts "*chomp* ... #{input} consumed", ""
		else
			puts "You can't eat that", ""
		end
		in_kitchen(thePlayer)

	elsif input == "examine door"
		puts "Oh what a beautiful 18th century mahogany door. A great portal to someting new and exciting... It stands there as if to call for a new adventure, a new challenge and the chance to discover your true self...", ""
		in_kitchen(thePlayer)

	elsif input =~ /inventory/
		read_inventory(thePlayer)
		in_kitchen(thePlayer)

	elsif input =~ /shelf/
		check_shelf(thePlayer)
		in_kitchen(thePlayer)

	elsif input == "examine kitchen"
		puts "Your quaint kitchen is minimal and pleasing. Not much here, just a sink by the window, a table and door to the larder.", ""
		in_kitchen(thePlayer)

	elsif input =~ /journal/
		journal(thePlayer)

	elsif input =~ /(wash|clean)/
		if input =~ /jar/
			flash("<< Cleaning >>", 3)
			puts "Your jars are now as clean as a whistle", ""
		elsif input =~ /window/
			flash("<< Cleaning >>", 4)
			puts "You have cleaned the window. The view is crystal clear!", ""
		elsif input =~ /sink/
			flash("<< Cleaning >>", 5)
			puts "Your sink is sparkling clean.", ""
		elsif input =~ /kitchen/
			flash("<< Cleaning >>", 30)
			puts "You have a sparkling kitchen.", ""
		else
			no_sense()
		end
		in_kitchen(thePlayer)

	elsif input =~ /sink/
		puts "What a wonderful sink you have..", ""
		in_kitchen(thePlayer)

	elsif input =~ /kraut/
		can_make_kraut?(thePlayer)

	elsif input =~ /knife/
		puts "1. Use for food preparation / 2. Use on yourself / 3. Admire", ""
		input = gets.strip.to_i
		case input
		when 1
			can_make_kraut?(thePlayer)
		when 2
			6000.times do 
				arr = ["OUCH!!!!!!","OUUCH!!!!!!!!!","OUCH!!!!!!!!!!!!!","OUCH!!!"]
				num = rand(3)
				print arr[num]
				puts ""
			end
			clear_screen()
			sleep(0.5)
			talk("That hurt!!!")
			sleep(1.5)
			clear_screen()
			title_screen()
			in_kitchen(thePlayer)
		else
			puts "Ah my trusted double edged suminagashi blue steel blade... It can never let me down...", ""
			in_kitchen(thePlayer)
		end

	elsif input =~ /(food processor|kenwood multipro)/
		can_make_kraut?(thePlayer)

	elsif input =~ /billy corgan/
		puts "Everyone hates Billy Corgan in this world", ""
		in_kitchen(thePlayer)

	elsif input =~ /table/
		puts "Ah, an old Kenwood MultiPro. There's also a chef's knife lying next to it. Nothing lies inside the food processor...", ""
		in_kitchen(thePlayer)

	elsif input =~ /phone/
		use_phone(thePlayer)

	elsif input =~ /save/
		save_game(thePlayer)
		puts "<< Game saved >>", ""
		in_kitchen(thePlayer)

	elsif input =~ /window/
		random = rand(4)
		text = [
		"Oh what a wonderful view...",
		"You see a gang of pigeons beating up a squirrel.",
		"Someone is peeing in the alley...",
		"What a glorious day outside!",
		"It's raining, it's pouring..."]
		puts text[random], ""
		if random == 1
			thePlayer.journalWriting[2] = "> There's lot of animal drama outside."
		end 
		in_kitchen(thePlayer)

	elsif input =~ /larder/ || input =~ /door/ 
		move_room("right")
		Prompts.enable
		in_larder(thePlayer)

	elsif input =~ /help/
		help_menu()
		in_kitchen(thePlayer)

	elsif input =~ /about/
		about_menu()
		in_kitchen(thePlayer)

	elsif input =~ /delete/
		delete_game(thePlayer)

	else
		# to examine shelf items
		input = input.gsub("examine ", "").strip
		if thePlayer.krauts.any? { |i| i.values[0] == input }
			check_kraut(thePlayer, input)
		else
			no_sense()
			in_kitchen(thePlayer)
		end
	end
end

