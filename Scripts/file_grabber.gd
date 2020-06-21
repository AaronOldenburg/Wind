extends Node

# From this tutorial: https://www.udemy.com/course/godot/learn/lecture/12785487?start=15#overview

func get_files(folder):
	var gathered_files = {}
	var file_count = 0
	var dir = Directory.new()
	
	dir.open(folder)
	dir.list_dir_begin(true)

	while true:
		var file = dir.get_next()
		print ("Next file: ", file)
		if file == "":
			break
		elif !file.begins_with(".") && !file.ends_with(".import"):
			gathered_files[file_count] = folder + file
			file_count += 1

	return gathered_files
