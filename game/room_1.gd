extends Sprite2D

var room_boundaries := {}
var respawn_marker

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
		player.global_position = respawn_marker.global_position
