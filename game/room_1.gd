extends Sprite2D

var room_boundaries := {}

@onready var player = $"../../player"

func _ready():
	SignalBus.room_bounds_changed.connect(_on_room_bounds_changed)

func _on_room_bounds_changed(boundaries: Dictionary) -> void: #boundaries is the name from the signal bus, carrying the dictionary data from world.gd
	room_boundaries = boundaries
	print("test")

func _physics_process(delta: float) -> void:
	if room_boundaries.is_empty():
		return
	if player.position.y > room_boundaries["bottom"]:
		print("player should die here")
