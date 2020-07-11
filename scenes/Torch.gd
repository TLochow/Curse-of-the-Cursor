extends Area2D

export(float) var Brightness = 1.0

var On = false

func _ready():
	$AnimationPlayer.play("Out")

func LightTorch():
	if not On:
		On = true
		$Ignite.play()
		$Light2D.enabled = true
		$AnimationPlayer.play("On")
		$Tween.interpolate_property($Light2D, "energy", 0.0, Brightness, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func _on_Torch_body_entered(body):
	LightTorch()
