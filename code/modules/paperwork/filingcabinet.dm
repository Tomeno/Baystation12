/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filing_cabinet0"
	var/icon_closed = "filing_cabinet0"
	var/icon_open = "filing_cabinet1"
	density = 1
	anchored = 1

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"
	icon_closed = "chestdrawer"
	icon_open = "chestdrawer-open"

/obj/structure/filingcabinet/filingcabinet
	icon_state = "filingcabinet"
	icon_closed = "filingcabinet"
	icon_open = "filingcabinet-open"

/obj/structure/filingcabinet/initialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/weapon/paper) || istype(I, /obj/item/weapon/folder) || istype(I, /obj/item/weapon/photo))
			I.loc = src

/obj/structure/filingcabinet/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/paper) || istype(P, /obj/item/weapon/folder) || istype(P, /obj/item/weapon/photo))
		user << "<span class='notice'>You put [P] in [src].</span>"
		user.drop_item()
		P.loc = src
		icon_state = icon_open
		sleep(5)
		icon_state = icon_closed
		updateUsrDialog()
	else if(istype(P, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored
		user << "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>"
	else
		user << "<span class='notice'>You can't put [P] in [src]!</span>"

/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(contents.len <= 0)
		user << "<span class='notice'>\The [src] is empty.</span>"
		return

	user.machine = src
	var/dat = "<center><table>"
	var/i
	for(i=contents.len, i>=1, i--)
		var/obj/item/P = contents[i]
		dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	user << browse("<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=filingcabinet;size=250x300")

	return

/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list["retrieve"])
		usr << browse("", "window=filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(P && in_range(src, usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			icon_state = icon_open
			sleep(5)
			icon_state = icon_closed


