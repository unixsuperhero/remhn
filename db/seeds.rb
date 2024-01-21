# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# attr_names = %i[name size swamp desert forest]
# monster_data = {
#   great_jigras:    [ 'Great Jigras'   ,  :large ,  true  ,  true  ,  true],
#   kulu:            [ "Kulu-Ya-Ku"     ,  :large ,  true  ,  true  ,  true],
#   pukei:           [ "Pukei-Pukei"    ,  :large ,  true  ,  true  ,  true],
#   barroth:         [ "Barroth"        ,  :large ,  false ,  true  ,  true],
#   great_girros:    [ "Great Girros"   ,  :large ,  true  ,  false ,  true],
#   tobi:            [ "Tobi-Kadachi"   ,  :large ,  true  ,  false ,  true],
#   paolumu:         [ "Paolumu"        ,  :large ,  false ,  true  ,  true],
#   jyuratodus:      [ "Jyuratodus"     ,  :large ,  false ,  false ,  true],
#   anjanath:        [ "Anjanath"       ,  :large ,  true  ,  true  ,  false],
#   rathian:         [ "Rathian"        ,  :large ,  true  ,  true  ,  false],
#   pink_rathian:    [ "Pink Rathian"   ,  :large ,  true  ,  false ,  false],
#   legiana:         [ "Legiana"        ,  :large ,  false ,  false ,  true],
#   diablos:         [ "Diablos"        ,  :large ,  false ,  true  ,  false],
#   black_diablos:   [ "Black Diablos"  ,  :large ,  false ,  true  ,  false],
#   rathalos:        [ "Rathalos"       ,  :large ,  true  ,  false ,  false],
#   azure_rathalos:  [ "Azure Rathalos" ,  :large ,  true  ,  false ,  false],
#   radobaan:        [ "Radobaan"       ,  :large ,  false ,  true  ,  true],
#   banbaro:         [ "Banbaro"        ,  :large ,  true  ,  false ,  true],
#   barioth:         [ "Barioth"        ,  :large ,  true  ,  false ,  false],
#   zinogre:         [ "Zinogre"        ,  :large ,  true  ,  false ,  true],
# }
#
# monsters = monster_data.inject({}) do |h, (k, vs)|
#   attrs = attr_names.zip(vs).to_h
#   monster = :placeholder # Monster.create(attrs)
#   h.merge(k => monster)
# end

# attr_names = %i[name rarity forest swamp desert forest_outcrop swamp_outcrop desert_outcrop]
# item_data = {
#   iron_ore: [1, true, true, true, false, true, false],
#   monster_bone_s: [1, true, true, true, false, false, true],
#   fire_herb: [1, true, true, true, true, false, false],
#   flowfern: [1, true, true, true, true, false, false],
#
#   snow_herb: [1, true, true, true, true, false, false],
#   sleep_herb: [1, true, true, true, true, false, false],
#   parashroom: [1, true, true, true, true, false, false],
#   toadstool: [1, true, true, true, true, false, false],
#
#   thunderbug: [1, true, true, true, true, false, false],
#   godbug: [1, true, true, true, true, false, false],
#   sharp_claw: [1, false, false, false, false, false, false],
#   wingdrake_hide: [1, false, false, false, false, false, false],
#
#   great_jigras_scale: [1, false, false, false, false, false, false],
#   great_jigras_hide: [1, false, false, false, false, false, false],
#   kulu_ya_ku_scale: [1, false, false, false, false, false, false],
#   kulu_ya_ku_hide: [1, false, false, false, false, false, false],
#
#   pukei_pukei_scale: [1, false, false, false, false, false, false],
#   pukei_pukei_shell: [1, false, false, false, false, false, false],
#   barroth_shell: [1, false, false, false, false, false, false],
#   barroth_claw: [1, false, false, false, false, false, false],
#
#   great_girros_scale: [1, false, false, false, false, false, false],
#   great_girros_fang: [1, false, false, false, false, false, false],
#   tobi_kadachi_scale: [1, false, false, false, false, false, false],
#   tobi_kadachi_claw: [1, false, false, false, false, false, false],
#
#   paolumu_scale: [1, false, false, false, false, false, false],
#   paolumu_pelt: [1, false, false, false, false, false, false],
#   jyuratodus_shell: [1, false, false, false, false, false, false],
#   jyuratodus_scale: [1, false, false, false, false, false, false],
#
#   anjanath_scale: [1, false, false, false, false, false, false],
#   anjanath_fang: [1, false, false, false, false, false, false],
#   rathian_scale: [1, false, false, false, false, false, false],
#   rathian_shell: [1, false, false, false, false, false, false],
#
#   pink_rathian_scale: [1, false, false, false, false, false, false],
#   pink_rathian_shell: [1, false, false, false, false, false, false],
#   legiana_scale: [1, false, false, false, false, false, false],
#   legiana_hide: [1, false, false, false, false, false, false],
#
#   diablos_shell: [1, false, false, false, false, false, false],
#   diablos_fang: [1, false, false, false, false, false, false],
#   black_diablos_fang: [1, false, false, false, false, false, false],
#   black_diablos_shell: [1, false, false, false, false, false, false],
#
#   rathalos_scale: [1, false, false, false, false, false, false],
#   rathalos_shell: [1, false, false, false, false, false, false],
#   azure_rathalos_scale: [1, false, false, false, false, false, false],
#   azure_rathalos_wingtalon: [1, false, false, false, false, false, false],
#
#   radobaan_scale: [1, false, false, false, false, false, false],
#   radobaan_shell: [1, false, false, false, false, false, false],
#   banbaro_shell: [1, false, false, false, false, false, false],
#   banbaro_ridge: [1, false, false, false, false, false, false],
#
#   barioth_claw: [1, false, false, false, false, false, false],
#   barioth_shell: [1, false, false, false, false, false, false],
#   zinogre_claw: [1, false, false, false, false, false, false],
#   zinogre_shell: [1, false, false, false, false, false, false],
#
#   machalite_ore: [2, true, true, true, false, true, false],
#   monster_bone_m: [2, true, true, true, false, false, true],
#   great_jigras_claw: [2, false, false, false, false, false, false],
#   kulu_ya_ku_beak: [2, false, false, false, false, false, false],
#
#   pukei_pukei_tail: [2, false, false, false, false, false, false],
#   barroth_tail: [2, false, false, false, false, false, false],
#   great_girros_tail: [2, false, false, false, false, false, false],
#   tobi_kadachi_pelt: [2, false, false, false, false, false, false],
#
#   paolumu_webbing: [2, false, false, false, false, false, false],
#   jyuratodus_fang: [2, false, false, false, false, false, false],
#   rathian_webbing: [2, false, false, false, false, false, false],
#   pink_rathian_webbing: [2, false, false, false, false, false, false],
#
#   legiana_claw: [2, false, false, false, false, false, false],
#   diablos_tailcase: [2, false, false, false, false, false, false],
#   rathalos_tail: [2, false, false, false, false, false, false],
#   azure_rathalos_tail: [2, false, false, false, false, false, false],
#
#   radobaan_tail: [2, false, false, false, false, false, false],
#   banbaro_tail: [2, false, false, false, false, false, false],
#   barioth_tail: [2, false, false, false, false, false, false],
#   '2024_weapon_ticket': [2, false, false, false, false, false, false],
# }
#
# items = item_data.inject({}) do |h, (k, vs)|
#   attrs = attr_names.zip([k.to_s.titleize, *vs]).to_h
#   item = :item_placeholder # Item.create(attrs)
#   h.merge(k => item)
# end

monsters = {}

monster_names = {
  "alloy": "Alloy",
  "leather": "Leather",
  "g-jagr": "Great Jagras",
  "kulu": "Kulu-Ya-Ku",
  "puke": "Pukei-Pukei",
  "barr": "Barroth",
  "g-girr": "Great Girros",
  "tobi": "Tobi-Kadachi",
  "halloween": "Halloween",
  "paol": "Paolumu",
  "jyur": "Jyuratodus",
  "anja": "Anjanath",
  "rathi": "Rathian",
  "legi": "Legiana",
  "diab": "Diablos",
  "ratha": "Rathalos",
  "p-rathi": "Pink Rathian",
  "a-ratha": "Azure Rathalos",
  "b-diab": "Black Diablos",
  "rado": "Radobaan",
  "banb": "Banbaro",
  "bari": "Barioth",
  "zino": "Zinogre",
  "small-monster": "Small Monsters",
  "ore": "Ore",
  "bone": "Bone",
  "plant-bug": "Plant/Bug",
  "event": "Event",
  "rare": "Rare",
  "ny-24": "New Year"
}

{
  "g-jagr": {
    "biome": [ "forest", "desert", "swamp" ],
    "weakness": [ "fire" ],
    "poison": 3,
    "paralysis": 3,
    "stun": 3,
    "sleep": 3,
    "hp": {
      "5": 6450,
      "6": 10520,
      "7": 17560,
      "8": 32080,
      "9": 67780,
      "10": 139115
    },
    "raid-hp": {
      "4": 7900,
      "5": 13935,
      "6": 24665,
      "7": 41340
    },
    "physiology": {
      "head": [ 130, 135, 130, 1, [ "c", "e" ] ],
      "body": [ 90, 100, 70 ],
      "stomach": [ 140, 145, 140, 1 ],
      "forelegs": [ 120, 110, 90, 1, [ "b", "d", "f" ] ],
      "hindlegs": [ 100, 90, 70 ],
      "tail": [ 100, 90, 70 ]
    }
  },
  "kulu": {
    "biome": [ "forest", "desert", "swamp" ],
    "weakness": [ "water" ],
    "poison": 2,
    "paralysis": 3,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 6150,
      "6": 10040,
      "7": 16740,
      "8": 30580,
      "9": 64560,
      "10": 132480
    },
    "raid-hp": {
      "4": 7520,
      "5": 13270,
      "6": 23490,
      "7": 39370
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "b", "d", "f" ] ],
      "body": [ 90, 90, 70 ],
      "forelegs": [ 130, 135, 130, 1, [ "c", "e" ] ],
      "hindlegs": [ 90, 90, 70 ],
      "tail": [ 110, 110, 70 ],
      "rock": [ 10, 10, 10 ]
    }
  },
  "puke": {
    "biome": [ "forest", "desert", "swamp" ],
    "weakness": [ "thunder" ],
    "poison": 1,
    "paralysis": 3,
    "stun": 2,
    "sleep": 3,
    "hp": {
      "5": 6150,
      "6": 10040,
      "7": 16740,
      "8": 30580,
      "9": 64560,
      "10": 132480
    },
    "raid-hp": {
      "4": 7520,
      "5": 13270,
      "6": 23490,
      "7": 39370
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "c", "e" ] ],
      "back": [ 90, 100, 70, 1 ],
      "wings": [ 110, 110, 95, 1, [ "d" ] ],
      "legs": [ 100, 110, 80 ],
      "tail": [ 120, 110, 90, 2, [ "b", "f" ] ]
    }
  },
  "barr": {
    "biome": [ "desert", "swamp" ],
    "weakness": [ "fire" ],
    "poison": 3,
    "paralysis": 2,
    "stun": 1,
    "sleep": 2,
    "hp": {
      "5": 4300,
      "6": 7720,
      "7": 12680,
      "8": 23560,
      "9": 49950,
      "10": 99160
    },
    "raid-hp": {
      "4": 5265,
      "5": 9290,
      "6": 16440,
      "7": 27560
    },
    "physiology": {
      "head": [ 80, 110, 55, 3, [ "c", "d" ] ],
      "body": [ 100, 100, 80 ],
      "forelegs": [ 140, 145, 140, 1, [ "e" ] ],
      "hindlegs": [ 90, 100, 65, 1 ],
      "tail": [ 120, 100, 80, 2, [ "b", "f" ] ],
      "mud": [ 30 ],
      "water-mud": 1
    }
  },
  "g-girr": {
    "biome": [ "forest", "swamp" ],
    "weakness": [ "water" ],
    "poison": 2,
    "paralysis": 1,
    "stun": 2,
    "sleep": 3,
    "hp": {
      "5": 6150,
      "6": 11000,
      "7": 18150,
      "8": 33680,
      "9": 71340,
      "10": 141680
    },
    "raid-hp": {
      "4": 7520,
      "5": 13270,
      "6": 23490,
      "7": 39370
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "c", "e", "f" ] ],
      "body": [ 90, 100, 70 ],
      "forelegs": [ 110, 110, 90, 1, [ "d" ] ],
      "hindlegs": [ 100, 100, 80 ],
      "tail": [ 120, 110, 90, 2, [ "b" ] ]
    }
  },
  "tobi": {
    "biome": [ "forest", "swamp" ],
    "weakness": [ "water" ],
    "poison": 3,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 5850,
      "6": 10450,
      "7": 18680,
      "8": 31960,
      "9": 74240,
      "10": 143340
    },
    "raid-hp": {
      "4": 7145,
      "5": 12610,
      "6": 22315,
      "7": 37400
    },
    "physiology": {
      "head": [ 130, 135, 130, 1, [ "b" ] ],
      "body": [ 100, 110, 80 ],
      "back": [ 100, 100, 95, 1 ],
      "forelegs": [ 90, 90, 55, 1, [ "c", "d" ] ],
      "hindlegs": [ 90, 90, 55 ],
      "tail": [ 140, 140, 140, 1, [ "e", "f" ] ]
    }
  },
  "paol": {
    "biome": [ "desert", "swamp" ],
    "weakness": [ "fire" ],
    "poison": 2,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 6960,
      "6": 12330,
      "7": 19040,
      "8": 38600,
      "9": 74920,
      "10": 148760
    },
    "raid-hp": {
      "4": 7900,
      "5": 13935,
      "6": 24665,
      "7": 41340
    },
    "physiology": {
      "head": [ 130, 130, 95 ],
      "neck-pouch": [ 140, 140, 130, 1 ],
      "body": [ 100, 110, 80 ],
      "back": [ 100, 110, 80, 1 ],
      "wings": [ 100, 100, 130, 1, [ "b", "d" ] ],
      "legs": [ 80, 90, 55 ],
      "tail": [ 90, 80, 55, 1, [ "c", "e", "f" ] ]
    }
  },
  "jyur": {
    "biome": [ "swamp" ],
    "weakness": [ "thunder" ],
    "poison": 2,
    "paralysis": 2,
    "stun": 3,
    "sleep": 1,
    "hp": {
      "5": 4590,
      "6": 8200,
      "7": 13760,
      "8": 25720,
      "9": 54680,
      "10": 105600
    },
    "raid-hp": {
      "4": 5265,
      "5": 9290,
      "6": 16440,
      "7": 27560
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "b", "f" ] ],
      "neck": [ 110, 120, 90 ],
      "body": [ 100, 110, 80, 1, [ "c", "d" ] ],
      "back": [ 80, 90, 65 ],
      "fins": [ 80, 80, 95 ],
      "hindlegs": [ 90, 100, 70, 1 ],
      "tail": [ 135, 130, 130, 1, [ "e" ] ],
      "mud": [ 30 ],
      "water-mud": 1
    }
  },
  "anja": {
    "biome": [ "forest", "desert" ],
    "weakness": [ "water" ],
    "poison": 2,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 6960,
      "6": 12200,
      "7": 20800,
      "8": 39040,
      "9": 83240,
      "10": 156880
    },
    "raid-hp": {
      "5": 13965,
      "6": 24400,
      "7": 41650
    },
    "physiology": {
      "head": [ 130, 135, 130, 1, [ "c" ] ],
      "snout": [ 140, 140, 145 ],
      "neck": [ 90, 90, 65 ],
      "body": [ 90, 90, 80 ],
      "wings": [ 140, 110, 145 ],
      "hindlegs": [ 90, 100, 70, 1, [ "d" ] ],
      "tail": [ 130, 120, 95, 2, [ "b", "e", "f" ] ]
    }
  },
  "rathi": {
    "biome": [ "forest", "desert" ],
    "weakness": [ "thunder", "dragon" ],
    "poison": 1,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 6850,
      "6": 11920,
      "7": 20400,
      "8": 38240,
      "9": 81520,
      "10": 153640
    },
    "raid-hp": {
      "5": 13680,
      "6": 23905,
      "7": 40800
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "d" ] ],
      "body": [ 90, 100, 70 ],
      "back": [ 90, 100, 70, 1 ],
      "wings": [ 130, 130, 135, 1, [ "b" ] ],
      "legs": [ 90, 90, 70 ],
      "tail": [ 120, 110, 90, 2, [ "c", "e", "f" ] ],
      "tail-tip": [ 120, 120, 95 ]
    }
  },
  "p-rathi": {
    "biome": [ "forest" ],
    "weakness": [ "thunder", "dragon" ],
    "poison": 1,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 8120,
      "6": 13140,
      "7": 23000,
      "8": 42920,
      "9": 91720,
      "10": 169150
    },
    "raid-hp": {},
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "d" ] ],
      "body": [ 90, 100, 70 ],
      "back": [ 90, 100, 70, 1 ],
      "wings": [ 130, 130, 135, 1, [ "b" ] ],
      "legs": [ 90, 90, 70 ],
      "tail": [ 130, 120, 100, 2, [ "c", "e", "f" ] ],
      "tail-tip": [ 130, 130, 130 ]
    }
  },
  "legi": {
    "biome": [ "swamp" ],
    "weakness": [ "fire" ],
    "poison": 3,
    "poison-dmg": 2,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 7440,
      "6": 13590,
      "7": 23840,
      "8": 45080,
      "9": 96520,
      "10": 174880
    },
    "raid-hp": {
      "5": 13965,
      "6": 24400,
      "7": 41650,
      "8": 78105
    },
    "physiology": {
      "head": [ 140, 145, 140, 1 ],
      "body": [ 80, 90, 65 ],
      "back": [ 80, 90, 65, 1 ],
      "wings": [ 130, 130, 140, 1, [ "b", "c", "d", "f" ] ],
      "legs": [ 90, 100, 70 ],
      "tail": [ 120, 110, 90, 1, [ "e" ] ]
    }
  },
  "diab": {
    "biome": [ "desert" ],
    "weakness": [ "ice", "dragon" ],
    "poison": 2,
    "paralysis": 3,
    "stun": 1,
    "sleep": 2,
    "hp": {
      "5": 6840,
      "6": 12480,
      "7": 21920,
      "8": 41420,
      "9": 88670,
      "10": 160600
    },
    "raid-hp": {
      "5": 12825,
      "6": 22410,
      "7": 38250,
      "8": 71730
    },
    "physiology": {
      "head": [ 110, 135, 90 ],
      "horns": [ 80, 100, 65, 1, [ "f" ] ],
      "body": [ 140, 145, 90 ],
      "back": [ 80, 100, 65, 1, [ "c", "d", "e" ] ],
      "wings": [ 110, 90, 135 ],
      "legs": [ 100, 100, 80 ],
      "tail": [ 130, 80, 80, 2, [ "b", "e" ] ],
      "tail-tip": [ 80, 90, 55 ]
    }
  },
  "b-diab": {
    "biome": [ "desert" ],
    "weakness": [ "ice" ],
    "poison": 2,
    "paralysis": 3,
    "stun": 1,
    "sleep": 2,
    "hp": {
      "5": 9800,
      "6": 16000,
      "7": 29000,
      "8": 55250,
      "9": 112080,
      "10": 187660
    },
    "raid-hp": {},
    "physiology": {
      "head": [ 105, 130, 80 ],
      "horns": [ 75, 95, 60, 1, [ "f" ] ],
      "body": [ 135, 140, 85 ],
      "back": [ 75, 95, 60, 1, [ "c", "d", "e" ] ],
      "wings": [ 105, 85, 130 ],
      "legs": [ 95, 95, 75 ],
      "tail": [ 130, 75, 75, 2, [ "b", "e" ] ],
      "tail-tip": [ 75, 85, 50 ]
    }
  },
  "ratha": {
    "biome": [ "forest" ],
    "weakness": [ "thunder", "dragon" ],
    "poison": 1,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 8150,
      "6": 13160,
      "7": 23120,
      "8": 43720,
      "9": 93600,
      "10": 169520
    },
    "raid-hp": {
      "5": 13540,
      "6": 23655,
      "7": 40375,
      "8": 75715
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "d" ] ],
      "body": [ 90, 100, 70 ],
      "back": [ 90, 100, 70, 1, [ "c" ] ],
      "wings": [ 130, 130, 135, 1 ],
      "legs": [ 90, 90, 70 ],
      "tail": [ 120, 110, 90, 2, [ "b", "c", "e", "f" ] ],
      "tail-tip": [ 120, 120, 95 ]
    }
  },
  "a-ratha": {
    "biome": [ "forest" ],
    "weakness": [ "ice", "dragon" ],
    "poison": 1,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 9000,
      "6": 14580,
      "7": 25870,
      "8": 49020,
      "9": 105300,
      "10": 190150
    },
    "raid-hp": {},
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "d" ] ],
      "body": [ 90, 100, 70 ],
      "back": [ 90, 100, 70, 1, [ "c" ] ],
      "wings": [ 130, 130, 135, 1 ],
      "legs": [ 80, 80, 65 ],
      "tail": [ 110, 100, 80, 2, [ "b", "c", "e", "f" ] ],
      "tail-tip": [ 140, 135, 135 ]
    }
  },
  "rado": {
    "biome": [ "desert", "swamp" ],
    "weakness": [ "ice", "dragon" ],
    "poison": 3,
    "paralysis": 2,
    "stun": 1,
    "sleep": 2,
    "hp": {
      "5": 5840,
      "6": 10440,
      "7": 17200,
      "8": 31940,
      "9": 67760,
      "10": 134600
    },
    "raid-hp": {
      "4": 7145,
      "5": 12610,
      "6": 22315,
      "7": 37400,
      "8": 75715
    },
    "physiology": {
      "head": [ 70, 100, 55, 1, [ "c", "f" ] ],
      "*head": [ 140, 145, 140 ],
      "neck": [ 90, 90, 70 ],
      "body": [ 70, 90, 55, 1, [ "e" ] ],
      "*body": [ 125, 130, 95 ],
      "hindlegs": [ 70, 90, 55, 1, [ "d" ] ],
      "*hindlegs": [ 130, 125, 130 ],
      "tail": [ 120, 110, 90, 2, [ "b" ] ]
    }
  },
  "banb": {
    "biome": [ "forest", "swamp" ],
    "weakness": [ "fire", "dragon" ],
    "poison": 2,
    "paralysis": 2,
    "stun": 1,
    "sleep": 2,
    "hp": {
      "5": 4280,
      "6": 7600,
      "7": 11760,
      "8": 23880,
      "9": 46360,
      "10": 92080
    },
    "raid-hp": {
      "4": 4890,
      "5": 8625,
      "6": 15270,
      "7": 25590
    },
    "physiology": {
      "horns": [ 80, 100, 65, 1, [ "e", "f" ] ],
      "head": [ 140, 145, 140 ],
      "neck": [ 90, 100, 70 ],
      "body": [ 80, 90, 65 ],
      "hindlegs": [ 90, 100, 70, 1, [ "d" ] ],
      "*hindlegs": [ 130, 135, 130 ],
      "tail": [ 100, 80, 65, 2, [ "b", "c" ] ]
    }
  },
  "bari": {
    "biome": [ "forest" ],
    "weakness": [ "fire" ],
    "poison": 2,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 6240,
      "6": 10920,
      "7": 18680,
      "8": 35040,
      "9": 74720,
      "10": 140840
    },
    "raid-hp": {
      "5": 12540,
      "6": 21910,
      "7": 37400,
      "8": 70135
    },
    "physiology": {
      "head": [ 140, 145, 140, 1, [ "e" ] ],
      "body": [ 100, 110, 80 ],
      "back": [ 100, 110, 80 ],
      "wings": [ 110, 135, 80 ],
      "spikes": [ 130, 135, 130, 1, [ "c", "d" ] ],
      "hindlegs": [ 90, 100, 70 ],
      "tail": [ 130, 90, 130, 2, [ "b", "f" ] ],
      "tail-tip": [ 145, 130, 130 ]
    }
  },
  "zino": {
    "biome": [ "forest", "swamp" ],
    "weakness": [ "ice" ],
    "poison": 2,
    "paralysis": 2,
    "stun": 2,
    "sleep": 2,
    "hp": {
      "5": 7480
    },
    "raid-hp": {
      "5": 14960,
      "6": 26145,
      "7": 44625,
      "8": 83685
    },
    "physiology": {
      "horns": [ 130, 135, 130, 1, [ "e" ] ],
      "+horns": [ 140, 145, 140 ],
      "neck": [ 110, 110, 90 ],
      "+neck": [ 120, 120, 100 ],
      "body": [ 90, 100, 70 ],
      "+body": [ 80, 90, 65 ],
      "back": [ 80, 90, 65, 1, [ "c" ] ],
      "+back": [ 90, 100, 70 ],
      "forelegs": [ 110, 120, 90, 1, [ "d" ] ],
      "+forelegs": [ 120, 130, 95 ],
      "hindlegs": [ 90, 100, 70 ],
      "+hindlegs": [ 80, 90, 65 ],
      "tail": [ 120, 110, 90, 2, [ "b", "f" ] ],
      "+tail": [ 130, 120, 95 ]
    }
  }
}.each do |key, info|
  name = monster_names[key]

  defaults = {
    size: :large,
    swamp: false,
    desert: false,
    forest: false,
    fire_weak: false,
    water_weak: false,
    thunder_weak: false,
    dragon_weak: false,
    ice_weak: false,
    poison: 1,
    paralysis: 1,
    stun: 1,
    sleep: 1,
  }

  flags = info[:biome].zip Array.new(info[:biome].length, true)
  weak_keys = info[:weakness].map { |w|
    [w, :weak].join(?_)
  }
  weaknesses = weak_keys.zip Array.new(info[:weakness].length, true)
  attrs = {
    name: name,
    **defaults,
    **flags.to_h.symbolize_keys,
    **weaknesses.to_h.symbolize_keys,
    poison: info[:poison],
    paralysis: info[:paralysis],
    stun: info[:stun],
    sleep: info[:sleep],
  }

  monster = Monster.create(attrs)
  monsters[key] = monster
end

skill_data = [
  "Fire Attack",
  "Water Attack",
  "Ice Attack",
  "Thunder Attack",
  "Dragon Attack",
  "Poison Attack",
  "Paralysis Attack",
  "Sleep Attack",
  "Lock On",
  "Critical Eye",
  "Weakness Exploit",
  "Critical Boost",
  "Attack Boost",
  "Burst",
  "Skyward Striker",
  "Focus",
  "Peak Performance",
  "Divine Blessing",
  "Health Boost",
  "Rising Tide",
  "Guard",
  "Offensive Guard",
  "Evade ExtenderUP",
  "Artful Dodger",
  "Reload Speed",
  "Recoil Down",
  "Concentration",
  "Special Boost",
  "Evasive Concentration",
  "Windproof",
  "Tremor Resistance",
  "Earplugs",
  "Sneak Attack",
  "Fortify",
  "Resentment",
  "Guts",
  "Heroics",
  "Slugger",
  "Partbreaker"
]

skills = skill_data.map { |name|
  [name, Skill.create(name: name)]
}.to_h

forgables = {
    "alloy": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "lance" ],
    "bone": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "lance" ],
    "leather": [ "armor" ],
    "g-jagr": [ "shield-sword", "great-sword", "light-gun", "armor" ],
    "kulu": [ "hammer", "long-sword", "bow", "dual-blades", "lance", "armor" ],
    "puke": [ "shield-sword", "great-sword", "hammer", "bow", "lance", "armor" ],
    "barr": [ "shield-sword", "great-sword", "hammer", "light-gun", "lance", "armor" ],
    "g-girr": [ "shield-sword", "great-sword", "hammer", "armor" ],
    "tobi": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "lance", "armor" ],
    "paol": [ "shield-sword", "light-gun", "armor" ],
    "jyur": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "lance", "armor" ],
    "anja": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "armor" ],
    "rathi": [ "shield-sword", "long-sword", "bow", "armor" ],
    "legi": [ "shield-sword", "great-sword", "long-sword", "light-gun", "bow", "dual-blades", "lance", "armor" ],
    "diab": [ "hammer", "bow", "dual-blades", "armor" ],
    "ratha": [ "shield-sword", "great-sword", "long-sword", "light-gun", "bow", "lance", "armor" ],
    "b-diab": [ "hammer", "bow", "dual-blades", "armor" ],
    "p-rathi": [ "shield-sword", "long-sword", "bow", "armor" ],
    "a-ratha": [ "shield-sword", "great-sword", "long-sword", "light-gun", "bow", "lance", "armor" ],
    "rado": [ "shield-sword", "great-sword", "hammer", "armor" ],
    "banb": [ "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "armor" ],
    "bari": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "lance", "armor" ],
    "zino": [ "shield-sword", "great-sword", "hammer", "long-sword", "light-gun", "bow", "dual-blades", "lance", "armor" ],
    "halloween": [ "helm" ],
    "ny-24": [ "helm" ]
}
equipment_skills = {
  "alloy": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Poison Resistance",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "bone": {
    "weapon": [
      {
        "unlock": 4,
        "skill": "Concentration",
        "lv": 1
      }
    ]
  },
  "leather": {
    "noWeapon": 1,
    "helm": [
      {
        "unlock": 2,
        "skill": "Critical Eye",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Ice Resistance",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 2,
        "skill": "Attack Boost",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Fire Resistance",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": 2,
        "skill": "Defense Boost",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Thunder Resistance",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": 2,
        "skill": "Health Boost",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Water Resistance",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 2,
        "skill": "Poison Resistance",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Paralysis Resistance",
        "lv": 1
      }
    ]
  },
  "g-jagr": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Health Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Firm Foothold",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Rising Tide",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": 2,
        "skill": "Firm Foothold",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Water Attack",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Fortify",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 4,
        "skill": "Rising Tide",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Water Attack",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "kulu": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Fortify",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": 2,
        "skill": "Lock On",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Critical Eye",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Guts",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": 2,
        "skill": "Last Stand",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Critical Eye",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": 2,
        "skill": "Last Stand",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Evade ExtenderUP",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Critical Eye",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "puke": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Sneak Attack",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 2,
        "skill": "Focus",
        "lv": 1
      },
      {
        "unlock": [ 4, 6 ],
        "skill": "Health Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": 2,
        "skill": "Poison Resistance",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Focus",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": 2,
        "skill": "Poison Attack",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Poison Resistance",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Poison Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": 2,
        "skill": "Health Boost",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Poison Resistance",
        "lv": 1
      }
    ]
  },
  "barr": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Defense Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": 2,
        "skill": "Defense Boost",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Offensive Guard",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Offensive Guard",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Guard",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 2,
        "skill": "Defense Boost",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Guard",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 2,
        "skill": "Recoil Down",
        "lv": 1
      },
      {
        "unlock": [ 4, 6 ],
        "skill": "Defense Boost",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "g-girr": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Sneak Attack",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": [ 2, 4 ],
        "skill": "Paralysis Resistance",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": 2,
        "skill": "Paralysis Resistance",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Sneak Attack",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": 2,
        "skill": "Sneak Attack",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Earplugs",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": 2,
        "skill": "Paralysis Attack",
        "lv": 1
      },
      {
        "unlock": [ 4, 6 ],
        "skill": "Earplugs",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Paralysis Attack",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "tobi": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Evade ExtenderUP",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 2,
        "skill": "Reload Speed",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Artful Dodger",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 2,
        "skill": "Evade ExtenderUP",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Thunder Attack",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Evade ExtenderUP",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 4,
        "skill": "Artful Dodger",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Thunder Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": 2,
        "skill": "Artful Dodger",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Thunder Resistance",
        "lv": 1
      }
    ]
  },
  "paol": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Divine Blessing",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": 3,
        "skill": "Concentration",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Windproof",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Recoil Down",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Concentration",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 4,
        "skill": "Divine Blessing",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Divine Blessing",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Windproof",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "jyur": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Last Stand",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 3,
        "skill": "Water Resistance",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Last Stand",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 3,
        "skill": "Water Attack",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Last Stand",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Water Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": [ 3, 4 ],
        "skill": "Water Resistance",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Focus",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 4,
        "skill": "Last Stand",
        "lv": 1
      }
    ]
  },
  "anja": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Rising Tide",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 4,
        "skill": "Fire Attack",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Fire Resistance",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 4, 6 ],
        "skill": "Special Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": [ 4, 6 ],
        "skill": "Fire Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 4,
        "skill": "Fire Resistance",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Special Boost",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": [ 4, 6 ],
        "skill": "Peak Performance",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "rathi": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Health Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": 4,
        "skill": "Health Boost",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Poison Attack",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 4, 6 ],
        "skill": "Poison Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": 4,
        "skill": "Lock On",
        "lv": 1
      },
      {
        "unlock": [ 4, 6 ],
        "skill": "Burst",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 4,
        "skill": "Poison Resistance",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Burst",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": [ 4, 6 ],
        "skill": "Health Boost",
        "lv": [ 1, 2 ]
      }
    ]
  },
  "legi": {
    "weapon": [
      {
        "unlock": [ 5, 8 ],
        "skill": "Divine Blessing",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": 5,
        "skill": "Divine Blessing",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Ice Attack",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 5,
        "skill": "Divine Blessing",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Windproof",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Reload Speed",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 5,
        "skill": "Ice Attack",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Windproof",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Reload Speed",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Ice Resistance",
        "lv": 1
      }
    ]
  },
  "diab": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Heroics",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Heroics",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": 5,
        "skill": "Slugger",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Heroics",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": 5,
        "skill": "Heroics",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Partbreaker",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": 5,
        "skill": "Partbreaker",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Offensive Guard",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Slugger",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Partbreaker",
        "lv": 1
      }
    ]
  },
  "ratha": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Earplugs",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 5,
        "skill": "Attack Boost",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Fire Attack",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Weakness Exploit",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": 5,
        "skill": "Fire Resistance",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Attack Boost",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": 5,
        "skill": "Focus",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Fire Attack",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Fire Resistance",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Weakness Exploit",
        "lv": 1
      }
    ]
  },
  "b-diab": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Partbreaker",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 5,
        "skill": "Partbreaker",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Resentment",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 5,
        "skill": "Resentment",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Firm Foothold",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": 5,
        "skill": "Resentment",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Focus",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": 5,
        "skill": "Lock On",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Heroics",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Heroics",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Offensive Guard",
        "lv": 1
      }
    ]
  },
  "p-rathi": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Evade ExtenderUP",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 5,
        "skill": "Special Boost",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Windproof",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 5,
        "skill": "Dragon Attack",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Focus",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": 5,
        "skill": "Windproof",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Critical Eye",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Critical Eye",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Special Boost",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Dragon Attack",
        "lv": 1
      }
    ]
  },
  "a-ratha": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Special Boost",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Focus",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Earplugs",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 5,
        "skill": "Fire Attack",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Critical Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 5,
        "skill": "Special Boost",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Critical Boost",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Reload Speed",
        "lv": 2
      },
      {
        "unlock": 6,
        "skill": "Fire Attack",
        "lv": 1
      }
    ]
  },
  "halloween": {
    "noWeapon": 1,
    "helm": [
      {
        "unlock": 2,
        "skill": "Solidarity (Pumpkin Hunt)",
        "lv": 1
      }
    ]
  },
  "rado": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Defense Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Guard",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": 2,
        "skill": "Sleep Attack",
        "lv": 1
      },
      {
        "unlock": [ 4, 6 ],
        "skill": "Defense Boost",
        "lv": [ 1, 2 ]
      }
    ],
    "gloves": [
      {
        "unlock": 2,
        "skill": "Slugger",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Sleep Resistance",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 2, 6 ],
        "skill": "Sleep Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "greaves": [
      {
        "unlock": 2,
        "skill": "Sleep Resistance",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Guard",
        "lv": 1
      }
    ]
  },
  "banb": {
    "weapon": [
      {
        "unlock": [ 4, 8 ],
        "skill": "Firm Foothold",
        "lv": [ 1, 2 ]
      }
    ],
    "helm": [
      {
        "unlock": 3,
        "skill": "Tremor Resistance",
        "lv": 1
      },
      {
        "unlock": 4,
        "skill": "Recoil Down",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": 3,
        "skill": "Concentration",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Partbreaker",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Offensive Guard",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 4,
        "skill": "Tremor Resistance",
        "lv": 1
      }
    ],
    "belt": [
      {
        "unlock": [ 3, 6 ],
        "skill": "Attack Boost",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 4,
        "skill": "Firm Foothold",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 3,
        "skill": "Divine Blessing",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Concentration",
        "lv": 1
      }
    ]
  },
  "bari": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Evade ExtenderUP",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 4,
        "skill": "Evade ExtenderUP",
        "lv": 1
      },
      {
        "unlock": [ 4, 6 ],
        "skill": "Skyward Striker",
        "lv": [ 1, 2 ]
      }
    ],
    "mail": [
      {
        "unlock": 4,
        "skill": "Ice Resistance",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Ice Attack",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 4, 6 ],
        "skill": "Ice Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 4,
        "skill": "Skyward Striker",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Ice Resistance",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 4,
        "skill": "Sneak Attack",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Evade ExtenderUP",
        "lv": 1
      }
    ]
  },
  "zino": {
    "weapon": [
      {
        "unlock": 8,
        "skill": "Artful Dodger",
        "lv": 1
      }
    ],
    "helm": [
      {
        "unlock": 5,
        "skill": "Evasive Concentration",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Burst",
        "lv": 1
      }
    ],
    "mail": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Evasive Concentration",
        "lv": [ 1, 2 ]
      },
      {
        "unlock": 5,
        "skill": "Thunder Resistance",
        "lv": 1
      }
    ],
    "gloves": [
      {
        "unlock": [ 5, 6 ],
        "skill": "Thunder Attack",
        "lv": [ 1, 2 ]
      }
    ],
    "belt": [
      {
        "unlock": 5,
        "skill": "Artful Dodger",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Reload Speed",
        "lv": 1
      }
    ],
    "greaves": [
      {
        "unlock": 5,
        "skill": "Burst",
        "lv": 1
      },
      {
        "unlock": 6,
        "skill": "Thunder Attack",
        "lv": 1
      }
    ]
  },
  "ny-24": {
    "noWeapon": 1,
    "helm": [
      {
        "unlock": 4,
        "skill": "Happy New Year (2024)",
        "lv": 1
      }
    ]
  }
}.each do |name, equips|
  monster = monsters[name]
  next if monster.nil?

  equipables = []
  equips.each do |k, data|
    if k == :weapon
      w = equips[:weapon]
      cforg = forgables[name] - ['armor']
      cforg2 = cforg.map do |forg|
        x = Equipable.create(
          monster: monster,
          group: :weapon,
          subgroup: forg.gsub(/-/, ?_).to_sym,
        )
        equipables << x
      end
    else
      x = Equipable.create(
        monster: monster,
        group: :armor,
        subgroup: k,
      )
      equipables << x
    end
  end
end


binding.pry
