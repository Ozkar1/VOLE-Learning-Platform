extends Node

var user_data = {}

func store_data(data):
	user_data["UserID"] = data["UserID"]
	user_data["Username"] = data["Username"]
	user_data["Role"] = data["Role"]
	print("User data stored: ", user_data)
	# Optionally, save this data to disk if needed
	save_to_disk(user_data)

func save_to_disk(data, path="user://user_data.save"):
	var file = File.new()
	if file.open(path, File.WRITE) == OK:
		file.store_var(data)
		file.close()

func load_from_disk(path="user://user_data.save"):
	var file = File.new()
	if file.exists(path):
		if file.open(path, File.READ) == OK:
			user_data = file.get_var()
			file.close()
			return user_data
