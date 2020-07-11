extends Node

var Level = 1

func LoadNextLevel():
	Level += 1
	var nextLevelPath = "res://scenes/levels/Level" + str(Level) + ".tscn"
	print(nextLevelPath)
	SceneChanger.ChangeScene(nextLevelPath)
