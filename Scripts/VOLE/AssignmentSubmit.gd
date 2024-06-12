extends Button

onready var http_request = $HTTPRequest
onready var inArea = get_node("/root/Control2/InArea")
onready var mem = get_node("/root/Control2/MemoryGridContainer")
onready var regs = get_node("/root/Control2/CPUPanel")

var assignmentId

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
	assignmentId = Storage.get_assignmentID()
	if assignmentId != null:
		visible = true

# Function to handle the submit button pressed signal
func _on_SubmitButton_pressed():
	var input = inArea.text
	var memory = _memory_to_string()
	var register = _registers_to_string()
	var assignment_id = assignmentId
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
	http_request.request("https://sunlit-inn-423416-r4.ew.r.appspot.com/api/assignments/submit", headers, true, HTTPClient.METHOD_POST, json_data)

# Function to handle the HTTP request completion
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Assignment submitted successfully!")
		Storage.set_alertMsg("Assignment submitted successfully!")
		Storage.clearAssignmentValues()
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		print("Failed to submit assignment: ", response_code)
		Storage.alert("Assignment Incomplete")
