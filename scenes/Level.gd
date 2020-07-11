extends Node2D

func _ready():
	$CanvasModulate.visible = true
	$Entry.connect("Closed", $Player, "Activate")
	$Exit.connect("StartOpening", $Player, "Deactivate")

func _on_Exit_Opened():
	Global.LoadNextLevel()
