# update accordingly
def game_version
	return 1.0
end

# game state
class Player
	attr_accessor :fermenting,
	:inventory,
	:kitchen,
	:larder,
	:other,
	:krauts,
	:journalKrauts,
	:journalWriting,
	:gameEvents,
	:areIll,
	:randomEvents
	def initialize()
		@fermenting = false
		@inventory = {
			"journal" => [true, 0.0, "", 0.0],
			"phone" => [true, 0.0, "", 0.0]
			}

		@larder = {
			"tomatoes" => [true, -5.0, "vegetable", 0.0],
			"celeriac" => [true, 3.0, "vegetable", 0.0],
			"carrots" => [true, 2.0, "vegetable", 0.0],
			"salt" => [true, 10.0, "seasoning", 1.0],
			"cabbage" => [true, 10.0, "vegetable", 0.0],
			"eggs" => [true, -28.0, "vegetable", -25.0],
			"jars" => [true, 0.0, "", 0.0],
			"weight" => [true, 0.0, "", 0.0]
		}

		@other = {
			"purple_cabbage" => [true, 13.0, "vegetable", 2.0],
			"organic_cabbage" => [true, 13.0, "vegetable", 5.0],
			"kale" => [true, 4, "vegetable", 0.5],
			"radish" => [true, 3, "vegetable", 0.5],
			"beetroot" => [true, 3, "vegetable", 0.5],
			"caraway_seeds" => [true, 0.3, "seasoning", 0.0],
			"juniper_berries" => [true, 0.3, "seasoning", 0.0],
			"dill" => [true, 0.3, "seasoning", 0.0],
			"organic_dill" => [true, 0.5, "seasoning", 10.0],
			"water_filter" => [true, 8.0, "", 10.0], # For later game version
			"potato" => [true, -5.0, "vegetable", -5.0],
			"nappa_cabbage" => [true, 10.0, "vegetable", 2.0],
			"seeds_of_god" => [true, 0.3, "seasoning", 20.0],
			"daikon" => [true, 0.3, "vegetable", 1.0],
			"black_spanish_radish" => [true, 0.3, "vegetable", 1.2],
			"heirloom_cabbage" => [true, 0.3, "vegetable", 1.3],
			"tax_forms" => [true, 0.0, "", 0.0], # For later game version
			"pen" => [true, 0.0, "", 0.0],
			"kosher_salt" => [true, 12.0, "seasoning", 1.1],
			"fermentation_valve" => [true, 10.0, "", 10.0], # For later game version
			"heater" => [true, -30.0, "", 10.0] # For later game version
		}

		@krauts = []

		@journalKrauts = []

		@journalWriting = {
		1 => "> Saw program on the TV. Sauerkraut deemed healthy by a group of Wizards.",
		2 => "> .......................................................................",
		3 => "> .......................................................................",
		4 => "> .......................................................................",
		5 => "> .......................................................................",
		6 => "> .......................................................................",
		7 => "> .......................................................................",
		8 => "> .......................................................................",
		9 => "> .......................................................................",
		10 => "> ......................................................................."
		} 
		#1. "> Saw program on the TV. Sauerkraut deemed healthy by experts."
		#2. "> There's lot of animal drama outside..."
		#3. "> Finished 5 jars of sauerkraut. Go me!"
		#4. Other achievements will be added in the new version
		#5.
		#6.
		#7.
		#8.
		#9.
		#10.

		@gameEvents = {
			"add_larder_food" => [0, []],
			"special_offers" => [0, []],
			"complaint_gift" => [0, []]
		}

        @areIll = 0

	end
end

# to stop the initial larder or kitchen prompt from repeating
class Prompts
	@@kitchenPrompt = true
	@@larderPrompt = true

	def self.kitchenPrompt
		return @@kitchenPrompt
	end

	def self.larderPrompt
		return @@kitchenPrompt
	end

	def self.enable
		@@kitchenPrompt = true
		@@larderPrompt = true
	end

	def self.disable
		@@kitchenPrompt = false
		@@larderPrompt = false
	end
end

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

# call your mother
def call_mother(thePlayer)
	call()
	puts "There was no answer...", ""
	puts
	sleep(1)
	puts "Press enter to continue", ""
	gets
	clear_screen()
	title_screen()
	in_kitchen(thePlayer)
end

# call the supermarket
def call_supermarket(thePlayer)

	def special_offer(thePlayer)

		# weight of different items when being randomly selected
		food = {
			"pink_salt" => 5,
			"seeds_of_god" => 2,
			"salt" => 90,
			"cabbage" => 90,
			"radish" => 40,
			"potato" => 30,
			"caraway_seeds" => 30,
			"juniper_berries" => 30,
			"beetroot" => 30,
			"kosher_salt" => 10,
			"daikon" => 25,
			"celeriac" => 45,
			"black_spanish_radish" => 20,
			"heirloom_cabbage" => 10,
			"kale" => 51
		}	

		# creates four special offer items
		specialOfferItems = []
		until specialOfferItems.length == 4
			food.each do |key, value| 
				if rand(100) <= value && specialOfferItems.length != 4 && !specialOfferItems.include?(key)
					specialOfferItems << key
				end
			end
		end	

		# checks if special offers have already been created for the day. There can only be one offer a day.
		if thePlayer.gameEvents["special_offers"][1].length < 1 && Time.now.to_i > thePlayer.gameEvents["special_offers"][0]

			# add items to today's special offers
			thePlayer.gameEvents["special_offers"][1] = specialOfferItems
		end

		# print special offer items for the day
		talk("Employee: \"Today we have #{thePlayer.gameEvents["special_offers"][1][0..2].join(", ")} and #{thePlayer.gameEvents["special_offers"][1][3]}.\"")
		puts

		puts "1. Purchase all", "2. Reject all"
		input = gets.strip.downcase
		if input =~ /(1|purchase)/
			talk('"I\'ll take \'em all."')
			talk('Employee: "No problem."')
			talk('Employee: "What is your address?"')
			gets
			talk('Employee: "Let me just get that processed."')
			flash("<< Employee working >>", 12)	

			# add a day's time to game events
			thePlayer.gameEvents["special_offers"][0] = Time.now.to_i + 86400	

			talk('Employee: "Ok. All done!"')
			talk('Employee: "We will deliver all this rubbish to your house in a day\'s time."')
			sleep(0.3)
			talk('"Great."')
			talk('Employee: "No problem. Have a blessed day, customer!"')
			sleep(1)		
			clear_screen()
			title_screen()
			in_kitchen(thePlayer)
		else
			talk('"Employee: Be sure to check out new offers when they come in. We have new items on offer every day!"')
			puts
			speak(thePlayer)
		end
		
	end

	def speak(thePlayer)
		puts "1. order food", "2. make a complaint", "3. hang up", ""
		input = gets.strip.downcase
		if input =~ /(1|order)/
			talk('"I want to order some food."')
			talk('Employee: "Ok sure. What is it that you\'re looking for?"')
			puts
			puts "1. The usual", "2. Today's special offers"
			input = gets.strip.downcase
			if input =~ /(1|usual)/
				talk('"Meh, just the usual."')
				talk('Employee: "Absolutely, kindest customer."')
				talk('Employee: "What is your address?"')
				gets
				talk('Employee: "Thank you. One moment please."')
				flash("<< Employee working >>", 15)		

				fewHoursTime = rand(3..7)
				# add items to add_larder_food
				thePlayer.gameEvents["add_larder_food"][1] = ["cabbage", "salt", "carrots", "potato", "sugar", "eggs", "tomatoes", "mustard_seeds"] 
				# add a a few hours time to the event
				thePlayer.gameEvents["add_larder_food"][0] = Time.now.to_i + (3600 * fewHoursTime)

				talk('Employee: "Ok. That\'s all been processed."')
				talk("Employee: \"We will deliver everything to your home in #{fewHoursTime} hours time.\"")
				sleep(0.3)
				talk('"Great. Goodbye."')
				talk('Employee: "Not at all. Have a blessed day, wonderful customer."')
				sleep(1)		
				clear_screen()
				title_screen()
				in_kitchen(thePlayer)
			elsif input =~ /(2|special)/
				talk('"What have you got on offer?"')
				talk('Employee: "So many great products! We have new offers every day!"')
				special_offer(thePlayer)
			else
				talk('Employee: "Sorry, I didn\'t quite understand that."')
				puts
				speak(thePlayer)
			end
		elsif input =~ /(2|make)/
			talk('"I\'d like to make a complaint please."')
			sleep(0.3)
			talk('Employee: "Ok, go ahead."')
			gets
			talk('Employee: "I\'m so sorry to hear that. We always strive to offer the best service at this generic supermarket..."')
			gets
			talk('Employee: "Oh dear... Duly noted."')
			talk('Employee: "Is there anything else you\'d like to add?"')
			gets
			talk('Employee: "My dearest and most sincere appologies unsatisfied customer."')
			sleep(0.5)
			talk('Employee: "Here at this wonderful establishment we always adhere to the best standards, but I\'m so so sorry we\'ve let you down."')
			sleep(0.3)
			talk('Employee: "Hearing your complaint brings tears to my eyes..."')
			sleep(0.3)
			talk('Employee: "I want to weep like a little girl..."')
			sleep(0.3)
			talk('Employee: "Let me talk to management right away. Please hold."') 
			flash("<< Employee working >>", 7)
			talk('Employee: "One moment please."')
			flash("<< Employee working >>", rand(5..7))
			talk('As a token of our gratitude for raising this worthy complaint, we would love to send you a complimentary gift in the post."')
			sleep(0.3)
			talk('Employee: "What is your address?"')
			gets
			talk('Employee: "Thank you."')
			talk('Employee: "Rest assured that your gift will arrive in the post in a week\'s time. Appologies once again for any inconvenience caused. I really am so so so so so sorry. I sincerely apologise from the bottom of my heart."')
			sleep(0.8)
			talk('"Ok, goodbye."')
			sleep(0.3)
			talk('Employee: "Thank you. Have a blessed day."')
			sleep(1.2)

			# adds items to complaint_gift
			thePlayer.gameEvents["complaint_gift"][1] = "cabbage"
			# adds a week of time to complaint_gift
			thePlayer.gameEvents["complaint_gift"][0] = Time.now.to_i + 604800

			clear_screen()
			title_screen()
			in_kitchen(thePlayer)
		elsif input =~ /(3|hang)/
			clear_screen()
			title_screen()
			in_kitchen(thePlayer)
		else
			talk('Employee: "I don\'t understand you my child... How can I help?"')
			puts
			speak(thePlayer)
		end
	end

	call()

	# daft names
	names = ["Tubelord", "Buble", "Porkie", "Bartboy", "Oakley", "Samsung", "Viauviau", "Coney", "Blaerg", "Quimby"]

	"Employee: \"Hello, this is your local Supermarket. #{names[rand(10)]} speaking. How can I help?\"".each_char do |char|
		if char == "."
			print char
			sleep(0.64)
		else
			print char
			sleep(0.008)
		end
	end
	puts
	speak(thePlayer)
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

def save_game(thePlayer)
	File.open('save.sauerkraut', 'wb') { |f| f.write(Marshal.dump(thePlayer)) }
	thePlayer = Marshal.load(File.open('save.sauerkraut', 'rb'))
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

def title_screen
	puts "", "-------------Cabbage.exe ------------- "
	puts "--------------- V #{game_version()} ---------------- ", ""
	puts " Type 'help' for the help menu "
	puts " To save, go to the kitchen and type 'save'", ""
	puts "-------------------------------------- ", ""
end

# game begins from this point
clear_screen()
title_screen()

timeNow = Time.now

# creates game state class
thePlayer = Player.new()

# checks if the game state has been saved in a file. If there is no save file, it makes one
if File.exists?('save.sauerkraut')

	# loads game state
	thePlayer = Marshal.load(File.open('save.sauerkraut', 'rb'))

	# check if the player is ill. If they are then it doesn't let them play
	arr = [
	    "You are feeling really sick... You don't want to do anything for a while...",
	    "Your stomach is rumbling... You don't have the energy to do anything...",
	    "You are feeling sick... You can't face the world right now...",
	    "You're real ill right now... You can't be bothered to do anything..."
	]
	    
	if Time.now.to_i < thePlayer.areIll
	    talk(arr.sample)
	    puts "", ""
	    sleep(0.5)
	    puts "Check back later"
	    gets
	    exit
	end

# starts the player off in the kitchen
in_kitchen(thePlayer)

else
	# creates game state and starts the player off in the kitchen
	File.open('save.sauerkraut', 'wb') { |f| f.write(Marshal.dump(thePlayer)) }
	move_room("start")
	sleep(0.8)
	talk("Please enter your name: ")
	puts
	personName = gets.strip
	talk("Nice to meet you #{personName}")
	sleep(0.5)
	puts
	in_kitchen(thePlayer)
end





