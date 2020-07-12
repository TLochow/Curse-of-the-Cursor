extends Node

var ScreenShake = 0.0

var Level = 1

func LoadLevel():
	SceneChanger.ChangeScene("res://scenes/levels/Level" + str(Level) + ".tscn")

func LoadNextLevel():
	Level += 1
	LoadLevel()
