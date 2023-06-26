

/obj/item/reagent_containers/food/snacks/muffin_batter
	name = "muffin batter"
	desc = "A mixing bowl with the perfect muffin batter!."
	icon = 'icons/obj/foodNdrink/cupcakes.dmi'
	icon_state = "muffin_batter"

/obj/item/reagent_containers/food/snacks/muffin_pan1
	name = "muffin pan"
	desc = "A muffin pan filled with batter!."
	icon = 'icons/obj/foodNdrink/cupcakes.dmi'
	icon_state = "muffin_pan1"

/obj/item/reagent_containers/food/snacks/muffin_pan2
	var/mbc_left = 4
	name = "muffin pan"
	desc = "A muffin pan full of freshly baked muffins!."
	icon = 'icons/obj/foodNdrink/cupcakes.dmi'
	icon_state = "muffin_pan2"

	attack_hand(mob/user, unused, flag)
		if (flag)
			return ..()
		if (user.r_hand == src || user.l_hand == src)
			if(src.mbc_left == 0)
				boutput(user, "<span class='alert'>That was all the muffins!.</span>")
				return
			else
				var/obj/item/reagent_containers/food/snacks/muffin/B = new(user)
				user.put_in_hand_or_drop(B)
				src.mbc_left--
				if(src.mbc_left == 3)
					src.icon_state = "muffin_pan3"
				else if(src.mbc_left == 2)
					src.icon_state = "muffin_pan4"
				else if(src.mbc_left == 1)
					src.icon_state = "muffin_pan5"
				else if(src.mbc_left == 0)
					src.icon_state = "muffin_pan"
		else
			return ..()
		return

/obj/item/reagent_containers/food/snacks/muffin
	name = "muffin"
	desc = "A muffin."
	icon = 'icons/obj/foodNdrink/cupcakes.dmi'
	icon_state = "muffin"
	flags = FPRINT | TABLEPASS | NOSPLASH
	appearance_flags = KEEP_TOGETHER
	heal_amt = 1
	initial_volume = 20
	initial_reagents = list("sugar" = 5)
	food_effects = list("food_energized")
	var/can_add_frosting = TRUE
	var/can_add_topping = TRUE
	var/static/list/frosting_styles = list(
	"base" = "muffin_frosting_base",
	"swirl" = "muffin_frosting_swirl")
	var/style_step = 1

	proc/add_frosting(var/obj/item/reagent_containers/food/drinks/drinkingglass/icing/tube, var/mob/user)
		if (tube.reagents.total_volume < 20)
			user.show_text("The [tube] isn't full enough to add frosting.", "red")
			return

		if (src.style_step > 2) // only allow up to two frosting types on a single muffin
			user.show_text("You can't add anymore frosting.", "red")
			return

		var/frosting_type = null
		frosting_type = input("Which frosting style would you like?", "Frosting Style", null) as null|anything in frosting_styles
		if(frosting_type && (BOUNDS_DIST(src, user) == 0))
			frosting_type = src.frosting_styles[frosting_type]
			var/datum/color/average = tube.reagents.get_average_color()
			var/image/frosting_overlay = new(src.icon, frosting_type)
			frosting_overlay.color = average.to_rgba()
			src.UpdateOverlays(frosting_overlay, "frosting[src.style_step]")
			user.show_text("You add some frosting to [src]", "red")
			src.style_step += 1
			tube.reagents.trans_to(src, 15)
			JOB_XP(user, "Chef", 1)

	attackby(obj/item/F, mob/user)
		if (istype(F, /obj/item/reagent_containers/food/drinks/drinkingglass/icing))
			src.add_frosting(F, user)
			return
		else
			. = ..()

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/reagent_containers/food/snacks/plant/strawberry))
			user.u_equip(W)
			qdel(W)
			src.UpdateOverlays(src.SafeGetOverlayImage('icons/obj/foodNdrink/cupcakes.dmi', "strawberry", src.layer + 0.1), "strawberry")
		else
			. = ..()

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/reagent_containers/food/snacks/plant/cherry))
			user.u_equip(W)
			qdel(W)
			src.UpdateOverlays(src.SafeGetOverlayImage('icons/obj/foodNdrink/cupcakes.dmi', "cherry", src.layer + 0.1), "cherry")
		else
			. = ..()

	attackby(obj/item/W, mob/user)
		if (istype(W, /obj/item/reagent_containers/food/snacks/plant/blueberry))
			user.u_equip(W)
			qdel(W)
			src.UpdateOverlays(src.SafeGetOverlayImage('icons/obj/foodNdrink/cupcakes.dmi', "blueberry", src.layer + 0.1), "blueberry")
		else
			. = ..()



