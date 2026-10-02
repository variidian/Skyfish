extends Node2D

var current_room
var current_room_boundaries := {}

@onready var player = $player

signal room_bounds_changed

func _ready() -> void:
	for room in get_tree().get_nodes_in_group("room_areas"):
		if room is Area2D: #if child is area2d
			room.body_entered.connect(room_entry.bind(room)) 
			# ^^ on body entering a room the signal sends the body as an argument
			# .bind(room) creates a vers of the room_entry func with the room the signal belongs to as the 2nd argument 

func set_room(room):
	current_room = room

func room_entry(body,room): #body, room = arguments from line 7-9. in that specific order bc godot sends the body argument then room
	if body == player:
		set_room(room)
		print(room.name)
		find_room_bounds()
		SignalBus.room_bounds_changed.emit(current_room_boundaries)

func find_room_bounds():
	var room_collision_shape2d = current_room.get_child(0)
	var pos = room_collision_shape2d.global_position #position returns the center points x + y value
	var extents = room_collision_shape2d.shape.extents #extents = half sizes measured from the center of the rectangle
	
	current_room_boundaries = { #dictionary with the room boundary values
		"top": pos.y - extents.y,
		"bottom": pos.y + extents.y,
		"left": pos.x - extents.x,
		"right": pos.x + extents.x
	}
