
const areas=["forest","desert","swamp"];

const z4={
    "Ice Resistance":["Decreases damage from ice-element monster by 10%.","Decreases damage from ice-element monster by 20%.","Decreases damage from ice-element monster by 30%.","Decreases damage from ice-element monster by 40%.","Decreases damage from ice-element monster by 50%."],
    "Fire Resistance":["Decreases damage from fire-element monster by 10%.","Decreases damage from fire-element monster by 20%.","Decreases damage from fire-element monster by 30%.","Decreases damage from fire-element monster by 40%.","Decreases damage from fire-element monster by 50%."],
    "Thunder Resistance":["Decreases damage from thunder-element monster by 10%.","Decreases damage from thunder-element monster by 20%.","Decreases damage from thunder-element monster by 30%.","Decreases damage from thunder-element monster by 40%.","Decreases damage from thunder-element monster by 50%."],
    "Water Resistance":["Decreases damage from water-element monster by 10%.","Decreases damage from water-element monster by 20%.","Decreases damage from water-element monster by 30%.","Decreases damage from water-element monster by 40%.","Decreases damage from water-element monster by 50%."],
    "Paralysis Resistance":["Grants a 20% chance of preventing paralysis status when damaged by a paralysis-element attack.","Grants a 40% chance of preventing paralysis status when damaged by a paralysis-element attack.","Grants a 60% chance of preventing paralysis status when damaged by a paralysis-element attack.","Grants a 80% chance of preventing paralysis status when damaged by a paralysis-element attack.","Prevents paralysis."],
    "Poison Resistance":["Grants a 20% chance of preventing poison status when damaged by a poison-element attack.","Grants a 40% chance of preventing poison status when damaged by a poison-element attack.","Grants a 60% chance of preventing poison status when damaged by a poison-element attack.","Grants a 80% chance of preventing poison status when damaged by a poison-element attack.","Prevents poisoning."],
    "Fire Attack":["Increases weapon's fire-element value by 50.","Increases weapon's fire-element value by 100.","Increases weapon's fire-element value by 200.","Increases weapon's fire-element value by 350.","Increases weapon's fire-element value by 500."],
    "Water Attack":["Increases weapon's water-element value by 50.","Increases weapon's water-element value by 100.","Increases weapon's water-element value by 200.","Increases weapon's water-element value by 350.","Increases weapon's water-element value by 500."],
    "Ice Attack":["Increases weapon's ice-element value by 50.","Increases weapon's ice-element value by 100.","Increases weapon's ice-element value by 200.","Increases weapon's ice-element value by 350.","Increases weapon's ice-element value by 500."],
    "Thunder Attack":["Increases weapon's thunder-element value by 50.","Increases weapon's thunder-element value by 100.","Increases weapon's thunder-element value by 200.","Increases weapon's thunder-element value by 350.","Increases weapon's thunder-element value by 500."],
    "Dragon Attack":["Increases weapon's dragon-element value by 50.","Increases weapon's dragon-element value by 100.","Increases weapon's dragon-element value by 200.","Increases weapon's dragon-element value by 350.","Increases weapon's dragon-element value by 500."],
    "Poison Attack":["Increases weapon's poison buildup value by 50.","Increases weapon's poison buildup value by 75.","Increases weapon's poison buildup value by 100.","Increases weapon's poison buildup value by 125.","Increases weapon's poison buildup value by 150."],
    "Paralysis Attack":["Increases weapon's paralysis buildup value by 50.","Increases weapon's paralysis buildup value by 75.","Increases weapon's paralysis buildup value by 100.","Increases weapon's paralysis buildup value by 125.","Increases weapon's paralysis buildup value by 150."],
    "Fortify":["Increases attack power by 10% for 10 seconds each time you revive after fainting during a hunt.","Increases attack power by 15% for 10 seconds each time you revive after fainting during a hunt.","Increases attack power by 20% for 10 seconds each time you revive after fainting during a hunt.","Increases attack power by 30% for 10 seconds each time you revive after fainting during a hunt.","Increases attack power by 40% for 10 seconds each time you revive after fainting during a hunt."],
    "Critical Eye":["Increases affinity by 10%.","Increases affinity by 15%.","Increases affinity by 20%.","Increases affinity by 30%.","Increases affinity by 40%."],
    "Attack Boost":["Increases attack power by 20.","Increases attack power by 40.","Increases attack power by 60.","Increases attack power by 80.","Increases attack power by 120."],
    "Defense Boost":["Increases defense by 20.","Increases defense by 40.","Increases defense by 60.","Increases defense by 80.","Increases defense by 100."],
    "Health Boost":["Increases health by 10.","Increases health by 20.","Increases health by 30.","Increases health by 40.","Increases health by 50."],
    "Firm Foothold":["Very slightly reduces knockback when taking damage.","Slightly reduces knockback when taking damage.","Moderately reduces knockback when taking damage."],
    "Rising Tide":["Very slightly increases attack power and defense as the hunt timer runs out.","Slightly increases attack power and defense as the hunt timer runs out.","Moderately increases attack power and defense as the hunt timer runs out.","Greatly increases attack power and defense as the hunt timer runs out.","Massively increases attack power and defense as the hunt timer runs out."],
    "Lock On":["Displays a lock-on button while hunting with a close-range weapon, allowing a specific monster body part to be targeted."],
    "Guts":["Up to 1 time(s) per hunt, survive lethal damage taken at 80 health or above.","Up to 1 time(s) per hunt, survive lethal damage taken at 70 health or above.","Up to 1 time(s) per hunt, survive lethal damage taken at 60 health or above.","Up to 1 time(s) per hunt, survive lethal damage taken at 50 health or above.","Up to 1 time(s) per hunt, survive lethal damage taken at 40 health or above."],
    "Last Stand":["Increases defense by 50 when your health drops to 29% or lower.","Increases defense by 100 when your health drops to 29% or lower.","Increases defense by 150 when your health drops to 29% or lower.","Increases defense by 200 when your health drops to 29% or lower.","Increases defense by 300 when your health drops to 29% or lower."],
    "Evade ExtenderUP":["Very slightly extends evasion distance.","Slightly extends evasion distance.","Moderately extends evasion distance.","Greatly extends evasion distance.","Massively extends evasion distance."],
    "Offensive Guard":["Increases attack power by 10% for 10 seconds after executing a well-timed guard.","Increases attack power by 15% for 10 seconds after executing a well-timed guard.","Increases attack power by 20% for 10 seconds after executing a well-timed guard.","Increases attack power by 30% for 10 seconds after executing a well-timed guard.","Increases attack power by 40% for 10 seconds after executing a well-timed guard."],
    "Focus":["Shortens charging time for weapons with charge attacks by 5%, and increases the fill rate of the Spirit Gauge by 5%.","Shortens charging time for weapons with charge attacks by 10%, and increases the fill rate of the Spirit Gauge by 10%.","Shortens charging time for weapons with charge attacks by 15%, and increases the fill rate of the Spirit Gauge by 15%.","Shortens charging time for weapons with charge attacks by 20%, and increases the fill rate of the Spirit Gauge by 20%.","Shortens charging time for weapons with charge attacks by 30%, and increases the fill rate of the Spirit Gauge by 30%."],
    "Guard":["Very slightly reduces damage and knockback when guarding against monster attacks.","Slightly reduces damage and knockback when guarding against monster attacks.","Moderately reduces damage and knockback when guarding against monster attacks.","Greatly reduces damage and knockback when guarding against monster attacks.","Massively reduces damage and knockback when guarding against monster attacks."],
    "Recoil Down":["Slightly reduces bowgun recoil.","Moderately reduces bowgun recoil.","Greatly reduces bowgun recoil."],
    "Sneak Attack":["Increases damage by 10% when attacking a monster from behind.","Increases damage by 15% when attacking a monster from behind.","Increases damage by 20% when attacking a monster from behind.","Increases damage by 25% when attacking a monster from behind.","Increases damage by 30% when attacking a monster from behind."],
    "Earplugs":["Slightly reduces the effects of weak monster roars.","Moderately reduces the effects of weak monster roars.","Nullified the effects of weak monster roars, and slightly reduces the effects of strong monster roars.","Nullified the effects of weak monster roars, and moderately reduces the effects of strong monster roars.","Nullified the effects of both weak and strong monster roars."],
    "Reload Speed":["Slightly reduces reload time for bowguns.","Moderately reduces reload time for bowguns.","Greatly reduces reload time for bowguns."],
    "Artful Dodger":["Makes perfect evades ever so slightly easier to perform.","Makes perfect evades slightly easier to perform.","Makes perfect evades moderately easier to perform.","Makes perfect evades much easier to perform.","Makes perfect evades significantly easier to perform."],
    "Concentration":["Increases Special Gauge fill rate by 5%.","Increases Special Gauge fill rate by 10%.","Increases Special Gauge fill rate by 15%.","Increases Special Gauge fill rate by 20%.","Increases Special Gauge fill rate by 30%."],
    "Special Boost":["Increases the damage of Special Skills by 10%.","Increases the damage of Special Skills by 15%.","Increases the damage of Special Skills by 20%.","Increases the damage of Special Skills by 25%.","Increases the damage of Special Skills by 30%."],
    "Windproof":["Slightly reduces the effects of minor wind pressure.","Reduces the effects of minor wind pressure.","Negates minor wind pressure and slightly reduces the effects of major wind pressure.","Negates minor wind pressure and reduces the effects of major wind pressure.","Negates minor and major wind pressure."],
    "Peak Performance":["Increases attack power by 30 when your health is full.","Increases attack power by 60 when your health is full.","Increases attack power by 90 when your health is full.","Increases attack power by 130 when your health is full.","Increases attack power by 180 when your health is full."],
    "Divine Blessing":["30% chance of reducing damage from a monster's attack by 50%.","40% chance of reducing damage from a monster's attack by 50%.","50% chance of reducing damage from a monster's attack by 50%.","50% chance of reducing damage from a monster's attack by 60%.","50% chance of reducing damage from a monster's attack by 80%."],
    "Burst":["Landing consecutive hits in a short span of time increases attack power by 5% for 4 seconds.","Landing consecutive hits in a short span of time increases attack power by 10% for 4 seconds.","Landing consecutive hits in a short span of time increases attack power by 15% for 4 seconds.","Landing consecutive hits in a short span of time increases attack power by 20% for 4 seconds.","Landing consecutive hits in a short span of time increases attack power by 30% for 4 seconds."],
    "Heroics":["Increases attack power by 10% when your health drops to 29% or lower.","Increases attack power by 20% when your health drops to 29% or lower.","Increases attack power by 30% when your health drops to 29% or lower.","Increases attack power by 40% when your health drops to 29% or lower.","Increases attack power by 50% when your health drops to 29% or lower."],
    "Slugger":["Increases stun power by 10%.","Increases stun power by 15%.","Increases stun power by 20%.","Increases stun power by 25%.","Increases stun power by 30%."],
    "Partbreaker":["Increases part damage accumulated on breakable parts by 5%.","Increases part damage accumulated on breakable parts by 10%.","Increases part damage accumulated on breakable parts by 20%.","Increases part damage accumulated on breakable parts by 30%.","Increases part damage accumulated on breakable parts by 40%."],
    "Weakness Exploit":["Increases affinity by 20% when attacking a monster's weak spot.","Increases affinity by 25% when attacking a monster's weak spot.","Increases affinity by 30% when attacking a monster's weak spot.","Increases affinity by 40% when attacking a monster's weak spot.","Increases affinity by 50% when attacking a monster's weak spot."],
    "Resentment":["When taking damage, attack power is increased by 10% for 15 seconds.","When taking damage, attack power is increased by 15% for 15 seconds.","When taking damage, attack power is increased by 20% for 15 seconds.","When taking damage, attack power is increased by 25% for 15 seconds.","When taking damage, attack power is increased by 30% for 15 seconds."],
    "Solidarity (Pumpkin Hunt)":["Increases raw attack power by 1%. The effect is multiplied by the number of hunters who are wearing it in the team. *During the Halloween Pumpkin Hunt event, extra 5 times the effect."],
    "Critical Boost":["Increases the damage multiplier of critical hits to 130%.","Increases the damage multiplier of critical hits to 135%.","Increases the damage multiplier of critical hits to 140%.","Increases the damage multiplier of critical hits to 145%.","Increases the damage multiplier of critical hits to 150%."],
    "Sleep Resistance":["20% chance of preventing sleep status when damaged by a sleep-element attack.","40% chance of preventing sleep status when damaged by a sleep-element attack.","60% chance of preventing sleep status when damaged by a sleep-element attack.","80% chance of preventing sleep status when damaged by a sleep-element attack.","Prevents sleep status."],
    "Sleep Attack":["Increases weapon's sleep buildup value by 50.","Increases weapon's sleep buildup value by 75.","Increases weapon's sleep buildup value by 100.","Increases weapon's sleep buildup value by 125.","Increases weapon's sleep buildup value by 150."],
    "Evasive Concentration":["Fills Special Gauge by 7% after performing a perfect evade.","Fills Special Gauge by 10% after performing a perfect evade.","Fills Special Gauge by 12% after performing a perfect evade.","Fills Special Gauge by 15% after performing a perfect evade.","Fills Special Gauge by 20% after performing a perfect evade."],
    "Tremor Resistance":["Negates weak tremors.","Negates weak tremors and reduces the effects of strong tremors.","Negates weak and strong tremors."],
    "Skyward Striker":["Increases the damage of aerial attacks by 10%.","Increases the damage of aerial attacks by 15%.","Increases the damage of aerial attacks by 20%.","Increases the damage of aerial attacks by 25%.","Increases the damage of aerial attacks by 30%."],
    "Happy New Year (2024)":["No practical effect."]
  };

const elements=["fire","water","thunder","ice","dragon"];

const equipment_types=["weapon","helm","mail","gloves","belt","greaves"];

const weapons={
    "01": "shield-sword",
    "02": "great-sword",
    "03": "hammer",
    "04": "long-sword",
    "05": "light-gun",
    "06": "bow",
    "07": "dual-blades",
    "08": "lance"
  };

const skills=[
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
  ];

const compare_skills={
    "Attack Boost": [ 5 ],
    "Elemental Attack": [ 5 ],
    "Peak Performance": [ 5 ],
    "Rising Tide": [ 5 ],
    "Burst": [ 5, 95 ],
    "Sneak Attack": [ 5, 80 ],
    "Heroics": [ 5, 90 ],
    "Critical Eye": [ 5 ],
    "Weakness Exploit": [ 5, 85 ],
    "Critical Boost": [ 5 ],
    "Focus": [ 5 ],
    "Reload Speed": [ 3 ],
    "Recoil Down": [ 3 ],
    "Offensive Guard": [ 5, 85 ],
    "Resentment": [ 5, 85 ],
    "Partbreaker": [ 5, 0 ]
  };

const guide={
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
      "weakness": [ "fire" ], "poison": 3,
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
  };

const bow_set={
    "alloy": {
      "id": 14,
      "unlock": 1,
      "starter": 1,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "common-atk"
      },
      "ammo": [
        ["normal", 5],
        ["pierce", 4]
      ],
      "arrow": [
        ["rapid", 1],
        ["rapid", 2],
        ["rapid", 3],
        [ "rapid", 4 ]
      ]
    },
    "bone": {
      "id": 23,
      "unlock": 3,
      "evtOnly": 1,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "common-atk"
      },
      "ammo": [
        [ "normal", 5 ],
        [ "sticky", 2 ]
      ],
      "arrow": [
        [ "spread", 1 ],
        [ "spread", 2 ],
        [ "rapid", 3 ],
        [ "rapid", 4 ]
      ]
    },
    "leather": {
      "id": 0,
      "unlock": 1,
      "starter": 1
    },
    "g-jagr": {
      "id": 1,
      "unlock": 1,
      "eff": {
        "all": "water"
      },
      "water": {
        "base": "g-jagr-atk",
        "ele": "g-jagr-ele"
      },
      "ammo": [
        [ "water", 6 ],
        [ "slicing-water", 2 ]
      ]
    },
    "kulu": {
      "id": 2,
      "unlock": 1,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "common-atk",
        "crit": "common-crit"
      },
      "arrow": [
        [ "rapid", 1 ],
        [ "rapid", 2 ],
        [ "rapid", 3 ],
        [ "pierce", 4 ]
      ]
    },
    "puke": {
      "id": 3,
      "unlock": 1,
      "eff": {
        "all": "poison"
      },
      "poison": {
        "base": "common-atk",
        "ele": "common-ele"
      },
      "arrow": [
        [ "rapid", 1 ],
        [ "rapid", 2 ],
        [ "rapid", 3 ],
        [ "spread", 4 ]
      ],
      "bottle": "poison"
    },
    "barr": {
      "id": 4,
      "unlock": 1,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "barr-atk"
      },
      "ammo": [
        [ "normal", 4 ],
        [ "spread", 3 ]
      ]
    },
    "g-girr": {
      "id": 5,
      "unlock": 2,
      "eff": {
        "all": "paralysis"
      },
      "paralysis": {
        "base": "common-atk",
        "ele": "common-ele"
      }
    },
    "tobi": {
      "id": 6,
      "unlock": 2,
      "eff": {
        "all": "thunder"
      },
      "thunder": {
        "base": "tobi-atk",
        "ele": "tobi-ele"
      },
      "ammo": [
        [ "thunder", 5 ],
        [ "slicing-thunder", 3 ]
      ],
      "arrow": [
        [ "pierce", 1 ],
        [ "pierce", 2 ],
        [ "pierce", 3 ],
        [ "pierce", 4 ]
      ]
    },
    "paol": {
      "id": 7,
      "unlock": 3,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "paol-atk"
      },
      "ammo": [
        [ "normal", 5 ],
        [ "spread", 4 ],
        [ "pierce", 4 ]
      ]
    },
    "jyur": {
      "id": 8,
      "unlock": 3,
      "eff": {
        "all": "water"
      },
      "water": {
        "base": "tobi-atk",
        "ele": "tobi-ele"
      },
      "ammo": [
        [ "water", 5 ],
        [ "spread-water", 4 ],
        [ "sticky-water", 2 ]
      ],
      "arrow": [
        [ "spread", 1 ],
        [ "spread", 2 ],
        [ "rapid", 3 ],
        [ "rapid", 4 ]
      ]
    },
    "anja": {
      "id": 9,
      "unlock": 4,
      "eff": {
        "all": "fire"
      },
      "fire": {
        "base": "tobi-atk",
        "ele": "tobi-ele"
      },
      "ammo": [
        [ "fire", 6 ],
        [ "sticky-fire", 3 ]
      ],
      "arrow": [
        [ "spread", 1 ],
        [ "spread", 2 ],
        [ "spread", 3 ],
        [ "spread", 4 ]
      ]
    },
    "rathi": {
      "id": 10,
      "unlock": 4,
      "eff": {
        "all": "poison"
      },
      "poison": {
        "base": "rathi-atk",
        "ele": "rathi-ele"
      },
      "arrow": [
        [ "rapid", 1 ],
        [ "rapid", 2 ],
        [ "spread", 3 ],
        [ "spread", 4 ]
      ],
      "bottle": "poison"
    },
    "legi": {
      "id": 11,
      "unlock": 5,
      "eff": {
        "all": "ice"
      },
      "ice": {
        "base": "legi-atk",
        "ele": "legi-ele"
      },
      "ammo": [
        [ "ice", 5 ],
        [ "spread-ice", 4 ],
        [ "slicing-ice", 3 ]
      ],
      "arrow": [
        [ "pierce", 1 ],
        [ "pierce", 2 ],
        [ "rapid", 3 ],
        [ "rapid", 4 ]
      ]
    },
    "diab": {
      "id": 12,
      "unlock": 5,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "diab-atk"
      },
      "arrow": [
        [ "spread", 1 ],
        [ "rapid", 2 ],
        [ "spread", 3 ],
        [ "rapid", 4 ]
      ]
    },
    "ratha": {
      "id": 13,
      "unlock": 5,
      "eff": {
        "all": "fire"
      },
      "fire": {
        "base": "legi-atk",
        "ele": "legi-ele"
      },
      "ammo": [
        [ "fire", 5 ],
        [ "piercing-fire", 4 ],
        [ "slicing-fire", 3 ]
      ],
      "arrow": [
        [ "rapid", 1 ],
        [ "rapid", 2 ],
        [ "pierce", 3 ],
        [ "pierce", 4 ]
      ]
    },
    "p-rathi": {
      "id": 16,
      "unlock": 5,
      "eventOnly": 1,
      "eff": {
        "shield-sword": "poison",
        "long-sword": "poison",
        "bow": "dragon",
        "hammer": "dragon",
        "dual-blades": "dragon"
      },
      "poison": {
        "base": "p-rathi-atk",
        "ele": "p-rathi-ele"
      },
      "dragon": {
        "base": "tobi-atk",
        "ele": "tobi-ele"
      },
      "arrow": [
        [ "pierce", 2 ],
        [ "pierce", 3 ],
        [ "spread", 3 ],
        [ "spread", 4 ]
      ]
    },
    "b-diab": {
      "id": 15,
      "unlock": 5,
      "eventOnly": 1,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "b-diab-atk",
        "crit": "b-diab-crit"
      },
      "arrow": [
        [ "pierce", 1 ],
        [ "pierce", 1 ],
        [ "pierce", 4 ],
        [ "pierce", 4 ]
      ]
    },
    "a-ratha": {
      "id": 17,
      "unlock": 5,
      "eventOnly": 1,
      "eff": {
        "all": "fire"
      },
      "fire": {
        "base": "a-ratha-atk",
        "ele": "a-ratha-ele"
      },
      "ammo": [
        [ "fire", 5 ],
        [ "piercing-fire", 4 ],
        [ "sticky-fire", 2 ]
      ],
      "arrow": [
        [ "spread", 2 ],
        [ "spread", 3 ],
        [ "rapid", 3 ],
        [ "rapid", 4 ]
      ]
    },
    "zino": {
      "id": 19,
      "unlock": 5,
      "eventOnly": 1,
      "eff": {
        "all": "thunder"
      },
      "thunder": {
        "base": "legi-atk",
        "ele": "legi-ele"
      },
      "ammo": [
        [ "thunder", 5 ],
        [ "piercing-thunder", 4 ],
        [ "sticky-thunder", 2 ]
      ],
      "arrow": [
        [ "pierce", 1 ],
        [ "pierce", 2 ],
        [ "rapid", 3 ],
        [ "rapid", 4 ]
      ]
    },
    "bari": {
      "id": 20,
      "unlock": 4,
      "eff": {
        "all": "ice"
      },
      "ice": {
        "base": "bari-atk",
        "ele": "tobi-ele",
        "crit": "bari-crit"
      },
      "ammo": [
        [ "spread-ice", 3 ],
        [ "piercing-ice", 3 ]
      ],
      "arrow": [
        [ "rapid", 1 ],
        [ "rapid", 2 ],
        [ "spread", 3 ],
        [ "spread", 4 ]
      ]
    },
    "banb": {
      "id": 21,
      "unlock": 3,
      "eff": {
        "all": "white"
      },
      "white": {
        "base": "paol-atk"
      },
      "ammo": [
        [ "normal", 5 ],
        [ "spread", 4 ],
        [ "sticky", 2 ]
      ],
      "arrow": [
        [ "pierce", 1 ],
        [ "spread", 2 ],
        [ "pierce", 3 ],
        [ "spread", 4 ]
      ]
    },
    "rado": {
      "id": 22,
      "unlock": 2,
      "eff": {
        "all": "sleep"
      },
      "sleep": {
        "base": "common-atk",
        "ele": "common-ele"
      }
    },
    "halloween": {
      "id": 18,
      "evtOnly": 1,
      "unlock": 2
    },
    "ny-24": {
      "id": 24,
      "evtOnly": 1,
      "unlock": 4,
      "matUntil": [ 4, 5 ]
    }
  }

const equipment_skills={
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
  };

const cost_type={
    "1": {
      "1": [ "z", "a", "ha" ],
      "2": [ "z", "a", "j" ],
      "3": [ "z", "a", "b" ],
      "4": [ "z", "a", "j" ],
      "5": [ "z", "a", "ha" ]
    },
    "2": {
      "1": [ "z", "a", "c", "hb" ],
      "2": [ "z", "a", "j", "ha" ],
      "3": [ "z", "a", "b", "g" ],
      "4": [ "z", "a", "j", "ha" ],
      "5": [ "z", "a", "hc", "f" ]
    },
    "3": {
      "1": [ "z", "a", "c", "hb" ],
      "2": [ "z", "a", "j", "ha" ],
      "3": [ "z", "a", "b", "g" ],
      "4": [ "z", "a", "j", "ha" ],
      "5": [ "z", "a", "hc", "f" ]
    },
    "4": {
      "1": [ "z", "a", "c", "d", "hb" ],
      "2": [ "z", "a", "j", "ha" ],
      "3": [ "z", "a", "b", "g" ],
      "4": [ "z", "a", "j", "ha" ],
      "5": [ "z", "a", "hc", "f" ]
    },
    "5": {
      "1": [ "z", "a", "c", "d", "hb" ],
      "2": [ "z", "a", "j", "ha" ],
      "3": [ "z", "a", "b", "g" ],
      "4": [ "z", "a", "j", "ha" ],
      "5": [ "z", "a", "hc", "f" ]
    },
    "6": {
      "1": [ "z", "a", "d", "e", "k" ],
      "2": [ "z", "a", "j", "ha", "ib" ],
      "3": [ "z", "a", "b", "c", "g" ],
      "4": [ "z", "a", "j", "ha", "ic" ],
      "5": [ "z", "a", "hb", "hc", "f" ]
    },
    "7": {
      "1": [ "z", "a", "d", "e", "k" ],
      "2": [ "z", "a", "j", "ha", "ib" ],
      "3": [ "z", "a", "b", "c", "g" ],
      "4": [ "z", "a", "j", "ha", "ic" ],
      "5": [ "z", "a", "hb", "hc", "f" ]
    },
    "8": {
      "1": [ "z", "e", "l", "k" ],
      "2": [ "z", "b", "j", "ha", "id" ],
      "3": [ "z", "c", "l", "hb", "g" ],
      "4": [ "z", "d", "j", "ha", "ie" ],
      "5": [ "z", "a", "l", "hc", "f" ]
    },
    "9": {
      "1": [ "z", "e", "l", "k" ],
      "2": [ "z", "b", "j", "ha", "id" ],
      "3": [ "z", "c", "l", "hb", "g" ],
      "4": [ "z", "d", "j", "ha", "ie" ],
      "5": [ "z", "a", "l", "hc", "f" ]
    },
    "10": {
      "1": [ "z", "e", "l", "k" ],
      "2": [ "z", "b", "j", "ha", "id" ],
      "3": [ "z", "c", "l", "hb", "g" ],
      "4": [ "z", "d", "j", "ha", "ie" ],
      "5": [ "z", "a", "l", "hc", "f" ]
    }
  };

const level_0_cost_type={
    "1": {
      "1": [ "z", "ha" ],
      "2": [ "z", "ha" ],
      "3": [ "z", "ha" ],
      "4": [ "z", "ha" ],
      "5": [ "z", "ha" ]
    },
    "2": {
      "1": [ "z", "ha", "hb", "hc" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "3": {
      "1": [ "z", "ha", "hb", "hc" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "4": {
      "1": [ "z", "ha", "hb", "hc" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "5": {
      "1": [ "z", "ha", "hb", "hc" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "6": {
      "1": [ "z", "ha", "hb", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "7": {
      "1": [ "z", "ha", "hb", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "8": {
      "1": [ "z", "ha", "l", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "l", "g", "hb" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "l", "f" ]
    },
    "9": {
      "1": [ "z", "ha", "l", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "l", "g", "hb" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "l", "f" ]
    },
    "10": {
      "1": [ "z", "ha", "l", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "l", "g", "hb" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "l", "f" ]
    }
  };

const A5={
    "1": {
      "1": [ 10, 2, 2 ],
      "2": [ 20, 2, 2 ],
      "3": [ 30, 2, 1 ],
      "4": [ 40, 2, 2 ],
      "5": [ 50, 2, 2 ]
    },
    "2": {
      "1": [ 300, 3, 1, 1 ],
      "2": [ 100, 3, 4, 4 ],
      "3": [ 150, 3, 3, 3 ],
      "4": [ 200, 3, 4, 4 ],
      "5": [ 250, 3, 1, 3 ]
    },
    "3": {
      "1": [ 600, 5, 2, 3 ],
      "2": [ 200, 5, 12, 8 ],
      "3": [ 300, 5, 6, 5 ],
      "4": [ 400, 5, 12, 8 ],
      "5": [ 500, 5, 2, 6 ]
    },
    "4": {
      "1": [ 900, 8, 4, 2, 8 ],
      "2": [ 300, 8, 24, 16 ],
      "3": [ 450, 8, 9, 8 ],
      "4": [ 600, 8, 24, 16 ],
      "5": [ 750, 8, 3, 12 ]
    },
    "5": {
      "1": [ 1500, 12, 6, 4, 10 ],
      "2": [ 500, 12, 32, 24 ],
      "3": [ 750, 12, 12, 15 ],
      "4": [ 1000, 12, 32, 24 ],
      "5": [ 1250, 12, 4, 16 ]
    },
    "6": {
      "1": [ 3000, 18, 6, 2, 1 ],
      "2": [ 1000, 18, 44, 32, 4 ],
      "3": [ 1500, 18, 20, 15, 20 ],
      "4": [ 2000, 18, 44, 32, 4 ],
      "5": [ 2500, 18, 20, 7, 20 ]
    },
    "7": {
      "1": [ 6000, 24, 12, 3, 3 ],
      "2": [ 2000, 24, 51, 42, 6 ],
      "3": [ 3000, 24, 30, 20, 31 ],
      "4": [ 4000, 24, 51, 42, 6 ],
      "5": [ 5000, 24, 30, 11, 31 ]
    },
    "8": {
      "1": [ 12000, 5, 4, 5 ],
      "2": [ 4000, 40, 64, 53, 4 ],
      "3": [ 6000, 30, 4, 40, 41 ],
      "4": [ 8000, 20, 64, 53, 4 ],
      "5": [ 10000, 100, 4, 17, 41 ]
    },
    "9": {
      "1": [ 30000, 10, 6, 7 ],
      "2": [ 10000, 50, 73, 61, 6 ],
      "3": [ 15000, 40, 6, 49, 52 ],
      "4": [ 20000, 30, 73, 61, 6 ],
      "5": [ 25000, 200, 6, 21, 52 ]
    },
    "10": {
      "1": [ 75000, 20, 10, 9 ],
      "2": [ 25000, 60, 85, 73, 8 ],
      "3": [ 37500, 50, 20, 59, 63 ],
      "4": [ 50000, 40, 85, 73, 8 ],
      "5": [ 62500, 300, 30, 31, 63 ]
    }
  };

const T5={
    "1": {
      "1": [ 10, 2 ],
      "2": [ 20, 2 ],
      "3": [ 30, 2 ],
      "4": [ 40, 2 ],
      "5": [ 50, 2 ]
    },
    "2": {
      "1": [ 300, 6, 4, 2 ],
      "2": [ 100, 6, 4 ],
      "3": [ 150, 6, 3 ],
      "4": [ 200, 6, 4 ],
      "5": [ 250, 6, 10 ]
    },
    "3": {
      "1": [ 600, 12, 8, 5 ],
      "2": [ 200, 12, 12 ],
      "3": [ 300, 12, 5 ],
      "4": [ 400, 12, 12 ],
      "5": [ 500, 12, 15 ]
    },
    "4": {
      "1": [ 900, 18, 15, 10 ],
      "2": [ 300, 18, 24 ],
      "3": [ 450, 18, 8 ],
      "4": [ 600, 18, 24 ],
      "5": [ 750, 18, 20 ]
    },
    "5": {
      "1": [ 1500, 24, 20, 15 ],
      "2": [ 500, 24, 32 ],
      "3": [ 750, 24, 15 ],
      "4": [ 1000, 24, 32 ],
      "5": [ 1250, 24, 25 ]
    },
    "6": {
      "1": [ 3000, 30, 30, 20, 1 ],
      "2": [ 1000, 30, 44 ],
      "3": [ 1500, 30, 20 ],
      "4": [ 2000, 30, 44 ],
      "5": [ 2500, 30, 30 ]
    },
    "7": {
      "1": [ 6000, 40, 40, 30, 3 ],
      "2": [ 2000, 40, 50 ],
      "3": [ 3000, 40, 30 ],
      "4": [ 4000, 40, 50 ],
      "5": [ 5000, 40, 40 ]
    },
    "8": {
      "1": [ 12000, 50, 4, 40, 5 ],
      "2": [ 4000, 50, 60 ],
      "3": [ 6000, 50, 4, 40, 50 ],
      "4": [ 8000, 50, 60 ],
      "5": [ 10000, 100, 4, 50 ]
    },
    "9": {
      "1": [ 30000, 50, 6, 50, 7 ],
      "2": [ 10000, 50, 70 ],
      "3": [ 15000, 50, 6, 50, 60 ],
      "4": [ 20000, 50, 70 ],
      "5": [ 25000, 150, 6, 60 ]
    },
    "10": {
      "1": [ 75000, 50, 10, 60, 9 ],
      "2": [ 25000, 50, 80 ],
      "3": [ 37500, 50, 20, 60, 70 ],
      "4": [ 50000, 50, 80 ],
      "5": [ 62500, 200, 30, 70 ]
    }
  };

const R5={
    "1": [ 10, 2, 2 ],
    "2": [ 300, 3, 1, 1 ],
    "3": [ 600, 5, 2, 3 ],
    "4": [ 900, 4, 2, 2, 8 ],
    "5": [ 1500, 6, 2, 2, 10 ]
  };

const C5={
    "1": {
      "1": [ 10, 2, 2 ],
      "2": [ 20, 2, 2 ],
      "3": [ 30, 2, 1 ],
      "4": [ 40, 2, 2 ],
      "5": [ 50, 2, 2 ]
    },
    "2": {
      "1": [ 300, 2, 1, 1 ],
      "2": [ 100, 2, 4, 3 ],
      "3": [ 150, 2, 2, 2 ],
      "4": [ 200, 2, 4, 3 ],
      "5": [ 250, 2, 1, 2 ]
    },
    "3": {
      "1": [ 600, 4, 2, 2 ],
      "2": [ 200, 4, 9, 6 ],
      "3": [ 300, 4, 3, 4 ],
      "4": [ 400, 4, 9, 6 ],
      "5": [ 500, 4, 1, 4 ]
    },
    "4": {
      "1": [ 900, 6, 2, 2, 6 ],
      "2": [ 300, 6, 17, 11 ],
      "3": [ 450, 6, 5, 6 ],
      "4": [ 600, 6, 17, 11 ],
      "5": [ 750, 6, 2, 8 ]
    },
    "5": {
      "1": [ 1500, 8, 3, 3, 7 ],
      "2": [ 500, 8, 22, 17 ],
      "3": [ 750, 8, 6, 11 ],
      "4": [ 1000, 8, 22, 17 ],
      "5": [ 1250, 8, 3, 11 ]
    },
    "6": {
      "1": [ 3000, 13, 3, 2, 1 ],
      "2": [ 1000, 13, 31, 22, 2 ],
      "3": [ 1500, 13, 10, 8, 14 ],
      "4": [ 2000, 13, 31, 22, 2 ],
      "5": [ 2500, 13, 14, 5, 14 ]
    },
    "7": {
      "1": [ 6000, 17, 6, 2, 3 ],
      "2": [ 2000, 17, 36, 29, 3 ],
      "3": [ 3000, 17, 15, 10, 22 ],
      "4": [ 4000, 17, 36, 29, 3 ],
      "5": [ 5000, 17, 21, 8, 22 ]
    },
    "8": {
      "1": [ 12000, 3, 2, 5 ],
      "2": [ 4000, 20, 45, 37, 2 ],
      "3": [ 6000, 15, 2, 28, 29 ],
      "4": [ 8000, 10, 45, 37, 2 ],
      "5": [ 10000, 70, 2, 12, 29 ]
    },
    "9": {
      "1": [ 30000, 5, 3, 7 ],
      "2": [ 10000, 25, 51, 43, 3 ],
      "3": [ 15000, 20, 3, 34, 36 ],
      "4": [ 20000, 15, 51, 43, 3 ],
      "5": [ 25000, 140, 3, 15, 36 ]
    },
    "10": {
      "1": [ 75000, 10, 5, 9 ],
      "2": [ 25000, 30, 60, 51, 4 ],
      "3": [ 37500, 25, 10, 41, 44 ],
      "4": [ 50000, 20, 60, 51, 4 ],
      "5": [ 62500, 210, 15, 22, 44 ]
    }
  };

const E5={
    "1": {
      "1": [ 10, 2 ],
      "2": [ 20, 2 ],
      "3": [ 30, 2 ],
      "4": [ 40, 2 ],
      "5": [ 50, 2 ]
    },
    "2": {
      "1": [ 300, 4, 4, 2 ],
      "2": [ 100, 4, 4 ],
      "3": [ 150, 4, 3 ],
      "4": [ 200, 4, 4 ],
      "5": [ 250, 4, 10 ]
    },
    "3": {
      "1": [ 600, 8, 8, 4 ],
      "2": [ 200, 8, 12 ],
      "3": [ 300, 8, 5 ],
      "4": [ 400, 8, 12 ],
      "5": [ 500, 8, 15 ]
    },
    "4": {
      "1": [ 900, 13, 15, 6 ],
      "2": [ 300, 13, 24 ],
      "3": [ 450, 13, 8 ],
      "4": [ 600, 13, 24 ],
      "5": [ 750, 13, 20 ]
    },
    "5": {
      "1": [ 1500, 17, 20, 8 ],
      "2": [ 500, 17, 32 ],
      "3": [ 750, 17, 15 ],
      "4": [ 1000, 17, 32 ],
      "5": [ 1250, 17, 25 ]
    },
    "6": {
      "1": [ 3000, 21, 30, 15, 1 ],
      "2": [ 1000, 21, 44 ],
      "3": [ 1500, 21, 20 ],
      "4": [ 2000, 21, 44 ],
      "5": [ 2500, 21, 30 ]
    },
    "7": {
      "1": [ 6000, 28, 40, 20, 3 ],
      "2": [ 2000, 28, 50 ],
      "3": [ 3000, 28, 30 ],
      "4": [ 4000, 28, 50 ],
      "5": [ 5000, 28, 40 ]
    },
    "8": {
      "1": [ 12000, 35, 2, 30, 5 ],
      "2": [ 4000, 35, 60 ],
      "3": [ 6000, 35, 2, 40, 50 ],
      "4": [ 8000, 35, 60 ],
      "5": [ 10000, 70, 2, 50 ]
    },
    "9": {
      "1": [ 30000, 35, 3, 40, 7 ],
      "2": [ 10000, 35, 70 ],
      "3": [ 15000, 35, 3, 50, 60 ],
      "4": [ 20000, 35, 70 ],
      "5": [ 25000, 105, 3, 60 ]
    },
    "10": {
      "1": [ 75000, 35, 5, 50, 9 ],
      "2": [ 25000, 35, 80 ],
      "3": [ 37500, 35, 10, 60, 70 ],
      "4": [ 50000, 35, 80 ],
      "5": [ 62500, 140, 15, 70 ]
    }
  };

const S5={
    "1": [ 10, 2, 2 ],
    "2": [ 300, 2, 1, 1 ],
    "3": [ 600, 4, 2, 2 ],
    "4": [ 900, 3, 1, 2, 6 ],
    "5": [ 1500, 4, 2, 2, 7 ]
  };

const I5={
    "5": {
      "1": [ "z", "a", "c", "d", "hb" ],
      "2": [ "z", "a", "j", "ha" ],
      "3": [ "z", "a", "b", "g" ],
      "4": [ "z", "a", "j", "ha" ],
      "5": [ "z", "a", "hc", "f" ]
    },
    "6": {
      "1": [ "z", "a", "d", "e", "k" ],
      "2": [ "z", "a", "j", "ha", "ib" ],
      "3": [ "z", "a", "b", "c", "g" ],
      "4": [ "z", "a", "j", "ha", "ic" ],
      "5": [ "z", "a", "hb", "hc", "f" ]
    },
    "7": {
      "1": [ "z", "a", "d", "e", "k" ],
      "2": [ "z", "a", "j", "ha", "ib" ],
      "3": [ "z", "a", "b", "c", "g" ],
      "4": [ "z", "a", "j", "ha", "ic" ],
      "5": [ "z", "a", "hb", "hc", "f" ]
    },
    "8": {
      "1": [ "z", "e", "f*", "k" ],
      "2": [ "z", "b", "j", "ha", "id" ],
      "3": [ "z", "c", "f*", "hb", "g" ],
      "4": [ "z", "d", "j", "ha", "ie" ],
      "5": [ "z", "a", "f*", "hc", "f" ]
    },
    "9": {
      "1": [ "z", "e", "f*", "k" ],
      "2": [ "z", "b", "j", "ha", "id" ],
      "3": [ "z", "c", "f*", "hb", "g" ],
      "4": [ "z", "d", "j", "ha", "ie" ],
      "5": [ "z", "a", "f*", "hc", "f" ]
    },
    "10": {
      "1": [ "z", "e", "f*", "k" ],
      "2": [ "z", "b", "j", "ha", "id" ],
      "3": [ "z", "c", "f*", "hb", "g" ],
      "4": [ "z", "d", "j", "ha", "ie" ],
      "5": [ "z", "a", "f*", "hc", "f" ]
    }
  };

const L5={
    "5": {
      "1": [ 1500, 6, 6, 4, 10 ],
      "2": [ 500, 6, 32, 24 ],
      "3": [ 750, 6, 6, 15 ],
      "4": [ 1000, 6, 32, 24 ],
      "5": [ 1250, 6, 4, 16 ]
    },
    "6": {
      "1": [ 3000, 9, 4, 2, 1 ],
      "2": [ 1000, 9, 44, 32, 4 ],
      "3": [ 1500, 9, 12, 10, 20 ],
      "4": [ 2000, 9, 44, 32, 4 ],
      "5": [ 2500, 9, 20, 7, 20 ]
    },
    "7": {
      "1": [ 6000, 12, 8, 3, 3 ],
      "2": [ 2000, 12, 51, 42, 6 ],
      "3": [ 3000, 12, 20, 15, 31 ],
      "4": [ 4000, 12, 51, 42, 6 ],
      "5": [ 5000, 12, 30, 11, 31 ]
    },
    "8": {
      "1": [ 12000, 8, 2, 5 ],
      "2": [ 4000, 30, 64, 53, 4 ],
      "3": [ 6000, 20, 2, 40, 41 ],
      "4": [ 8000, 15, 64, 53, 4 ],
      "5": [ 10000, 50, 2, 17, 41 ]
    },
    "9": {
      "1": [ 30000, 12, 3, 7 ],
      "2": [ 10000, 40, 73, 61, 6 ],
      "3": [ 15000, 30, 3, 49, 52 ],
      "4": [ 20000, 20, 73, 61, 6 ],
      "5": [ 25000, 100, 3, 21, 52 ]
    },
    "10": {
      "1": [ 75000, 20, 4, 9 ],
      "2": [ 25000, 50, 85, 73, 8 ],
      "3": [ 37500, 40, 4, 59, 63 ],
      "4": [ 50000, 30, 85, 73, 8 ],
      "5": [ 62500, 150, 4, 31, 63 ]
    }
  };

const P5={
    "5": {
      "1": [ 1500, 6, 6, 4, 10 ],
      "2": [ 500, 4, 22, 17 ],
      "3": [ 750, 4, 3, 11 ],
      "4": [ 1000, 4, 22, 17 ],
      "5": [ 1250, 4, 3, 11 ]
    },
    "6": {
      "1": [ 3000, 6, 2, 2, 1 ],
      "2": [ 1000, 6, 31, 22, 2 ],
      "3": [ 1500, 6, 6, 5, 14 ],
      "4": [ 2000, 6, 31, 22, 2 ],
      "5": [ 2500, 6, 14, 5, 14 ]
    },
    "7": {
      "1": [ 6000, 8, 4, 2, 3 ],
      "2": [ 2000, 8, 36, 29, 3 ],
      "3": [ 3000, 8, 10, 7, 22 ],
      "4": [ 4000, 8, 36, 29, 3 ],
      "5": [ 5000, 8, 21, 8, 22 ]
    },
    "8": {
      "1": [ 12000, 4, 1, 5 ],
      "2": [ 4000, 15, 45, 37, 2 ],
      "3": [ 6000, 10, 1, 28, 29 ],
      "4": [ 8000, 7, 45, 37, 2 ],
      "5": [ 10000, 35, 1, 12, 29 ]
    },
    "9": {
      "1": [ 30000, 6, 2, 7 ],
      "2": [ 10000, 20, 51, 43, 3 ],
      "3": [ 15000, 15, 2, 34, 36 ],
      "4": [ 20000, 10, 51, 43, 3 ],
      "5": [ 25000, 70, 2, 15, 36 ]
    },
    "10": {
      "1": [ 75000, 10, 2, 9 ],
      "2": [ 25000, 25, 60, 51, 4 ],
      "3": [ 37500, 20, 2, 41, 44 ],
      "4": [ 50000, 15, 60, 51, 4 ],
      "5": [ 62500, 100, 2, 22, 44 ]
    }
  };

const M5={
    "5": [ 1500, 4, 2, 2, 10 ]
  };

const O5={
    "5": [ 1500, 3, 2, 2, 7 ]
  };

const D5={
    "2": [ 300, 10, 1, 1 ]
  };

const z5={
    "2": {
      "1": [ 300, 10, 1, 1 ],
      "2": [ 100, 2, 4, 3 ],
      "3": [ 150, 2, 2, 2 ],
      "4": [ 200, 2, 4, 3 ],
      "5": [ 250, 2, 1, 2 ]
    },
    "3": {
      "1": [ 600, 20, 2, 2 ],
      "2": [ 200, 4, 9, 6 ],
      "3": [ 300, 4, 3, 4 ],
      "4": [ 400, 4, 9, 6 ],
      "5": [ 500, 4, 1, 4 ]
    },
    "4": {
      "1": [ 900, 40, 2, 2, 6 ],
      "2": [ 300, 6, 17, 11 ],
      "3": [ 450, 6, 5, 6 ],
      "4": [ 600, 6, 17, 11 ],
      "5": [ 750, 6, 2, 8 ]
    },
    "5": {
      "1": [ 1500, 4, 2, 2, 7 ],
      "2": [ 500, 8, 22, 17 ],
      "3": [ 750, 8, 6, 11 ],
      "4": [ 1000, 8, 22, 17 ],
      "5": [ 1250, 8, 3, 11 ]
    },
    "6": {
      "1": [ 3000, 13, 3, 2, 1 ],
      "2": [ 1000, 13, 31, 22, 2 ],
      "3": [ 1500, 13, 10, 8, 14 ],
      "4": [ 2000, 13, 31, 22, 2 ],
      "5": [ 2500, 13, 14, 5, 14 ]
    },
    "7": {
      "1": [ 6000, 17, 6, 2, 3 ],
      "2": [ 2000, 17, 36, 29, 3 ],
      "3": [ 3000, 17, 15, 10, 22 ],
      "4": [ 4000, 17, 36, 29, 3 ],
      "5": [ 5000, 17, 21, 8, 22 ]
    },
    "8": {
      "1": [ 12000, 3, 2, 5 ],
      "2": [ 4000, 20, 45, 37, 2 ],
      "3": [ 6000, 15, 2, 28, 29 ],
      "4": [ 8000, 10, 45, 37, 2 ],
      "5": [ 10000, 70, 2, 12, 29 ]
    },
    "9": {
      "1": [ 30000, 5, 3, 7 ],
      "2": [ 10000, 25, 51, 43, 3 ],
      "3": [ 15000, 20, 3, 34, 36 ],
      "4": [ 20000, 15, 51, 43, 3 ],
      "5": [ 25000, 140, 3, 15, 36 ]
    },
    "10": {
      "1": [ 75000, 10, 5, 9 ],
      "2": [ 25000, 30, 60, 51, 4 ],
      "3": [ 37500, 25, 10, 41, 44 ],
      "4": [ 50000, 20, 60, 51, 4 ],
      "5": [ 62500, 210, 15, 22, 44 ]
    }
  };

const F5={
    "2": {
      "1": [ "z", "b", "kulu/b", "hb" ],
      "2": [ "z", "kulu/a1", "j", "ga" ],
      "3": [ "z", "barr/a1", "g-girr/b", "gg" ],
      "4": [ "z", "kulu/a1", "j", "gb" ],
      "5": [ "z", "barr/a1", "hc", "f" ]
    },
    "3": {
      "1": [ "z", "b", "paol/b", "hb" ],
      "2": [ "z", "kulu/a1", "j", "gc" ],
      "3": [ "z", "barr/a1", "g-girr/c", "gg" ],
      "4": [ "z", "kulu/a1", "j", "gf" ],
      "5": [ "z", "barr/a1", "hc", "f" ]
    },
    "4": {
      "1": [ "z", "b", "paol/c", "kulu/d", "hb" ],
      "2": [ "z", "kulu/a1", "j", "ge" ],
      "3": [ "z", "barr/a1", "anja/b", "gg" ],
      "4": [ "z", "kulu/a1", "j", "gd" ],
      "5": [ "z", "barr/a1", "hc", "f" ]
    },
    "5": {
      "1": [ "z", "kulu/a1", "anja/c", "kulu/d", "hb" ],
      "2": [ "z", "g-girr/a1", "j", "ga" ],
      "3": [ "z", "barr/a1", "diab/b", "gg" ],
      "4": [ "z", "g-girr/a1", "j", "gb" ],
      "5": [ "z", "barr/a1", "hc", "f" ]
    },
    "6": {
      "1": [ "z", "g-girr/a1", "diab/c", "kulu/e", "k" ],
      "2": [ "z", "paol/a1", "j", "gc", "barr/b" ],
      "3": [ "z", "g-girr/a1", "g-girr/c", "kulu/c", "gg" ],
      "4": [ "z", "paol/a1", "j", "gf", "barr/c" ],
      "5": [ "z", "g-girr/a1", "hb", "hc", "fa" ]
    },
    "7": {
      "1": [ "z", "paol/a1", "paol/d", "kulu/e", "k" ],
      "2": [ "z", "anja/a1", "j", "ge", "barr/b" ],
      "3": [ "z", "paol/a1", "anja/c", "kulu/c", "gg" ],
      "4": [ "z", "anja/a1", "j", "gd", "barr/c" ],
      "5": [ "z", "paol/a1", "hb", "hc", "fa" ]
    },
    "8": {
      "1": [ "z", "anja/a1", "diab/d", "k" ],
      "2": [ "z", "diab/a1", "j", "ga", "barr/d" ],
      "3": [ "z", "anja/a1", "g-girr/e", "hb", "gg" ],
      "4": [ "z", "diab/a1", "j", "gb", "barr/e" ],
      "5": [ "z", "anja/a1", "paol/e", "hc", "fa" ]
    },
    "9": {
      "1": [ "z", "barr/e", "anja/e", "k" ],
      "2": [ "z", "barr/b", "j", "gc", "barr/d" ],
      "3": [ "z", "barr/c", "diab/e", "hb", "gg" ],
      "4": [ "z", "barr/d", "j", "gf", "barr/e" ],
      "5": [ "z", "diab/a1", "l", "hc", "fa" ]
    },
    "10": {
      "1": [ "z", "kulu/e", "l", "k" ],
      "2": [ "z", "kulu/b", "j", "ge", "barr/d" ],
      "3": [ "z", "kulu/c", "l", "hb", "gg" ],
      "4": [ "z", "kulu/d", "j", "gd", "barr/e" ],
      "5": [ "z", "kulu/a1", "l", "hc", "fa" ]
    }
  };

const N5={
    "3": {
      "1": [ "z", "bone/b" ],
      "2": [ "z", "ha" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "4": {
      "1": [ "z", "ha", "hb", "hc" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "hc", "f" ]
    },
    "5": {
      "1": [ "z", "ha", "hb", "hc" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "6": {
      "1": [ "z", "ha", "hb", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "7": {
      "1": [ "z", "ha", "hb", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "g" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "f" ]
    },
    "8": {
      "1": [ "z", "ha", "l", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "l", "g", "hb" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "l", "f" ]
    },
    "9": {
      "1": [ "z", "ha", "l", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "l", "g", "hb" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "l", "f" ]
    },
    "10": {
      "1": [ "z", "ha", "l", "hc", "k" ],
      "2": [ "z", "ha", "j" ],
      "3": [ "z", "ha", "l", "g", "hb" ],
      "4": [ "z", "ha", "j" ],
      "5": [ "z", "ha", "l", "f" ]
    }
  };

const G5={
    "3": {
      "1": [ 600, 1 ],
      "2": [ 200, 6 ],
      "3": [ 300, 6, 2 ],
      "4": [ 400, 6, 6 ],
      "5": [ 500, 6, 1 ]
    },
    "4": {
      "1": [ 900, 9, 3, 1 ],
      "2": [ 300, 9, 12 ],
      "3": [ 450, 9, 4 ],
      "4": [ 600, 9, 12 ],
      "5": [ 750, 9, 2, 3 ]
    },
    "5": {
      "1": [ 1500, 24, 20, 15 ],
      "2": [ 500, 24, 32 ],
      "3": [ 750, 24, 15 ],
      "4": [ 1000, 24, 32 ],
      "5": [ 1250, 24, 25 ]
    },
    "6": {
      "1": [ 3000, 30, 30, 20, 1 ],
      "2": [ 1000, 30, 44 ],
      "3": [ 1500, 30, 20 ],
      "4": [ 2000, 30, 44 ],
      "5": [ 2500, 30, 30 ]
    },
    "7": {
      "1": [ 6000, 40, 40, 30, 3 ],
      "2": [ 2000, 40, 50 ],
      "3": [ 3000, 40, 30 ],
      "4": [ 4000, 40, 50 ],
      "5": [ 5000, 40, 40 ]
    },
    "8": {
      "1": [ 12000, 50, 4, 40, 5 ],
      "2": [ 4000, 50, 60 ],
      "3": [ 6000, 50, 4, 40, 50 ],
      "4": [ 8000, 50, 60 ],
      "5": [ 10000, 100, 4, 50 ]
    },
    "9": {
      "1": [ 30000, 50, 6, 50, 7 ],
      "2": [ 10000, 50, 70 ],
      "3": [ 15000, 50, 6, 50, 60 ],
      "4": [ 20000, 50, 70 ],
      "5": [ 25000, 150, 6, 60 ]
    },
    "10": {
      "1": [ 75000, 50, 10, 60, 9 ],
      "2": [ 25000, 50, 80 ],
      "3": [ 37500, 50, 20, 60, 70 ],
      "4": [ 50000, 50, 80 ],
      "5": [ 62500, 200, 30, 70 ]
    }
  };

const B5={
    "4": {
      "1": [ "z", "ny-24/b" ],
      "2": [ "z", "ny-24/b" ],
      "3": [ "z", "ny-24/b" ],
      "4": [ "z", "ny-24/b" ],
      "5": [ "z", "ny-24/b" ]
    }
  };

const q5={
    "4": {
      "1": [ 100, 1 ],
      "2": [ 100, 1 ],
      "3": [ 100, 1 ],
      "4": [ 100, 1 ],
      "5": [ 100, 1 ]
    }
  };

const j5={
    "alloy": [ "b", "g", "2", "g-jagr" ],
    "bone": [ "c", "g", "1", "g-jagr" ],
    "leather": [ "b", "g", "2", "g-jagr" ],
    "g-jagr": [ "b", "b", "2", "jyur" ],
    "kulu": [ "c", "g", "1", "g-jagr" ],
    "puke": [ "a", "e", "2", "rathi" ],
    "barr": [ "a", "g", "1", "diab" ],
    "g-girr": [ "b", "d", "2", "tobi" ],
    "tobi": [ "c", "f", "1", "g-girr" ],
    "paol": [ "a", "g", "2", "legi" ],
    "jyur": [ "a", "b", "1", "g-jagr" ],
    "anja": [ "c", "a", "1", "ratha" ],
    "rathi": [ "c", "e", "1", "puke" ],
    "legi": [ "b", "c", "2", "paol" ],
    "diab": [ "a", "g", "1", "barr" ],
    "ratha": [ "b", "a", "2", "anja" ],
    "b-diab": [ "a", "g", "1", "diab" ],
    "p-rathi": [ "c", "e", "1", "rathi" ],
    "a-ratha": [ "b", "a", "2", "ratha" ],
    "halloween": [ "c", "a", "1", "g-jagr" ],
    "rado": [ "c", "h", "1", "g-girr" ],
    "banb": [ "c", "g", "1", "barr" ],
    "bari": [ "b", "c", "2", "banb" ],
    "zino": [ "a", "f", "2", "tobi" ]
  };

const U5=["shield-sword","great-sword","hammer","long-sword","light-gun","bow","dual-blades","lance"];

const W5=["helm","mail","gloves","belt","greaves"];

const forgable_materials={
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
  };

const K5={
    "ore": [ "h2/a", "h2/b", "h2/c", "f/b" ],
    "bone": [ "h1/a", "h1/b", "h1/c", "f/c" ],
    "plant-bug": [ "g/a", "g/b", "g/c", "g/d", "g/e", "g/f", "g/g", "g/h", "f/a" ],
    "small-monster": [ "j2", "j1" ],
    "g-jagr": [ "g-jagr/a1", "g-jagr/a2", "g-jagr/b", "g-jagr/c", "g-jagr/d", "g-jagr/e" ],
    "kulu": [ "kulu/a2", "kulu/a1", "kulu/b", "kulu/c", "kulu/d", "kulu/e" ],
    "puke": [ "puke/a2", "puke/a1", "puke/b", "puke/c", "puke/d", "puke/e" ],
    "barr": [ "barr/a2", "barr/a1", "barr/b", "barr/c", "barr/d", "barr/e" ],
    "g-girr": [ "g-girr/a2", "g-girr/a1", "g-girr/b", "g-girr/c", "g-girr/d", "g-girr/e" ],
    "tobi": [ "tobi/a2", "tobi/a1", "tobi/b", "tobi/c", "tobi/d", "tobi/e" ],
    "paol": [ "paol/a2", "paol/a1", "paol/b", "paol/c", "paol/d", "paol/e" ],
    "jyur": [ "jyur/a2", "jyur/a1", "jyur/b", "jyur/c", "jyur/d", "jyur/e" ],
    "anja": [ "anja/a2", "anja/a1", "anja/b", "anja/c", "anja/d", "anja/e" ],
    "rathi": [ "rathi/a2", "rathi/a1", "rathi/b", "rathi/c", "rathi/d", "rathi/e" ],
    "p-rathi": [ "p-rathi/a2", "p-rathi/a1", "p-rathi/b", "p-rathi/c", "p-rathi/d", "p-rathi/e" ],
    "legi": [ "legi/a2", "legi/a1", "legi/b", "legi/c", "legi/d", "legi/e" ],
    "diab": [ "diab/a2", "diab/a1", "diab/b", "diab/c", "diab/d", "diab/e" ],
    "b-diab": [ "b-diab/a2", "b-diab/a1", "b-diab/b", "b-diab/c", "b-diab/d", "b-diab/e" ],
    "ratha": [ "ratha/a2", "ratha/a1", "ratha/b", "ratha/c", "ratha/d", "ratha/e" ],
    "a-ratha": [ "a-ratha/a2", "a-ratha/a1", "a-ratha/b", "a-ratha/c", "a-ratha/d", "a-ratha/e" ],
    "rado": [ "rado/a2", "rado/a1", "rado/b", "rado/c", "rado/d", "rado/e" ],
    "banb": [ "banb/a2", "banb/a1", "banb/b", "banb/c", "banb/d", "banb/e" ],
    "bari": [ "bari/a2", "bari/a1", "bari/b", "bari/c", "bari/d", "bari/e" ],
    "zino": [ "zino/a2", "zino/a1", "zino/b", "zino/c", "zino/d", "zino/e", "zino/f" ],
    "event": [ "halloween/b", "bone/b", "ny-24/b" ],
    "rare": [ "l", "k2", "k1" ]
  };

const armor_strength_by_level=[
    20,22,25,27,29,
    34,36,39,41,44,
    49,52,54,57,60,
    65,68,71,73,76,
    82,85,88,91,94,
    100,103,106,109,113,
    119,122,126,129,132,
    139,142,146,149,153,
    160,164,167,171,175,
    182,186,190,193,197];

const weapon_strength={
    "g-jagr-atk": [
      95, 102, 109, 116, 123,
      135, 145, 155, 165, 174,
      193, 207, 221, 235, 249,
      275, 295, 315, 335, 355,
      391, 411, 430, 449, 469,
      503, 528, 553, 578, 603,
      647, 679, 711, 743, 775,
      832, 873, 914, 955, 996,
      1068, 1121, 1174, 1227, 1280,
      1373, 1441, 1509, 1576, 1644 ],
    "g-jagr-ele": [
      25, 27, 29, 32, 34,
      38, 41, 45, 49, 53,
      59, 64, 70, 75, 81,
      90, 98, 106, 114, 122,
      136, 145, 153, 162, 171,
      184, 196, 208, 220, 232,
      251, 266, 282, 297, 313,
      337, 358, 379, 400, 421,
      453, 481, 509, 537, 565,
      607, 644, 681, 718, 754 ],
    "tobi-atk": [
      90, 97, 103, 110, 116,
      128, 137, 147, 156, 165,
      182, 196, 209, 222, 236,
      260, 279, 298, 317, 335,
      370, 388, 406, 425, 443,
      475, 499, 522, 546, 569,
      611, 641, 671, 701, 732,
      784, 823, 862, 901, 939,
      1007, 1057, 1107, 1156, 1206,
      1293, 1357, 1421, 1485, 1549 ],
    "tobi-ele": [
      30, 33, 36, 38, 41,
      47, 52, 56, 61, 65,
      75, 82, 89, 96, 103,
      117, 128, 138, 149, 159,
      181, 193, 204, 216, 227,
      251, 267, 283, 300, 316,
      349, 371, 393, 414, 436,
      481, 511, 541, 571, 601,
      663, 704, 745, 785, 826,
      910, 965, 1021, 1076, 1131 ],
    "legi-atk": [
      90, 97, 103, 110, 116,
      127, 137, 146, 155, 164,
      180, 193, 207, 220, 233,
      256, 274, 293, 311, 330,
      361, 379, 397, 415, 433,
      461, 484, 507, 530, 553,
      589, 618, 647, 676, 705,
      751, 788, 826, 863, 900,
      958, 1005, 1053, 1100, 1147,
      1221, 1281, 1342, 1402, 1463 ],
    "legi-ele": [
      39, 43, 46, 50, 54,
      61, 67, 73, 79, 85,
      97, 106, 115, 124, 133,
      150, 164, 177, 191, 205,
      232, 246, 261, 276, 291,
      320, 341, 361, 382, 402,
      443, 471, 499, 526, 554,
      608, 646, 684, 722, 760,
      835, 887, 938, 989, 1041,
      1142, 1211, 1281, 1350, 1420 ],
    "common-atk": [
      100, 107, 115, 122, 129,
      144, 154, 165, 175, 186,
      207, 222, 237, 253, 268,
      299, 321, 342, 364, 385,
      430, 451, 473, 494, 515,
      559, 587, 614, 642, 670,
      727, 763, 799, 835, 871,
      945, 992, 1038, 1085, 1132,
      1228, 1289, 1349, 1410, 1471,
      1596, 1675, 1754, 1833, 1912 ],
    "common-ele": [
      50, 58, 67, 75, 83,
      100, 108, 117, 125, 133,
      150, 158, 167, 175, 183,
      200, 208, 217, 225, 233,
      250, 258, 267, 275, 283,
      300, 304, 308, 312, 317,
      325, 329, 333, 337, 342,
      350, 354, 358, 362, 367,
      375, 379, 383, 387, 392,
      400, 404, 408, 412, 417 ],
    "common-crit": [
      5, 5, 5, 5, 5,
      10, 10, 10, 10, 10,
      10, 10, 10, 10, 10,
      15, 15, 15, 15, 15,
      15, 15, 15, 15, 15,
      20, 20, 20, 20, 20,
      20, 20, 20, 20, 20,
      25, 25, 25, 25, 25,
      25, 25, 25, 25, 25,
      30, 30, 30, 30, 30 ],
    "rathi-atk": [
      95, 102, 109, 116, 123,
      137, 147, 157, 166, 176,
      197, 211, 225, 240, 254,
      284, 305, 325, 346, 366,
      409, 429, 449, 469, 489,
      531, 557, 584, 610, 636,
      691, 725, 759, 793, 827,
      898, 942, 986, 1031, 1075,
      1167, 1224, 1282, 1340, 1397,
      1516, 1591, 1666, 1741, 1817 ],
    "rathi-ele": [
      58, 67, 76, 86, 95,
      116, 126, 135, 145, 154,
      176, 185, 195, 204, 214,
      236, 246, 255, 265, 275,
      298, 307, 317, 327, 337,
      360, 365, 370, 375, 380,
      393, 398, 403, 408, 413,
      427, 432, 437, 442, 447,
      461, 466, 471, 476, 482,
      496, 501, 506, 511, 516 ],
    "p-rathi-atk": [
      110, 118, 126, 134, 142,
      158, 170, 181, 193, 204,
      228, 244, 261, 278, 294,
      329, 353, 376, 400, 424,
      473, 496, 520, 543, 567,
      615, 645, 676, 706, 737,
      800, 839, 879, 918, 958,
      1040, 1091, 1142, 1194, 1245,
      1351, 1418, 1484, 1551, 1618,
      1756, 1843, 1929, 2016, 2103 ],
    "p-rathi-ele": [
      38, 44, 50, 56, 62,
      75, 81, 87, 94, 100,
      113, 119, 125, 131, 137,
      150, 156, 162, 169, 175,
      188, 194, 200, 206, 212,
      225, 228, 231, 234, 237,
      244, 247, 250, 253, 256,
      263, 266, 269, 272, 275,
      281, 284, 287, 291, 294,
      300, 303, 306, 309, 312 ],
    "barr-atk": [
      110, 118, 126, 134, 142,
      158, 170, 181, 193, 204,
      228, 244, 261, 278, 294,
      329, 353, 376, 400, 424,
      473, 496, 520, 543, 567,
      615, 645, 676, 706, 737,
      800, 839, 879, 918, 958,
      1040, 1091, 1142, 1194, 1245,
      1351, 1418, 1484, 1551, 1618,
      1756, 1843, 1929, 2016, 2103 ],
    "paol-atk": [
      115, 123, 132, 140, 148,
      165, 177, 189, 201, 212,
      236, 253, 271, 288, 305,
      339, 364, 388, 413, 437,
      486, 510, 534, 558, 582,
      629, 660, 691, 722, 754,
      814, 855, 895, 935, 975,
      1054, 1106, 1158, 1210, 1262,
      1363, 1430, 1498, 1565, 1633,
      1764, 1851, 1938, 2026, 2113 ],
    "diab-atk": [
      115, 123, 132, 140, 148,
      167, 179, 191, 203, 215,
      242, 260, 278, 295, 313,
      353, 378, 404, 429, 455,
      512, 537, 562, 588, 613,
      671, 704, 737, 771, 804,
      880, 923, 967, 1010, 1054,
      1153, 1210, 1267, 1324, 1381,
      1510, 1585, 1660, 1734, 1809,
      1979, 2077, 2175, 2273, 2371 ],
    "b-diab-atk": [
      130, 139, 149, 158, 168,
      189, 202, 216, 229, 243,
      273, 293, 313, 333, 353,
      398, 426, 455, 484, 513,
      576, 605, 633, 662, 690,
      755, 792, 829, 867, 904,
      989, 1038, 1087, 1135, 1184,
      1295, 1359, 1423, 1487, 1551,
      1695, 1778, 1862, 1946, 2030,
      2218, 2328, 2438, 2548, 2658 ],
    "b-diab-crit": [
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30,
      -30, -30, -30, -30, -30 ],
    "a-ratha-atk": [
      100, 107, 115, 122, 129,
      145, 155, 166, 176, 187,
      209, 225, 240, 256, 271,
      304, 326, 348, 370, 392,
      440, 462, 484, 506, 528,
      576, 604, 633, 661, 690,
      753, 790, 828, 865, 902,
      985, 1033, 1082, 1131, 1179,
      1287, 1351, 1414, 1478, 1541,
      1682, 1765, 1849, 1932, 2015 ],
    "a-ratha-ele": [
      24, 26, 28, 31, 33,
      37, 41, 44, 48, 51,
      58, 63, 68, 74, 79,
      88, 96, 104, 112, 120,
      134, 142, 151, 160, 168,
      182, 194, 205, 217, 229,
      248, 263, 279, 294, 310,
      334, 355, 376, 397, 418,
      451, 479, 506, 534, 562,
      605, 642, 679, 715, 752 ],
    "bari-atk": [
      80, 87, 93, 99, 105,
      116, 124, 132, 140, 148,
      164, 176, 188, 200, 211,
      234, 251, 268, 285, 301,
      334, 350, 367, 383, 400,
      430, 452, 473, 494, 516,
      555, 583, 610, 638, 665,
      716, 752, 787, 822, 858,
      923, 969, 1015, 1060, 1106,
      1191, 1250, 1309, 1367, 1426 ],
    "bari-crit": [
      0, 0, 0, 0, 0,
      0, 0, 0, 0, 0,
      5, 5, 5, 5, 5,
      5, 5, 5, 5, 5,
      10, 10, 10, 10, 10,
      10, 10, 10, 10, 10,
      15, 15, 15, 15, 15,
      15, 15, 15, 15, 20,
      20, 20, 20, 20, 20,
      20, 20, 20, 20, 20 ]
  };

const V5={
    areas: areas,
    elements: elements,
    eqTypes: equipment_types,
    weapons: weapons,
    skills: skills,
    compareSkills: compare_skills,
    guide: guide,
    set: bow_set,
    eq: equipment_skills,
    costType: cost_type,
    lv0CostType: level_0_cost_type,
    weaponCost: A5,
    lv0WeaponCost: T5,
    forgeWeaponCost: R5,
    armorCost: C5,
    lv0ArmorCost: E5,
    forgeArmorCost: S5,
    zinoCostType: I5,
    zinoWeaponCost: L5,
    zinoArmorCost: P5,
    forgeZinoWeaponCost: M5,
    forgeZinoArmorCost: O5,
    forgeHalloweenArmorCost: D5,
    halloweenArmorCost: z5,
    halloweenCostType: F5,
    boneCostType: N5,
    boneWeaponCost: G5,
    ny24CostType: B5,
    ny24ArmorCost: q5,
    itemType: j5,
    weaponType: U5,
    armorType: W5,
    matForge: forgable_materials,
    matSeries: K5,
    armorVal: armor_strength_by_level,
    weaponVal: weapon_strength,
    "drop-rate": {
      1:[86.7,13.3],
      2:[81,10.7,8.3],
      3:[80.4,11.3,8.3],
      4:[79,9.3,6.5,5.2],
      5:[79,9,6.3,5.7],
      6:[69.6,12.5,8.8,5.4,3.7],
      7:[69.4,12.5,8.8,5,4.3],
      8:[67.8,13.8,8.8,5,3.4,1.2],
      9:[67.8,13.8,8.8,5,3.1,1.5]
    },
    "member-hp-ratio":{1:1,2:1.45,3:2,4:2.55}
  };

const KE="Equipment";

const XE="Build";

const YE="Monster";

const VE="Weakness";

const HE="Found in";

const ZE="Skills";

const JE="Search";

const QE="Material";

const xE="Compare";

const e4="Map";

const t4="Item Box";

const i4="Event";

const n4="Coordinates";

const s4="longitude";

const a4="latitude";

const r4="Add";

const l4="Auto Build";

const o4="Hide irrelevant equipment";

const u4="Wish List";

const c4="Add to Wish List";

const d4="Update Wish List";

const h4="Remove from Wish List";

const f4="Upgrade";

const m4="Total Materials";

const g4="Estimation";

const p4="Classify";

const _4="Now";

const v4="Tomorrow";

const b4="Hunt-a-thons";

const k4="Loadout";

const y4="Rarity ";

const w4="Keywords";

const E4="All";

const T4="Individual Progress";

const R4="Adblock detected! Please disable it and refresh.";

const S4={
    "weapon": "Weapon",
    "helm": "Helmet",
    "mail": "Mail",
    "gloves": "Vambraces",
    "belt": "Coil",
    "greaves": "Greaves",
    "weapon-type": {
      "shield-sword": "Sword & Shield",
      "great-sword": "Great Sword",
      "hammer": "Hammer",
      "long-sword": "Long Sword",
      "light-gun": "Light Bowgun",
      "bow": "Bow",
      "dual-blades": "Dual Blades",
      "lance": "Lance"
    }
  };

const A4="Reset";

const C4="Link";

const I4="Link Copied";

const L4="Owned Equipments Only";

const P4="Physiology & Rewards";

const M4="Rewards";

const O4="Weakness";

const D4={
    "general": "Breakable",
    "sever": "Breakable only with Sever",
    "blunt": "Breakable only with Blunt",
    "or-above": " or above"
  };

const F4={
    "pierce": "Pierce",
    "rapid": "Rapid",
    "spread": "Spread"
  };

const N4={
    "none": "None",
    "paralysis": "Paralysis Coating",
    "poison": "Poison Coating"
  };

const G4={
    "normal": "Normal Ammo 1",
    "fire": "Flaming Ammo",
    "water": "Water Ammo",
    "ice": "Freeze Ammo",
    "thunder": "Thunder Ammo",
    "dragon": "Dragon Ammo",
    "spread": "Spread Ammo 1",
    "spread-fire": "Spread Fire Ammo",
    "spread-water": "Spread Water Ammo",
    "spread-ice": "Spread Ice Ammo",
    "spread-thunder": "Spread Thunder Ammo",
    "spread-dragon": "Spread Dragon Ammo",
    "sticky": "Sticky Ammo 1",
    "sticky-fire": "Sticky Fire Ammo",
    "sticky-water": "Sticky Water Ammo",
    "sticky-ice": "Sticky Ice Ammo",
    "sticky-thunder": "Sticky Thunder Ammo",
    "sticky-dragon": "Sticky Dragon Ammo",
    "cluster": "Cluster Bomb 1",
    "cluster-fire": "Cluster Fire Ammo",
    "cluster-water": "Cluster Water Ammo",
    "cluster-ice": "Cluster Ice Ammo",
    "cluster-thunder": "Cluster Thunder Ammo",
    "cluster-dragon": "Cluster Dragon Ammo",
    "slicing": "Slicing Ammo 1",
    "slicing-fire": "Slicing Fire Ammo",
    "slicing-water": "Slicing Water Ammo",
    "slicing-ice": "Slicing Ice Ammo",
    "slicing-thunder": "Slicing Thunder Ammo",
    "slicing-dragon": "Slicing Dragon Ammo",
    "pierce": "Pierce Ammo 1",
    "piercing-fire": "Piercing Fire Ammo",
    "piercing-water": "Piercing Water Ammo",
    "piercing-ice": "Piercing Ice Ammo",
    "piercing-thunder": "Piercing Thunder Ammo",
    "piercing-dragon": "Piercing Dragon Ammo"
  };

const B4={
    "alloy": {
      "a2": "Iron Ore",
      "b": "Machalite Ore",
      "c": "Dragonite Ore"
    },
    "bone": {
      "b": "2024 Weapon Ticket"
    },
    "leather": {
      "a1": "Iron Ore",
      "b": "Machalite Ore",
      "c": "Dragonite Ore"
    },
    "g-jagr": {
      "g-jagr\/a1": "Great Jagras Hide",
      "g-jagr\/a2": "Great Jagras Scale",
      "g-jagr\/b": "Great Jagras Claw",
      "g-jagr\/c": "Great Jagras Mane",
      "g-jagr\/d": "Great Jagras Primescale",
      "g-jagr\/e": "Fanged Wyvern Gem"
    },
    "kulu": {
      "kulu\/a1": "Kulu-Ya-Ku Hide",
      "kulu\/a2": "Kulu-Ya-Ku Scale",
      "kulu\/b": "Kulu-Ya-Ku Beak",
      "kulu\/c": "Kulu-Ya-Ku Plume",
      "kulu\/d": "Kulu-Ya-Ku Primescale",
      "kulu\/e": "Kulu-Ya-Ku Primehide"
    },
    "puke": {
      "puke\/a1": "Pukei-Pukei Shell",
      "puke\/a2": "Pukei-Pukei Scale",
      "puke\/b": "Pukei-Pukei Tail",
      "puke\/c": "Pukei-Pukei Sac",
      "puke\/d": "Pukei-Pukei Quill",
      "puke\/e": "Pukei-Pukei Primescale"
    },
    "barr": {
      "barr\/a1": "Barroth Shell",
      "barr\/a2": "Barroth Claw",
      "barr\/b": "Barroth Tail",
      "barr\/c": "Barroth Scalp",
      "barr\/d": "Barroth Ridge",
      "barr\/e": "Barroth Primeshell"
    },
    "g-girr": {
      "g-girr\/a1": "Great Girros Scale",
      "g-girr\/a2": "Great Girros Fang",
      "g-girr\/b": "Great Girros Tail",
      "g-girr\/c": "Great Girros Hood",
      "g-girr\/d": "Great Girros Primescale",
      "g-girr\/e": "Great Girros Primefang"
    },
    "tobi": {
      "tobi\/a1": "Tobi-Kadachi Scale",
      "tobi\/a2": "Tobi-Kadachi Claw",
      "tobi\/b": "Tobi-Kadachi Pelt",
      "tobi\/c": "Tobi-Kadachi Membrane",
      "tobi\/d": "Tobi-Kadachi Primescale",
      "tobi\/e": "Tobi-Kadachi Electrode"
    },
    "paol": {
      "paol\/a1": "Paolumu Pelt",
      "paol\/a2": "Paolumu Scale",
      "paol\/b": "Paolumu Webbing",
      "paol\/c": "Paolumu Shell",
      "paol\/d": "Paolumu Primescale",
      "paol\/e": "Paolumu Primeshell"
    },
    "jyur": {
      "jyur\/a1": "Jyuratodus Shell",
      "jyur\/a2": "Jyuratodus Scale",
      "jyur\/b": "Jyuratodus Fang",
      "jyur\/c": "Jyuratodus Fin",
      "jyur\/d": "Jyuratodus Primescale",
      "jyur\/e": "Jyuratodus Primeshell"
    },
    "anja": {
      "anja\/a1": "Anjanath Scale",
      "anja\/a2": "Anjanath Fang",
      "anja\/b": "Anjanath Tail",
      "anja\/c": "Anjanath Nosebone",
      "anja\/d": "Anjanath Primescale",
      "anja\/e": "Anjanath Plate"
    },
    "rathi": {
      "rathi\/a1": "Rathian Shell",
      "rathi\/a2": "Rathian Scale",
      "rathi\/b": "Rathian Webbing",
      "rathi\/c": "Rathian Spike",
      "rathi\/d": "Rathian Primescale",
      "rathi\/e": "Rathian Plate"
    },
    "legi": {
      "legi\/a1": "Legiana Hide",
      "legi\/a2": "Legiana Scale",
      "legi\/b": "Legiana Claw",
      "legi\/c": "Legiana Webbing",
      "legi\/d": "Legiana Primescale",
      "legi\/e": "Legiana Plate"
    },
    "diab": {
      "diab\/a1": "Diablos Shell",
      "diab\/a2": "Diablos Fang",
      "diab\/b": "Diablos Tailcase",
      "diab\/c": "Diablos Ridge",
      "diab\/d": "Diablos Primeshell",
      "diab\/e": "Diablos Marrow"
    },
    "ratha": {
      "ratha\/a1": "Rathalos Wingtalon",
      "ratha\/a2": "Rathalos Scale",
      "ratha\/b": "Rathalos Tail",
      "ratha\/c": "Rathalos Marrow",
      "ratha\/d": "Rathalos Primescale",
      "ratha\/e": "Rathalos Plate"
    },
    "b-diab": {
      "b-diab\/a1": "Black Diablos Shell",
      "b-diab\/a2": "Black Diablos Fang",
      "b-diab\/b": "Black Diablos Tailcase",
      "b-diab\/c": "Black Diablos Ridge",
      "b-diab\/d": "Black Diablos Primeshell",
      "b-diab\/e": "Black Diablos Marrow"
    },
    "p-rathi": {
      "p-rathi\/a1": "Pink Rathian Shell",
      "p-rathi\/a2": "Pink Rathian Scale",
      "p-rathi\/b": "Pink Rathian Webbing",
      "p-rathi\/c": "Pink Rathian Spike",
      "p-rathi\/d": "Pink Rathian Primescale",
      "p-rathi\/e": "Pink Rathian Plate"
    },
    "a-ratha": {
      "a-ratha\/a1": "Azure Rathalos Wingtalon",
      "a-ratha\/a2": "Azure Rathalos Scale",
      "a-ratha\/b": "Azure Rathalos Tail",
      "a-ratha\/c": "Azure Rathalos Marrow",
      "a-ratha\/d": "Azure Rathalos Primescale",
      "a-ratha\/e": "Azure Rathalos Plate"
    },
    "rado": {
      "rado\/a1": "Radobaan Shell",
      "rado\/a2": "Radobaan Scale",
      "rado\/b": "Radobaan Tail",
      "rado\/c": "Radobaan Oilshell",
      "rado\/d": "Radobaan Primescale",
      "rado\/e": "Radobaan Marrow"
    },
    "banb": {
      "banb\/a1": "Banbaro Ridge",
      "banb\/a2": "Banbaro Shell",
      "banb\/b": "Banbaro Tail",
      "banb\/c": "Banbaro Pelt",
      "banb\/d": "Banbaro Primeshell",
      "banb\/e": "Banbaro Great Horn"
    },
    "bari": {
      "bari\/a1": "Barioth Shell",
      "bari\/a2": "Barioth Claw",
      "bari\/b": "Barioth Tail",
      "bari\/c": "Barioth Spike",
      "bari\/d": "Barioth Primeclaw",
      "bari\/e": "Amber Fang"
    },
    "zino": {
      "zino\/a1": "Zinogre Shell",
      "zino\/a2": "Zinogre Claw",
      "zino\/b": "Zinogre Tail",
      "zino\/c": "Zinogre Shockfur",
      "zino\/d": "Zinogre Primeclaw",
      "zino\/e": "Zinogre Horn",
      "zino\/f": "Zinogre Plate"
    },
    "halloween": {
      "halloween\/a1": "Kulu-Ya-Ku Hide",
      "halloween\/b": "Pumpkin Ticket",
      "halloween\/c": "Kulu-Ya-Ku Plume",
      "halloween\/d": "Kulu-Ya-Ku Primescale",
      "halloween\/e": "Kulu-Ya-Ku Primehide"
    },
    "ny-24": {
      "ny-24\/b": "2024 Armor Ticket"
    },
    "f": {
      "f\/a": "Carpenterbug",
      "f\/b": "Earth Crystal",
      "f\/c": "Monster Bone+"
    },
    "g": {
      "g\/a": "Fire Herb",
      "g\/b": "Flowfern",
      "g\/c": "Snow Herb",
      "g\/d": "Parashroom",
      "g\/e": "Toadstool",
      "g\/f": "Thunderbug",
      "g\/g": "Godbug",
      "g\/h": "Sleep Herb"
    },
    "h1": {
      "h1\/a": "Monster Bone S",
      "h1\/b": "Monster Bone M",
      "h1\/c": "Monster Bone L"
    },
    "h2": {
      "h2\/a": "Iron Ore",
      "h2\/b": "Machalite Ore",
      "h2\/c": "Dragonite Ore"
    },
    "j1": "Wingdrake Hide",
    "j2": "Sharp Claw",
    "k1": "Armor Refining Parts",
    "k2": "Weapon Refining Parts",
    "l": "Wyvern Gem Shard",
    "z": "Zenny"
  };

const q4={
    "eq":KE,
    "equip":XE,
    "monsters":YE,
    "weakness":VE,
    "areas":HE,
    "skills":ZE,
    "search":JE,
    "forge":QE,
    "compare":xE,
    "map":e4,
    "box":t4,
    "event":i4,
    "coordinate":n4,
    "longitude":s4,
    "latitude":a4,
    "add":r4,
    "forge-new":"New Forge",
    "autoBuild":l4,
    "hideIrrelavent":o4,
    "wishList":u4,
    "addToWishList":c4,
    "updateWishList":d4,
    "removeFromWishList":h4,
    "upgrade":f4,
    "reverse-search":"Reverse Search",
    "used-in":"Used in",
    "totalMats":m4,
    "estimation":g4,
    "req-kills-clarify":"The estimation does not include obtaining wyvern gem shards and zenny.",
    "classify":p4,
    "now":_4,
    "tomorrow":v4,
    "day-after":"2 Days later",
    "after-time":"After {0}",
    "raid":b4,
    "raid-cd":"You will be able to join the Hunt-a-thon after <span class='yellow'>{0}</span>.",
    "loadout":k4,
    "loadout-name":"Loadout Name",
    "rare":y4,
    "skill-bias":"Practicality Assessment",
    "ele-null":"Elemental Attack Invalid",
    "keywords":w4,
    "all":E4,
    "individual":T4,
    "warm":R4,
    "trash-list":"Trash List",
    "trash-list-desc":"The materials not needed in your wish list:",
    "parts":S4,
    "reset":A4,
    "copyLink":C4,
    "linkCopied":I4,
    "export":"Export",
    "import":"Import",
    "onlyItemBox":L4,
    "monster-name":{"alloy":"Alloy",
    "leather":"Leather",
    "g-jagr":"Great Jagras",
    "kulu":"Kulu-Ya-Ku",
    "puke":"Pukei-Pukei",
    "barr":"Barroth",
    "g-girr":"Great Girros",
    "tobi":"Tobi-Kadachi",
    "halloween":"Halloween",
    "paol":"Paolumu",
    "jyur":"Jyuratodus",
    "anja":"Anjanath",
    "rathi":"Rathian",
    "legi":"Legiana",
    "diab":"Diablos",
    "ratha":"Rathalos",
    "p-rathi":"Pink Rathian",
    "a-ratha":"Azure Rathalos",
    "b-diab":"Black Diablos",
    "rado":"Radobaan",
    "banb":"Banbaro",
    "bari":"Barioth",
    "zino":"Zinogre",
    "small-monster":"Small Monsters",
    "ore":"Ore",
    "bone":"Bone",
    "plant-bug":"Plant/Bug",
    "event":"Event",
    "rare":"Rare",
    "ny-24":"New Year"},
    "physiology":P4,
    "rewards":M4,
    "weak":O4,
    "monster-parts":{"back":"Back",
    "body":"Body",
    "fins":"Fins",
    "forelegs":"Forelegs",
    "head":"Head",
    "hindlegs":"Hindlegs",
    "horns":"Horns",
    "legs":"Legs",
    "mud":"Mud Covered",
    "neck":"Neck",
    "neck-pouch":"Neck Pouch",
    "snout":"Snout",
    "rock":"Rock",
    "stomach":"Stomach",
    "tail":"Tail",
    "tail-tip":"Tail Tip",
    "wings":"Wings",
    "spikes":"Spikes",
    "broken":"Broken",
    "charged":"Charged"},
    "water-mud":"Water attack ignores Mud Covered effect",
    "breakable":D4,
    "action-type":{"sever":"Sever",
    "blunt":"Blunt",
    "ranged":"Ranged",
    "blast":"Blast"},
    "ele-attack":"Elemental Attack",
    "skill-name":{
      "Ice Resistance":"Ice Resistance",
      "Fire Resistance":"Fire Resistance",
      "Thunder Resistance":"Thunder Resistance",
      "Water Resistance":"Water Resistance",
      "Paralysis Resistance":"Paralysis Resistance",
      "Poison Resistance":"Poison Resistance",
      "Fire Attack":"Fire Attack",
      "Water Attack":"Water Attack",
      "Ice Attack":"Ice Attack",
      "Thunder Attack":"Thunder Attack",
      "Dragon Attack":"Dragon Attack",
      "Poison Attack":"Poison Attack",
      "Paralysis Attack":"Paralysis Attack",
      "Fortify":"Fortify",
      "Critical Eye":"Critical Eye",
      "Attack Boost":"Attack Boost",
      "Defense Boost":"Defense Boost",
      "Health Boost":"Health Boost",
      "Firm Foothold":"Firm Foothold",
      "Rising Tide":"Rising Tide",
      "Lock On":"Lock On",
      "Guts":"Guts",
      "Last Stand":"Last Stand",
      "Evade ExtenderUP":"Evade Extender",
      "Offensive Guard":"Offensive Guard",
      "Focus":"Focus",
      "Guard":"Guard",
      "Recoil Down":"Recoil Down",
      "Sneak Attack":"Sneak Attack",
      "Earplugs":"Earplugs",
      "Reload Speed":"Reload Speed",
      "Artful Dodger":"Artful Dodger",
      "Concentration":"Concentration",
      "Special Boost":"Special Boost",
      "Windproof":"Windproof",
      "Peak Performance":"Peak Performance",
      "Divine Blessing":"Divine Blessing",
      "Burst":"Burst",
      "Heroics":"Heroics",
      "Slugger":"Slugger",
      "Partbreaker":"Partbreaker",
      "Weakness Exploit":"Weakness Exploit",
      "Resentment":"Resentment",
      "Solidarity (Pumpkin Hunt)":"Solidarity (Pumpkin Hunt)",
      "Critical Boost":"Critical Boost",
      "Sleep Resistance":"Sleep Resistance",
      "Sleep Attack":"Sleep Attack",
      "Evasive Concentration":"Evasive Concentration",
      "Tremor Resistance":"Tremor Resistance",
      "Skyward Striker":"Skyward Striker",
      "Happy New Year (2024)":"Happy New Year (2024)"
    },
    "skill":z4,
    "arrow":F4,
    "bottle":N4,
    "ammo":G4,
    "item":B4
  };
