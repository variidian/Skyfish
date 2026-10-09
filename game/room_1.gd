extends Sprite2D

var room_boundaries := {}
var respawn_marker
var is_dying

@onready var player = $"../../player"

func _ready():
	SignalBus.room_bounds_changed.connect(_on_room_bounds_changed)
	
	respawn_marker = find_child("Marker2D") #recursively finds the node with the name "Marker2D" under this script's node
	#useful if the marker2d is nested differently in each room


func _on_room_bounds_changed(boundaries: Dictionary, room: Node) -> void: #boundaries is the name from the signal bus, carrying the dictionary data from world.gd
	if is_ancestor_of(room): # the entered Area2D is under this room
		room_boundaries = boundaries
	else:
		room_boundaries = {} # not the active room, so stay idle

func _physics_process(delta: float) -> void:
	if room_boundaries.is_empty(): #for when it hasnt loaded yet
		return
	if player.position.y > room_boundaries["bottom"]:
		death()

func death():
	
	if is_dying:
		return
	is_dying = true
	
	#pause player
	player.set_physics_process(false)
	player.set_process_input(false)
	
	#death particles
	%death_particles.global_position = player.global_position
	%death_particles.emitting = true
	await %death_particles.finished #wait till particles finish before continuing rest of code
	
	#find starting position, based on current room
	var rect_starting_pos = room_boundaries["pos"]
	rect_starting_pos.y -= 180 # + 1 room height
	var rect_room_pos = room_boundaries["pos"]
	#find ending position, based on currnet room
	var rect_ending_pos = room_boundaries["pos"]
	rect_ending_pos.y += 180 # - 1 room height
	
	#set starting point + visibility
	var death_anim_marker2d = %death_anim
	death_anim_marker2d.global_position = rect_starting_pos
	death_anim_marker2d.show() #hidden before, show it now
	
	#actual animation 
	var tween = create_tween() 
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(death_anim_marker2d, "position", rect_room_pos, 0.5)
	await tween.finished #wait till finihsed tween to continue
	#reset player pos now the whole screen is covered
	player.global_position = respawn_marker.global_position # die + reset spawn
	await get_tree().create_timer(0.1).timeout
	var tweentwo = create_tween() 
	tweentwo.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tweentwo.tween_property(death_anim_marker2d, "position", rect_ending_pos, 0.5)
	
	#unpause player + visibility
	await tweentwo.finished #wait until tween finished playing
	player.set_physics_process(true)
	player.set_process_input(true)
	death_anim_marker2d.hide()
	is_dying = false
