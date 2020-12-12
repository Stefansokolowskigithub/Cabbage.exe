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
