extends Control

onready var http_request = $HTTPRequest
onready var submittersVBox = $ColorRect/ColorRect/SubmittersVBox
onready var classromNameLabel = $ColorRect/ClassroomNameLabel
onready var assignmentNameLabel = $ColorRect/AssigmentNameLabel
onready var assignmentDescLabel = $ColorRect/AssignmentDescLabel
onready var assignmentCriteriaLabel = $ColorRect/AssignmentCriteriaLabel


var assignmentId
var assignmentTitle
var assignmentDesc
var assignmentCritera
var url
var alertMsg


# Called when the node enters the scene tree for the first time.
func _ready():
	assignmentId = Storage.get_assignmentID()
	assignmentTitle = Storage.get_assignmentTitle()
	assignmentDesc = Storage.get_assignmentDescription()
	assignmentCritera = Storage.get_assignmentCriteria()
	assignmentCriteriaLabel.text = assignmentCritera
	assignmentNameLabel.text = "Submissions for " + assignmentTitle
	assignmentDescLabel.text = assignmentDesc
	url = "https://sunlit-inn-423416-r4.ew.r.appspot.com/api/assignments/" + str(assignmentId) + "/completions"
	get_completion_status_info()
	
func get_completion_status_info():
	var token = Storage.load_token()
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
	]
	http_request.request(url, headers, true, HTTPClient.METHOD_GET, "")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		print(response)
		if response is Array:
			for item in response:
				add_submission(item)
		else:
			print("Invalid response format: expected array")
	else:
		var response = parse_json(body.get_string_from_utf8())
		print("Failed to fetch assignment data:", response_code, response.message)

func add_submission(item):
	var name_of_submitter = Label.new()
	name_of_submitter.text = item.FirstName.capitalize() + " " +item.LastName.capitalize()
	submittersVBox.add_child(name_of_submitter)
	

func _on_BackToClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/AssignmentsTeacher.tscn")
