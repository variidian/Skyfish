extends Node2D
@onready var start_button = $pop_in/start_button
@onready var options_button = $pop_in/options_button
@onready var quit_button = $pop_in/quit_button
@onready var star = $pivot

func _ready() -> void:
	stagger_pop_in()

func stagger_pop_in() -> void:
	var delay_step: float = 0.15
	var index: int = 0
	
	for child in $pop_in.get_children():
		child.scale = Vector2.ZERO
		
		# Handle unique centering logic per type
		if child is Control:
			child.pivot_offset = child.size / 2
		elif child is Sprite2D:
			child.centered = true
		
		# Run the shared tween animation
		var tween = create_tween().set_parallel(true)
		var start_delay = index * delay_step
		
		tween.tween_property(child, "scale", Vector2.ONE, 0.3)\
			.set_delay(start_delay)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_OUT)
			
		if index == 3:
			await tween.finished
			start_button.grab_focus()
		
		index += 1
		

#star turns by 90deg tweening
func star_turn() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(star, "rotation_degrees",star.rotation_degrees + 90, 0.5)

func button_pop(node) -> void:
	var poptween = create_tween().set_parallel(true)
	poptween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	poptween.tween_property(node, "scale",Vector2(1.2,1.2), 0.1)
	poptween.tween_property(node, "rotation_degrees",-15, 0.1)

func button_shrink(node) -> void:
	var shrinktween = create_tween().set_parallel(true)
	shrinktween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	shrinktween.tween_property(node, "scale",Vector2(1,1), 0.1)
	shrinktween.tween_property(node, "rotation_degrees",-10.5, 0.1)

#button selected -> trigger star turning
func _on_start_button_focus_entered() -> void:
	star_turn()
	button_pop(start_button)
	
	button_shrink(options_button)
	button_shrink(quit_button)
func _on_options_button_focus_entered() -> void:
	star_turn()
	button_pop(options_button)
	
	button_shrink(start_button)
	button_shrink(quit_button)
func _on_quit_button_focus_entered() -> void:
	star_turn()
	
	button_pop(quit_button)
	
	button_shrink(start_button)
	button_shrink(options_button)
