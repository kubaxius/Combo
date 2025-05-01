extends "res://addons/gd-plug/plug.gd"

func _plugging():
	# Declare plugins with plug(repo, args)
	# For example, clone from github repo("user/repo_name")
	# plug("imjp94/gd-YAFSM") # By default, gd-plug will only install anything from "addons/" directory
	# Or you can explicitly specify which file/directory to include
	# plug("imjp94/gd-YAFSM", {"include": ["addons/"]}) # By default, gd-plug will only install anything from "addons/" directory
	
	plug("NoctemCat/BottomPanelShortcuts")
	plug("zaevi/godot-filesystem-view")
	plug("derkork/godot-statecharts")
	plug("OrigamiDev-Pete/TODO_Manager")
	plug("arkology/ShaderV")
	plug("TechnocatDev/2d-shapes")
	plug("bitbrain/beehave", {"include": ["addons/beehave/"]})
	plug("MikeSchulze/gdUnit4")
	
	# plug("pixelpen-dev/pixelpen", {"include": ["project/addons/net.yarvis.pixel_pen/"]})
	# Rapier2D is compiled, so it can't be installed like this.
