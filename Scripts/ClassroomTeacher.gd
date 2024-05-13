extends Node


onready var http_request = $HTTPRequest
onready var ClassroomsSelector = $ColorRect/OptionButton

onready var classroomName

const url = "http://localhost:3000/api/classrooms/teacher" 

func _ready():
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
		ClassroomsSelector.clear()
		if response is Array:
			for item in response:
				var classroomName = "Classroom: " + item.ClassroomName
				print("Classroom name received: " + item.ClassroomName)
				ClassroomsSelector.add_item(classroomName)
		else:
			print("Invalid response format: expected array")
	else:
		print("Failed to fetch classroom data:", response_code)

func _on_MenuBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_DeleteClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/DeleteClassroom.tscn")


func _on_CreateClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/CreateClassroom.tscn")
