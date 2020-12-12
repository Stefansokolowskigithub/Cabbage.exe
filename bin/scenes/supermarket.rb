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
