extends Control


onready var http_request = $HTTPRequest
onready var assignmentNameVBox = $ColorRect/ColorRect/AssignmentNameVBox
onready var submissionsVBox = $ColorRect/ColorRect/SubmissionsVBox
onready var classromNameLabel = $ColorRect/ClassroomNameLabel

var classroomId
var classroomName
var url

func _ready():
	classroomId = Storage.get_classroomId()
	classroomName = Storage.get_classroomName()
	classromNameLabel.text = classroomName + " - Assignments"
	url = "http://localhost:3000/api/assignments/" + str(classroomId)
	fetch_teacher_classroom_info()


func fetch_teacher_classroom_info():
	var token = Storage.load_token()  
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
		]
	http_request.request(url, headers, true, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		print(response)
		if response is Array:
			for item in response:
				add_assignment(item)
	else:
		print("Failed to fetch assignment data:", response_code)

func add_assignment(item):
	if item.Title:
		
		var assignment_name_label = Label.new()
		assignment_name_label.text = item.Title
		assignmentNameVBox.add_child(assignment_name_label)

func _on_BackToClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")


func _on_DeleteAssignmentBtn_pressed():
	get_tree().change_scene("res://Scenes/DeleteAssignment.tscn")


func _on_CreateAssignmentBtn_pressed():
	get_tree().change_scene("res://Scenes/CreateAssignment.tscn")
