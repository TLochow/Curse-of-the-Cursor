extends Area2D

signal Absorbed

var Phase = "Idle"

var Player
var PlayerPos

var Shake = 0.0

var StartPos
var StartDistance

func _on_MagicArtefact_body_entered(body):
	if body.is_in_group("Player"):
		Phase = "Liftoff"
		Player = body
		body.Deactivate(body.get_position())
		$Light2D.enabled = true
		$Tween.interpolate_property($Light2D, "energy", 0.0, 10.0, 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func _process(delta):
	if Phase == "Liftoff":
		var pos = get_position()
		pos.y -= delta * 15.0
		set_position(pos)
	elif Phase == "GetPlayer":
		var pos = get_position()
		PlayerPos.x = min(PlayerPos.x + (delta * 50.0), pos.x)
		Player.Deactivate(PlayerPos)
		if PlayerPos.x >= pos.x:
			Phase = "Activate"
	elif Phase == "Activate":
		Shake += delta * 2.0
		$Sprite.offset = Vector2(rand_range(-Shake, Shake), rand_range(-Shake, Shake))
		if Shake > 10.0:
			Shake = 0.0
			Phase = "Stop"
			$Mysterious.stop()
	elif Phase == "Stop":
		Shake += delta
		if Shake > 2.0:
			Phase = "Absorb"
			StartPos = get_position()
			StartDistance = (Player.get_position() - StartPos).length()
			$Woosh.play()
	elif Phase == "Absorb":
		var pos = get_position()
		var playerPos = Player.get_position()
		var toPlayer = playerPos - pos
		var distanceToPlayer = toPlayer.length()
		if distanceToPlayer > 1.0:
			var distanceToStart = (playerPos - StartPos).length()
			pos += toPlayer.normalized() * min(distanceToPlayer, 10.0)
			$Light2D.energy = range_lerp(distanceToStart, 0.0, StartDistance, 0.0, 10.0)
			set_position(pos)
		else:
			emit_signal("Absorbed")
			queue_free()

func _on_Tween_tween_all_completed():
	if Phase == "Liftoff":
		Phase = "GetPlayer"
		PlayerPos = Player.get_position()
