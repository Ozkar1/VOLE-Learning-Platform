extends Control

# Declare member variables here.
var hasUppercase = false
var hasLowercase = false
var hasSpecialChar = false
var errorMessage = ""

## Ready signal handler
onready var drop_down_menu = $ColorRect/Panel/OptionButton
onready var passwordInput = $ColorRect/Panel/PasswordInput
onready var errorLabel = $ColorRect/ErrorLabel


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
	if passwordInput != null:
		passwordInput.connect("text_changed", self, "on_password_text_changed")
		errorLabel.visible = false

## Function to add items to the dropdown menu
func add_items():
	drop_down_menu.add_item("Student")
	drop_down_menu.add_item("Teacher")

func _on_OptionButton_item_selected(index):
	var current_selected = index
<<<<<<< HEAD
	# if current_selected == 0:
	#     student selected
=======
	
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
>>>>>>> main

## Function called when the Sign Up button is pressed
func _on_SignUpBtn_pressed():
<<<<<<< HEAD
	# Validate password before scene change
	on_password_text_changed(passwordInput.text)
	if errorMessage == "" and hasUppercase and hasLowercase and hasSpecialChar:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		errorLabel.text = errorMessage
		errorLabel.visible = true
=======
	register_user()
	

>>>>>>> main

## Function called when the Have An Account button is pressed
func _on_HaveAnAccBtn_pressed():
	get_tree().change_scene("res://Scenes/Login.tscn")

## Function for password text change validation
func on_password_text_changed(new_text):
	errorMessage = ""
	
	var regex = RegEx.new()
	regex.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$")
	var result = regex.search(new_text)
	if not result:
		errorMessage = " Password must include atleast \n 8 character \n One uppercase \n One lowercase \n One special sign"
	
	# Display error message (if any) or highlight the LineEdit
	if errorMessage != "":
		# Show a popup or label displaying the errorMessage
		errorLabel.text = errorMessage
		errorLabel.visible = true
	else:
		errorLabel.visible = false
