extends Control

onready var assignmentNameLabel = $ColorRect/AssignmentNameLabel
onready var assignmentDescriptionLabel = $ColorRect/ColorRect/AssignmentDescriptionLabel
onready var criteriaLabel = $ColorRect2/CriteriaLabel
onready var assignmentCriteriaDesc = $ColorRect2/AssignmentCriteriaDesc

var assignmentTitle
var assignmentDescription
var criteriaType
var criteriaDesc

func _ready():
	assignmentTitle = Storage.get_assignmentTitle()
	assignmentDescription = Storage.get_assignmentDescription()
	criteriaDesc = Storage.get_assignmentCriteria()
	criteriaType = Storage.get_assignmentCriteriaType()
	
	assignmentNameLabel.text = "Assignment: " + assignmentTitle
	assignmentDescriptionLabel.text = assignmentDescription
	criteriaLabel.text = criteriaType
	assignmentCriteriaDesc.text = criteriaDesc



func _on_MenuBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomStudent.tscn")

func _on_BeginAssignmentBtn_pressed():
	get_tree().change_scene("res://Scenes/Simulator.tscn")
