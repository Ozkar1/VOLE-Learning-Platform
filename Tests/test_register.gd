extends "res://addons/gut/test.gd"

var RegisterScene = preload("res://Scenes/Register.tscn")  # Adjust the path if necessary

var register_instance

func before_each():
	register_instance = RegisterScene.instance()
	add_child(register_instance)

func after_each():
	register_instance.queue_free()
	register_instance = null

# Helper function to get nodes from the register_instance
func get_nodes():
	return {
		"username_input": register_instance.get_node("ColorRect/Panel/UsernameInput"),
		"email_input": register_instance.get_node("ColorRect/Panel/EmailInput"),
		"first_name_input": register_instance.get_node("ColorRect/Panel/FirstNameInput"),
		"last_name_input": register_instance.get_node("ColorRect/Panel/LastNameInput"),
		"password_input": register_instance.get_node("ColorRect/Panel/PasswordInput"),
		"password_confirm_input": register_instance.get_node("ColorRect/Panel/PasswordConfirmInput"),
		"role_dropdown": register_instance.get_node("ColorRect/Panel/OptionButton"),
		"errorLabel": register_instance.get_node("ColorRect/ErrorLabel"),
		"http_request": register_instance.get_node("HTTPRequest")
	}

# Test adding items to dropdown menu
func test_add_items():
	register_instance.add_items()
	var nodes = get_nodes()
	assert_eq(nodes["role_dropdown"].get_item_text(0), "Student", "First item should be 'Student'")
	assert_eq(nodes["role_dropdown"].get_item_text(1), "Teacher", "Second item should be 'Teacher'")

# Test input validation with valid data
func test_validate_input_valid():
	var nodes = get_nodes()
	nodes["username_input"].text = "validuser"
	nodes["email_input"].text = "valid@example.com"
	nodes["first_name_input"].text = "John"
	nodes["last_name_input"].text = "Doe"
	nodes["password_input"].text = "Valid123!"
	nodes["password_confirm_input"].text = "Valid123!"
	
	var result = register_instance.validate_input()
	assert_true(result, "Validation should pass with valid inputs")
	assert_false(nodes["errorLabel"].visible, "Error label should not be visible with valid inputs")

# Test input validation with invalid data
func test_validate_input_invalid():
	var nodes = get_nodes()
	nodes["username_input"].text = "u"
	nodes["email_input"].text = "invalidemail"
	nodes["first_name_input"].text = ""
	nodes["last_name_input"].text = ""
	nodes["password_input"].text = "short"
	nodes["password_confirm_input"].text = "different"
	
	var result = register_instance.validate_input()
	assert_false(result, "Validation should fail with invalid inputs")
	assert_true(nodes["errorLabel"].visible, "Error label should be visible with invalid inputs")
	assert_ne(nodes["errorLabel"].text, "", "Error label should have error messages")

# Test registration user (mock network call)
func test_register_user():
	var nodes = get_nodes()
	# Stub the HTTPRequest request method
	stub(nodes["http_request"], "request")
	
	# Set valid data
	nodes["username_input"].text = "validuser"
	nodes["email_input"].text = "valid@example.com"
	nodes["first_name_input"].text = "John"
	nodes["last_name_input"].text = "Doe"
	nodes["password_input"].text = "Valid123!"
	nodes["password_confirm_input"].text = "Valid123!"
	nodes["role_dropdown"].add_item("student")
	nodes["role_dropdown"].select(0)
	
	# Call the method to test
	register_instance.register_user()
	
	# Verify HTTPRequest request method was called
	assert_called(nodes["http_request"], "request")

# Test the Sign Up button pressed
func test_on_SignUpBtn_pressed():
	var nodes = get_nodes()
	# Set up valid data for registration
	nodes["username_input"].text = "validuser"
	nodes["email_input"].text = "valid@example.com"
	nodes["first_name_input"].text = "John"
	nodes["last_name_input"].text = "Doe"
	nodes["password_input"].text = "Valid123!"
	nodes["password_confirm_input"].text = "Valid123!"
	nodes["role_dropdown"].add_item("student")
	nodes["role_dropdown"].select(0)

	# Mock register_user method
	stub(register_instance, "register_user")

	# Call the method
	register_instance._on_SignUpBtn_pressed()

	# Check if register_user method was called
	assert_called(register_instance, "register_user")
