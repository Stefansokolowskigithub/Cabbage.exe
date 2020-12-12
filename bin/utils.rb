# flashes text on screen
def flash(text, repetitions, speed = 0.2)
	textLength = text.length
	repetitions.times do
		STDOUT.print text
		sleep speed
		STDOUT.print "\r#{' ' * textLength}\r"
		sleep speed
	end
	puts
end


# phone call functionality
def call
	2.times do
		clear_screen()
		talk("* Ring Ring *")
		talk("* Ring Ring *")
		puts
		flash("...", 3, 0.3)
	end
	clear_screen()
end

def help_menu
	puts "", "-------------Cabbage.exe ------------- "
	puts "------------- Help Menu -------------- ", ""
	puts "The world of sauerkraut production is a multifaceted one..."
	puts "Type in numerous commands to navigate around."
	puts "Perhaps you will find more than you think.."
	puts "Navigate by typing a command + item/thing/place"
	puts "e.g. `examine kitchen`", ""
	puts "Useful commands to get started: examine, eat, take, use", ""
	puts "Check inventory: inventory"
	puts "To save, go to the kitchen and type: save"
	puts "To delete your game, go to the kitchen and type: delete game", ""
	puts "It would help your quest if you were a case sensitive soul", ""
	puts "-------------------------------------- "
	puts "-------------------------------------- ", ""
end

# when something undesirable is written
def no_sense
	text = [
		"Your words make no sense...",
		"Invalid input",
		"Try a valid command",
		"That doesn't work",
		"Say whaaat?",
		"That don't mean nuffin...",
		"Please input a valid command"
	]
	puts text[rand(6)], ""
end

# foul language
def swearing
	text = [
		"Such foul language...",
		"Oh goodness gracious! People don't use that language in this land...",
		"These horrid words you speak are forsaken here...",
		"My goodness... such awful language you speak...",
		"This world does not care for your foul tongue...",
		"Your foul language is not welcome in this world...",
		"This world does not take kindly to that kind of language..."
	]
	puts text[rand(6)], ""
end

# text for moving room
def move_room(direction)
	righttext = "--- Moving room -->"
	lefttext = "<-- Moving room ---"
	starttext = "Welcome to Cabbage.exe!"
	i = 0
	if direction == "right"
		until i == righttext.length do
			print righttext[i]
			sleep(0.05)
			i += 1
		end
	elsif direction == "left"
		until i == lefttext.length do
			print lefttext[i]
			sleep(0.05)
			i += 1
		end
	elsif direction == "start"
		until i == starttext.length do
			print starttext[i]
			sleep(0.05)
			i += 1
		end		
	end
	puts "",""
end

# prints text at a certain speed. Pauses is there is a full stop or three full stops in a row.
def talk(text, speed = 0.008)
    pause = speed * 80
    last_char = nil
    text.each_char do |char|
        if char == '.' 
            print('.')
        else
            sleep(pause) if last_char == '.'
            print char
            sleep(speed)
        end
        last_char = char
    end
    sleep(pause)
    puts
end

# shows what sauerkrauts the player has on their shelf
def check_shelf(thePlayer)
	if thePlayer.krauts.length > 0
		puts "-------------------------------------- ", ""
		thePlayer.krauts.each do |i| 
			puts "Sauerkraut name: '#{i["krautName"]}'"
			puts "Ingredients: #{i["ingredients"].join(", ")}"
			puts "Current fermentation time: #{(Time.now.to_i - i["start"].to_i) / 3600} hours", ""
		end 
		puts "-------------------------------------- ", ""
	else
		puts "Nothing to see here. Perhaps you can fill the shelf with some fermented goods..." ,""
	end	
	in_kitchen(thePlayer)
end

def clear_screen
	if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
		system('cls')
	else
		system('clear')
	end
	Prompts.enable
end

def journal(thePlayer)
	clear_screen()

	def log_journal_krauts(thePlayer)
		if thePlayer.journalKrauts.length == 0
			puts "> You currently have no entries."
		else
			krautCount = 0
			thePlayer.journalKrauts.each do |entry|
				krautCount += 1
				puts
				puts "Name: '#{entry["krautName"]}'"
				puts "Ingredients: #{entry["ingredients"].join(", ")}"
				puts "Score: #{entry["final score"]}"
				puts
				if krautCount >= 5
					thePlayer.journalWriting[3] = "> Finished 5 jars of sauerkraut. Go me!"
				end
			end
		end
	end

	def log_journal_entries(thePlayer)
		if thePlayer.journalWriting.length == 0
			puts "> You currently have no entries."
		else
			thePlayer.journalWriting.each { |entry, value| puts "#{value}" }
		end
	end

	puts "-------------------------------------- ", "" 
	puts "SAUERKRAUTS:"
	log_journal_krauts(thePlayer)
	puts
	puts "ENTRIES:"
	log_journal_entries(thePlayer)
	puts
	puts "-------------------------------------- ", ""
	puts "Press any key to return"
	gets
	clear_screen()
	title_screen()
	in_kitchen(thePlayer)
end

def use_phone(thePlayer)
	puts "Who do you want to call?" 
	puts "1. Mother"
	puts "2. Supermarket"
	puts
	input = gets.strip.downcase
	if input =~ /(mother|1)/
		call_mother(thePlayer)
	elsif input =~ /(supermarket|2)/
		call_supermarket(thePlayer)
	else
		no_sense()
		in_kitchen(thePlayer)
	end
end

def title_screen
	puts "", "-------------Cabbage.exe ------------- "
	puts "--------------- V #{game_version()} ---------------- ", ""
	puts " Type 'help' for the help menu "
	puts " To save, go to the kitchen and type 'save'", ""
	puts "-------------------------------------- ", ""
end

def about_menu
	puts "", "-------------Cabbage.exe ------------- "
	puts "--------------- About ---------------- ", ""
	puts "   A real-time, text-based sauerkraut  "
	puts " simulator. Discover the mundane nature"
	puts " of sauerkraut production, and more... ", ""
	puts "         Created by Stefan S           "
	puts " Special thanks to Emily Mouthporridge "
	puts "                                       "
	puts "                V #{game_version()}                  ", ""
	puts "               (C)2020                 ", ""
	puts "-------------------------------------- ", ""
end

def save_game(thePlayer)
	File.open('sav/save.sauerkraut', 'wb') { |f| f.write(Marshal.dump(thePlayer)) }
	thePlayer = Marshal.load(File.open('sav/save.sauerkraut', 'rb'))
end

def delete_game(thePlayer)
	puts "Are you SURE you want to delete your current game?"
	puts "YES / NO", ""
	input = gets.strip.downcase
	case input
	when "yes"
		File.delete("save.sauerkraut")
		puts "<< Game deleted >>"
		sleep(1)
		puts "Goodbye!"
		sleep(1)
		exit
	else
		in_kitchen(thePlayer)
	end
end

def update_larder_food(thePlayer)
	currentTime = Time.now.to_i

	# need to improve this section
	foodToAdd = {
		"pink_salt" => [true, 15.5, "seasoning", 1.2], 
		"salt" => [true, 10.0, "seasoning", 1.0], 
		"oliveoil" => [true, -3.0, "seasoning", -10.0], 
		"sugar" => [true, -30.0, "seasoning", -20.0],
		"tomatoes" => [true, -5.0, "vegetable", 0.0],
		"celeriac" => [true, 3.0, "vegetable", 0.0],
		"carrots" => [true, 2.0, "vegetable", 0.0],
		"cabbage" => [true, 10.0, "vegetable", 0.0],
		"eggs" => [true, -28.0, "vegetable", -25.0],
		"mustard_seeds" => [true, 0.2, "seasoning", 0.0],
		"chili_flakes" => [true, 0.3, "seasoning", 0.0],
		"purple_cabbage" => [true, 13.0, "vegetable", 2.0],
		"organic_cabbage" => [true, 13.0, "vegetable", 5.0],
		"kale" => [true, 4, "vegetable", 0.5],
		"radish" => [true, 3, "vegetable", 0.5],
		"beetroot" => [true, 3, "vegetable", 0.5],
		"caraway_seeds" => [true, 0.3, "seasoning", 0.0],
		"juniper_berries" => [true, 0.3, "seasoning", 0.0],
		"dill" => [true, 0.3, "seasoning", 0.0],
		"organic_dill" => [true, 0.5, "seasoning", 10.0],
		"water_filter" => [true, 8.0, "", 10.0],
		"potato" => [true, -5.0, "vegetable", -5.0],
		"nappa_cabbage" => [true, 10.0, "vegetable", 2.0],
		"seeds_of_god" => [true, 0.3, "seasoning", 20.0],
		"daikon" => [true, 0.3, "vegetable", 1.0],
		"black_spanish_radish" => [true, 0.3, "vegetable", 1.2],
		"heirloom_cabbage" => [true, 0.3, "vegetable", 1.3],
		"kosher_salt" => [true, 12.0, "seasoning", 1.1]
	}

	if (thePlayer.gameEvents["add_larder_food"][0] < currentTime) && (thePlayer.gameEvents["add_larder_food"][1].length > 0)

		thePlayer.gameEvents["add_larder_food"][1].each do |item|
			foodToAdd.each do |key, value|
				if item == key
					thePlayer.larder[key] = value
				end
			end
		end
		# reset add_larder_food
		thePlayer.gameEvents["add_larder_food"][0] = 0
		thePlayer.gameEvents["add_larder_food"][1] = []
	end

	if (thePlayer.gameEvents["special_offers"][0] < currentTime) && (thePlayer.gameEvents["special_offers"][1].length > 0)

		thePlayer.gameEvents["special_offers"][1].each do |item| 
			foodToAdd.each do |key, value|
				if item == key
					thePlayer.larder[key] = value
				end
			end
		end	
		# reset add_larder_food
		thePlayer.gameEvents["special_offers"][0] = 0
		thePlayer.gameEvents["special_offers"][1] = []
	end

	if (thePlayer.gameEvents["complaint_gift"][0] < currentTime) && (thePlayer.gameEvents["complaint_gift"][1].length > 0)

		thePlayer.gameEvents["complaint_gift"][1].each do |item| 
			foodToAdd.each do |key, value|
				if item == key
					thePlayer.larder[key] = value
				end
			end
		end	
		# reset add_larder_food
		thePlayer.gameEvents["complaint_gift"][0] = 0
		thePlayer.gameEvents["complaint_gift"][1] = []
	end
end

# read the inventory
def read_inventory(thePlayer)
	puts "", "Your inventory:"
	puts "---------------"
	if thePlayer.inventory.length < 1
		puts "nothing here yet"
	else
		thePlayer.inventory.each do |key|
			puts "> #{key[0]}"
		end
	end
	puts
end

def check_inventory(thePlayer, input)
	if thePlayer.larder.has_key?(input) == true
		thePlayer.inventory[input] = thePlayer.larder[input]
		thePlayer.larder.delete(input)
		puts "Added #{input} to the inventory", ""
	else
		puts "That doesn't work..", ""
	end
end


def make_kraut(thePlayer)
	# high scores will be based on the longevity score and extra points

	longevityScore = 0.0 
	extraPoints = 0.0
	rawIngredients = nil
	seasoningIngredients = nil


	puts "What raw ingredients do you want to add? In your inventory you have:"
	thePlayer.inventory.each do |key, value|
		if value[2] == "vegetable"
			puts "> #{key}"
		end
	end
	puts "", "(separate chosen ingredients with the space key)", ""

	loop do
		# present vegetables from your inventory
		rawIngredients = gets.strip.split(' ')

		# check if cabbage has been added, if not then they need to add cabbage
		if !rawIngredients.any? { |item| item == "cabbage" || item == "purple_cabbage" }
			puts "Cabbage is required. You need to add at least one variety.", ""
			redo
		end

		#check each word can be found in the inventory dictionary
		#check if someone hasn't accidentally inputted anything from the inventory that isn't a vegetable
		if !rawIngredients.all? { |item| thePlayer.inventory.has_key?(item) && thePlayer.inventory[item][2] == "vegetable" }
			puts "You can only add ingredients from your inventory.", ""
			redo
		else
			break
		end
	end

	# cutting size - there is an optimal size to cut
	puts "How fine would you like to chop your cabbage?"
	puts "Choose slice width in milimetres (1-30): ", "" 

	loop do
		widthinput = gets.strip.to_i
		if widthinput >= 1 && widthinput <= 3
			longevityScore += 2.0
			extraPoints += 5.0
			break
		elsif widthinput >= 4 && widthinput <= 10
			longevityScore += 1.0
			extraPoints += 10.0
			break
		elsif widthinput >= 11 && widthinput <= 30
			extraPoints += -5.0
			break
		else
			puts "You need to input a number between 1-30", ""
		end
	end

	flash("<< Chopping >>", 4, 0.1)

	# display seasonings
	puts "What seasonings or spices do you want to add? In your inventory you have:"
	thePlayer.inventory.each do |key, value|
		if value[2] == "seasoning"
			puts "> #{key}"
		end
	end
	puts "", "(separate chosen ingredients with the space key)", ""

	loop do
		seasoningIngredients = gets.strip.split(' ')

		# check if salt has been added. Salt needs to be added.
		if !seasoningIngredients.any? { |item| item == "salt" || item == "pink_salt" || item == "kosher_salt" }
			puts "Salt needs to be added.", ""
			redo
		end

		# check each word can be found in the inventory dictionary, if not, prompt the user to repeat
		# check if someone hasn't accidentally inputted anything from the inventory that isn't a seasoning
		if !seasoningIngredients.all? { |item| thePlayer.inventory.has_key?(item) && thePlayer.inventory[item][2] == "seasoning" }
			puts "You can only add seasonings from your inventory.", ""
			redo
		else
			break
		end
	end

	puts "You can't see any brine covering the top yet..."
	puts "(Press enter to mash veg. Type any key followed by enter to stop)"

	# mash the sauerkraut
	mashData = {
	"halfAnInch" => rand(4..6),
	"anInch" => rand(10..12),
	"twoInches" => rand(17..20),
	"nothingElse" => rand(21..24),
	"mCount" => 0,
	"extraLongevity" => 0,
	"doingNothing" => false
	}

	loop do
		input = gets.strip
		if input == ""
			mashData["mCount"] += 1
			case mashData["mCount"]
			when mashData["halfAnInch"]
			    print "half an inch of brine has formed... Continue mashing?"
			    mashData["extraLongevity"] += 0
			    redo
			when mashData["anInch"]
			    print "An inch of brine has formed... Continue mashing?"
			    mashData["extraLongevity"] += 2
			    redo
			when mashData["twoInches"]
			    print "Two inches of brine have formed... Continue mashing?"
			    mashData["extraLongevity"] += 2
			    redo
			when mashData["nothingElse"]
			    print "Your mashing doesn't appear to be doing anything"
			    mashData["doingNothing"] = true
			    redo
		  	else
			    if mashData["doingNothing"]
			    	print "Your mashing doesn't appear to be doing anything"
			    	redo
			    else
			    	print "Mashing the kraut..."
			    	redo
			    end
		  	end
		else
			if mashData["mCount"] >= mashData["halfAnInch"]
		    	break
		  	else
		    	puts "There isn't any brine in your jar. You need to keep mashing."
		    	redo
		  	end
		end
	end

	puts "Your arm is tired!",""

	# combine seasonings and vegetables together
	krautCombined = {}

	rawIngredients.each do |item|
		krautCombined[item] = thePlayer.inventory[item]
		thePlayer.inventory.delete(item)
	end
	seasoningIngredients.each do |item|
		krautCombined[item] = thePlayer.inventory[item]
		thePlayer.inventory.delete(item)
	end

	# create the longevity score
	krautCombined.each do |item|
		longevityScore += item[1][1]
		extraPoints += item[1][3]
	end

	# add the sauerkraut mashing data to the longevity score
	longevityScore += mashData["extraLongevity"]

	# finish the score, making it a bit smaller in appearance
	longevityScore = (longevityScore / 100) 

	puts "What do you want to name your sauerkraut?", ""
	# name the sauerkraut
	def name_kraut
	  krautName = gets.strip.downcase
	  if krautName == ""
	    puts "You need to name your sauerkraut", ""
	    name_kraut
	  elsif krautName =~ /(fuck|shit|cunt|bitch|ass|dick|piss|bastard)/
		swearing()
		puts "Try a better name" , ""
		name_kraut
	  else
	    return krautName
	  end
	end

	krautName = name_kraut
	talk("Your sauerkraut '#{krautName}' is sitting on your kitchen shelf")

	# creates a timeline for when various sauerkraut events occur. This will be checked as the game progresses. Progression through the timeline makes up the score at the end.
	# if you don't take it out by the spoil time, the score starts to decrease after this point
	# score decreases even more when it's a bad spoil
	# time in days * 86400 (to get time in seconds)

	startTime = Time.now.to_i
	time1 = startTime + ((3 + (longevityScore * 3)) * 86400) # mould
	time2 = startTime + ((5 + (longevityScore * 5)) * 86400) # bad mould
	time3 = startTime + ((25 + (longevityScore * 25)) * 86400) # spoil
	time4 = startTime + ((28 + (longevityScore * 28)) * 86400) # bad spoil
	time5 = startTime + ((30 + (longevityScore * 30)) * 86400) # dead

	# add extra points to the final game score
	extraPoints = ((extraPoints / 10) * 86400)

	# add the timeline to the game state
	thePlayer.krauts << { 
		"krautName" => krautName, 
		"ingredients" => rawIngredients + seasoningIngredients,
		"start" => startTime, 
		"mould" => time1, 
		"bad mould" => time2, 
		"spoil" => time3, 
		"bad spoil" => time4, 
		"dead" => time5,
		"extra points" => extraPoints,
		"final score" => 0
	}

	puts
	
end

# calculates the final score to be saved, based on where the player is in the timeline and any extra points
def calculate_score(thePlayer, krautInQuestion)
	score = 0
	spoil = 0
	badSpoil = 0
	finalScore = 0
	extraPoints = 0
	timeNow = Time.now.to_i

	# locate specific kraut from the array (chosen sauerkraut)
	thePlayer.krauts.any? do |i| 
		if i.values[0] == krautInQuestion
		# take away the time you created the sauerkraut from the time now to form the general score
			score += timeNow - i.values[2]
		# if the player is after the spoil event, decrease the score
			if i.values[5] < timeNow
				spoil -= ((timeNow - i.values[5]) * 1.5)
			end
		# if the player is after the bad spoil event, decrease the score even more
			if i.values[6] < timeNow
				spoil -= ((timeNow - i.values[6]) * 2.5)
			end

		# add on extra points
			extraPoints += i.values[8]

		# convert extra points into a nicer looking score
			extraPoints = extraPoints - 1 

		# put together the final score. Round it off so it looks nicer.
			finalScore += ((score + spoil + badSpoil + extraPoints) / 100).round 
			i["final score"] = finalScore
		else
		end
	end

	sleep(1)
	puts "", ""
	puts "Your score: #{finalScore}", "", ""
	sleep(1)
	puts "Press enter to continue"
	gets
end

# functionality for checking the sauerkraut
def check_kraut(thePlayer, krautInQuestion)

	# delete the sauerkraut
	def delete_kraut(thePlayer, krautInQuestion)
		thePlayer.krauts.each do |i|
			if i.values[0] == krautInQuestion
				thePlayer.krauts.delete(i)
			end
		end	
	end

	# put the kraut into your journal
	def move_kraut_to_journal(thePlayer, krautInQuestion)
		thePlayer.krauts.each do |i|
			if i.values[0] == krautInQuestion
				thePlayer.journalKrauts.push(i)
			end
		end			
	end

	# if the kraut doesn't exist, do no sense
		if !thePlayer.krauts.any? { |i| i.values[0] == krautInQuestion }
			no_sense()
			check_shelf(thePlayer)
		end

	# checks which kraut the player is reffering to, or if the name is valid
	timeNow = Time.now.to_i

	krautkey = ""
	krautval = 0

	thePlayer.krauts.each do |i|
		if i.values[0] == krautInQuestion 
			for j in 2..7
				if i.values[j] >= timeNow
					krautkey = i.keys[j]
					krautval = i.values[j]
					if krautval > timeNow
						krautkey = "start"
						krautval = 0
					end
					break
				end
			end
		end 
	end 

	puts

	# when you eat your sauerkraut
	def eat_it(thePlayer, krautInQuestion)
		calculate_score(thePlayer, krautInQuestion)
		move_kraut_to_journal(thePlayer, krautInQuestion)
		delete_kraut(thePlayer, krautInQuestion)
		clear_screen()
		title_screen()
		in_kitchen(thePlayer)
	end

	# now that the appropriate section in the timeline has been established, we check to see what the status is and what the player needs to do next
	case krautkey
	when "start"
		krautWords = ["sauerkraut", "kraut", "jar of veg", "jar of sauerkraut", "sauerkraut jar", "chopped vegetable kraut", "jar of cut up vegetables"]
		noActivity = [
			"Your #{krautWords[rand(6)]} is sitting nicely on the shelf",
			"A quiet #{krautWords[rand(6)]} reclines on the shelf",
			"Your #{krautWords[rand(6)]} is resting comfortably",
			"A #{krautWords[rand(6)]} is sitting around. Not much activity for now",
			"Your #{krautWords[rand(6)]} is resting on the shelf",
			"Your simple #{krautWords[rand(6)]} is reclining on the shelf. Nothing much going on yet."
		]
		puts noActivity[rand(5)]
		puts "What do you want to do next? ", ""
		input = gets.strip.downcase
		if input =~ /eat/
			clear_screen()
			talk("You take it out...")
			talk("And consume...")
			talk("You made a note in your journal.")
			talk("The rest can be had another time..")
			eat_it(thePlayer, krautInQuestion)
		elsif input =~ /(discard|throw|remove)/
			delete_kraut(thePlayer, krautInQuestion)
			puts "You put it in the bin.", ""
			in_kitchen(thePlayer)
		elsif input =~ /kitchen/
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end
	when "mould" # scraping the mould off prevents the mould events from happening in the future
		puts "You're looking at the mould.. wondering what to do..."
		puts "What do you want to do next? ", ""
		input = gets.strip.downcase
		if input =~ /(mould|scrape|remove|clean)/
			puts "Mould scraped off... You tossed that gross mould in the bin."
			thePlayer.krauts.each do |i|
				if i.values[0] == krautInQuestion
					i["mould"] = 0
					i["bad mould"] = 0
				end
			end
			puts thePlayer.krauts
			gets
		elsif input =~ /eat/
			clear_screen()
			talk("You take it out...")
			talk("And consume...")
			talk("You made a note in your journal.")
			talk("The rest can be had another time..")
			eat_it(thePlayer, krautInQuestion)
		elsif input =~ /(discard|throw|remove)/
			delete_kraut(thePlayer, krautInQuestion)
			puts "You put it in the bin.", ""
			in_kitchen(thePlayer)
		elsif input =~ /kitchen/
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end
			
	when "bad mould" # scraping the mould off prevents the mould events from happening in the future
		puts "You notice some mould... it's growing rather large.. Some blue spots appearing... thinking about what to do..."
		puts "What do you want to do next? ", ""
		input = gets.strip.downcase
		if input =~ /(mould|scrape|remove|clean)/
			puts "Mould scraped off... You tossed it in the bin."
			thePlayer.krauts.each do |i|
				if i.values[0] == krautInQuestion
					i["mould"] = 0
					i["bad mould"] = 0
				end
			end
			puts thePlayer.krauts
			gets
		elsif input =~ /eat/
			clear_screen()
			talk("You take it out...")
			talk("After scraping off the mould you consume...")
			talk("You made a note in your journal.")
			talk("The rest can be had another time..")
			eat_it(thePlayer, krautInQuestion)
		elsif input =~ /kitchen/
			in_kitchen(thePlayer)
		elsif input =~ /(discard|throw|remove)/
			delete_kraut(thePlayer, krautInQuestion)
			puts "You put it in the bin.", ""
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end

	when "spoil" # points decrease after this time
		puts "You can see mould making its way below the level of the brine... looks to be spoiling..."
		puts "What do you want to do next? ", ""
		input = gets.strip.downcase
		if input =~ /(mould|scrape|remove|clean)/
			puts "You tried, but it doesn't look like there's a lot you can do.."
			in_kitchen(thePlayer)
		elsif input =~ /kitchen/
			in_kitchen(thePlayer)
		elsif input =~ /eat/
			clear_screen()
			talk("You take it out...")
			talk("You try to scrape off the mould..")
			talk("It smells a bit funky... but you take a bite anyway..")
			talk("You made a note in your journal")
			eat_it(thePlayer, krautInQuestion)
		elsif input =~ /(discard|throw|remove)/
			delete_kraut(thePlayer, krautInQuestion)
			puts "You put it in the bin.", ""
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end

	when "bad spoil" # Will make you sick - not able to play for 3 days. Score in your journal is very low.
		puts "The mould is growing all over the place.. you can see pink and black spots appearing..."
		puts "Mould is appearing all over.. there are black spots appearing..."
		puts "Mould appears to be growing a great deal. You notice some pink spots and black speckles..."
		puts "What do you want to do next? ", ""
		input = gets.strip.downcase
		if input =~ /(mould|scrape|remove|clean)/
			puts "You tried, but it doesn't look like there's a lot you can do.."
			in_kitchen(thePlayer)
		elsif input =~ /kitchen/
			in_kitchen(thePlayer)
		elsif input =~ /eat/
			clear_screen()
			talk("You take it out...")
			talk("You try to clean around it..")
			talk("The smell isn't the best, but you try and scrape the bad bits off.")
			talk("You made a note in your journal")
			talk("but...")
			talk("You feel a bit sick")
			sleep(0.8)
			flash("<< Throws up >>", 2)	
			talk("Eugghhhh... Oh dear...")
			flash("<< Throws up >>", 5)	
			talk("You need to go and lie down...")
			sleep(2)
			thePlayer.areIll = Time.now.to_i + 259200 # 3 days of illness
			eat_it(thePlayer, krautInQuestion)
		elsif input =~ /(discard|throw|remove)/
			delete_kraut(thePlayer, krautInQuestion)
			puts "You put it in the bin.", ""
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end	

	else # will make you sick if you eat it and the game will stop and your game will be deleted.
		puts "Mould is everywhere! Pink and black mould has permeated right past the brine..."
		puts "What do you want to do next? ", ""
		input = gets.strip.downcase
		if input =~ /(mould|scrape|remove|clean)/
			puts "You tried, but it doesn't look like there's a lot you can do.."
			in_kitchen(thePlayer)
		elsif input =~ /kitchen/
			in_kitchen(thePlayer)
		elsif input =~ /eat/
			talk("You take it out...")
			talk("You try to clean around it..")
			talk("The smell is not to be desired... almost like putrid flesh...")
			talk("You made a note in your journal.")
			talk("BUT... oh no...")
			talk("You start to feel sick...")
			talk("You're feeling very sick...")
			talk("Stomach rumbling... ")
			flash("<< Throws up >>", 4, 0.1)	
			talk("This doesn't feel good...")
			flash("<< Throws up >>", 5, 0.1)	
			talk("This is not going to go well...")
			talk("Oh god..")
			talk("OH GOD!!!")
			sleep(1)
			9999.times do 
				arr = ["AAHHH!!!!!!","ARGHGHHHHHH!!!!","ARHHHHHHHHHHHHHHH!!!!!!!!!!!!!","ARRRRAAAAHHH!!!!!!"]
				num = rand(3)
				print arr[num]
				puts ""
			end
			clear_screen()
			sleep(1.5)
			talk("The sauerkraut was too much for your body to handle.")
			sleep(2)
			puts "", "You are dead.", "", ""
			sleep(1.5)
			puts "GAME OVER"
			File.delete("save.sauerkraut")
			gets
			exit
		elsif input =~ /(discard|throw|remove)/
			delete_kraut(thePlayer, krautInQuestion)
			puts "You put it in the bin.", ""
			in_kitchen(thePlayer)
		else
			no_sense()
			in_kitchen(thePlayer)
		end	

	end
end

