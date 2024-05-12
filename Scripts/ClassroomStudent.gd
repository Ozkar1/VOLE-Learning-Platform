extends Node

onready var http_request = $HTTPRequest
onready var classroomName = $ColorRect/ClassroomName

# Constant variables for the API
const API_URL = "http://localhost:3000/api/classrooms/student/:studentId" 

func _ready():
	fetch_student_classroom_info()

func fetch_student_classroom_info():
	var token = Storage.load_token()  
	var headers = [
		"Authorization: Bearer " + token
	]
	http_request.request(API_URL, headers, true, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		print(response)
		classroomName = "Classroom: " + response.ClassroomName
		print("Classroom name recieved: " + response.ClassroomName)
	else:
		print("Failed to fetch classroom data:", response_code)


func _on_MenuBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_JoinClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/JoinClassroom.tscn")


func _on_LeaveClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/LeaveClassroom.tscn")
