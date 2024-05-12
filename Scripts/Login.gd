extends Node

var usernameErrorMsg = ""
var passwordErrorMsg = ""

onready var username_input = $ColorRect/Panel/UsernameInput
onready var password_input = $ColorRect/Panel/PasswordInput
onready var login_button = $ColorRect/Panel/LoginButton
onready var http_request = $HTTPRequest
onready var usernameErrorLabel = $ColorRect/UsernameErrorLabel
onready var passwordErrorLabel = $ColorRect/PasswordErrorLabel
onready var loginErrorLabel = $ColorRect/LoginErrorLabel

func _ready():
	pass
	usernameErrorLabel.visible = false
	passwordErrorLabel.visible = false
	loginErrorLabel.visible = false


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
		Storage.save_token(token)  # Save the token securel
		print(Storage.load_token())
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
		# Store token securely and use for subsequent requests
	else:
		print("Login failed:", response.message if 'message' in response else 'Unknown error')
		loginErrorLabel.text =  "Incorrect username and/or password"
		loginErrorLabel.visible = true
		

func validate_input():
	if username_input.text.length() == 0:
		usernameErrorMsg = "Please fill out username"
	if password_input.text.length() == 0:
		passwordErrorMsg = "Please fill out password"

func _on_VoleBtn_pressed():
	get_tree().change_scene("res://Scenes/Simulator.tscn")

func _on_ClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classroom.tscn")

func _on_RegisterBtn_pressed():
	get_tree().change_scene("res://Scenes/Register.tscn")

func _on_OfflineBtn_pressed():
	get_tree().change_scene("res://Scenes/OfflineSimulator.tscn")
