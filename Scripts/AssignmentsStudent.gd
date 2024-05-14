extends Control

onready var assignmentNameLabel = $ColorRect/AssignmentNameLabel
onready var assignmentDescriptionLabel = $ColorRect/ColorRect/AssignmentDescriptionLabel

var assignmentTitle
var assignmentDescription


func _ready():
	assignmentTitle = Storage.get_assignmentTitle()
	assignmentDescription = Storage.get_assignmentDescription()
	
	assignmentNameLabel.text = "Assignment: " + assignmentTitle
	assignmentDescriptionLabel.text = assignmentDescription



func _on_MenuBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomStudent.tscn")
