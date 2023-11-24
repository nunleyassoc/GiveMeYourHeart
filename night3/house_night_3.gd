extends Control

@onready var black_bg = $BlackBG
@onready var black_anim = $BlackBG/BackgroundAnim
@onready var footies = $Footies
@onready var deathtimer = $deathtimer
@onready var blood = $blood
@onready var punch = $punch
@onready var punchsfx = $punchsfx
@onready var knife = $knife
@onready var knifetimer = $knifetimer
@onready var punch_2_timer = $punch2timer
@onready var punch_2 = $punch2
@onready var black_bg_2 = $BlackBG2
@onready var toendtimer = $toendtimer


#fix sound scale
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_footies_finished():
	knifetimer.start()
	deathtimer.start()
	punchsfx.start()


func _on_deathtimer_timeout():
	blood.show()
func _on_punchsfx_timeout():
	punch.play()
	punch_2_timer.start()


func _on_knifetimer_timeout():
	knife.play()


func _on_punch_2_timer_timeout():
	punch_2.play()
	blood.hide()
	black_bg_2.show()
	toendtimer.start()


func _on_toendtimer_timeout():
	get_tree().change_scene_to_file("res://RetryGame/retry_screen.tscn")






func _ready():
	# Load Scene1
	var scene1 = load("res://night2/house_night_2.tscn")
	
	# Instantiate Scene1 as a node
	var scene1_instance = scene1.instance()
	add_child(scene1_instance)
	
	# Connect to the signal in Scene1
	if scene1_instance.has_method("variable_sent"):
		scene1_instance.connect("variable_sent", self, "_on_variable_sent")

func _on_variable_sent(value):
	print("Received variable from Scene1:", value)
	# Do something with the received variable
