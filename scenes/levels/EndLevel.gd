extends Node2D

onready var Player = get_tree().get_nodes_in_group("Player")[0]

var Phase = "Start"

var PlayerPos = Vector2(0.0, 0.0)

var TorchCount = -1

func _process(delta):
	$Camera2D.set_position(Player.get_position())
	if Phase == "End":
		Player.Deactivate(PlayerPos)

func _on_TriggerEndArea_body_entered(body):
	Phase = "End"
	PlayerPos = Player.get_position()
	$Tween.interpolate_property(self, "PlayerPos", PlayerPos, Vector2(888.0, 224.0), 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_all_completed():
	if Phase == "End":
		Phase = "End2"
		$Timer.start()

func _on_Timer_timeout():
	TorchCount += 1
	if TorchCount == 3:
		$EndTorches/Torch1.LightTorch()
		$EndTorches/Torch2.LightTorch()
	elif TorchCount == 4:
		$EndTorches/Torch3.LightTorch()
		$EndTorches/Torch4.LightTorch()
	elif TorchCount == 5:
		$EndTorches/Torch5.LightTorch()
		$EndTorches/Torch6.LightTorch()
		$Timer.stop()
