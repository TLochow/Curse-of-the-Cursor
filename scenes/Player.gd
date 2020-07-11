extends KinematicBody2D

var Active = false
onready var InActivePos = get_position()

var Motion = Vector2(0.0, 0.0)

var coyoteTime = 0.0

func _physics_process(delta):
	Motion.y = min(Motion.y + (600.0 * delta), 300.0)
	
	var pos = get_position()
	
	var isOnFloor = is_on_floor()
	
	if Active:
		if Input.is_action_just_pressed("mouse_click") and coyoteTime > 0.0:
			coyoteTime = 0.0
			isOnFloor = false
			Motion.y = -250.0
		
		var mousePos = .get_global_mouse_position()
		var distanceToMouse = mousePos.x - pos.x
		Motion.x = lerp(Motion.x, distanceToMouse, delta * 10.0)
	else:
		var distanceToInactivePos = InActivePos.x - pos.x
		Motion.x = lerp(Motion.x, distanceToInactivePos, delta * 10.0)
	
	Motion = move_and_slide(Motion, Vector2(0.0, -1.0))
	
	var moving = false
	if Motion.x < -1.0:
		$Sprite.flip_h = true
		moving = true
	elif Motion.x > 1.0:
		$Sprite.flip_h = false
		moving = true
	if isOnFloor:
		coyoteTime = 0.1
		if moving:
			SwitchAnimation($AnimationPlayer, "Walk")
		else:
			SwitchAnimation($AnimationPlayer, "Idle")
	else:
		coyoteTime -= delta
		if Motion.y < 0.0:
			SwitchAnimation($AnimationPlayer, "Jump")
		elif Motion.y > 0.0:
			SwitchAnimation($AnimationPlayer, "Fall")

func SwitchAnimation(animationPlayer, animation):
	if animationPlayer.current_animation != animation:
		animationPlayer.play(animation)

func Activate():
	Active = true

func Deactivate(pos):
	Active = false
	InActivePos = pos
