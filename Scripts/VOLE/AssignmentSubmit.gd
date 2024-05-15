extends Button

onready var http_request = $HTTPRequest
onready var inArea = get_node("/root/Control/InArea")
onready var mem = get_node("/root/Control/MemoryGridContainer")
onready var regs = get_node("/root/Control/CPUPanel")
onready var optionButton = get_node("/root/Control/HTTPRequest/OptionButton")

# Helper function to convert memory labels to string
func _memory_to_string():
	var memory_str = ""
	for i in range(1, 17):
		for j in range(1, 17):
			memory_str += mem.get_child(i * 17 + j).text + " "
	return memory_str.strip_edges()

# Helper function to convert registers to string
func _registers_to_string():
	var registers_str = ""
	for i in range(16):
		var reg_label = regs.get_child(i * 2).text
		var reg_value = regs.get_child(i * 2 + 1).text
		registers_str += reg_label + ":" + reg_value + " "
	return registers_str.strip_edges()

# Called when the node enters the scene tree for the first time
func _ready():
	pass

# Function to handle the submit button pressed signal
func _on_SubmitButton_pressed():
	var input = inArea.text
	var memory = _memory_to_string()
	var register = _registers_to_string()
	var assignment_id = optionButton.get_selected_id()
	var token = Storage.load_token()
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
	]

	var request = {
		"AssignmentID": assignment_id,
		"input": input,
		"memory": memory,
		"register": register
	}

	var json_data = to_json(request)
	http_request.request("http://localhost:3000/api/assignments/submit", headers, true, HTTPClient.METHOD_POST, json_data)

# Function to handle the HTTP request completion
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Assignment submitted successfully!")
	else:
		print("Failed to submit assignment: ", response_code)
