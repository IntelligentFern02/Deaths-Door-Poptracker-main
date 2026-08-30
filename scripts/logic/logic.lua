-- put logic functions here using the Lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
-- don't be afraid to use custom logic functions. it will make many things a lot easier to maintain, for example by adding logging.
-- to see how this function gets called, check: locations/locations.json
-- example:
function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    amount = tonumber(amount)
    if not amount then
      return count > 0
    else
      return count >= amount
    end
end

-- HALL REGIONS================================================================================
function AncientDoor1Open()
  return has("CROW_MANOR_AFTER_TORCH_PUZZLE")
    and has("CROW_MANOR_IMP_LOFT")
    and has("CROW_MANOR_LIBRARY")
    and has("CROW_MANOR_BEDROOM")
end

function AncientDoor2Open()
  return has("CROW_DUNGEON_HALL")
    and has("CROW_DUNGEON_WATER_ARENA")
    and has("CROW_DUNGEON_COBWEB")
    and has("CROW_DUNGEON_RIGHTMOST")
end

function AncientDoor3Open()
  return has("CROW_LOCKSTONE_EAST")
    and has("CROW_LOCKSTONE_WEST")
    and has("CROW_LOCKSTONE_WEST_LOCKED")
    and has("CROW_LOCKSTONE_SOUTH_WEST")
end

function CanFightLord()
  return PeakAccess()
    and has("GIANT_SOUL_OF_THE_URN_WITCH")
    and has("GIANT_SOUL_OF_THE_FROG_KING") 
    and has("GIANT_SOUL_OF_BETTY") 
    and has("hookshot")
end

-- CEMETARY REGIONS==========================================================================
function CemetaryEntrance()
  return has("LOST_CEMETERY_DOOR") 
    or has("GROVE_OF_SPIRITS_DOOR") 
end

function PeakAccess()
  return (CemetaryEntrance() and (has("LEVER_GUARDIAN_OF_THE_DOOR_ACCESS") or (has("LEVER_CEMETERY_SEWER") and (has("PINK_KEY",1) or (has("hookshot") and has("LEVER_CATACOMBS_TOWER"))))))
    or (LegdayAccess() and has("LEVER_GUARDIAN_OF_THE_DOOR_ACCESS") and has ("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE"))
end

function SteadhoneAccess()
  return (CemetaryEntrance() and (has("PINK_KEY",1) or (has("LEVER_GUARDIAN_OF_THE_DOOR_ACCESS") and (has("LEVER_CEMETERY_SEWER"))) or has("LEVER_CATACOMBS_TOWER")))
    or (LegdayAccess() and has ("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE") and (has("LEVER_CATACOMBS_TOWER") or (has("LEVER_GUARDIAN_OF_THE_DOOR_ACCESS") or has("LEVER_CEMETERY_SEWER"))))
end

function HasNightAccess()
  return has("RUSTY_BELLTOWER_KEY") and (
    (PeakAccess() and has("PINK_KEY",1)) or 
    (SteadhoneAccess() and has("LEVER_CEMETERY_EXIT_TO_ESTATE"))
  )
end

function CatacombsRoomOneAccess()
  return (CemetaryEntrance() and (has("fire") or has("LEVER_CATACOMBS_EXIT")))
  or (LegdayAccess() and has("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE") and (has("LEVER_GUARDIAN_OF_THE_DOOR_ACCESS") or has("LEVER_CATACOMBS_TOWER")))
end

function CatacombsFullAccess()
  return (CatacombsRoomOneAccess() and has("fire"))
end

function ArrowSilentServant()
  return (CatacombsFullAccess() and has("bomb") and has("hookshot"))
end

function EastTreeAreaAccess()
  return (LegdayAccess() and has("LEVER_CEMETERY_EAST_TREE"))
    or (PeakAccess() and has("fire"))
    or ((SteadhoneAccess() or CemetaryEntrance()) and has("LEVER_CATACOMBS_TOWER") and has("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE") and has("LEVER_CEMETERY_EAST_TREE"))
end

function RuinExitAccess()
  return (PeakAccess() and has("fire"))
    or ((SteadhoneAccess() or CemetaryEntrance()) and has("LEVER_CATACOMBS_TOWER") and has("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE"))
end

function CemetaryEntranceExternal()
  return (LegdayAccess() and has("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE") and (has("LEVER_GUARDIAN_OF_THE_DOOR_ACCESS") or has("LEVER_CATACOMBS_TOWER")))
end

function BridgeEndAccess()
  return (CemetaryEntrance() and has("LEVER_CATACOMBS_TOWER"))
    or (SteadhoneAccess() and has("LEVER_CATACOMBS_TOWER"))
    or (LegdayAccess() and has("LEVER_CEMETERY_SHORTCUT_TO_EAST_TREE"))
end

--CRYPT ACCESS ==================================================================================
function CryptAccess()
  return (PeakAccess() and has("PINK_KEY",1) and has("LEVER_CEMETERY_EXIT_TO_ESTATE"))
    or (SteadhoneAccess() and has("LEVER_CEMETERY_EXIT_TO_ESTATE"))
end

--Estate Regions ================================================================================
function ManorDoorAccess()
  return ((CryptAccess() or has("ESTATE_OF_THE_URN_WITCH_DOOR")) and has("LEVER_GARDEN_OF_PEACE") and has("LEVER_GARDEN_OF_JOY"))
    or has("CERAMIC_MANOR_DOOR")
end

function EstateFrontAccess()
  return CryptAccess() or has("ESTATE_OF_THE_URN_WITCH_DOOR") 
    or (has("CERAMIC_MANOR_DOOR") and has("LEVER_GARDEN_OF_PEACE") and has("LEVER_GARDEN_OF_JOY"))
end

--Manor Regions =================================================================================
function ManorEntranceAccess()
  return (ManorDoorAccess() and has("LEVER_GARDEN_OF_LIFE_END") and has("LEVER_GARDEN_OF_LOVE"))
    or has("CERAMIC_MANOR_DOOR")
end

function ManorBehindKey()
  return ManorEntranceAccess() and has("YELLOW_KEY",1)
end

--FURNACE OBS ROOM===============================================================================
function FurnaceObservationRoomAccess()
  return (ManorEntranceAccess() and has("fire") and has("YELLOW_YEY,1"))
    or has("INNER_FURNACE_DOOR")
end

--RUINS & DUNGEONS REGIONS =================================================================================
function LegdayAccess()
  return RuinGateAccess() and has("LEVER_RUINS_MAIN_GATE")
end

function RuinGateAccess()
  return has("OVERGROWN_RUINS_DOOR")
  or has("MUSHROOM_DUNGEON_DOOR")
end

function DungeonsAccess()
  return (RuinGateAccess() and has("MAGICAL_FOREST_HORN")) 
    or has("MUSHROOM_DUNGEON_DOOR")
    or (RuinGateAccess() and (has("bomb") or has("LEVER_DUNGEON_ABOVE_RIGHTMOST_CROW")))
end

function DungeonRequiresKey()
  return (DungeonsAccess() and has("GREEN_KEY",1))
end

--FORTRESS REGIONS=================================================================================
function FloodedFortressFrontAccess()
  return (DungeonsAccess() and has("bomb"))
end

function FortressGateAccess()
  return has("FLOODED_FORTRESS_DOOR")
    or (FloodedFortressFrontAccess() and has("LEVER_FORTRESS_PRE_MAIN_GATE") and has("LEVER_FORTRESS_STATUE"))
end

function FortressCentralAccess()
  return FortressGateAccess() and has("LEVER_FORTRESS_MAIN_GATE") and has("LEVER_FORTRESS_BOMB") and has("bomb")
end

function FortressInnerAccess()
  return FortressCentralAccess() and has("LEVER_FORTRESS_NORTH_WEST")
end

function FortressWatchtowerAccess()
  return FloodedFortressFrontAccess() and has("LEVER_FORTRESS_WATCHTOWER_LOWER")
end

--THRONE ROOM REGIONS==============================================================================
function ThroneRoomAccess()
  return FortressInnerAccess() and has("LEVER_FORTRESS_BRIDGE")
    or has("THRONE_OF_THE_FROG_KING_DOOR")
end

--SAILOR CAVES REGIONS=============================================================================
function StrandedSailorCavesAccess()
  return (SteadhoneAccess() and has("fire"))
    or (PeakAccess() and has("fire") and has ("LEVER_CEMETERY_EXIT_TO_ESTATE"))
    or StrandedSailorAccess()
end

--SAILOR REGIONS===================================================================================
function StrandedSailorAccess()
  return has("STRANDED_SAILOR_DOOR")
    or (has("LEVER_LOCKSTONE_ENTRANCE") and has("bomb") and (has("CASTLE_LOCKSTONE_DOOR") or (has("CAMP_OF_THE_FREE_CROWS_DOOR") and has("hookshot"))))
    or (SteadhoneAccess() and has("fire"))
end

function StrandedSailorHookshot()
  return StrandedSailorAccess() and has("hookshot")
end

function StrandedSailorUpper()
  return (StrandedSailorAccess() and has("bomb"))
    or (has("LEVER_LOCKSTONE_ENTRANCE") and (has("CASTLE_LOCKSTONE_DOOR") or has("CAMP_OF_THE_FREE_CROWS_DOOR")))
end

--LOCKSTONE REGIONS================================================================================
function LockstoneCenterAccess()
  return (StrandedSailorAccess() and has("bomb") and has("LEVER_LOCKSTONE_ENTRANCE"))
    or has("CASTLE_LOCKSTONE_DOOR") 
    or (has("CAMP_OF_THE_FREE_CROWS_DOOR") and has("hookshot"))
end

function LockstoneExitElevator()
  return LockstoneCenterAccess() and has("fire") and has("hookshot")
    and has("LEVER_LOCKSTONE_TRACKING_BEAM_PUZZLE") and has("LEVER_LOCKSTONE_VERTICAL_LASER_PUZZLE") and has("LEVER_LOCKSTONE_DUAL_LASER_PUZZLE")
end

--CAMP REGIONS====================================================================================
function CampAccess()
  return (LockstoneExitElevator() and has("hookshot"))
    or has("CAMP_OF_THE_FREE_CROWS_DOOR")
end

--WATCHTOWERS REGIONS============================================================================
function WatchtowersDoorAccess()
  return (CampAccess() and has("PINK_KEY"))
    or has("OLD_WATCHTOWERS_DOOR")
end

function WatchtowersAccess()
  return WatchtowersDoorAccess() and has("hookshot")
end

function WatchtowersTwoAccess()
  return WatchtowersAccess() and has("LEVER_WATCHTOWERS_BEFORE_ICE_ARENA")
end

function WatchtowersArenaAccess()
  return (WatchtowersTwoAccess() and has("LEVER_WATCHTOWERS_AFTER_ICE_SKATING"))
    or has("BETTYS_LAIR_DOOR")
end
















