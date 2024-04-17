extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var drop_down_menu = $ColorRect/Panel/OptionButton

# References to the input fields
onready var username_input = $ColorRect/Panel/UsernameInput
onready var email_input = $ColorRect/Panel/EmailInput
onready var first_name_input = $ColorRect/Panel/FirstNameInput
onready var last_name_input = $ColorRect/Panel/LastNameInput
onready var password_input = $ColorRect/Panel/PasswordInput
onready var profile_picture_input = "http://example.com/profile.jpg"
onready var role_dropdown = $ColorRect/Panel/OptionButton

# Reference to the HTTPRequest node
onready var http_request = $HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()
	pass # Replace with function body.



func add_items():
	drop_down_menu.add_item("Student")
	drop_down_menu.add_item("Teacher")
	drop_down_menu.add_item("Other")
	


func _on_OptionButton_item_selected(index):
	var current_selected = index
	
	#if current_selected == 0:
	#	student selected
	
func register_user():
	var user_data = {
		"Username": username_input.text,
		"Email": email_input.text,
		"FirstName": first_name_input.text,
		"LastName": last_name_input.text,
		"Password": password_input.text,
		"ProfilePictureURL": profile_picture_input,
		"Role": role_dropdown.get_item_text(role_dropdown.selected).to_lower()
	}
	
	var url = "http://localhost:3000/api/users/register" # Change this URL to your API endpoint
	var headers = ["Content-Type: application/json"]
	var json_data = to_json(user_data)
	http_request.request(url, headers, true, HTTPClient.METHOD_POST, json_data)
	
# Connect the 'request_completed' signal to handle the response
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())

	if response_code == 201:
		print("Registration successful:", response)
		get_tree().change_scene("res://Scenes/Login.tscn")
	else:
		print("Failed to register:", response)

func _on_SignUpBtn_pressed():
	register_user()
	


func _on_HaveAnAccBtn_pressed():
	get_tree().change_scene("res://Scenes/Login.tscn")
