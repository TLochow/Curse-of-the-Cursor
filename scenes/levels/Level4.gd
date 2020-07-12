extends Node2D

var Cursor = load("res://sprites/cursor.png")

onready var Player = get_tree().get_nodes_in_group("Player")[0] 

var Phase = "FollowPlayer"

var MusicStop = true

func _ready():
	$Tween.interpolate_method(MusicPlayer, "SetVolume", 0.0, -80.0, 4.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$MagicArtefact.connect("Absorbed", self, "ArtefactAbsorbed")

func _process(delta):
	if Phase == "FollowPlayer":
		$Camera2D.set_position(Player.get_position())
	elif Phase == "WaitForPlayerInput":
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up"):
			Phase = "Huh"
			$Tween.interpolate_property($Control/Label, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
	elif Phase == "WaitForPlayerInput2":
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up"):
			Phase = "CantMove"
			$Tween.interpolate_property($Control/Label2, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$Tween2.interpolate_property($Control/Label, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween2.start()
	elif Phase == "WaitForPlayerInput3":
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up"):
			Phase = "FollowPlayer"
			get_viewport().warp_mouse(get_viewport_rect().size * 0.5)
			$Tween.interpolate_property($Control/Label3, "modulate", Color(1.0, 1.0, 1.0, 0.0), Color(1.0, 1.0, 1.0, 1.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			$Tween2.interpolate_property($Control/Label2, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween2.start()
			Player.Activate()

func ArtefactAbsorbed():
	Phase = "Introduction"
	Player.MouseControl = true
	SwitchCursor()
	$Timer.wait_time = 1.0
	$Timer.start()
	pass

func SwitchCursor():
	Input.set_custom_mouse_cursor(Cursor)

func _on_Timer_timeout():
	if Phase == "Introduction":
		Phase = "WaitForPlayerInput"
		$IntroductionTorches/Torch.LightTorch()
		$IntroductionTorches/Torch2.LightTorch()

func _on_Tween_tween_all_completed():
	if Phase == "Huh":
		Phase = "WaitForPlayerInput2"
	elif Phase == "CantMove":
		Phase = "WaitForPlayerInput3"

func _on_MusicRestartArea_body_entered(body):
	if MusicStop:
		MusicStop = false
		$Tween.interpolate_method(MusicPlayer, "SetVolume", -80.0, 0.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
