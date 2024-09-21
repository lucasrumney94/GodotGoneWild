#extends Node
class_name Constants

enum EnemyType {
	CHERUBIM,
	MALAKIM,
	SERAPHIM,
	OPHANIM
}


static func format_time(seconds: float) -> String:
	var minutes = floor(seconds / 60.0)
	var remaining_seconds = floor(seconds - (minutes * 60))
	var centiseconds = (seconds - (minutes * 60) - remaining_seconds) * 100
	var minute_string: String = str(minutes)
	if minutes < 10:
		minute_string = "%02d" % minutes
	return minute_string + ":" + ("%02d" % remaining_seconds) + ":" + ("%02d" % centiseconds)
