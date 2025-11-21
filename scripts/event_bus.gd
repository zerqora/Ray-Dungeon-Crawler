extends Node

# When the user presses E
signal on_interaction_button_pressed()

# Level managers
signal door_entered(path: NodePath)
signal level_ready(level : Level)

# Player signals
signal player_died()
signal heal_oxygen(amount : int)
signal lose_oxygen(amount : int)
