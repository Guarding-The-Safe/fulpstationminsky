


// 		WITHOUT THIS POWER:
//
//	- Mid-Blood: SHOW AS PALE
//	- Low-Blood: SHOW AS DEAD
//	- No Heartbeat
//  - Examine shows actual blood
//	- Thermal homeostasis (ColdBlooded)



// 		WITH THIS POWER:
//	- Normal body temp -- remove Cold Blooded (return on deactivate)
//	-


/datum/action/bloodsucker/masquerade
	name = "Masquerade"
	desc = "Feign the vital signs of a mortal, and escape both casual and medical notice as the monster you truly are.<br><br><i>Your over-time blood consumption increases while Masquerade is active.</i>"
	button_icon_state = "power_human"

	bloodcost = 10
	cooldown = 50
	amToggle = TRUE
	bloodsucker_can_buy = TRUE



// NOTE: Firing off vulgar powers disables your Masquerade!


/datum/action/bloodsucker/masquerade/CheckCanUse(display_error)
	if(!..(display_error))// DEFAULT CHECKS
		return FALSE
	// DONE!
	return TRUE



/datum/action/bloodsucker/masquerade/ActivatePower()

	var/mob/living/user = owner
	var/datum/antagonist/bloodsucker/bloodsuckerdatum = user.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)

	to_chat(user, "<span class='notice'>Your heart beats falsely within your lifeless chest. You may yet pass for a mortal.</span>")
	to_chat(user, "<span class='warning'>Your vampiric healing is halted while imitating life.</span>")


	// Remove ColdBlooded & Hard/SoftCrit
	user.remove_trait(TRAIT_COLDBLOODED, "bloodsucker")
	user.remove_trait(TRAIT_NOHARDCRIT, "bloodsucker")
	user.remove_trait(TRAIT_NOSOFTCRIT, "bloodsucker")
	var/obj/item/organ/heart/vampheart/H = user.getorganslot(ORGAN_SLOT_HEART)

	// WE ARE ALIVE! //
	bloodsuckerdatum.poweron_masquerade = TRUE
	while(ContinueActive(user))

		// HEART
		if (istype(H))
			H.FakeStart()

		// 		PASSIVE (done from LIFE)
		// Don't Show Pale/Dead on low blood
		// Don't vomit food
		// Don't Heal

		// Pay Blood Toll
		bloodsuckerdatum.AddBloodVolume(-0.2)

		sleep(20) // Check every few ticks that we haven't disabled this power

	//DeactivatePower()





/datum/action/bloodsucker/masquerade/ContinueActive(mob/living/user)
	// Disable if unable to use power anymore.
	if (user.stat == DEAD || user.blood_volume <= 0) // not conscious or soft critor uncon, just dead
		return FALSE
	return ..() // Active, and still Antag


/datum/action/bloodsucker/masquerade/DeactivatePower(mob/living/user = owner, mob/living/target)
	..() // activate = FALSE

	var/datum/antagonist/bloodsucker/bloodsuckerdatum = user.mind.has_antag_datum(ANTAG_DATUM_BLOODSUCKER)
	bloodsuckerdatum.poweron_masquerade = FALSE

	user.add_trait(TRAIT_COLDBLOODED, "bloodsucker")
	user.add_trait(TRAIT_NOHARDCRIT, "bloodsucker")
	user.add_trait(TRAIT_NOSOFTCRIT, "bloodsucker")

	// HEART
	var/obj/item/organ/heart/H = user.getorganslot(ORGAN_SLOT_HEART)
	H.Stop()

	to_chat(user, "<span class='notice'>Your heart beats one final time, while your skin dries out and your icy pallor returns.</span>")
