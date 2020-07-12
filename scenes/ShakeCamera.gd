extends Camera2D

var ScreenShakeWait = 0.0

func _process(delta):
	ScreenShakeWait -= delta
	if ScreenShakeWait < 0.0:
		ScreenShakeWait = 0.05
		offset = Vector2(rand_range(-Global.ScreenShake, Global.ScreenShake), rand_range(-Global.ScreenShake, Global.ScreenShake))
	Global.ScreenShake = max(Global.ScreenShake - delta * 5.0, 0.0)
