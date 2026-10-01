extends Node2D

var current_room

func _ready() -> void:
	for room in get_tree().get_nodes_in_group("room_areas"):
		if room is Area2D: #if child is area2d
			room.body_entered.connect(room_entry.bind(room)) 
			# ^^ on body entering a room the signal sends the body as an argument
			# .bind(room) creates a vers of the room_entry func with the room the signal belongs to as the 2nd argument 


func set_room(room):
	current_room = room

func room_entry(body,room): #body, room = arguments from line 7-9. in that specific order bc godot sends the body argument then room
	if body is CharacterBody2D:
		set_room(room)
		print(room.name)
