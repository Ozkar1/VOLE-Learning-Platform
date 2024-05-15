extends Node

# Define the URL of your backend
var backend_url = "http://localhost:3000/assignment"

# Define variables to store the expected values
var expected_input = ""
var expected_memory = {}
var expected_register = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Fetch the expected values when the scene is ready
	fetch_expected_values()

# Function to fetch the expected values from the backend
func fetch_expected_values():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	var error = http_request.request(backend_url)
	if error != OK:
		print("Error making HTTP request: ", error)

# Callback function for HTTP request completion
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		expected_input = response.expected_input
		expected_memory = response.expected_memory
		expected_register = response.expected_register
	else:
		print("Failed to fetch expected values, response code: ", response_code)

# Function to check the input
func check_input():
	var input_area = get_node("InArea").text
	if input_area == expected_input:
		print("Input matches the expected value.")
	else:
		print("Input does not match the expected value.")

# Function to check the memory
func check_memory():
	for key in expected_memory.keys():
		var row = key.hex()[0].to_int()
		var col = key.hex()[1].to_int()
		var value = mem[row, col].text
		if value == expected_memory[key]:
			print("Memory at ", key, " matches the expected value.")
		else:
			print("Memory at ", key, " does not match the expected value.")

# Function to check the registers
func check_registers():
	for key in expected_register.keys():
		var reg_index = key.substr(1).hex().to_int()
		var value = regs[reg_index, 1].text
		if value == expected_register[key]:
			print("Register ", key, " matches the expected value.")
		else:
			print("Register ", key, " does not match the expected value.")

# Function to submit the results
func submit_results():
	var result = {
		"input": get_node("InArea").text,
		"memory": {},
		"register": {}
	}
	
	for i in range(1, 17):
		for j in range(1, 17):
			result.memory[str(i-1).hex() + str(j-1).hex()] = mem[i, j].text
	
	for i in range(16):
		var reg_name = regs[i, 0].text
		result.register[reg_name] = regs[i, 1].text
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var json_data = to_json(result)
	var error = http_request.request(backend_url, [], true, HTTPClient.METHOD_POST, json_data)
	if error != OK:
		print("Error making HTTP request: ", error)
	else:
		print("Results submitted successfully.")

# Button press handlers to check and submit the inputs
func _on_check_button_pressed():
	check_input()
	check_memory()
	check_registers()

func _on_submit_button_pressed():
	submit_results()
