extends Node2D

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db # object 
var db_name_res = "res://DataStore/database.db"
var db_name = "user://database.db" #path

var points = 0

func _ready():
	var dir = Directory.new()
	if(!dir.file_exists(db_name)):
		dir.copy(db_name_res, db_name);
	
	db = SQLite.new()
	db.path = db_name
	checkDatabase()
	readFromDB()
	

func commitDatatoDB():
	db.open_db()
	var tableName = "scoreTable"
	var dict : Dictionary = Dictionary() #declare dictionary to store values
	dict["Score"] = 21 #this value goes to score column
	
	db.insert_row(tableName, dict) #insert values into database

func readFromDB():
	db.open_db()
	var tableName = "scoreTable"
	db.query("SELECT * FROM " + tableName + ";")
	for i in range(0, db.query_result.size()):
		print("Query results: ", db.query_result[i]["Score"])

func checkDatabase():
	db.open_db()
	var tableName = "scoreTable"
	db.query("SELECT Score FROM " + tableName + " WHERE ID = 1;")
	if(db.query_result != null):
		points = int(str(db.query_result[0]["Score"]))
		$Label.text = str(db.query_result)
		print(str(db.query_result))
	else: $Label.text = "<Empty>"

func updateData(numINput:int):
	db.open_db()
	var id = 1
	var tableName = "scoreTable"
	db.query("UPDATE "+ tableName +" SET Score = "+str(numINput)+" WHERE ID = "+str(id)+";")
	checkDatabase()
	
func resetData():
	db.open_db()
	var id = 1
	var num = 0
	var tableName = "scoreTable"
	db.query("UPDATE "+ tableName +" SET Score = "+str(num)+" WHERE ID = "+str(id)+";")
	checkDatabase()


func _on_Quit_pressed():
	get_tree().quit()

func _on_Reset_pressed():
	resetData()
	points = 0

func _on_AddPoint_pressed():
	points = points + 1
	updateData(points)
	
