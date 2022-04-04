/obj/effect/spawner/modularmap
	name = "Modular map marker"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "random_map"
	dir = NORTH
	///The ID of the types we would like to be choosing from
	var/mapid
	///How high our spawner area is, used to catch mistakes in mapping
	var/spawner_height = 0
	///How wide our spawner area is, used to catch mistakes in mapping
	var/spawner_width = 0

/obj/effect/spawner/modularmap/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/spawner/modularmap/LateInitialize(mapload)
	var/datum/map_template/modular/template
	template = pick(SSmapping.modular_templates[mapid])
	var/errored = FALSE
	if(!istype(template, /datum/map_template/modular))
		stack_trace("A spawner has an invalid template")
		errored = TRUE
	if(spawner_height != template.template_height)
		stack_trace("A spawner has an invalid height")
		errored = TRUE
	if(spawner_width != template.template_width)
		stack_trace("A spawner has an invalid width")
		errored = TRUE
	if(errored)
		return
	if(!template)
		stack_trace("Mapping error: room loaded with no template")
		message_admins("Warning, modular mapping error, please report this to coders and get it fixed ASAP")
		qdel(src)
		return
	INVOKE_ASYNC(template, /datum/map_template.proc/load, get_turf(src), template.keepcentered)
	qdel(src)

/*********Types********/

/*****Prison / Fiona penitentiary****/
/obj/effect/spawner/modularmap/prison/civressouth
	mapid = "southcivres"
	spawner_width = 9
	spawner_height = 11

/************LV 624**********/
/obj/effect/spawner/modularmap/lv624/hydroroad
	mapid = "hydroroad"
	spawner_height = 20
	spawner_width = 20

/obj/effect/spawner/modularmap/lv624/domes
	mapid = "lvdome"
	spawner_height = 15
	spawner_width = 15

/obj/effect/spawner/modularmap/lv624/medicaldome
	mapid = "lvmedicaldome"
	spawner_height = 15
	spawner_width = 15

/obj/effect/spawner/modularmap/lv624/largecentralcave
	mapid = "lvcaveslakearea"
	spawner_height = 33
	spawner_width = 80


/************BIG RED******/
/obj/effect/spawner/modularmap/bigred/operations //todo decrease y by one
	mapid = "broperations"
	spawner_width = 29
	spawner_height = 25

/************EORG**********/
/obj/effect/spawner/modularmap/admin/eorg
	mapid = "EORG"
	spawner_height = 46
	spawner_width = 46
