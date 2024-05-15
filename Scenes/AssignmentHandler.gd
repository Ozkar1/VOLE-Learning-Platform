extends HTTPRequest

# The URL to fetch classroom info
var classroom_url = "http://localhost:3000/api/classrooms/student"

# A reference to the OptionButton in the scene
onready var assignment_selector = $OptionButton

# Flag to track what type of request is being handled
var is_fetching_classroom = true

func _ready():
	# Start by fetching the student's classroom info
	fetch_student_classroom_info()

func fetch_student_classroom_info():
	var token = Storage.load_token()
	var headers = [
		"Authorization: Bearer " + token
	]
	# Make the HTTP request to get classroom info
	is_fetching_classroom = true
	request(classroom_url, headers, true, HTTPClient.METHOD_GET, "")

func fetch_student_assignment_info(classroomId):
	var token = Storage.load_token()
	var assignment_url = "http://localhost:3000/api/assignments/" + str(classroomId)
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
	]
	# Make the HTTP request to get assignment info
	request(assignment_url, headers, true, HTTPClient.METHOD_GET, "")

# Handle the request completion signal
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("HTTP request completed with response code: %d" % response_code)
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		print("Response text: %s" % response_text)
		var response = parse_json(response_text)
		if typeof(response) == TYPE_DICTIONARY and response.has("error"):
			print("Failed to parse JSON response: %s" % response.error_string)
		else:
			var data = response
			print("Parsed response: %s" % data)
			if is_fetching_classroom:
				handle_classroom_response(data)
			else:
				handle_assignments_response(data)
	else:
		print("HTTP Request failed with response code: %d" % response_code)

func handle_classroom_response(data):
	print("Handling classroom response: %s" % data)
	if data is Array and data.size() > 0:
		var first_classroom = data[0]
		if first_classroom.has("ClassroomID"):
			var classroom_id = first_classroom["ClassroomID"]
			print("Found classroom ID: %s" % classroom_id)
			is_fetching_classroom = false  # Set the flag to false before fetching assignments
			fetch_student_assignment_info(classroom_id)
		else:
			print("Classroom ID not found in the first classroom object")
	else:
		print("Classroom response is not a non-empty array")

func handle_assignments_response(data):
	print("Handling assignments response: %s" % data)
	if data is Array:
		populate_assignment_selector(data)
	elif data.has("assignments"):
		populate_assignment_selector(data["assignments"])
	else:
		print("Assignments not found in the response")

func populate_assignment_selector(assignments):
	assignment_selector.clear()
	print("Populating assignment selector with: %s" % assignments)
	for assignment in assignments:
		if assignment.has("Title") and assignment.has("AssignmentID"):
			assignment_selector.add_item(assignment["Title"], assignment["AssignmentID"])
		else:
			print("Invalid assignment format: %s" % assignment)
