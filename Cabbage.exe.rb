require_relative "bin/gameState.rb"
require_relative "bin/utils.rb"
require_relative "bin/scenes/supermarket.rb"
require_relative "bin/scenes/kitchen.rb"
require_relative "bin/scenes/larder.rb"
require_relative "bin/scenes/mother.rb"


# update accordingly
def game_version
	return 1.0
end

# game begins from this point
clear_screen()
title_screen()


timeNow = Time.now

# creates game state class
thePlayer = Player.new()

# checks if the game state has been saved in a file. If there is no save file, it makes one
if File.exists?('sav/save.sauerkraut')

	# loads game state
	thePlayer = Marshal.load(File.open('sav/save.sauerkraut', 'rb'))

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
	File.open('sav/save.sauerkraut', 'wb') { |f| f.write(Marshal.dump(thePlayer)) }
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




