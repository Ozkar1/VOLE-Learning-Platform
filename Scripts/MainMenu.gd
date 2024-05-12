extends Control

var user_role = UserManager.user_data["Role"]

onready var name_label = $ColorRect/WelcomeText
onready var http_request = $HTTPRequest

# Constant variables for the API
const API_URL = "http://localhost:3000/api/profile" 

func _ready():
	fetch_user_info()

func fetch_user_info():
	var token = Storage.load_token()  
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
		]
	http_request.request(API_URL, headers, true, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		user_role = response.role 
		print(response)
		name_label.text = response.FirstName + " " + response.LastName + " ("+ response.role +")"
		print("Role retrieved:", user_role)
	else:
		print("Failed to fetch user data:", response_code)


func _on_VoleBtn_pressed():
	get_tree().change_scene("res://Scenes/Simulator.tscn")

func _on_ClassroomBtn_pressed():
	if user_role == "teacher":
		get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")
	elif user_role == "student":
		get_tree().change_scene("res://Scenes/Classrooms/ClassroomStudent.tscn")




