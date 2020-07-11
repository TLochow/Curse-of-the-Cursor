extends Area2D

signal StartOpening(pos)
signal Opened
signal Closed

export(bool) var Entry

func _ready():
	if Entry:
		$Sprite.frame = 4
		$AnimationPlayer.play("Close")
	else:
		$Sprite.frame = 0

func LightTorches():
	$Torch.LightTorch()
	$Torch2.LightTorch()
	emit_signal("Closed")

func PlayCloseSoundEffect():
	$Close.play()

func EmitOpenedSignal():
	emit_signal("Opened")

func _on_Door_body_entered(body):
	if not Entry:
		$Torch.LightTorch()
		$Torch2.LightTorch()
		emit_signal("StartOpening", get_position())
		$Open.play()
		$AnimationPlayer.play("Open")
