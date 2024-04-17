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
	# if current_selected == 0:
	#     student selected

## Function called when the Sign Up button is pressed
func _on_SignUpBtn_pressed():
	# Validate password before scene change
	on_password_text_changed(passwordInput.text)
	if errorMessage == "" and hasUppercase and hasLowercase and hasSpecialChar:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		errorLabel.text = errorMessage
		errorLabel.visible = true

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
