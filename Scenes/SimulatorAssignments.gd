extends Control


onready var assignmentType = $AssignmentType
onready var assignmentDesc = $AssignmentDesc

var assignType
var assignDesc

# Called when the node enters the scene tree for the first time.
func _ready():
	assignType = Storage.get_assignmentCriteriaType()
	assignDesc = Storage.get_assignmentCriteria()
	if assignType != null:
		assignmentType.text = assignType + ":"
		assignmentDesc.text = assignDesc
		assignmentType.visible = true
		assignmentDesc.visible = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MenuButton_pressed():
	Storage.set_assignmentDescription(null)
	Storage.set_assignmentTitle(null)
	Storage.set_assignmentID(null)
	Storage.set_assignmentCriteria(null)
	Storage.set_assignmentCriteriaType(null)
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
