extends Control


onready var AssignmentTitle = $ColorRect/Panel/AssignmentTitleInput
onready var AssignmentDescription = $ColorRect/Panel/AssignmentDescriptionInput
onready var ExpectedInput = $ColorRect/Panel/ExpectedInput
onready var ExpectedMemory = $ColorRect/Panel/ExpectedMemoryInput
onready var ExpectedRegister = $ColorRect/Panel/ExpectedRegisterInput
onready var ClassroomPicker = $ColorRect/Panel/OptionButton
onready var http_request = $HTTPRequest

var ClassroomIDMap = {}
var Classroom_info_api = "http://localhost:3000/api/classrooms/teacher"
var Assignment_create_api = "http://localhost:3000/api/assignments/create"

func _ready():
	fetch_teacher_classroom_info()

func fetch_teacher_classroom_info():
	var token = Storage.load_token()  
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
	]
	http_request.request(Classroom_info_api, headers, true, HTTPClient.METHOD_GET, "")

func create_assignment():
	var token = Storage.load_token()
	var selectedIdx = ClassroomPicker.selected
	var classroomID = ClassroomIDMap[selectedIdx]
	if classroomID:
		var assignment_data = {
			"title": AssignmentTitle.text,
			"description": AssignmentDescription.text,
			"dueDate": "2024-08-13 22:19:50", #MOCK DATA - Change! 
			"classroomID": classroomID,
			"expectedInput": ExpectedInput.text,
			"expectedMemory": ExpectedMemory.text,
			"expectedRegister": ExpectedRegister.text
		}
		var json_data = to_json(assignment_data)
		var headers = [
			"Content-Type: application/json",
			"Authorization: Bearer " + token
		]
		http_request.request(Assignment_create_api, headers, true, HTTPClient.METHOD_POST, json_data)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	if response_code == 201:
		print("Assignment created successfully:", body)
		get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")
	elif response_code == 200:
		ClassroomPicker.clear()
		ClassroomIDMap.clear()
		if response is Array:
			for idx in range(response.size()):
				var item = response[idx]
				var classroomName = "Classroom: " + item.ClassroomName
				ClassroomPicker.add_item("  " + classroomName)
				ClassroomIDMap[idx] = item.ClassroomID
		else:
			print("Invalid response format: expected array")
	else:
		print("Failed to fetch classroom data:", response_code)


func _on_BackToTeacherClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")


func _on_CreateAssignmentmBtn_pressed():
	create_assignment()
