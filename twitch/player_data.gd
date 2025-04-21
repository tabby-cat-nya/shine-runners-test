extends Resource
class_name PlayerData

@export var money : int = 0
@export var user_id : String = "" 
@export var username : String = ""

enum Result{
	none,
	win,
	lose
}

var playing : bool = true
var unix_timeout : int = 0 # will implement later, hides players who havent done anything for awhile
var betting : bool = false
var result : Result = Result.none
var current_bet : int = 20 # no selection icon
var current_wager : int = 0
