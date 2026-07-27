extends Node2D
@onready var start_button = $pop_in/start_button
@onready var options_button = $pop_in/options_button
@onready var quit_button = $pop_in/quit_button
@onready var star = $pivot
var tween:Tween

func _ready() -> void:
	start_button.grab_focus()

#star turns by 90deg tweening
func star_turn() -> void:
	if tween: tween.kill()
	tween = create_tween()
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
	button_pop(start_button)
	
	button_shrink(start_button)
	button_shrink(options_button)
