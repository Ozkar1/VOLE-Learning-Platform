extends Control

onready var http_request = $HTTPRequest
onready var AssignmentSelector = $ColorRect/Panel/OptionButton
onready var ConfirmDeletion = $ColorRect/Panel/CheckBox
onready var ErrorLabel = $ColorRect/ErrorLabel

var ClassroomID
var AssignmentDeleted = false
var AssignmentIDMap = {}

var classroomId
var assignments_info_api

func _ready():
	classroomId = Storage.get_classroomId()
	assignments_info_api = "http://localhost:3000/api/assignments/" + str(classroomId)
	fetch_teacher_classroom_info()
	ErrorLabel.visible = false

func fetch_teacher_classroom_info():
	var token = Storage.load_token()  
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
		]
	http_request.request(assignments_info_api, headers, true, HTTPClient.METHOD_GET, "")

func deleteAssignment():
	var selectedIdx = AssignmentSelector.selected
	var assignmentID = AssignmentIDMap[selectedIdx]
	if assignmentID:
		var token = Storage.load_token()  
		var url = "http://localhost:3000/api/assignments/delete/" + str(assignmentID)
		var headers = [
			"Content-Type: application/json",
			"Authorization: Bearer " + token
		]
		http_request.request(url, headers, true, HTTPClient.METHOD_DELETE)
		AssignmentDeleted = true

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	if AssignmentDeleted:
		if response_code == 200:
			Storage.set_alertMsg("Assignment successfully deleted!")
			get_tree().change_scene("res://Scenes/AssignmentsTeacher.tscn")
		else:
			print("Failed to delete classroom:", response)
		AssignmentDeleted = false
	else:
		if response_code == 200:
			AssignmentSelector.clear()
			AssignmentIDMap.clear()
			if response is Array:
				for idx in range(response.size()):
					var item = response[idx]
					var assignmentName = "Assignment: " + item.Title
					AssignmentSelector.add_item("  " + assignmentName)
					AssignmentIDMap[idx] = item.AssignmentID
			else:
				print("Invalid response format: expected array")
		else:
			print("Failed to fetch classroom data:", response_code)


func _on_DeleteAssignmentBtn_pressed():
	if ConfirmDeletion.pressed == true:
		deleteAssignment()
	else:
		ErrorLabel.text = "Please confirm deletion"
		ErrorLabel.visible = true


func _on_BackToTeacherClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/AssignmentsTeacher.tscn")
