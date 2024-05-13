extends Control


onready var http_request = $HTTPRequest
onready var AssignmentNameVBox = $ColorRect/ColorRect/AssignmentNameVBox
onready var AssignmentDescVBox = $ColorRect/ColorRect/AssignmentDescVBox
onready var SubmissionsVBox = $ColorRect/ColorRect/SubmissionsVBox

var classroomId
var url

func _ready():
	classroomId = Storage.get_classroomId()
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
	else:
		print("Failed to fetch assignment data:", response_code)


func _on_BackToClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")
