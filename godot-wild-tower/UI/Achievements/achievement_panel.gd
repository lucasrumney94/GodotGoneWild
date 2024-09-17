extends PanelContainer


func setup_panel(ach: Achievement, earned: bool):
	%IconTextureRect.texture = ach.icon
	%NameLabel.text = ach.title
	if earned:
		%DescriptionLabel.text = ach.description
		%CheckTextureRect.modulate = Color.GREEN
	else:
		%DescriptionLabel.text = "???"
