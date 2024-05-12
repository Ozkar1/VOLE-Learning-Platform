extends Node

onready var http_request = $HTTPRequest
onready var classroomName = $ColorRect/Panel/ClassroomNameInput
onready var classroomDescription = $ColorRect/Panel/ClassroomDescriptionInput
onready var errorLabel = $ColorRect/ErrorLabel

#var userID = Storage.getUserIdFromToken()


func _ready():
	errorLabel.visible = false


func createClassroom():
	var token = Storage.load_token()  
	var request_data = {
		"ClassroomName": classroomName.text,
		"Description": classroomDescription.text
	}
	var url = "http://localhost:3000/api/classrooms/create"
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
		]
	var json_data = to_json(request_data)
	print (json_data)
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, json_data)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())

	if response_code == 201:
		print("Classroom creation successful:", response)
		get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")
	else:
		print("Failed to create classroom:", response)

func _on_BackToTeacherClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")


func _on_CreateClassroomBtn_pressed():
	if classroomName.text.strip_edges().length() < 1:
		errorLabel.text = "Classroom name can not be empty"
		errorLabel.visible = true
	else: 
		createClassroom()
