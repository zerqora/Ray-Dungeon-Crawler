extends Node

# When the user presses E
signal on_interaction_button_pressed()

# Level managers
signal door_entered(path: NodePath)
signal level_ready(level : Level)
