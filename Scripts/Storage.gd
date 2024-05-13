extends Node


# Path to save the encrypted file
const FILE_PATH = "user://token.save"
# Key for encryption/decryption (ensure this is securely generated and stored)
const ENCRYPTION_KEY = "bdbfcd9fad9a3a3e7e38c6b333cc03d4638cfcae50d00e4e4995074847111547"

var _classroomId = null

func save_token(token: String):
	var file = File.new()
	file.open_encrypted_with_pass(FILE_PATH, File.WRITE, ENCRYPTION_KEY)
	file.store_string(token)
	file.close()

func load_token() -> String:
	var file = File.new()
	if file.file_exists(FILE_PATH):
		file.open_encrypted_with_pass(FILE_PATH, File.READ, ENCRYPTION_KEY)
		var token = file.get_as_text()
		file.close()
		return token
	return ""

func getUserIdFromToken() -> String:
	var token = load_token()
	if token != "":
		var decoded_token = JWT.decode(token)
		if decoded_token != null:
			var user_id = decoded_token.get_claim("UserID")
			if user_id != null:
				return user_id
			else:
				print("UserID not found in the JWT token")
		else:
			print("Failed to decode JWT token")
	return ""

func set_classroomId(classroomId):
	_classroomId = classroomId

func get_classroomId():
	return _classroomId
