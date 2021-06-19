//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Tether lateload maps
/datum/map_template/tether_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/tether_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(GLOB.using_map, z)

/datum/map_z_level/tether_lateload
	z = 0

/datum/map_z_level/tether_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)

//////////////////////////////////////////////////////////////////////////////
/// Static Load
/datum/map_template/tether_lateload/tether_misc
	name = "Tether - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "_maps/map_files/tether/tether_misc.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/misc

/datum/map_z_level/tether_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/tether_lateload/tether_underdark
	name = "Tether - Underdark"
	desc = "Mining, but harder."
	mappath = "_maps/map_files/tether/tether_underdark.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/underdark

/datum/map_z_level/tether_lateload/underdark
	name = "Underdark"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b
	z = Z_LEVEL_UNDERDARK

/datum/map_template/tether_lateload/tether_underdark/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_UNDERDARK), 100, /area/mine/unexplored/underdark, /datum/map_template/submap/level_specific/underdark)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNDERDARK, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_UNDERDARK, 64, 64)         // Create the mining ore distribution map.

/datum/map_template/tether_lateload/tether_plains
	name = "Tether - Plains"
	desc = "The Virgo 3B away mission."
	mappath = "_maps/map_files/tether/tether_plains.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/tether_plains

/datum/map_z_level/tether_lateload/tether_plains
	name = "Away Mission - Plains"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b
	z = Z_LEVEL_PLAINS

/datum/map_template/tether_lateload/tether_plains/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_PLAINS), 120, /area/tether/outpost/exploration_plains, /datum/map_template/submap/level_specific/plains)

//////////////////////////////////////////////////////////////////////////////
//Rogue Mines Stuff

/datum/map_template/tether_lateload/tether_roguemines1
	name = "Asteroid Belt 1"
	desc = "Mining, but rogue. Zone 1"
	mappath = '_maps/planet_levels/140x40/roguemining/rogue_mine1.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines1

/datum/map_z_level/tether_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_1

/datum/map_template/tether_lateload/tether_roguemines2
	name = "Asteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = '_maps/planet_levels/140x40/roguemining/rogue_mine2.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines2

/datum/map_z_level/tether_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_2

//////////////////////////////////////////////////////////////////////////////
/// Away Missions
/datum/map_template/tether_lateload/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = 'maps/expedition_vr/beach/beach.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/away_beach

/datum/map_z_level/tether_lateload/away_beach
	name = "Away Mission - Desert Beach"
	z = Z_LEVEL_BEACH
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/tether_lateload/away_beach_cave
	name = "Desert Planet - Z2 Cave"
	desc = "The beach away mission's cave."
	mappath = 'maps/expedition_vr/beach/cave.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/away_beach_cave

/datum/map_template/tether_lateload/away_beach_cave/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_BEACH_CAVE), 120, /area/tether_away/cave/unexplored/normal, /datum/map_template/submap/level_specific/mountains/normal)
	//seed_submaps(list(Z_LEVEL_BEACH_CAVE), 70, /area/tether_away/cave/unexplored/normal, /datum/map_template/submap/level_specific/mountains/deep)

	// Now for the tunnels.
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_BEACH_CAVE, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/beachmine(null, 1, 1, Z_LEVEL_BEACH_CAVE, 64, 64)

/datum/map_z_level/tether_lateload/away_beach_cave
	name = "Away Mission - Desert Cave"
	z = Z_LEVEL_BEACH_CAVE
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/obj/effect/step_trigger/zlevel_fall/beach
	var/static/target_z

/datum/map_template/tether_lateload/away_alienship
	name = "Alien Ship - Z1 Ship"
	desc = "The alien ship away mission."
	mappath = "_maps/planet_levels/140x140/alienship.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/away_alienship

/datum/map_z_level/tether_lateload/away_alienship
	name = "Away Mission - Alien Ship"

/datum/map_template/tether_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = "_maps/planet_levels/140x140/virgo2_aerostat.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/away_aerostat

/datum/map_z_level/tether_lateload/away_aerostat
	name = "Away Mission - Aerostat"
	z = Z_LEVEL_AEROSTAT
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky

/datum/map_template/tether_lateload/away_aerostat_surface
	name = "Remmi Aerostat - Z2 Surface"
	desc = "The surface from the Virgo 2 Aerostat."
	mappath = "_maps/planet_levels/140x140/virgo2_surface.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/away_aerostat_surface

/datum/map_template/tether_lateload/away_aerostat_surface/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_AEROSTAT_SURFACE), 120, /area/tether_away/aerostat/surface/unexplored, /datum/map_template/submap/level_specific/virgo2)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_AEROSTAT_SURFACE, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/virgo2(null, 1, 1, Z_LEVEL_AEROSTAT_SURFACE, 64, 64)

/datum/map_z_level/tether_lateload/away_aerostat_surface
	name = "Away Mission - Aerostat Surface"
	z = Z_LEVEL_AEROSTAT_SURFACE
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

/datum/map_template/tether_lateload/away_debrisfield
	name = "Debris Field - Z1 Space"
	desc = "The Virgo 3 Debris Field away mission."
	mappath = 'maps/expedition_vr/space/debrisfield.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/away_debrisfield

/datum/map_template/tether_lateload/away_debrisfield/on_map_loaded(z)
	. = ..()
	//Commented out until we actually get POIs
	seed_submaps(list(Z_LEVEL_DEBRISFIELD), 400, /area/space, /datum/map_template/submap/level_specific/debrisfield)

/datum/map_z_level/tether_lateload/away_debrisfield
	name = "Away Mission - Debris Field"
	z = Z_LEVEL_DEBRISFIELD

/datum/map_template/tether_lateload/away_fueldepot
	name = "Fuel Depot - Z1 Space"
	desc = "An unmanned fuel depot floating in space."
	mappath = 'maps/expedition_vr/space/fueldepot.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/away_fueldepot

/datum/map_z_level/tether_lateload/away_fueldepot
	name = "Away Mission - Fuel Depot"
	z = Z_LEVEL_FUELDEPOT

//////////////////////////////////////////////////////////////////////////////////////
// Gateway submaps go here

/obj/effect/overmap/visitable/sector/tether_gateway
	name = "Unknown"
	desc = "Approach and perform a scan to obtain further information."
	icon_state = "object" //or "globe" for planetary stuff
	known = FALSE

/datum/map_template/tether_lateload/gateway
	name = "Gateway Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = null

/datum/map_z_level/tether_lateload/gateway_destination
	name = "Gateway Destination"
	z = Z_LEVEL_GATEWAY

/datum/map_template/tether_lateload/gateway/snow_outpost
	name = "Snow Outpost"
	desc = "Big snowy area with various outposts."
	mappath = '_maps/away_missions/140x140/snow_outpost.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/zoo
	name = "Zoo"
	desc = "Gigantic space zoo"
	mappath = '_maps/away_missions/140x140/zoo.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/carpfarm
	name = "Carp Farm"
	desc = "Asteroid base surrounded by carp"
	mappath = '_maps/away_missions/140x140/carpfarm.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/snowfield
	name = "Snow Field"
	desc = "An old base in middle of snowy wasteland"
	mappath = '_maps/away_missions/140x140/snowfield.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/listeningpost
	name = "Listening Post"
	desc = "Asteroid-bound mercenary listening post"
	mappath = '_maps/away_missions/140x140/listeningpost.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

//////////////////////////////////////////////////////////////////////////////////////
// Admin-use z-levels for loading whenever an admin feels like
/datum/map_template/tether_lateload/fun/spa
	name = "Space Spa"
	desc = "A pleasant spa located in a spaceship."
	mappath = '_maps/templates/admin/spa.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/fun/spa

/datum/map_z_level/tether_lateload/fun/spa
	name = "Spa"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED

// Talon offmap spawn
/datum/map_template/tether_lateload/offmap/talon1
	name = "Offmap Ship - Talon Z1"
	desc = "Offmap spawn ship, the Talon."
	mappath = 'maps/offmap_vr/talon/talon1.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/talon1

/datum/map_template/tether_lateload/offmap/talon2
	name = "Offmap Ship - Talon Z2"
	desc = "Offmap spawn ship, the Talon."
	mappath = 'maps/offmap_vr/talon/talon2.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/talon2

/datum/map_z_level/tether_lateload/talon1
	name = "Talon Deck One"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/space
	z = Z_LEVEL_OFFMAP1

/datum/map_z_level/tether_lateload/talon2
	name = "Talon Deck Two"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open
	z = Z_LEVEL_OFFMAP2