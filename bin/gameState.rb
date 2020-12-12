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
