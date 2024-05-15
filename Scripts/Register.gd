extends Control

# Declare member variables here.
var hasUppercase = false
var hasLowercase = false
var hasSpecialChar = false
var errorMessage = ""
var passwordErrorMessage = ""

## Ready signal handler
onready var drop_down_menu = $ColorRect/Panel/OptionButton
onready var errorLabel = $ColorRect/ErrorLabel
onready var sign_up_btn = $ColorRect/Panel/SignUpBtn

# References to the input fields
onready var username_input = $ColorRect/Panel/UsernameInput
onready var email_input = $ColorRect/Panel/EmailInput
onready var first_name_input = $ColorRect/Panel/FirstNameInput
onready var last_name_input = $ColorRect/Panel/LastNameInput
onready var password_input = $ColorRect/Panel/PasswordInput
onready var profile_picture_input = "http://example.com/profile.jpg"
onready var role_dropdown = $ColorRect/Panel/OptionButton
onready var password_confirm_input = $ColorRect/Panel/PasswordConfirmInput

# Reference to the HTTPRequest node
onready var http_request = $HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()
	errorLabel.visible = false

## Function to add items to the dropdown menu
func add_items():
	drop_down_menu.add_item("Student")
	drop_down_menu.add_item("Teacher")
	

func _on_OptionButton_item_selected(index):
	var current_selected = index

	
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
	
	var url = "https://sunlit-inn-423416-r4.ew.r.appspot.com/api/users/register" # Change this URL to your API endpoint
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

func _on_HaveAnAccBtn_pressed():
	get_tree().change_scene("res://Scenes/Login.tscn")

func validate_input():
	errorMessage = ""
	passwordErrorMessage = ""
	 # Validate username
	if username_input.text.length() < 3 or username_input.text.length() >= 20:
		errorMessage += "- Username must be between \n  3 and 20 characters.\n"
	
	var emailRegex = RegEx.new()
	emailRegex.compile("^[\\w\\-\\.]+@([\\w\\-]+\\.)+[\\w\\-]{2,4}$")
	var emailRegexResult = emailRegex.search(email_input.text)
	if not emailRegexResult:
		errorMessage += '- Please input a valid email\n'
	
	# Validate first name
	if first_name_input.text.length() == 0 :
		errorMessage += "- Please fill out your first name.\n"
	
	# Validate last name
	if last_name_input.text.length() == 0:
		errorMessage += "- Please fill out your last name.\n"
	
	# Validate password confirmation
	if password_input.text != password_confirm_input.text:
		errorMessage += "- Passwords do not match.\n"
	
	var passwordRegex = RegEx.new()
	passwordRegex.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$")
	var passwordRegexresult = passwordRegex.search(password_input.text) 
	if not passwordRegexresult:
		errorMessage += "\n Password must include atleast: \n - 8 character \n - One uppercase \n - One lowercase \n - One special sign"
	
	# Display error message (if any)
	if errorMessage != "":
		errorLabel.text = errorMessage
		errorLabel.visible = true
		return false
	else:
		errorLabel.visible = false
		return true


## Function called when the Sign Up button is pressed
func _on_SignUpBtn_pressed():
	 # Validate input fields before registration
	if not validate_input():
		return
	
	# If all input is valid, proceed with registration
	register_user()
