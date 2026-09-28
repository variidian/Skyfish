extends CharacterBody2D

const speed = 90
const jump_height = -300
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		var gravity = get_gravity().y #grab y value of gravity
		 # If vertical velocity is near 0 (apex), apply less gravity for hang time
		if abs(velocity.y) < 30.0: #peak of jump
			velocity.y += gravity * 0.5 * delta  #half gravity
		elif velocity.y < 0: #when starting jump
			velocity.y += gravity * 0.8 * delta
		else: 
			velocity.y += gravity * 1 * delta  # Falling gravity (faster fall)
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_height
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
