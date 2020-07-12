extends KinematicBody2D

export(bool) var MoveUpAndDown = false

onready var Eye = $Eye
onready var MouseCast = $MouseCast
onready var Beam = $Beam

var Moving = false
var MoveLeft = false
export(float) var TimeTillMove = 0.0

var GrappingMouse = false
var MouseInView = 0.0
var Pos = Vector2(0.0, 0.0)
var MousePos = Vector2(0.0, 0.0)
var CollisionPoint = Vector2(0.0, 0.0)

var Motion = Vector2(0.0, 0.0)

func _ready():
	if TimeTillMove <= 0.0:
		TimeTillMove = rand_range(5.0, 10.0)
	if MoveUpAndDown:
		$LeftCast.cast_to = Vector2(0.0, -32.0)
		$RightCast.cast_to = Vector2(0.0, 32.0)

func _physics_process(delta):
	Pos = get_position()
	MousePos = .get_global_mouse_position()
	var directionToMouse = (MousePos - (Pos + Vector2(0.0, -2.0)))
	Eye.rotation = directionToMouse.angle() + 0.785398
	
	MouseCast.cast_to = to_local(MousePos)
	if MouseCast.is_colliding():
		GrappingMouse = false
		MouseInView = 0.0
		CollisionPoint = MouseCast.get_collision_point()
		if Beam.playing:
			Beam.stop()
	elif GrappingMouse:
		get_viewport().warp_mouse(MousePos - (directionToMouse * 0.1))
	else:
		MouseInView += delta
		if MouseInView > 1.0:
			GrappingMouse = true
			Beam.play()
	
	TimeTillMove -= delta
	if Moving:
		if MoveUpAndDown:
			if MoveLeft:
				Motion.y -= 60.0 * delta
			else:
				Motion.y += 60.0 * delta
		else:
			if MoveLeft:
				Motion.x -= 60.0 * delta
			else:
				Motion.x += 60.0 * delta
		var collision = move_and_collide(Motion)
		if collision:
			var body = collision.collider
			var stop = true
			if body.has_method("Push"):
				stop = not body.Push(Motion)
			if stop:
				Motion = Vector2(0.0, 0.0)
				Moving = false
				TimeTillMove = rand_range(5.0, 10.0)
				$Grind.stop()
				$Bang.play()
				$MoveParticles.emitting = false
				$StopParticles.emitting = true
				if body.has_method("Crush"):
					body.Crush()
	elif TimeTillMove < 0.0:
		Moving = true
		var leftFree = not $LeftCast.is_colliding()
		var rightFree = not $RightCast.is_colliding()
		if leftFree == rightFree:
			MoveLeft = randi() % 2 == 0
		else:
			MoveLeft = leftFree
		$Grind.play()
		$MoveParticles.emitting = true
	update()

func _draw():
	if GrappingMouse:
		draw_line(Vector2(0.0, -2.0), to_local(MousePos), Color(1.0, 0.0, 0.0, 1.0), 3.0, true)
	elif MouseInView > 0.0:
		draw_line(Vector2(0.0, -2.0), to_local(MousePos), Color(1.0, 0.0, 0.0, 0.3), 3.0, true)
	else:
		draw_line(Vector2(0.0, -2.0), to_local(CollisionPoint), Color(0.875, 0.443, 0.149, 0.1), 3.0, true)
