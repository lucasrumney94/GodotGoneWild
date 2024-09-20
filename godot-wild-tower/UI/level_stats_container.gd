extends PanelContainer


func populate_stats(level_index: int):
	%LevelLabel.text = "Level " + str(level_index + 1)
	#TOTALS STATS
	%TotalTimeLabel.text = Constants.format_time(SaveControl.get_stat(level_index, "time"))
	%AngelsKilledLabel.text = str(SaveControl.get_stat(level_index, "kill"))
	%CherubimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.CHERUBIM)))
	%MalakimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.MALAKIM)))
	%SeraphimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.SERAPHIM)))
	%OphanimKilledLabel.text = str(SaveControl.get_stat(level_index, "kill" + str(Constants.EnemyType.OPHANIM)))
	%RestartsLabel.text = str(SaveControl.get_stat(level_index, "restart"))
	%DeathsLabel.text = str(SaveControl.get_stat(level_index, "death"))
	
	#BEST STATS
	%FastestPlayLabel.text = Constants.format_time(SaveControl.get_stat(level_index, "best_time"))
	%MostKillsLabel.text = SaveControl.get_best_stat_string(level_index, "most_kills")
	%FewestKillsLabel.text = SaveControl.get_best_stat_string(level_index, "fewest_kills")
	%FewestRestartsLabel.text = SaveControl.get_best_stat_string(level_index, "fewest_restarts")
	%FewestDeathsLabel.text = SaveControl.get_best_stat_string(level_index, "fewest_deaths")
