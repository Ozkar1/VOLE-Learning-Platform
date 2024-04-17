extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var drop_down_menu = $ColorRect/Panel/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()
	pass # Replace with function body.



func add_items():
	drop_down_menu.add_item("Student")
	drop_down_menu.add_item("Teacher")
	drop_down_menu.add_item("Other")
	


func _on_OptionButton_item_selected(index):
	var current_selected = index
	
	#if current_selected == 0:
	#	student selected
	


func _on_SignUpBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_HaveAnAccBtn_pressed():
	get_tree().change_scene("res://Scenes/Login.tscn")
