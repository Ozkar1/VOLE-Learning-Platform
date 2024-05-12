extends Node


onready var http_request = $HTTPRequest
onready var classroomCode = $ColorRect/Panel/JoinCodeInput
onready var errorLabel = $ColorRect/Panel/ErrorLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	errorLabel.visible = false

func _on_BackToStudentClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/ClassroomStudent.tscn")

func joinClassroom():
	var request_data = {
		"JoinCode": classroomCode.text,
	}
	var url = "http://localhost:3000/api/classrooms/enroll"
	var token = Storage.load_token()  
	var headers = ["Authorization: Bearer " + token]
	var json_data = to_json(request_data)
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, json_data)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())

	if response_code == 201:
		print("Classroom join successful:", response)
		get_tree().change_scene("res://Scenes/Classrooms/ClassroomStudent.tscn")
	else:
		print("Failed to join classroom:", response)
		errorLabel.text = "Incorrect Classroom ID"
		errorLabel.visible = true

func _on_JoinClassroomBtn_pressed():
	if classroomCode.text.strip_edges().length() < 1:
		errorLabel.text = "Classroom ID can not be empty"
		errorLabel.visible = true
	else: 
		joinClassroom()
