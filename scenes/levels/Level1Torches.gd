extends Node2D

func _on_Area2D1_body_entered(body):
	$Torches/Torch1.LightTorch()
	$Torches/Torch2.LightTorch()

func _on_Area2D2_body_entered(body):
	$Torches/Torch3.LightTorch()
	$Torches/Torch4.LightTorch()

func _on_Area2D3_body_entered(body):
	$Torches/Torch5.LightTorch()
	$Torches/Torch6.LightTorch()

func _on_Area2D4_body_entered(body):
	$Torches/Torch7.LightTorch()
	$Torches/Torch8.LightTorch()

func _on_Area2D5_body_entered(body):
	$Torches/Torch9.LightTorch()
	$Torches/Torch10.LightTorch()
