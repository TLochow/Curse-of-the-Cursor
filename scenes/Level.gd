extends Node2D

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneChanger.EndGame()
	elif event.is_action_pressed("restart"):
		Global.LoadLevel()

func _ready():
	Global.ScreenShake = 0.0
	$CanvasModulate.visible = true
	$Entry.connect("Closed", $Player, "Activate")
	$Exit.connect("StartOpening", $Player, "Deactivate")
	$Exit.connect("StartOpening", $Player, "Blackout")

func _on_Exit_Opened():
	Global.LoadNextLevel()

func _on_DeathPlane_body_entered(body):
	Global.LoadLevel()
