extends KinematicBody2D

var Active = false
onready var InActivePos = get_position()

onready var PushCast = $PushCast

export(bool) var MouseControl

var Motion = Vector2(0.0, 0.0)

var coyoteTime = 0.0

func _ready():
	if MouseControl:
		CenterCursor()
	$Tween.interpolate_property($Sprite, "modulate", Color(0.0, 0.0, 0.0, 1.0), Color(1.0, 1.0, 1.0, 1.0), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func CenterCursor():
	get_viewport().warp_mouse(InActivePos)

func _physics_process(delta):
	Motion.y = min(Motion.y + (600.0 * delta), 300.0)
	
	var pos = get_position()
	
	var isOnFloor = is_on_floor()
	
	if Active:
		if MouseControl:
			if Input.is_action_just_pressed("mouse_click") and coyoteTime > 0.0:
				coyoteTime = 0.0
				isOnFloor = false
				Motion.y = -250.0
				$Jump.play()
			var mousePos = .get_global_mouse_position()
			var distanceToMouse = mousePos.x - pos.x
			Motion.x = lerp(Motion.x, distanceToMouse, delta * 10.0)
		else:
			var xMove = 0.0
			if Input.is_action_pressed("ui_left"):
				xMove += -100.0
			if Input.is_action_pressed("ui_right"):
				xMove += 100.0
			if Input.is_action_just_pressed("ui_up") and coyoteTime > 0.0:
				Motion.y = -250.0
				$Jump.play()
			
			Motion.x = xMove
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

func Blackout(pos):
	$Tween.interpolate_property($Sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(0.0, 0.0, 0.0, 1.0), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func Push(pushTo):
	PushCast.cast_to = pushTo
	PushCast.force_raycast_update()
	var pushable = false
	if not PushCast.is_colliding():
		pushable = true
		set_position(get_position() + pushTo)
	return pushable

func Crush():
	$Crush.play()
	Global.LoadLevel()
