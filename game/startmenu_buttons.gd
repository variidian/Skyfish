extends Control
func _ready() -> void:
	stagger_pop_in()

func stagger_pop_in() -> void:
	var delay_step: float = 0.2
	var index: int = 0
	
	for child in get_children():
		child.scale = Vector2.ZERO
		
		# Handle unique centering logic per type
		if child is Control:
			child.pivot_offset = child.size / 2
		elif child is Sprite2D:
			child.centered = true
		
		# Run the shared tween animation
		var tween = create_tween().set_parallel(true)
		var start_delay = index * delay_step
		
		tween.tween_property(child, "scale", Vector2.ONE, 0.6)\
			.set_delay(start_delay)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_OUT)
			
		index += 1
