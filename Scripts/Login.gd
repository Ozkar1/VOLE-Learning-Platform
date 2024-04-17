extends Node


onready var username_input = $ColorRect/Panel/UsernameInput
onready var password_input = $ColorRect/Panel/PasswordInput
onready var login_button = $ColorRect/Panel/LoginButton
onready var http_request = $HTTPRequest


func _ready():
	pass


func _on_LoginButton_pressed():
	
	var username = username_input.text
	var password = password_input.text
	print(username,password)
	send_login_request(username, password)
	
func send_login_request(username, password):
	var url = "http://localhost:3000/api/users/login"
	var headers = ["Content-Type: application/json"]
	var json_data = to_json({"Username": username, "Password": password})
	print(json_data)
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, json_data)
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	if response_code == 200:
		var token = response.token
		print("Login successful, token:", token)
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		# Store token securely and use for subsequent requests
	else:
		print("Login failed:", response.message if 'message' in response else 'Unknown error')
		
func _on_VoleBtn_pressed():
	get_tree().change_scene("res://Scenes/Simulator.tscn")

func _on_ClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classroom.tscn")

func _on_RegisterBtn_pressed():
	get_tree().change_scene("res://Scenes/Register.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
