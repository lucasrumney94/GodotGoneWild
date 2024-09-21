extends PanelContainer


func _process(_delta):
	if !visible: return
	
	%PlaythroughTimeLabel.text = "PlayThru: " + Constants.format_time(StatTracker.playthrough_time)
	%KillsLabel.text = "Kills: " + str(StatTracker.kills)
	%RestartsLabel.text = "Restarts: " + str(StatTracker.restarts)
	%DeathsLabel.text = "Deaths: " + str(StatTracker.deaths)
