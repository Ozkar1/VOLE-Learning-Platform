extends Control

onready var http_request = $HTTPRequest
onready var ClassroomsSelector = $ColorRect/Panel/OptionButton
onready var ConfirmDeletion = $ColorRect/Panel/CheckBox
onready var ErrorLabel = $ColorRect/ErrorLabel

var ClassroomID
var ClassroomDeleted = false
var ClassroomIDMap = {}


var Classroom_info_api = "http://localhost:3000/api/classrooms/teacher"

func _ready():
	fetch_teacher_classroom_info()
	ErrorLabel.visible = false

func fetch_teacher_classroom_info():
	var token = Storage.load_token()  
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + token
		]
	http_request.request(Classroom_info_api, headers, true, HTTPClient.METHOD_GET, "")


func deleteClassroom():
	var selectedIdx = ClassroomsSelector.selected
	var classroomID = ClassroomIDMap[selectedIdx]
	if classroomID:
		var token = Storage.load_token()  
		var url = "http://localhost:3000/api/classrooms/delete/" + str(classroomID)
		var headers = [
			"Content-Type: application/json",
			"Authorization: Bearer " + token
		]
		http_request.request(url, headers, true, HTTPClient.METHOD_DELETE)
		ClassroomDeleted = true

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	if ClassroomDeleted:
		if response_code == 200:
			Storage.set_alertMsg("Classroom successfully deleted!")
			get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")
		else:
			print("Failed to delete classroom:", response)
		ClassroomDeleted = false
	else:
		if response_code == 200:
			ClassroomsSelector.clear()
			ClassroomIDMap.clear()
			if response is Array:
				for idx in range(response.size()):
					var item = response[idx]
					var classroomName = "Classroom: " + item.ClassroomName
					ClassroomsSelector.add_item("  " + classroomName)
					ClassroomIDMap[idx] = item.ClassroomID
			else:
				print("Invalid response format: expected array")
		else:
			print("Failed to fetch classroom data:", response_code)



func _on_DeleteClassroomBtn_pressed():
	if ConfirmDeletion.pressed == true:
		deleteClassroom()
	else:
		ErrorLabel.text = "Please confirm deletion"
		ErrorLabel.visible = true


func _on_BackToTeacherClassroomBtn_pressed():
	get_tree().change_scene("res://Scenes/Classrooms/ClassroomTeacher.tscn")
