extends PanelContainer


func populate_stats(level_index: int):
	%LevelLabel.text = "Level " + str(level_index + 1)
	%FastestPlayLabel.text = Constants.format_time(SaveControl.get_stat(level_index, "best_time"))
	%TotalTimeLabel.text = Constants.format_time(SaveControl.get_stat(level_index, "time"))
	%AngelsKilledLabel.text = str(SaveControl.get_stat(level_index, "kill"))
	%CherubimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.CHERUBIM)))
	%MalakimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.MALAKIM)))
	%SeraphimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.SERAPHIM)))
	%OphanimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.OPHANIM)))
	%RestartsLabel.text = str(SaveControl.get_stat(level_index, "restart"))
	%DeathsLabel.text = str(SaveControl.get_stat(level_index, "death"))
