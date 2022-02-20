/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	resistance_flags = RESIST_ALL
	var/in_use = FALSE

INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy)

/mob/living/carbon/human/dummy/Initialize()
	SHOULD_CALL_PARENT(FALSE)// just dummies, shouldnt register
	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED
	dna = new()
	set_species()
	return INITIALIZE_HINT_NORMAL // This stops dummies being setup and registered in the human_mob_list

/mob/living/carbon/human/dummy/Destroy()
	in_use = FALSE
	return ..()

/mob/living/carbon/human/dummy/Life()
	SSmobs.stop_processing(src)


/mob/living/carbon/human/dummy/proc/wipe_state()
	delete_equipment()
	cut_overlays(TRUE)

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	D.in_use = TRUE
	return D

/proc/unset_busy_human_dummy(slotnumber)
	if(!slotnumber)
		return
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotnumber]
	if(!QDELETED(D))
		D.wipe_state()
		D.in_use = FALSE

/mob/living/carbon/human/dummy/set_species(new_species, default_colour, datum/preferences/pref_load)
	if(!new_species)
		new_species = "Human"
	if(species)
		// Clear out their species abilities.
		species.remove_inherent_verbs(src)
	var/datum/species/oldspecies = species
	species = GLOB.all_species[new_species]
	if(oldspecies)
		//additional things to change when we're no longer that species
		oldspecies.post_species_loss(src)
	species.create_organs(src)
	
	set_appearances(default_colour, pref_load)

	INVOKE_ASYNC(src, .proc/regenerate_icons)
	INVOKE_ASYNC(src, .proc/update_body)
	INVOKE_ASYNC(src, .proc/restore_blood)
	return TRUE

/mob/living/carbon/human/dummy/hud_set_job()
	return
