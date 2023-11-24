extends Control

#Rooms
@onready var couch_light = $CouchLight
@onready var couch_dark = $CouchDark
@onready var peephole_no = $PeepHoleNo
@onready var peephole_yes = $PeepHoleYes
@onready var electrical_light = $ElectricalLight
@onready var electrical_dark = $ElectricalDark
@onready var breaker_dark = $BreakerDark
@onready var breaker_light = $BreakerLight

#Blink
@onready var blinker = $BlinkControl
@onready var blink_anim = $BlinkControl/BlinkPlayer
@onready var blink_timer = $BlinkControl/BlinkTimer
@onready var move_timer = $BlinkControl/MoveTimer
var action = null
var reaction = null
var peephole_lighting = null # works for now
var window_lighting = null

#Audio
@onready var couch_sound = $CouchLight/SitOnCouch
@onready var switch_sound = $CouchLight/ClickButtons
@onready var stand_sound = $CouchLight/StandingUp
@onready var knocking = $PeepHoleNo/Knocking
@onready var peep_audio = $PeepHoleNo/PeepholeBreath
@onready var bg_fan = $CouchLight/BackgroundFan
@onready var noti = $CouchLight/PhoneLight/Notification
@onready var crying = $CouchLight/Crying
@onready var to_breaker_sound = $ElectricalDark/ToBreakerSound

#vent sounds
@onready var vent_upper = $ElectricalLight/Vent_Hit_Upper
@onready var vent_lower = $ElectricalLight/Vent_Hit_Lower
@onready var vent_hiss = $ElectricalLight/VentHiss
@onready var cough = $ElectricalLight/Cough

#tv sounds
@onready var tv_sounds = $CouchDark/TVSounds
@onready var breaking_bad = $CouchDark/BreakingBad
@onready var better_call_saul = $CouchDark/BetterCallSaul
@onready var netflix = $CouchDark/Netflix
@onready var stranger_things = $CouchDark/StrangerThings

#Electrical Power Off Sounds
@onready var h_slider_power1_off_audio = $ElectricalLight/PowerDown1
@onready var h_slider_power2_off_audio = $ElectricalLight/PowerDown2
@onready var h_slider_power3_off_audio = $ElectricalLight/PowerDown3
@onready var electrical_audio = $ElectricalLight/ElectricalAudio
@onready var lights_off_audio = $ElectricalLight/LightsOff
@onready var light_tick = $ElectricalLight/TickDown

#Electrical
@onready var h_slider_power1 = $BreakerDark/HSliderPower
@onready var h_slider_power2 = $BreakerDark/HSliderPower2
@onready var h_slider_power3 = $BreakerDark/HSliderPower3
var can_use_lights = true

#Window
@onready var window = $Window
@onready var boop = $Window/Boop #sound
@onready var rain = $Window/Rain #sound

#Black vision cover
@onready var black_bg = $BlackBG
@onready var black_anim = $BlackBG/BackgroundAnim

#burlap 
@onready var burlap_canvas = $BurlapCanvas
@onready var burlapanim = $BurlapCanvas/burlapanim

#ticks
var difficulty = 1
const min_tick_rate = 3
var random_tick = null
@onready var tick_timer = $TEST/TickTimer
@onready var door_knocking = $CouchLight/DoorKnocking
@onready var break_glass = $ElectricalLight/BreakGlass
@onready var tapping_glass = $Window/TappingGlass
@onready var upper_to_lower = $ElectricalDark/UpperToLower
@onready var walking_on_glass = $ElectricalLight/WalkingOnGlass
@onready var smokebomb_timer = $TEST/SmokebombTimer
@onready var whispers = $TEST/Whispers
@onready var enter_room = $TEST/EnterRoom
@onready var window_timer = $TEST/WindowTimer
@onready var lock_timer = $PeepHoleNo/LockTimer
var glass_broken = false
var front_locked = false
var electric_locked = false
@onready var front_door_timer = $PeepHoleNo/FrontDoorTimer
@onready var jumpscare_timer = $TEST/JumpscareTimer
@onready var footsteps = $TEST/Footsteps
var difficulty_spike = false

#tests
@onready var rect_1 = $TEST/rect1
@onready var rect_2 = $TEST/rect2
@onready var rect_3 = $TEST/rect3
@onready var rect_4 = $TEST/rect4
@onready var rect_5 = $TEST/rect5
@onready var rect_6 = $TEST/rect6
@onready var rect_7 = $TEST/rect7
@onready var rect_8 = $TEST/rect8
@onready var rect_9 = $TEST/rect9
@onready var test = $TEST

#radar
@onready var level_1 = $CouchLight/PhoneLight/radar/Level1
@onready var level_2 = $CouchLight/PhoneLight/radar/Level2
@onready var level_3 = $CouchLight/PhoneLight/radar/Level3
@onready var level_4 = $CouchLight/PhoneLight/radar/Level4

#killer in couch
@onready var killer_in_couch = $CouchLight/KillerInCouch
@onready var killer_in_5 = $CouchLight/KillerIn5
@onready var killer_in_window = $CouchLight/KillerInWindow
@onready var window_timer_2 = $TEST/WindowTimer2


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _process(delta):
	var x = delta
	delta = x #stops the annoying error
	hide_all_rects()
	show_correct_rect()
	whisper_check()
	radar()
	electrical_jumpscare_check()

#BLINKS
#HAPPENS AT THE START OF THE BLINK WHEN BUTTON IS PRESSED
func blink():
	blinker.show()
	blink_anim.play("Blink")
	blink_timer.start()
	move_timer.start()

#HAPPENS IN THE MIDDLE OF THE BLINK WHEN SCREEN IS BLACK
func _on_move_timer_timeout():
	action.hide()
	reaction.show()
	
	if reaction == window:
		vent_hiss_and_cough_end()

#TIMER HIDES BLINKER AND TIMER ITSELF
#SEEMS UNNESSARY BUT I WANT BLINKS TO STOP PLAYERS MOUSE
func _on_blink_timer_timeout():
	blinker.hide()


#BUTTONS
#LIGHT SWITCH OFF
func _on_light_switch_on_button_down():
	if can_use_lights == true:
		blink()
		
		action = couch_light
		reaction = couch_dark
		
		switch_sound.play()
		rand_tv_sounds()

#LIGHT SWITCH ON
func _on_light_switch_off_button_down():
	if can_use_lights == true:
		blink()
		action = couch_dark
		reaction = couch_light
		
		switch_sound.play()
		end_tv_sounds()


#GO TO PEEPHOLE DARK
func _on_go_to_peep_dark_button_down():
	blink()
	
	action = couch_dark
	reaction = peephole_no #make this a var and change it when the time comes
	
	bg_fan.stop()
	stand_sound.play()
	peep_audio.play()
	
	peephole_lighting = couch_dark

#GO TO PEEPHOLE LIGHT
func _on_go_to_peep_light_button_down():
	blink()
	
	action = couch_light
	reaction = peephole_no #make this a var and change it when the time comes
	
	bg_fan.stop()
	stand_sound.play()
	peep_audio.play()
	
	peephole_lighting = couch_light


#BACK FROM PEEPHOLE NO JUMPSCARE
func _on_back_button_no_button_down():
	blink()
	
	action = peephole_no
	reaction = peephole_lighting
	
	bg_fan.play()
	couch_sound.play()

#BACK FROM PEEPHOLE YES JUMPSCARE
func _on_back_button_yes_button_down():
	blink()
	
	action = peephole_yes
	reaction = peephole_lighting
	
	bg_fan.play()
	couch_sound.play()


# GO TO ELECTRICAL IN THE LIGHT
func _on_go_to_electrical_light_button_down():
	blink()
	
	action = couch_light
	reaction = electrical_light
	
	stand_sound.play()
	electrical_audio.play()

# GO TO ELECTRICAL IN THE DARK
func _on_go_to_electrical_dark_button_down():
	blink()
	
	action = couch_dark
	reaction = electrical_dark
	
	stand_sound.play()
	electrical_audio.play()


#BACK TO COUCH IN THE LIGHT
func _on_back_to_couch_light_button_down():
	blink()
	
	action = electrical_light
	reaction = couch_light
	
	couch_sound.play()
	electrical_audio.stop()

#BACK TO COUCH IN THE DARK
func _on_back_to_couch_dark_button_down():
	blink()
	
	action = electrical_dark
	reaction = couch_dark
	
	couch_sound.play()
	electrical_audio.stop()


#BREAKER DARK TO ELECTRICAL DARK
func _on_back_button_dark_button_down():
	blink()
	
	action = breaker_dark
	reaction = electrical_dark

#BREAKER LIGHT TO ELECTRICAL LIGHT
func _on_back_button_light_button_down():
	blink()
	
	action = breaker_light
	reaction = electrical_light


#ELECTRICAL DARK TO BREAKER DARK
func _on_breaker_dark_button_down():
	blink()
	
	to_breaker_sound.play()
	action = electrical_dark
	reaction = breaker_dark

#ELECTRICAL LIGHT TO BREAKER LIGHT
func _on_breaker_light_button_down():
	blink()
	
	to_breaker_sound.play()
	action = electrical_light
	reaction = breaker_light


#COUCH TO WINDOW IN THE LIGHT
func _on_window_light_button_down():
	blink()
	
	action = couch_light
	reaction = window
	
	bg_fan.stop()
	stand_sound.play()
	rain.play()
	peep_audio.play()
	
	window_lighting = couch_light

#COUCH TO WINDOW IN THE DARK
func _on_window_dark_button_down():
	blink()
	
	action = couch_dark
	reaction = window
	
	bg_fan.stop()
	stand_sound.play()
	rain.play()
	peep_audio.play()
	
	window_lighting = couch_dark

#WINDOW TO COUCH
func _on_window_back_button_button_down():
	blink()
	
	action = window
	reaction = window_lighting
	rain.stop()
	bg_fan.play()
	couch_sound.play()

#SNOOTBOOPNOISE
func _on_snoot_boop_button_down():
	boop.play()


#coughing sfx and cough kill
func _on_background_anim_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		get_tree().change_scene_to_file("res://night3/house_night_3.tscn")
	
	if anim_name == "coughing_15_sec":
		get_tree().change_scene_to_file("res://night3/house_night_3.tscn")
		black_anim.play("black_lol") #add jumpscare
	if anim_name == "coughing_10_sec":
		get_tree().change_scene_to_file("res://night3/house_night_3.tscn")
		black_anim.play("black_lol") #make this the kill / add jumpscare


#VentSounds
func vent_hiss_and_cough():
	vent_hiss.play()
	cough.play()
	black_anim.play("coughing_10_sec")
func vent_hiss_and_cough_end():
	vent_hiss.stop()
	cough.stop()
	black_anim.play("RESET") #stops the screen from going black

#REPEATS TV SOUND
func _on_tv_sounds_finished():
	tv_sounds.play()
func _on_background_fan_finished():
	bg_fan.play()
#funny tv sounds add more if time for polish
func rand_tv_sounds():
	var tv_s = randi_range(0,6)
	if tv_s == 0 or tv_s == 1 or tv_s == 2 or tv_s == 3 or tv_s == 4 or tv_s == 5:
		tv_sounds.play()
	elif tv_s== 6:
		netflix.play()
func _on_netflix_finished():
	var netty = randi_range(0,4)
	if netty == 0:
		breaking_bad.play()
	elif netty== 1:
		better_call_saul.play()
	elif netty == 2:
		stranger_things.play()
	elif netty == 3:
		tv_sounds.play()
	else:
		pass
func end_tv_sounds():
	tv_sounds.stop()
	breaking_bad.stop()
	netflix.stop()
	better_call_saul.stop()
	stranger_things.stop()


#light settings
func turn_lights_on():
	if h_slider_power1.value == 100 and \
		 h_slider_power2.value == 100 and \
			h_slider_power3.value == 100:
		switch_lights(true)

func turn_lights_off():
	if h_slider_power1.value == 0 or \
		 h_slider_power2.value == 0 or \
			h_slider_power3.value == 0:
		switch_lights(false)

func kill_lights():
	h_slider_power1.value = 0
	h_slider_power2.value = 0
	h_slider_power3.value = 0
	turn_lights_off()

func switch_lights(switch):
	if switch == true:
		action = breaker_dark
		reaction = breaker_light
		
		breaker_dark.hide()
		breaker_light.show()
		
		end_tv_sounds()
		can_use_lights = true
		
	if switch == false:
		lights_off_audio.play()
		rand_tv_sounds()
		
		if reaction == null: #for insta shut off
			couch_dark.show()
			couch_light.hide()
			reaction = couch_dark #changes reaction
		if reaction == couch_light:
			couch_dark.show()
			couch_light.hide()
			reaction = couch_dark
		if reaction == electrical_light:
			electrical_dark.show()
			electrical_light.hide()
			reaction = electrical_dark
		if reaction == breaker_light:
			breaker_dark.show()
			breaker_light.hide()
			reaction = breaker_dark
		
		window_lighting = couch_dark
		peephole_lighting = couch_dark #sorry this is staying lol
		can_use_lights = false

func powering_off():
#Rate at which lights turn off
#Can be Changed to add Difficulty
	var random_slider = randi_range(0,2)
	
	if random_slider == 0:
		h_slider_power1.value -= 25
		light_tick.play()
	elif random_slider == 1:
		h_slider_power2.value -= 25
		light_tick.play()
	elif random_slider == 2:
		h_slider_power3.value -= 25
		light_tick.play()

func _on_h_slider_power_value_changed(value):
	if value == 100:
		h_slider_power1_off_audio.play()
		turn_lights_on()
	elif value == 0:
		turn_lights_off()
func _on_h_slider_power_2_value_changed(value):
	if value == 100:
		h_slider_power2_off_audio.play()
		turn_lights_on()
	elif value == 0:
		turn_lights_off()
func _on_h_slider_power_3_value_changed(value):
	if value == 100:
		h_slider_power3_off_audio.play()
		turn_lights_on()
	elif value == 0:
		turn_lights_off()



#Difficulty  |  Minimum Value  |  Maximum Value
#----------------------------------------------
#    1       |        3        |       13
#    2       |        3        |       11
#    3       |        3        |        9
#    4       |        3        |        7
#    5       |        3        |        5
#    6       |        3        |        3
#                       Difficulty
#
#Minimum Value is constant at 3 for all difficulty levels.


# Calculate the maximum value based on the difficulty
func create_random_tick():
	var max_tick = 30 - (difficulty * 2) # Adjust this formula as needed
	# Ensure the maximum tick doesn't go below the minimum tick rate
	max_tick = max(min_tick_rate, max_tick)
	random_tick = randi() % (max_tick - min_tick_rate + 1) + min_tick_rate
	
	update_tick_timer_length(1, random_tick)

func update_tick_timer_length(type, new_time):
	if type == 1: #sets the time from the random tick creator
		tick_timer.set_wait_time(new_time)
		if !tick_timer.is_stopped():
			tick_timer.start()
	
	if type == 2: #adds time, such as for windows,doors, and vents
		var remaining_time = ceil(tick_timer.time_left)
		if new_time < remaining_time:
			tick_timer.stop()
			tick_timer.wait_time = remaining_time + new_time
			tick_timer.start()
	
	if type == 3:
		tick_timer.stop()
		tick_timer.set_wait_time(new_time)
		tick_timer.start()
	
	#print("random tick: ", random_tick)
	#print("Next action in: ", tick_timer.wait_time)

func _on_tick_timer_timeout(): 
	tick()
	create_random_tick()

func tick():
	var action_or_movement = randi_range(0, 3)#currently not using tick4
	if action_or_movement == 0:
		movement_tick()
	elif action_or_movement == 1:
		action_tick()
	elif action_or_movement == 2:
		movement_tick()
		powering_off()
	elif action_or_movement == 3:
		action_tick()
		powering_off()
	elif action_or_movement == 4:
		powering_off()
		print("TICK")

func action_tick():
	#decides what action the killer does
	var current_action = randi_range(0,3)
	
	if killer_location == 1: #deck
		if current_action == 0:
			break_glass_action()
		elif current_action == 1:
			door1_action() 
		elif current_action == 2:
			window_action()
		elif current_action == 3:
			vent_action()
	
	elif killer_location == 2: #door1
		if current_action == 0 or current_action == 1 or current_action == 2:
			door1_action()
		elif current_action == 3:
			window_action()
	
	elif killer_location == 3: #door2
		killer_location = 6
	
	elif killer_location == 4: #vent
		vent_action()
	
	elif killer_location == 5: #electrical
		if current_action == 0 or current_action == 1:
			smokebomb()
			kill_lights()
			failed_action()
		elif current_action == 2 or current_action == 3:
			killer_location = 9 #lol nice code dood
			electrical_jumpscare()
	
	elif killer_location == 6: #nathan
		if current_action == 0 or current_action == 1 or current_action == 2:
			killer_location = 5
			print("Moved to location ", killer_location)
		elif current_action == 3:
			vent_action()
	
	elif killer_location == 7: #window_breakable
		break_glass_action()
	
	elif killer_location == 8: #window_unbreakable
		window_action()

func movement_tick():
# Fetch the possible destinations based on the current killer location
# Choose a random destination from the possible destinations
# Update the killer's location to the newly chosen destination
# Output the new location or perform any movement logic here
	var possible_destinations = []
	if allowed_movements.has(killer_location):
		possible_destinations = allowed_movements[killer_location]
	
	if possible_destinations.size() == 1:
		killer_location = possible_destinations[0]
	else:
		var destination = possible_destinations[randi_range(0, possible_destinations.size() - 1)]
		killer_location = destination
	
	
	if killer_location == 7:
		break_glass_action()
	elif killer_location == 9:
		electrical_jumpscare()
	
	if difficulty_spike == true:
		
		if killer_location == 3:
			killer_location = 6
		elif killer_location == 4:
			vent_action()
		elif killer_location == 6:
			break_glass_action()
		elif killer_location == 8:
			window_action()

	
	print("Moved to location ", killer_location)

var allowed_movements = {
	1: [2, 7], 
	2: [2, 8], 
	3: [6], 
	4: [6],
	5: [9], 
	6: [5, 4], 
	7: [6, 4],
	8: [8, 2],
	9: [1], 
	}

var killer_location = 1

var deck = 1
var door1 = 2
var door2  = 3 #out of the game
var vent  = 4
var electrical  = 5
var nathan  = 6
var window_breakable  = 7
var window_unbreakable  = 8
var couch  = 9

func failed_action():
	killer_in_couch.hide()
	killer_location = 1
	print("Failed, now at deck")

func whisper_check():
	if killer_location == 6 and reaction == electrical_light:
		if !whispers.is_playing():
			whispers.play()
	elif killer_location == 6 and reaction == electrical_dark:
		if !whispers.is_playing():
			whispers.play()
	elif killer_location == 5 and reaction == couch_light:
		if !whispers.is_playing():
			whispers.play()
	elif killer_location == 5 and reaction == couch_dark:
		if !whispers.is_playing():
			whispers.play()
	elif killer_location == 6 and reaction == breaker_dark:
		if !whispers.is_playing():
			whispers.play()
	elif killer_location == 6 and reaction == breaker_light:
		if !whispers.is_playing():
			whispers.play()
	else:
		whispers.stop()

#breakable_window, should be complete
func break_glass_action():
	if glass_broken == false:
		break_glass.play()
		killer_location = 6
		glass_broken = true
	else:
		walking_on_glass.play()
		killer_location = 6
	
	print("Entered Nathans")

#front door
func door1_action():
	door_knocking.play()
	killer_location = 2
	#must add jumpscare and enter couch noises
	#Difficulty must change how much time is avaliable
	
	update_tick_timer_length(3, 9)
	
	front_door_timer.start()
	
	print("Knocking at front door")
func _on_lock_button_down():
	lock_timer.start()
	front_locked = true
func _on_lock_timer_timeout():
	front_locked = false
func _on_front_door_timer_timeout():
	if front_locked == false:
		door_kill()
	else:
		failed_action()

#vent
func vent_action():
	vent_upper.play()
	killer_location = 4
	#Difficulty must change how much time is avaliable
	
	update_tick_timer_length(3, 9)
	
	print("In the vents")
#waits for vent upper noise to finish
func _on_vent_hit_upper_finished():
	#change vent timer by difficulty
	upper_to_lower.start()
#starts the timer between upper and lower vent noises
func _on_upper_to_lower_timeout():
	vent_lower.play()
#plays either a smokebomb or enters electrical
func _on_vent_hit_lower_finished():
	if reaction == electrical_dark or reaction == electrical_light:
		smokebomb()
		failed_action()
	else:
		killer_location = 5
		print("In Electrical")
#after 1-10 sec, starts the smokebomb
func smokebomb():
	var random_time = randi_range(1, 10)
	smokebomb_timer.wait_time = random_time
	# If the timer is currently stopped, start it again with the new time
	smokebomb_timer.start()
func _on_smokebomb_timer_timeout():
	vent_hiss_and_cough()



func window_action():
	tapping_glass.play()
	killer_location = 8
	print("Climbing the window")
	
	update_tick_timer_length(3, 7)
	#difficulty sets a timer:
	window_timer.start()

func _on_window_timer_timeout():
	if !reaction == couch_dark:
		killer_in_window.show()
		enter_room.play()
		window_timer_2.start()
		can_use_lights = false
		print("WINDOW JUMPSCARE")
	else:
		failed_action()

func _on_window_timer_2_timeout():
	burlapanim.play("bag_window")




func door_kill(): #add stuff here like door opening noise
		burlapanim.play("puttingthebagon")

func electrical_jumpscare():
	enter_room.play()
	killer_in_couch.show()
	update_tick_timer_length(3, 7)
	jumpscare_timer.start()
	#if failed, do smokebomb or lights out and move to deck(1)
	print("ELECTRICAL JUMPSCARE")





func _on_jumpscare_timer_timeout():
	if !reaction == couch_dark:
		burlapanim.play("puttingthebagon")
	else:
		failed_action()

#for when you go to electrical and hes already there
func electrical_jumpscare_check():
	if killer_location == 5 and reaction == electrical_light or \
		killer_location == 5 and reaction == electrical_dark or \
			killer_location == 5 and reaction == breaker_dark or \
				killer_location == 5 and reaction == breaker_light or \
						killer_location == 9 and reaction == electrical_light or \
								killer_location == 9 and reaction == electrical_dark:
									burlapanim.play("puttingthebagon")
									crying.play()
	if killer_location == 5:
		killer_in_5.show()
	else:
		killer_in_5.hide()
#add more for like electrical or breaker box????????




signal variable_sent

var my_variable = "Hello from Scene1"




func _on_burlapanim_animation_finished(anim_name):
	if anim_name == "puttingthebagon":
		get_tree().change_scene_to_file("res://night3/house_night_3.tscn")
	if anim_name == "bag_window":
		
		emit_signal("variable_sent", my_variable)
		
		get_tree().change_scene_to_file("res://night3/house_night_3.tscn")



#test stuff
func show_correct_rect():
	if killer_location == 1:
		rect_1.show()
	if killer_location == 2:
		rect_2.show()
	if killer_location == 3:
		rect_3.show()
	if killer_location == 4:
		rect_4.show()
	if killer_location == 5:
		rect_5.show()
	if killer_location == 6:
		rect_6.show()
	if killer_location == 7:
		rect_7.show()
	if killer_location == 8:
		rect_8.show()
	if killer_location == 9:
		rect_9.show()
func hide_all_rects():
	rect_1.hide()
	rect_2.hide()
	rect_3.hide()
	rect_4.hide()
	rect_5.hide()
	rect_6.hide()
	rect_7.hide()
	rect_8.hide()
	rect_9.hide()

#TESTING TICKS
func _on_onoffonoff_toggled(button_pressed):
	if button_pressed == true:
		test.show()
	else:
		test.hide()
func _on_test_random_tick_button_down():
	tick_timer.stop()
func _on_test_random_tick_2_button_down():
	tick_timer.start()
func _on_test_random_tick_3_button_down():
	tick()
func _on_test_random_tick_4_button_down():
	powering_off()
	turn_lights_off()
func _on_test_difficulty_button_down():
	difficulty += 1
func _on_action_tester_button_down():
	#break_glass_action()
	#door1_action()
	#door2_action() #0ut of game
	#vent_action()
	window_action()
	#electrical_jumpscare()
	#killer_location = 5
	pass

#phone radar
func radar():
	if killer_location == 1 or killer_location == 7:
		level_1.show()
		level_2.hide()
		level_3.hide()
		level_4.hide()
	elif killer_location == 6 or killer_location == 3 or killer_location == 4:
		level_1.hide()
		level_2.show()
		level_3.hide()
		level_4.hide()
	elif killer_location == 5 or killer_location == 8 or killer_location == 2:
		level_1.hide()
		level_2.hide()
		level_3.show()
		level_4.hide()
	elif killer_location == 9:
		level_1.hide()
		level_2.hide()
		level_3.hide()
		level_4.show()

#Phone 
@onready var phone_node = $CouchLight/PhoneLight
@onready var home = $CouchLight/PhoneLight/Home
@onready var phone_app_options = $CouchLight/PhoneLight/AppOptions
@onready var phone_radar = $CouchLight/PhoneLight/radar
@onready var no_messages = $CouchLight/PhoneLight/NoMessages
@onready var messages = $CouchLight/PhoneLight/Messages

#messages
@onready var message_loading = $CouchLight/PhoneLight/MessageLoading
@onready var final_message = $CouchLight/PhoneLight/FinalMessage
@onready var threat = $CouchLight/PhoneLight/FinalMessage/Threat
@onready var go_away = $CouchLight/PhoneLight/FinalMessage/GoAway
@onready var message_1_timer = $CouchLight/PhoneLight/Message1Timer
var message_recieved = false

#goes to the app
func _on_load_tracker_button_down():
	home.hide()
	phone_app_options.show()
#goes to the cops
func _on_load_police_button_down():
	pass # Replace with function body.

#IN APP Choices
#goes to radar
func _on_radar_button_down():
	phone_app_options.hide()
	phone_radar.show()
#goes to messages
func _on_message_button_down():
	phone_app_options.hide()
	show_message()
#back to home page
func _on_back_to_home_button_down():
	phone_app_options.hide()
	home.show()

#radar to options
func _on_back_to_options_button_down():
	phone_radar.hide()
	phone_app_options.show()

func show_message():
	if message_recieved == true:
		messages.show()
	else:
		no_messages.show()

#whenever theres a noti, goes to messages
func _on_go_to_messages_button_down():
	final_message.show()


#message to options
func _on_back_to_p_opts_button_down():
	final_message.hide()
	phone_app_options.show()

#in the no messages
func _on_back_to_opts_button_down():
	no_messages.hide()
	phone_app_options.show()
#in the messages
func _on_back_to_optys_button_down():
	messages.hide()
	phone_app_options.show()


func _on_message_1_timer_timeout():
	noti.play()
	message_recieved = true


#try to make scaleing difficulty

#whispers doesnt work if the player never moves but who cares...

#resize all buttons to their correct spots
#make work on all resolutions?

#add something fun or anything to house_3

#main focus top needed: story, phone anything...

#make enter and hide func for door and window and electrical?

#add more axe only stuff for like electrical or breaker box????????


