extends Node

onready var http_request = $HTTPRequest
onready var classroomNameLabel = $ColorRect/ClassroomNameLabel
onready var assignmentNameVbox = $ColorRect/ColorRect/AssignmentNameVBox
onready var viewAssignmentVBox = $ColorRect/ColorRect/ViewAssignmentVBox
onready var joinClassBtn = $ColorRect/JoinClassroomBtn
onready var leaveClassBtn = $ColorRect/LeaveClassroomBtn
onready var confirmLeaveLabel = $ColorRect/ConfirmLeaveLabel
onready var confirmLeave = $ColorRect/ConfirmLeave

var Criteria
var CriteriaType
var classroomId
var alertMsg
var assignemntsFetched = false
var leaveButtonPressed = false

const classroom_url = "http://localhost:3000/api/classrooms/student"

func _ready():
	fetch_student_classroom_info()
	classroomNameLabel.visible = false
	leaveClassBtn.visible = false
	alertMsg = Storage.get_alertMsg()
	if alertMsg != null:
		Storage.alert(alertMsg)
		Storage.clearMsgValue()

func fetch_student_classroom_info():
	var token = Storage.load_token()  
	var headers = [
		"Authorization: Bearer " + token
	]
	http_request.request(classroom_url, headers, true, HTTPClient.METHOD_GET, "")

func fetch_student_assignment_info(classroomId):
	var token = Storage.load_token()
	var assignment_url = "http://localhost:3000/api/assignments/" + str(classroomId)
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token 
		]
	http_request.request(assignment_url, headers, true, HTTPClient.METHOD_GET, "")

func leave_classroom(classroomId):
	var token = Storage.load_token()
	var assignment_url = "http://localhost:3000/api/classrooms/leave"
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token 
		]
	var json_data = to_json({"classroomID": classroomId})
	print(json_data)
	http_request.request(assignment_url, headers, true, HTTPClient.METHOD_POST, json_data)

func add_assignment(item):
	if item.Title:
		
		var assignment_name_label = Label.new()
		assignment_name_label.text = item.Title
		assignmentNameVbox.add_child(assignment_name_label)

		var view_assignment_button = Button.new()
		view_assignment_button.text = "View"
		viewAssignmentVBox.add_child(view_assignment_button)
		
		if item.ExpectedInput != null:
			CriteriaType = "Expected Input"
			Criteria = item.ExpectedInput
		elif item.ExpectedMemory != null:
			CriteriaType = "Expected Memory"
			Criteria = item.ExpectedMemory
		elif item.ExpectedRegister != null:
			CriteriaType = "Expected Register"
			Criteria = item.ExpectedRegister
		else:
			return null
		view_assignment_button.connect("pressed", self, "_on_view_button_pressed", [
			item.Description,
			item.Title,
			item.AssignmentID,
			Criteria,
			CriteriaType])


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		print(response)
		if assignemntsFetched:
			print(response)
			if response is Array:
				for item in response:
					add_assignment(item)
		else:
			if response is Array:
				for item in response:
					var classroomName = "Classroom: " + item.ClassroomName
					classroomNameLabel.text = classroomName
					classroomNameLabel.visible = true
					classroomId = item.ClassroomID
				if classroomId != null:
					joinClassBtn.hide()
					leaveClassBtn.show()
				else:
					get_tree().change_scene("res://Scenes/Classrooms/JoinClassroom.tscn")
			else:
				print("Invalid response format: expected array")
			if assignemntsFetched == false:
				fetch_student_assignment_info(classroomId)
				assignemntsFetched = true
			else: 
				print("assignments have been fetched")
		if leaveButtonPressed:
			Storage.set_alertMsg("You have successfully left the classroom")
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		print("Failed to fetch classroom data:", response_code)

func _on_view_button_pressed(Description, Title, AssignmentID, Criteria, CriteriaType):
	Storage.set_assignmentDescription(Description)
	Storage.set_assignmentTitle(Title)
	Storage.set_assignmentID(AssignmentID)
	Storage.set_assignmentCriteria(Criteria)
	Storage.set_assignmentCriteriaType(CriteriaType)
	
	get_tree().change_scene("res://Scenes/AssignmentsStudent.tscn")

func _on_MenuBtn_pressed():
	Storage.set_assignmentDescription(null)
	Storage.set_assignmentTitle(null)
	Storage.set_assignmentID(null)
	Storage.set_assignmentCriteria(null)
	Storage.set_assignmentCriteriaType(null)
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_JoinClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/JoinClassroom.tscn")


func _on_LeaveClassroomBtn_pressed():
	if leaveButtonPressed == false:
		confirmLeave.visible = true
		confirmLeaveLabel.visible = true
		leaveButtonPressed = true
	else:
		if confirmLeave.pressed == true:
			leave_classroom(classroomId)
	
