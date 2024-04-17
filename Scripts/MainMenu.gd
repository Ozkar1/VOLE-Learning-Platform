extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_VoleBtn_pressed():
	get_tree().change_scene("res://Scenes/Simulator.tscn")

func _on_ClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classroom.tscn")

func _on_RegisterBtn_pressed():
	get_tree().change_scene("res://Scenes/Register.tscn")


func _on_LoginButton_pressed():
	pass # Replace with function body.


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
