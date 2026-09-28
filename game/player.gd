extends CharacterBody2D

const speed = 90
const air_speed = 120
const jump_height = -300

@onready var coyote_time = $coyote_timer
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var gravity = get_gravity().y #grab y value of gravity
		 # If vertical velocity is near 0 (apex), apply less gravity for hang time
		if abs(velocity.y) < 30.0: #peak of jump (top speed)
			velocity.y += gravity * 0.5 * delta  #half gravity
		elif velocity.y < 0: #when starting jump (acceleration)
			velocity.y += gravity * 0.7 * delta
		else: 
			velocity.y += gravity * 1 * delta  # (deceleration)
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_time.is_stopped()):
		velocity.y = jump_height
	
	var direction := Input.get_axis("left", "right")
	var current_speed = speed if is_on_floor() else air_speed
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and !is_on_floor(): #if was on floor and now isnt, start timer
		coyote_time.start()
