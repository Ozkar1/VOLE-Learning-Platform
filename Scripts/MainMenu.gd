extends Control

onready var name_label = $ColorRect/WelcomeText
onready var http_request = $HTTPRequest

# Constant variables for the API
const API_URL = "http://localhost:3000/api/profile" 

func _ready():
	fetch_user_info()

func fetch_user_info():
	var token = Storage.load_token()  
	var headers = [
		"Authorization: Bearer " + token
	]
	http_request.request(API_URL, headers, true, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		print(response)
		name_label.text = response.FirstName + " " + response.LastName + " ("+ response.role +")"
	else:
		print("Failed to fetch user data:", response_code)


func _on_VoleBtn_pressed():
	get_tree().change_scene("res://Scenes/Simulator.tscn")

func _on_ClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classroom.tscn")

func _on_RegisterBtn_pressed():
	get_tree().change_scene("res://Scenes/Register.tscn")


func _on_LoginButton_pressed():
	pass # Replace with function body.



