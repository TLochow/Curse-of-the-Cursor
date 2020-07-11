extends KinematicBody2D

var Motion = Vector2(0.0, 0.0)

func _physics_process(delta):
	Motion.y = min(Motion.y + (600.0 * delta), 300.0)
	
	var pos = get_position()
	var mousePos = .get_global_mouse_position()
	var distanceToMouse = mousePos.x - pos.x
	
	var isOnFloor = is_on_floor()
	
	if Input.is_action_just_pressed("mouse_click") and isOnFloor:
		Motion.y = -250.0
	
	Motion.x = lerp(Motion.x, distanceToMouse, delta * 10.0)
	
	Motion = move_and_slide(Motion, Vector2(0.0, -1.0))
	
	var moving = false
	if Motion.x < -1.0:
		$Sprite.flip_h = true
		moving = true
	elif Motion.x > 1.0:
		$Sprite.flip_h = false
		moving = true
	if isOnFloor:
		if moving:
			SwitchAnimation($AnimationPlayer, "Walk")
		else:
			SwitchAnimation($AnimationPlayer, "Idle")
	else:
		if Motion.y < 0.0:
			SwitchAnimation($AnimationPlayer, "Jump")
		elif Motion.y > 0.0:
			SwitchAnimation($AnimationPlayer, "Fall")

func SwitchAnimation(animationPlayer, animation):
	if animationPlayer.current_animation != animation:
		animationPlayer.play(animation)
