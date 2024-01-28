
if ENV['USE_SQL']
  unless Rails.env.production?
    connection = ActiveRecord::Base.connection
    connection.tables.each do |table|
      connection.execute("TRUNCATE #{table}") unless table == "schema_migrations"
    end

    sql = File.read('db/import.sql')
    statements = sql.split(/;$/)
    statements.pop

    ActiveRecord::Base.transaction do
      statements.each do |statement|
        connection.execute(statement)
      end
    end
  end
else
  json = IO.read('db/data.json')
  db = JSON.parse(json)

  forest = Area.create(name: 'forest')
  desert = Area.create(name: 'desert')
  swamp = Area.create(name: 'swamp')
  all_areas = [forest, desert, swamp]
  areas = {
    forest: forest,
    desert: desert,
    swamp: swamp,
  }.stringify_keys

  elements = {
    fire: Element.create(name: :fire),
    water: Element.create(name: :water),
    thunder: Element.create(name: :thunder),
    ice: Element.create(name: :ice),
    dragon: Element.create(name: :dragon),
    paralysis: Element.create(name: :paralysis),
    sleep: Element.create(name: :sleep),
    poison: Element.create(name: :poison),
  }.stringify_keys

  veg = Location.create(name: 'vegitation', areas: all_areas)
  mine = Location.create(name: 'mining outcrop', areas: all_areas)
  bones = Location.create(name: 'bonepile', areas: all_areas)
  lgveg = Location.create(name: 'large vegitation', areas: [forest])
  lgmine = Location.create(name: 'large mining outcrop', areas: [swamp])
  lgbones = Location.create(name: 'large bonepile', areas: [desert])

  monster_keys = db['guide'].keys
  monsters = db['guide'].map do |key, monster_info|
    name = db['en']['monster-name'][key]
    mon_areas = areas.values_at(*monster_info['biome'])
    mon_weaknesses = elements.values_at(*monster_info['weakness'])
    mon_elements = elements.values_at(*monster_info['elements'])
    mon = Monster.create(
      name: name,
      key: key,
      size: :large,
      areas: mon_areas,
      elements: mon_elements,
      weaknesses: mon_weaknesses,
    )
  end

  items = db['en']['item'].map do |set_key, set_info|
    if set_info.is_a?(String)
      set_info = { set_key => set_info }
    end

    set_info.map do |set_subkey, name|
      Item.create(
        name: name,
        set_key: set_key,
        set_subkey: set_subkey,
      )
    end
  end

  equips = db['set'].map do |key, eq_info|
    weaps = db['matForge'][key]
    armor = false
    armors = db['armorType']

    if weaps.include?('armor')
      armor = true
      weaps.delete('armor')
    elsif weaps.include?('helm')
      armor = true
      armors = ['helm']
      weaps.delete('helm')
    end

    f, g, h, alt_mon_key = db['itemType'][key]
    mon = Monster.find_by(key: key)
    alt_mon = Monster.find_by(key: alt_mon_key)

    all_eff = eq_info.fetch('eff', {})['all']

    created = []
    created += weaps.map do |subtype|
      weapon_name = db['en']['parts']['weapon-type'][subtype]
      set_name = [
        db['en']['monster-name'][key],
        weapon_name,
      ].join(' ')
      eff = eq_info.fetch('eff', {})[subtype] || all_eff

      eq_elem = elements[eff]
      atk_scheme = eq_info[eff]['base']
      crit_scheme = eq_info[eff]['crit']
      elem_scheme = eq_info[eff]['ele']
      def_scheme = nil

      eq = Equip.create(
        set_key: key,
        set_name: set_name,
        equip_type: :weapon,
        equip_subtype: subtype,
        unlock: eq_info['unlock'],
        starter: eq_info['starter'],
        event_only: eq_info['eventOnly'],
        atk_scheme: atk_scheme,
        crit_scheme: crit_scheme,
        elem_scheme: elem_scheme,
        def_scheme: def_scheme,
        f_code: f,
        g_code: g,
        h_code: h,
        monster: mon,
        alt_monster: alt_mon,
        element: eq_elem,
      )
    end

    if armor
      set_name = [
        db['en']['monster-name'][key],
        'Set',
      ].join(' ')
      atk_scheme = nil
      crit_scheme = nil
      elem_scheme = nil
      def_scheme = 'armor-def'
      created += armors.map do |subtype|
        eq = Equip.create(
          set_key: key,
          set_name: set_name,
          equip_type: :armor,
          equip_subtype: subtype,
          unlock: eq_info['unlock'],
          starter: eq_info['starter'],
          event_only: eq_info['eventOnly'],
          atk_scheme: atk_scheme,
          crit_scheme: crit_scheme,
          elem_scheme: elem_scheme,
          def_scheme: def_scheme,
          monster: mon,
          alt_monster: alt_mon,
          element: nil,
        )
      end
    end

    created.each do |equip|
      tbl = EquipTable.for(equip)

      equip.unlock.upto(10).each do |gr|
        cost_key = equip.armor? ? 'armorCost' : 'weaponCost'
        forge_cost_key = cost_key
        unless equip.starter
          forge_cost_key = equip.armor? ? 'forgeArmorCost' : 'forgeWeaponCost'
        end

        base_gr = (gr - 1) * 5

        1.upto(5).each do |subgr|
          costs = db[cost_key]
          forge = false
          if !equip.starter? && gr == equip.unlock && subgr == 1
            costs = db[forge_cost_key]
            forge = true
          end

          types = db['costType'][gr.to_s][subgr.to_s]
          cost = forge ? costs[gr.to_s] : costs[gr.to_s][subgr.to_s]

          powers = db['weaponVal']
          power_idx = base_gr + subgr - 1

          atk_power = powers[equip.atk_scheme]&.[](power_idx)
          crit_power = powers[equip.crit_scheme]&.[](power_idx)
          elem_power = powers[equip.elem_scheme]&.[](power_idx)
          def_power = powers[equip.def_scheme]&.[](power_idx)

          eg = EquipGrade.create(
            equip: equip,
            grade: gr,
            sub_grade: subgr,
            atk_power: atk_power,
            crit_power: crit_power,
            elem_power: elem_power,
            def_power: def_power,
            forge: forge,
          )

          types.each_with_index do |item_type, i|
            EquipGradeItem.create(
              equip: equip,
              equip_grade: eg,
              item: tbl[item_type],
              qty: cost[i],
            )
          end
        end
      end
    end
  end
end

if false
  vegetation = Location.find_or_create_by(name: 'Vegetation', terrain: forest, terrain_name: forest.name)
  large_vegetation = Location.find_or_create_by(name: 'Large Vegetation', terrain: forest, terrain_name: forest.name)
  mining_outcrop = Location.find_or_create_by(name: 'Mining Outcrop', terrain: swamp, terrain_name: swamp.name)
  large_mining_outcrop = Location.find_or_create_by(name: 'Large Mining Outcrop', terrain: swamp, terrain_name: swamp.name)
  bonepile = Location.find_or_create_by(name: 'Bonepile', terrain: desert, terrain_name: desert.name)
  large_bonepile = Location.find_or_create_by(name: 'Large Bonepile', terrain: desert, terrain_name: desert.name)

  fire = Element.find_or_create_by(name: 'Fire')
  poison = Element.find_or_create_by(name: 'Poison')
  sleep = Element.find_or_create_by(name: 'Sleep')
  water = Element.find_or_create_by(name: 'Water')
  thunder = Element.find_or_create_by(name: 'Thunder')
  ice = Element.find_or_create_by(name: 'Ice')
  dragon = Element.find_or_create_by(name: 'Dragon')
  paralysis = Element.find_or_create_by(name: 'Paralysis')

  elements = {
    fire: fire,
    poison: poison,
    sleep: sleep,
    water: water,
    thunder: thunder,
    ice: ice,
    dragon: dragon,
    paralysis: paralysis,
  }

  items = {
    # [ Ore ]
    iron_ore: ['Iron Ore', :ore, 1, [forest, desert, swamp, mining_outcrop, large_mining_outcrop]],
    machalite_ore: ['Machalite Ore', :ore, 2, [forest, desert, swamp, mining_outcrop, large_mining_outcrop]],
    dragonite_ore: ['Dragonite Ore', :ore, 3, [forest, desert, swamp, mining_outcrop, large_mining_outcrop]],
    earth_crystal: ['Earth Crystal', :ore, 3, [swamp, large_mining_outcrop]],

    # [ Monster Bones ]
    monster_bone_s: ['Monster Bone S', :bone, 1, [forest, desert, swamp, bonepile, large_bonepile]],
    monster_bone_m: ['Monster Bone M', :bone, 2, [forest, desert, swamp, bonepile, large_bonepile]],
    monster_bone_l: ['Monster Bone L', :bone, 3, [forest, desert, swamp, bonepile, large_bonepile]],
    monster_bone_xl: ['Monster Bone+', :bone, 3, [desert, large_bonepile]],

    # [ Vegetation ]
    # [[ Plants ]]
    fire_herb: ['Fire Herb', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    flowfern: ['Flowfern', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    snow_herb: ['Snow Herb', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    sleep_herb: ['Sleep Herb', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    # [[ Insects ]]
    thunderbug: ['Thunderbug', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    godbug: ['Godbug', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    carpenterbug: ['Carpenterbug', :vegetation, 3, [forest, large_vegetation]],
    # [[ Mushrooms ]]
    parashroom: ['Parashroom', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
    toadstool: ['Toadstool', :vegetation, 1, [forest, desert, swamp, vegetation, large_vegetation]],
  }

  items.each do |k, (name, type, rarity, srcs)|
    item = Item.find_or_create_by(name: name, item_type: type, rarity: rarity)
    srcs.each{|src| ItemSource.find_or_create_by(item: item, source: src) }
  end

  Item.find_or_create_by(name: 'Zenny', item_type: :money, rarity: 1)
  Item.find_or_create_by(name: 'Armor Refining Parts', item_type: :quest)
  Item.find_or_create_by(name: 'Weapon Refining Parts', item_type: :quest)

  monster_names = {
    'alloy': 'Alloy',
    'leather': 'Leather',
    'g-jagr': 'Great Jagras',
    'kulu': 'Kulu-Ya-Ku',
    'puke': 'Pukei-Pukei',
    'barr': 'Barroth',
    'g-girr': 'Great Girros',
    'tobi': 'Tobi-Kadachi',
    'halloween': 'Halloween',
    'paol': 'Paolumu',
    'jyur': 'Jyuratodus',
    'anja': 'Anjanath',
    'rathi': 'Rathian',
    'legi': 'Legiana',
    'diab': 'Diablos',
    'ratha': 'Rathalos',
    'p-rathi': 'Pink Rathian',
    'a-ratha': 'Azure Rathalos',
    'b-diab': 'Black Diablos',
    'rado': 'Radobaan',
    'banb': 'Banbaro',
    'bari': 'Barioth',
    'zino': 'Zinogre',
    'small-monster': 'Small Monsters',
    'ore': 'Ore',
    'bone': 'Bone',
    'plant-bug': 'Plant/Bug',
    'event': 'Event',
    'rare': 'Rare',
    'ny-24': 'New Year'
  }

  jagras = Monster.find_or_create_by(name: 'Jagras', size: :small)
  shamos = Monster.find_or_create_by(name: 'Shamos', size: :small)
  mernos = Monster.find_or_create_by(name: 'Mernos', size: :small)
  raphinos = Monster.find_or_create_by(name: 'Raphinos', size: :small)
  noios = Monster.find_or_create_by(name: 'Noios', size: :small)
  wulg = Monster.find_or_create_by(name: 'Wulg', size: :small)
  cortos = Monster.find_or_create_by(name: 'Cortos', size: :small)

  anjanath = Monster.find_or_create_by(name: 'Anjanath', size: :large, key: monster_names.key('Anjanath'))
  banbaro = Monster.find_or_create_by(name: 'Banbaro', size: :large, key: monster_names.key('Banbaro'))
  barioth = Monster.find_or_create_by(name: 'Barioth', size: :large, key: monster_names.key('Barioth'))
  barroth = Monster.find_or_create_by(name: 'Barroth', size: :large, key: monster_names.key('Barroth'))
  diablos = Monster.find_or_create_by(name: 'Diablos', size: :large, key: monster_names.key('Diablos'))
  black_diablos = Monster.find_or_create_by(name: 'Black Diablos', size: :large, key: monster_names.key('Black Diablos'))
  great_girros = Monster.find_or_create_by(name: 'Great Girros', size: :large, key: monster_names.key('Great Girros'))
  great_jagras = Monster.find_or_create_by(name: 'Great Jagras', size: :large, key: monster_names.key('Great Jagras'))
  halloween = Monster.find_or_create_by(name: 'Halloween', size: :large, key: monster_names.key('Halloween'))
  jyuratodus = Monster.find_or_create_by(name: 'Jyuratodus', size: :large, key: monster_names.key('Jyuratodus'))
  kulu_ya_ku = Monster.find_or_create_by(name: 'Kulu-Ya-Ku', size: :large, key: monster_names.key('Kulu-Ya-Ku'))
  legiana = Monster.find_or_create_by(name: 'Legiana', size: :large, key: monster_names.key('Legiana'))
  paolumu = Monster.find_or_create_by(name: 'Paolumu', size: :large, key: monster_names.key('Paolumu'))
  pukei_pukei = Monster.find_or_create_by(name: 'Pukei-Pukei', size: :large, key: monster_names.key('Pukei-Pukei'))
  radobaan = Monster.find_or_create_by(name: 'Radobaan', size: :large, key: monster_names.key('Radobaan'))
  rathalos = Monster.find_or_create_by(name: 'Rathalos', size: :large, key: monster_names.key('Rathalos'))
  azure_rathalos = Monster.find_or_create_by(name: 'Azure Rathalos', size: :large, key: monster_names.key('Azure Rathalos'))
  rathian = Monster.find_or_create_by(name: 'Rathian', size: :large, key: monster_names.key('Rathian'))
  pink_rathian = Monster.find_or_create_by(name: 'Pink Rathian', size: :large, key: monster_names.key('Pink Rathian'))
  tobi_kadachi = Monster.find_or_create_by(name: 'Tobi-Kadachi', size: :large, key: monster_names.key('Tobi-Kadachi'))
  zinogre = Monster.find_or_create_by(name: 'Zinogre', size: :large, key: monster_names.key('Zinogre'))

  monster = {
    'anja': anjanath,
    'banb': banbaro,
    'bari': barioth,
    'barr': barroth,
    'diab': diablos,
    'b-diab': black_diablos,
    'g-girr': great_girros,
    'g-jagr': great_jagras,
    'halloween': halloween,
    'jyur': jyuratodus,
    'kulu': kulu_ya_ku,
    'legi': legiana,
    'paol': paolumu,
    'puke': pukei_pukei,
    'rado': radobaan,
    'ratha': rathalos,
    'a-ratha': azure_rathalos,
    'rathi': rathian,
    'p-rathi': pink_rathian,
    'tobi': tobi_kadachi,
    'zino': zinogre,
  }

  monster_elements = [
    [great_jagras, [fire, poison, sleep], []],
    [kulu_ya_ku, [water], []],
    [pukei_pukei, [thunder, sleep], [poison]],
    [barroth, [fire, poison], [water]],
    [great_girros, [water, sleep], [paralysis]],
    [tobi_kadachi, [water, poison], [thunder]],
    [paolumu, [fire], []],
    [jyuratodus, [thunder], [water]],
    [anjanath, [water], [fire]],
    [rathian, [thunder, dragon], [fire, poison]],
    [pink_rathian, [thunder, dragon], [fire, poison]],
    [legiana, [fire, poison], [ice]],
    [diablos, [ice, dragon, paralysis], []],
    [black_diablos, [ice, paralysis], []],
    [rathalos, [thunder, dragon], [fire, poison]],
    [azure_rathalos, [thunder, dragon], [fire, poison]],
    [radobaan, [ice, dragon], [sleep]],
    [banbaro, [fire, dragon], []],
    [barioth, [fire], [ice]],
    [zinogre, [ice], [thunder]],
  ].each do |mon, wk, el|
    wk.each{|o| Weakness.find_or_create_by(monster: mon, element: o) }
    el.each{|o| MonsterElement.find_or_create_by(monster: mon, element: o) }
  end

  monster_items = [
    [jagras, 'Sharp Claw', 1],
    [shamos, 'Sharp Claw', 1],
    [mernos, 'Wingdrake Hide', 1],
    [raphinos, 'Wingdrake Hide', 1],
    [noios, 'Wingdrake Hide', 1],
    [wulg, 'Sharp Claw', 1],
    [cortos, 'Wingdrake Hide', 1],

    [great_jagras, 'Great Jagras Scale', 1],
    [great_jagras, 'Great Jagras Hide', 1],
    [great_jagras, 'Great Jagras Claw', 1],
    [great_jagras, 'Great Jagras Mane', 2],
    [great_jagras, 'Great Jagras Primescale', 4],
    [great_jagras, 'Fanged Wyvern Gem', 6],
    [great_jagras, 'Wyvern Gem Shard', 8],

    [kulu_ya_ku, 'Kulu-Ya-Ku Scale', 1],
    [kulu_ya_ku, 'Kulu-Ya-Ku Hide', 1],
    [kulu_ya_ku, 'Kulu-Ya-Ku Beak', 1],
    [kulu_ya_ku, 'Kulu-Ya-Ku Plume', 2],
    [kulu_ya_ku, 'Kulu-Ya-Ku Primescale', 4],
    [kulu_ya_ku, 'Kulu-Ya-Ku Primehide', 6],
    [kulu_ya_ku, 'Wyvern Gem Shard', 8],

    [pukei_pukei, 'Pukei-Pukei Scale', 1],
    [pukei_pukei, 'Pukei-Pukei Shell', 1],
    [pukei_pukei, 'Pukei-Pukei Tail', 1],
    [pukei_pukei, 'Pukei-Pukei Sac', 2],
    [pukei_pukei, 'Pukei-Pukei Quill', 4],
    [pukei_pukei, 'Pukei-Pukei Primescale', 6],
    [pukei_pukei, 'Wyvern Gem Shard', 8],

    [barroth, 'Barroth Tail', 1],
    [barroth, 'Barroth Claw', 1],
    [barroth, 'Barroth Shell', 1],
    [barroth, 'Barroth Scalp', 2],
    [barroth, 'Barroth Ridge', 4],
    [barroth, 'Barroth Primeshell', 6],
    [barroth, 'Wyvern Gem Shard', 8],

    [great_girros, 'Great Girros Fang', 2],
    [great_girros, 'Great Girros Tail', 2],
    [great_girros, 'Great Girros Scale', 2],
    [great_girros, 'Great Girros Hood', 2],
    [great_girros, 'Great Girros Primescale', 4],
    [great_girros, 'Great Girros Primefang', 6],
    [great_girros, 'Wyvern Gem Shard', 8],

    [tobi_kadachi, 'Tobi-Kadachi Scale', 2],
    [tobi_kadachi, 'Tobi-Kadachi Pelt', 2],
    [tobi_kadachi, 'Tobi-Kadachi Membrane', 2],
    [tobi_kadachi, 'Tobi-Kadachi Claw', 2],
    [tobi_kadachi, 'Tobi-Kadachi Primescale', 4],
    [tobi_kadachi, 'Tobi-Kadachi Electrode', 6],
    [tobi_kadachi, 'Wyvern Gem Shard', 8],

    [paolumu, 'Paolumu Scale', 3],
    [paolumu, 'Paolumu Pelt', 3],
    [paolumu, 'Paolumu Webbing', 3],
    [paolumu, 'Paolumu Shell', 3],
    [paolumu, 'Paolumu Primescale', 4],
    [paolumu, 'Paolumu Primeshell', 6],
    [paolumu, 'Wyvern Gem Shard', 8],

    [jyuratodus, 'Jyuratodus Shell', 3],
    [jyuratodus, 'Jyuratodus Scale', 3],
    [jyuratodus, 'Jyuratodus Fang', 3],
    [jyuratodus, 'Jyuratodus Fin', 3],
    [jyuratodus, 'Jyuratodus Primescale', 4],
    [jyuratodus, 'Jyuratodus Primeshell', 6],
    [jyuratodus, 'Wyvern Gem Shard', 8],

    [anjanath, 'Anjanath Scale', 4],
    [anjanath, 'Anjanath Fang', 4],
    [anjanath, 'Anjanath Tail', 4],
    [anjanath, 'Anjanath Nosebone', 4],
    [anjanath, 'Anjanath Primescale', 4],
    [anjanath, 'Anjanath Plate', 6],
    [anjanath, 'Wyvern Gem Shard', 8],

    [rathian, 'Rathian Shell', 4],
    [rathian, 'Rathian Scale', 4],
    [rathian, 'Rathian Webbing', 4],
    [rathian, 'Rathian Spike', 4],
    [rathian, 'Rathian Primescale', 4],
    [rathian, 'Rathian Plate', 6],
    [rathian, 'Wyvern Gem Shard', 8],

    [legiana, 'Legiana Scale', 5],
    [legiana, 'Legiana Hide', 5],
    [legiana, 'Legiana Claw', 5],
    [legiana, 'Legiana Webbing', 5],
    [legiana, 'Legiana Primescale', 5],
    [legiana, 'Legiana Plate', 6],
    [legiana, 'Wyvern Gem Shard', 8],

    [diablos, 'Diablos Shell', 5],
    [diablos, 'Diablos Fang', 5],
    [diablos, 'Diablos Tailcase', 5],
    [diablos, 'Diablos Ridge', 5],
    [diablos, 'Diablos Primeshell', 5],
    [diablos, 'Diablos Marrow', 6],
    [diablos, 'Wyvern Gem Shard', 8],

    [rathalos, 'Rathalos Wingtalon', 5],
    [rathalos, 'Rathalos Scale', 5],
    [rathalos, 'Rathalos Tail', 5],
    [rathalos, 'Rathalos Marrow', 5],
    [rathalos, 'Rathalos Primescale', 5],
    [rathalos, 'Rathalos Plate', 6],
    [rathalos, 'Wyvern Gem Shard', 8],

    [black_diablos, 'Black Diablos Shell', 5],
    [black_diablos, 'Black Diablos Fang', 5],
    [black_diablos, 'Black Diablos Tailcase', 5],
    [black_diablos, 'Black Diablos Ridge', 5],
    [black_diablos, 'Black Diablos Primeshell', 5],
    [black_diablos, 'Black Diablos Marrow', 6],

    [pink_rathian, 'Pink Rathian Scale', 5],
    [pink_rathian, 'Pink Rathian Shell', 5],
    [pink_rathian, 'Pink Rathian Webbing', 5],
    [pink_rathian, 'Pink Rathian Spike', 5],
    [pink_rathian, 'Pink Rathian Primescale', 5],
    [pink_rathian, 'Pink Rathian Plate', 6],

    [radobaan, 'Radobaan Scale', 2],
    [radobaan, 'Radobaan Shell', 2],
    [radobaan, 'Radobaan Tail', 2],
    [radobaan, 'Radobaan Oilshell', 2],
    [radobaan, 'Radobaan Primescale', 4],
    [radobaan, 'Radobaan Marrow', 6],
    [radobaan, 'Wyvern Gem Shard', 8],

    [banbaro, 'Banbaro Shell', 3],
    [banbaro, 'Banbaro Ridge', 3],
    [banbaro, 'Banbaro Tail', 3],
    [banbaro, 'Banbaro Pelt', 3],
    [banbaro, 'Banbaro Primeshell', 4],
    [banbaro, 'Banbaro Great Horn', 6],
    [banbaro, 'Wyvern Gem Shard', 8],

    [barioth, 'Barioth Primeclaw', 4],
    [barioth, 'Barioth Spike', 4],
    [barioth, 'Barioth Shell', 4],
    [barioth, 'Barioth Claw', 4],
    [barioth, 'Barioth Tail', 4],
    [barioth, 'Amber Fang', 6],
    [barioth, 'Wyvern Gem Shard', 8],

    [zinogre, 'Zinogre Claw', 5],
    [zinogre, 'Zinogre Shell', 5],
    [zinogre, 'Zinogre Tail', 5],
    [zinogre, 'Zinogre Shockfur', 5],
    [zinogre, 'Zinogre Primeclaw', 5],
    [zinogre, 'Zinogre Horn', 6],
    [zinogre, 'Zinogre Plate', 8],

    [azure_rathalos, 'Azure Rathalos Scale', 5],
    [azure_rathalos, 'Azure Rathalos Wingtalon', 5],
    [azure_rathalos, 'Azure Rathalos Tail', 5],
    [azure_rathalos, 'Azure Rathalos Marrow', 5],
    [azure_rathalos, 'Azure Rathalos Primescale', 5],
    [azure_rathalos, 'Azure Rathalos Plate', 6],
  ]

  monster_items.each do |mon, name, stars|
    type = :monster
    item = Item.find_or_create_by(name: name, item_type: type)
    ItemSource.find_or_create_by(item: item, source: mon, stars: stars)
  end

  monster_terrain = [
    [jagras, forest],
    [shamos, desert, swamp],
    [mernos, forest],
    [raphinos, swamp],
    [noios, desert],
    [wulg, swamp],
    [cortos, swamp],

    [great_jagras, forest, desert, swamp],
    [kulu_ya_ku, forest, desert, swamp],
    [pukei_pukei, forest, desert, swamp],
    [barroth, desert, swamp],
    [great_girros, forest, swamp],
    [tobi_kadachi, forest, swamp],
    [paolumu, desert, swamp],
    [jyuratodus, swamp],
    [anjanath, forest, desert],
    [rathian, forest, desert],
    [pink_rathian, forest],
    [legiana, swamp],
    [diablos, desert],
    [black_diablos, desert],
    [rathalos, forest],
    [azure_rathalos, forest],
    [radobaan, desert, swamp],
    [banbaro, forest, swamp],
    [barioth, forest],
    [zinogre, forest, swamp],
  ]

  monster_terrain.each do |mon, *list|
    mon.terrains = list
  end

  monster_weapon_map = {
    'g-jagr': {
      'biome': [ 'forest', 'desert', 'swamp' ],
      'weakness': [ 'fire' ],
      'poison': 3,
      'paralysis': 3,
      'stun': 3,
      'sleep': 3,
      'hp': {
        '5': 6450,
        '6': 10520,
        '7': 17560,
        '8': 32080,
        '9': 67780,
        '10': 139115
      },
      'raid-hp': {
        '4': 7900,
        '5': 13935,
        '6': 24665,
        '7': 41340
      },
      'physiology': {
        'head': [ 130, 135, 130, 1, [ 'c', 'e' ] ],
        'body': [ 90, 100, 70 ],
        'stomach': [ 140, 145, 140, 1 ],
        'forelegs': [ 120, 110, 90, 1, [ 'b', 'd', 'f' ] ],
        'hindlegs': [ 100, 90, 70 ],
        'tail': [ 100, 90, 70 ]
      }
    },
    'kulu': {
      'biome': [ 'forest', 'desert', 'swamp' ],
      'weakness': [ 'water' ],
      'poison': 2,
      'paralysis': 3,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 6150,
        '6': 10040,
        '7': 16740,
        '8': 30580,
        '9': 64560,
        '10': 132480
      },
      'raid-hp': {
        '4': 7520,
        '5': 13270,
        '6': 23490,
        '7': 39370
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'b', 'd', 'f' ] ],
        'body': [ 90, 90, 70 ],
        'forelegs': [ 130, 135, 130, 1, [ 'c', 'e' ] ],
        'hindlegs': [ 90, 90, 70 ],
        'tail': [ 110, 110, 70 ],
        'rock': [ 10, 10, 10 ]
      }
    },
    'puke': {
      'biome': [ 'forest', 'desert', 'swamp' ],
      'weakness': [ 'thunder' ],
      'poison': 1,
      'paralysis': 3,
      'stun': 2,
      'sleep': 3,
      'hp': {
        '5': 6150,
        '6': 10040,
        '7': 16740,
        '8': 30580,
        '9': 64560,
        '10': 132480
      },
      'raid-hp': {
        '4': 7520,
        '5': 13270,
        '6': 23490,
        '7': 39370
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'c', 'e' ] ],
        'back': [ 90, 100, 70, 1 ],
        'wings': [ 110, 110, 95, 1, [ 'd' ] ],
        'legs': [ 100, 110, 80 ],
        'tail': [ 120, 110, 90, 2, [ 'b', 'f' ] ]
      }
    },
    'barr': {
      'biome': [ 'desert', 'swamp' ],
      'weakness': [ 'fire' ],
      'poison': 3,
      'paralysis': 2,
      'stun': 1,
      'sleep': 2,
      'hp': {
        '5': 4300,
        '6': 7720,
        '7': 12680,
        '8': 23560,
        '9': 49950,
        '10': 99160
      },
      'raid-hp': {
        '4': 5265,
        '5': 9290,
        '6': 16440,
        '7': 27560
      },
      'physiology': {
        'head': [ 80, 110, 55, 3, [ 'c', 'd' ] ],
        'body': [ 100, 100, 80 ],
        'forelegs': [ 140, 145, 140, 1, [ 'e' ] ],
        'hindlegs': [ 90, 100, 65, 1 ],
        'tail': [ 120, 100, 80, 2, [ 'b', 'f' ] ],
        'mud': [ 30 ],
        'water-mud': 1
      }
    },
    'g-girr': {
      'biome': [ 'forest', 'swamp' ],
      'weakness': [ 'water' ],
      'poison': 2,
      'paralysis': 1,
      'stun': 2,
      'sleep': 3,
      'hp': {
        '5': 6150,
        '6': 11000,
        '7': 18150,
        '8': 33680,
        '9': 71340,
        '10': 141680
      },
      'raid-hp': {
        '4': 7520,
        '5': 13270,
        '6': 23490,
        '7': 39370
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'c', 'e', 'f' ] ],
        'body': [ 90, 100, 70 ],
        'forelegs': [ 110, 110, 90, 1, [ 'd' ] ],
        'hindlegs': [ 100, 100, 80 ],
        'tail': [ 120, 110, 90, 2, [ 'b' ] ]
      }
    },
    'tobi': {
      'biome': [ 'forest', 'swamp' ],
      'weakness': [ 'water' ],
      'poison': 3,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 5850,
        '6': 10450,
        '7': 18680,
        '8': 31960,
        '9': 74240,
        '10': 143340
      },
      'raid-hp': {
        '4': 7145,
        '5': 12610,
        '6': 22315,
        '7': 37400
      },
      'physiology': {
        'head': [ 130, 135, 130, 1, [ 'b' ] ],
        'body': [ 100, 110, 80 ],
        'back': [ 100, 100, 95, 1 ],
        'forelegs': [ 90, 90, 55, 1, [ 'c', 'd' ] ],
        'hindlegs': [ 90, 90, 55 ],
        'tail': [ 140, 140, 140, 1, [ 'e', 'f' ] ]
      }
    },
    'paol': {
      'biome': [ 'desert', 'swamp' ],
      'weakness': [ 'fire' ],
      'poison': 2,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 6960,
        '6': 12330,
        '7': 19040,
        '8': 38600,
        '9': 74920,
        '10': 148760
      },
      'raid-hp': {
        '4': 7900,
        '5': 13935,
        '6': 24665,
        '7': 41340
      },
      'physiology': {
        'head': [ 130, 130, 95 ],
        'neck-pouch': [ 140, 140, 130, 1 ],
        'body': [ 100, 110, 80 ],
        'back': [ 100, 110, 80, 1 ],
        'wings': [ 100, 100, 130, 1, [ 'b', 'd' ] ],
        'legs': [ 80, 90, 55 ],
        'tail': [ 90, 80, 55, 1, [ 'c', 'e', 'f' ] ]
      }
    },
    'jyur': {
      'biome': [ 'swamp' ],
      'weakness': [ 'thunder' ],
      'poison': 2,
      'paralysis': 2,
      'stun': 3,
      'sleep': 1,
      'hp': {
        '5': 4590,
        '6': 8200,
        '7': 13760,
        '8': 25720,
        '9': 54680,
        '10': 105600
      },
      'raid-hp': {
        '4': 5265,
        '5': 9290,
        '6': 16440,
        '7': 27560
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'b', 'f' ] ],
        'neck': [ 110, 120, 90 ],
        'body': [ 100, 110, 80, 1, [ 'c', 'd' ] ],
        'back': [ 80, 90, 65 ],
        'fins': [ 80, 80, 95 ],
        'hindlegs': [ 90, 100, 70, 1 ],
        'tail': [ 135, 130, 130, 1, [ 'e' ] ],
        'mud': [ 30 ],
        'water-mud': 1
      }
    },
    'anja': {
      'biome': [ 'forest', 'desert' ],
      'weakness': [ 'water' ],
      'poison': 2,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 6960,
        '6': 12200,
        '7': 20800,
        '8': 39040,
        '9': 83240,
        '10': 156880
      },
      'raid-hp': {
        '5': 13965,
        '6': 24400,
        '7': 41650
      },
      'physiology': {
        'head': [ 130, 135, 130, 1, [ 'c' ] ],
        'snout': [ 140, 140, 145 ],
        'neck': [ 90, 90, 65 ],
        'body': [ 90, 90, 80 ],
        'wings': [ 140, 110, 145 ],
        'hindlegs': [ 90, 100, 70, 1, [ 'd' ] ],
        'tail': [ 130, 120, 95, 2, [ 'b', 'e', 'f' ] ]
      }
    },
    'rathi': {
      'biome': [ 'forest', 'desert' ],
      'weakness': [ 'thunder', 'dragon' ],
      'poison': 1,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 6850,
        '6': 11920,
        '7': 20400,
        '8': 38240,
        '9': 81520,
        '10': 153640
      },
      'raid-hp': {
        '5': 13680,
        '6': 23905,
        '7': 40800
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'd' ] ],
        'body': [ 90, 100, 70 ],
        'back': [ 90, 100, 70, 1 ],
        'wings': [ 130, 130, 135, 1, [ 'b' ] ],
        'legs': [ 90, 90, 70 ],
        'tail': [ 120, 110, 90, 2, [ 'c', 'e', 'f' ] ],
        'tail-tip': [ 120, 120, 95 ]
      }
    },
    'p-rathi': {
      'biome': [ 'forest' ],
      'weakness': [ 'thunder', 'dragon' ],
      'poison': 1,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 8120,
        '6': 13140,
        '7': 23000,
        '8': 42920,
        '9': 91720,
        '10': 169150
      },
      'raid-hp': {},
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'd' ] ],
        'body': [ 90, 100, 70 ],
        'back': [ 90, 100, 70, 1 ],
        'wings': [ 130, 130, 135, 1, [ 'b' ] ],
        'legs': [ 90, 90, 70 ],
        'tail': [ 130, 120, 100, 2, [ 'c', 'e', 'f' ] ],
        'tail-tip': [ 130, 130, 130 ]
      }
    },
    'legi': {
      'biome': [ 'swamp' ],
      'weakness': [ 'fire' ],
      'poison': 3,
      'poison-dmg': 2,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 7440,
        '6': 13590,
        '7': 23840,
        '8': 45080,
        '9': 96520,
        '10': 174880
      },
      'raid-hp': {
        '5': 13965,
        '6': 24400,
        '7': 41650,
        '8': 78105
      },
      'physiology': {
        'head': [ 140, 145, 140, 1 ],
        'body': [ 80, 90, 65 ],
        'back': [ 80, 90, 65, 1 ],
        'wings': [ 130, 130, 140, 1, [ 'b', 'c', 'd', 'f' ] ],
        'legs': [ 90, 100, 70 ],
        'tail': [ 120, 110, 90, 1, [ 'e' ] ]
      }
    },
    'diab': {
      'biome': [ 'desert' ],
      'weakness': [ 'ice', 'dragon' ],
      'poison': 2,
      'paralysis': 3,
      'stun': 1,
      'sleep': 2,
      'hp': {
        '5': 6840,
        '6': 12480,
        '7': 21920,
        '8': 41420,
        '9': 88670,
        '10': 160600
      },
      'raid-hp': {
        '5': 12825,
        '6': 22410,
        '7': 38250,
        '8': 71730
      },
      'physiology': {
        'head': [ 110, 135, 90 ],
        'horns': [ 80, 100, 65, 1, [ 'f' ] ],
        'body': [ 140, 145, 90 ],
        'back': [ 80, 100, 65, 1, [ 'c', 'd', 'e' ] ],
        'wings': [ 110, 90, 135 ],
        'legs': [ 100, 100, 80 ],
        'tail': [ 130, 80, 80, 2, [ 'b', 'e' ] ],
        'tail-tip': [ 80, 90, 55 ]
      }
    },
    'b-diab': {
      'biome': [ 'desert' ],
      'weakness': [ 'ice' ],
      'poison': 2,
      'paralysis': 3,
      'stun': 1,
      'sleep': 2,
      'hp': {
        '5': 9800,
        '6': 16000,
        '7': 29000,
        '8': 55250,
        '9': 112080,
        '10': 187660
      },
      'raid-hp': {},
      'physiology': {
        'head': [ 105, 130, 80 ],
        'horns': [ 75, 95, 60, 1, [ 'f' ] ],
        'body': [ 135, 140, 85 ],
        'back': [ 75, 95, 60, 1, [ 'c', 'd', 'e' ] ],
        'wings': [ 105, 85, 130 ],
        'legs': [ 95, 95, 75 ],
        'tail': [ 130, 75, 75, 2, [ 'b', 'e' ] ],
        'tail-tip': [ 75, 85, 50 ]
      }
    },
    'ratha': {
      'biome': [ 'forest' ],
      'weakness': [ 'thunder', 'dragon' ],
      'poison': 1,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 8150,
        '6': 13160,
        '7': 23120,
        '8': 43720,
        '9': 93600,
        '10': 169520
      },
      'raid-hp': {
        '5': 13540,
        '6': 23655,
        '7': 40375,
        '8': 75715
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'd' ] ],
        'body': [ 90, 100, 70 ],
        'back': [ 90, 100, 70, 1, [ 'c' ] ],
        'wings': [ 130, 130, 135, 1 ],
        'legs': [ 90, 90, 70 ],
        'tail': [ 120, 110, 90, 2, [ 'b', 'c', 'e', 'f' ] ],
        'tail-tip': [ 120, 120, 95 ]
      }
    },
    'a-ratha': {
      'biome': [ 'forest' ],
      'weakness': [ 'ice', 'dragon' ],
      'poison': 1,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 9000,
        '6': 14580,
        '7': 25870,
        '8': 49020,
        '9': 105300,
        '10': 190150
      },
      'raid-hp': {},
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'd' ] ],
        'body': [ 90, 100, 70 ],
        'back': [ 90, 100, 70, 1, [ 'c' ] ],
        'wings': [ 130, 130, 135, 1 ],
        'legs': [ 80, 80, 65 ],
        'tail': [ 110, 100, 80, 2, [ 'b', 'c', 'e', 'f' ] ],
        'tail-tip': [ 140, 135, 135 ]
      }
    },
    'rado': {
      'biome': [ 'desert', 'swamp' ],
      'weakness': [ 'ice', 'dragon' ],
      'poison': 3,
      'paralysis': 2,
      'stun': 1,
      'sleep': 2,
      'hp': {
        '5': 5840,
        '6': 10440,
        '7': 17200,
        '8': 31940,
        '9': 67760,
        '10': 134600
      },
      'raid-hp': {
        '4': 7145,
        '5': 12610,
        '6': 22315,
        '7': 37400,
        '8': 75715
      },
      'physiology': {
        'head': [ 70, 100, 55, 1, [ 'c', 'f' ] ],
        '*head': [ 140, 145, 140 ],
        'neck': [ 90, 90, 70 ],
        'body': [ 70, 90, 55, 1, [ 'e' ] ],
        '*body': [ 125, 130, 95 ],
        'hindlegs': [ 70, 90, 55, 1, [ 'd' ] ],
        '*hindlegs': [ 130, 125, 130 ],
        'tail': [ 120, 110, 90, 2, [ 'b' ] ]
      }
    },
    'banb': {
      'biome': [ 'forest', 'swamp' ],
      'weakness': [ 'fire', 'dragon' ],
      'poison': 2,
      'paralysis': 2,
      'stun': 1,
      'sleep': 2,
      'hp': {
        '5': 4280,
        '6': 7600,
        '7': 11760,
        '8': 23880,
        '9': 46360,
        '10': 92080
      },
      'raid-hp': {
        '4': 4890,
        '5': 8625,
        '6': 15270,
        '7': 25590
      },
      'physiology': {
        'horns': [ 80, 100, 65, 1, [ 'e', 'f' ] ],
        'head': [ 140, 145, 140 ],
        'neck': [ 90, 100, 70 ],
        'body': [ 80, 90, 65 ],
        'hindlegs': [ 90, 100, 70, 1, [ 'd' ] ],
        '*hindlegs': [ 130, 135, 130 ],
        'tail': [ 100, 80, 65, 2, [ 'b', 'c' ] ]
      }
    },
    'bari': {
      'biome': [ 'forest' ],
      'weakness': [ 'fire' ],
      'poison': 2,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 6240,
        '6': 10920,
        '7': 18680,
        '8': 35040,
        '9': 74720,
        '10': 140840
      },
      'raid-hp': {
        '5': 12540,
        '6': 21910,
        '7': 37400,
        '8': 70135
      },
      'physiology': {
        'head': [ 140, 145, 140, 1, [ 'e' ] ],
        'body': [ 100, 110, 80 ],
        'back': [ 100, 110, 80 ],
        'wings': [ 110, 135, 80 ],
        'spikes': [ 130, 135, 130, 1, [ 'c', 'd' ] ],
        'hindlegs': [ 90, 100, 70 ],
        'tail': [ 130, 90, 130, 2, [ 'b', 'f' ] ],
        'tail-tip': [ 145, 130, 130 ]
      }
    },
    'zino': {
      'biome': [ 'forest', 'swamp' ],
      'weakness': [ 'ice' ],
      'poison': 2,
      'paralysis': 2,
      'stun': 2,
      'sleep': 2,
      'hp': {
        '5': 7480
      },
      'raid-hp': {
        '5': 14960,
        '6': 26145,
        '7': 44625,
        '8': 83685
      },
      'physiology': {
        'horns': [ 130, 135, 130, 1, [ 'e' ] ],
        '+horns': [ 140, 145, 140 ],
        'neck': [ 110, 110, 90 ],
        '+neck': [ 120, 120, 100 ],
        'body': [ 90, 100, 70 ],
        '+body': [ 80, 90, 65 ],
        'back': [ 80, 90, 65, 1, [ 'c' ] ],
        '+back': [ 90, 100, 70 ],
        'forelegs': [ 110, 120, 90, 1, [ 'd' ] ],
        '+forelegs': [ 120, 130, 95 ],
        'hindlegs': [ 90, 100, 70 ],
        '+hindlegs': [ 80, 90, 65 ],
        'tail': [ 120, 110, 90, 2, [ 'b', 'f' ] ],
        '+tail': [ 130, 120, 95 ]
      }
    }
  }

  mon_info = {
    alloy: {
      id: 14,
      unlock: 1,
      starter: 1,
      eff: {
        all: "white",
      },
      white: {
        base: "common-atk",
      },
      ammo: [
        ["normal", 5],
        ["pierce", 4],
      ],
      arrow: [
        ["rapid", 1],
        ["rapid", 2],
        ["rapid", 3],
        ["rapid", 4],
      ],
    },
    bone: {
      id: 23,
      unlock: 3,
      evtOnly: 1,
      eff: {
        all: "white",
      },
      white: {
        base: "common-atk",
      },
      ammo: [
        ["normal", 5],
        ["sticky", 2],
      ],
      arrow: [
        ["spread", 1],
        ["spread", 2],
        ["rapid", 3],
        ["rapid", 4],
      ],
    },
    leather: {
      id: 0,
      unlock: 1,
      starter: 1,
    },
    "g-jagr": {
      id: 1,
      unlock: 1,
      eff: {
        all: "water",
      },
      water: {
        base: "g-jagr-atk",
        ele: "g-jagr-ele",
      },
      ammo: [
        ["water", 6],
        ["slicing-water", 2],
      ],
    },
    kulu: {
      id: 2,
      unlock: 1,
      eff: {
        all: "white",
      },
      white: {
        base: "common-atk",
        crit: "common-crit",
      },
      arrow: [
        ["rapid", 1],
        ["rapid", 2],
        ["rapid", 3],
        ["pierce", 4],
      ],
    },
    puke: {
      id: 3,
      unlock: 1,
      eff: {
        all: "poison",
      },
      poison: {
        base: "common-atk",
        ele: "common-ele",
      },
      arrow: [
        ["rapid", 1],
        ["rapid", 2],
        ["rapid", 3],
        ["spread", 4],
      ],
      bottle: "poison",
    },
    barr: {
      id: 4,
      unlock: 1,
      eff: {
        all: "white",
      },
      white: {
        base: "barr-atk",
      },
      ammo: [
        ["normal", 4],
        ["spread", 3],
      ],
    },
    "g-girr": {
      id: 5,
      unlock: 2,
      eff: {
        all: "paralysis",
      },
      paralysis: {
        base: "common-atk",
        ele: "common-ele",
      },
    },
    tobi: {
      id: 6,
      unlock: 2,
      eff: {
        all: "thunder",
      },
      thunder: {
        base: "tobi-atk",
        ele: "tobi-ele",
      },
      ammo: [
        ["thunder", 5],
        ["slicing-thunder", 3],
      ],
      arrow: [
        ["pierce", 1],
        ["pierce", 2],
        ["pierce", 3],
        ["pierce", 4],
      ],
    },
    paol: {
      id: 7,
      unlock: 3,
      eff: {
        all: "white",
      },
      white: {
        base: "paol-atk",
      },
      ammo: [
        ["normal", 5],
        ["spread", 4],
        ["pierce", 4],
      ],
    },
    jyur: {
      id: 8,
      unlock: 3,
      eff: {
        all: "water",
      },
      water: {
        base: "tobi-atk",
        ele: "tobi-ele",
      },
      ammo: [
        ["water", 5],
        ["spread-water", 4],
        ["sticky-water", 2],
      ],
      arrow: [
        ["spread", 1],
        ["spread", 2],
        ["rapid", 3],
        ["rapid", 4],
      ],
    },
    anja: {
      id: 9,
      unlock: 4,
      eff: {
        all: "fire",
      },
      fire: {
        base: "tobi-atk",
        ele: "tobi-ele",
      },
      ammo: [
        ["fire", 6],
        ["sticky-fire", 3],
      ],
      arrow: [
        ["spread", 1],
        ["spread", 2],
        ["spread", 3],
        ["spread", 4],
      ],
    },
    rathi: {
      id: 10,
      unlock: 4,
      eff: {
        all: "poison",
      },
      poison: {
        base: "rathi-atk",
        ele: "rathi-ele",
      },
      arrow: [
        ["rapid", 1],
        ["rapid", 2],
        ["spread", 3],
        ["spread", 4],
      ],
      bottle: "poison",
    },
    legi: {
      id: 11,
      unlock: 5,
      eff: {
        all: "ice",
      },
      ice: {
        base: "legi-atk",
        ele: "legi-ele",
      },
      ammo: [
        ["ice", 5],
        ["spread-ice", 4],
        ["slicing-ice", 3],
      ],
      arrow: [
        ["pierce", 1],
        ["pierce", 2],
        ["rapid", 3],
        ["rapid", 4],
      ],
    },
    diab: {
      id: 12,
      unlock: 5,
      eff: {
        all: "white",
      },
      white: {
        base: "diab-atk",
      },
      arrow: [
        ["spread", 1],
        ["rapid", 2],
        ["spread", 3],
        ["rapid", 4],
      ],
    },
    ratha: {
      id: 13,
      unlock: 5,
      eff: {
        all: "fire",
      },
      fire: {
        base: "legi-atk",
        ele: "legi-ele",
      },
      ammo: [
        ["fire", 5],
        ["piercing-fire", 4],
        ["slicing-fire", 3],
      ],
      arrow: [
        ["rapid", 1],
        ["rapid", 2],
        ["pierce", 3],
        ["pierce", 4],
      ],
    },
    "p-rathi": {
      id: 16,
      unlock: 5,
      eventOnly: 1,
      eff: {
        "shield-sword": "poison",
        "long-sword": "poison",
        bow: "dragon",
        hammer: "dragon",
        "dual-blades": "dragon",
      },
      poison: {
        base: "p-rathi-atk",
        ele: "p-rathi-ele",
      },
      dragon: {
        base: "tobi-atk",
        ele: "tobi-ele",
      },
      arrow: [
        ["pierce", 2],
        ["pierce", 3],
        ["spread", 3],
        ["spread", 4],
      ],
    },
    "b-diab": {
      id: 15,
      unlock: 5,
      eventOnly: 1,
      eff: {
        all: "white",
      },
      white: {
        base: "b-diab-atk",
        crit: "b-diab-crit",
      },
      arrow: [
        ["pierce", 1],
        ["pierce", 1],
        ["pierce", 4],
        ["pierce", 4],
      ],
    },
    "a-ratha": {
      id: 17,
      unlock: 5,
      eventOnly: 1,
      eff: {
        all: "fire",
      },
      fire: {
        base: "a-ratha-atk",
        ele: "a-ratha-ele",
      },
      ammo: [
        ["fire", 5],
        ["piercing-fire", 4],
        ["sticky-fire", 2],
      ],
      arrow: [
        ["spread", 2],
        ["spread", 3],
        ["rapid", 3],
        ["rapid", 4],
      ],
    },
    zino: {
      id: 19,
      unlock: 5,
      eventOnly: 1,
      eff: {
        all: "thunder",
      },
      thunder: {
        base: "legi-atk",
        ele: "legi-ele",
      },
      ammo: [
        ["thunder", 5],
        ["piercing-thunder", 4],
        ["sticky-thunder", 2],
      ],
      arrow: [
        ["pierce", 1],
        ["pierce", 2],
        ["rapid", 3],
        ["rapid", 4],
      ],
    },
    bari: {
      id: 20,
      unlock: 4,
      eff: {
        all: "ice",
      },
      ice: {
        base: "bari-atk",
        ele: "tobi-ele",
        crit: "bari-crit",
      },
      ammo: [
        ["spread-ice", 3],
        ["piercing-ice", 3],
      ],
      arrow: [
        ["rapid", 1],
        ["rapid", 2],
        ["spread", 3],
        ["spread", 4],
      ],
    },
    banb: {
      id: 21,
      unlock: 3,
      eff: {
        all: "white",
      },
      white: {
        base: "paol-atk",
      },
      ammo: [
        ["normal", 5],
        ["spread", 4],
        ["sticky", 2],
      ],
      arrow: [
        ["pierce", 1],
        ["spread", 2],
        ["pierce", 3],
        ["spread", 4],
      ],
    },
    rado: {
      id: 22,
      unlock: 2,
      eff: {
        all: "sleep",
      },
      sleep: {
        base: "common-atk",
        ele: "common-ele",
      },
    },
    halloween: {
      id: 18,
      evtOnly: 1,
      unlock: 2,
    },
    "ny-24": {
      id: 24,
      evtOnly: 1,
      unlock: 4,
      matUntil: [4, 5],
    },
  }

  all = {
    armorVal: [
      20, 22, 25, 27, 29, 34, 36, 39, 41, 44, 49, 52, 54, 57, 60, 65, 68, 71, 73,
      76, 82, 85, 88, 91, 94, 100, 103, 106, 109, 113, 119, 122, 126, 129, 132,
      139, 142, 146, 149, 153, 160, 164, 167, 171, 175, 182, 186, 190, 193, 197,
    ],
    weaponVal: {
      "g-jagr-atk": [
        95, 102, 109, 116, 123, 135, 145, 155, 165, 174, 193, 207, 221, 235, 249,
        275, 295, 315, 335, 355, 391, 411, 430, 449, 469, 503, 528, 553, 578, 603,
        647, 679, 711, 743, 775, 832, 873, 914, 955, 996, 1068, 1121, 1174, 1227,
        1280, 1373, 1441, 1509, 1576, 1644,
      ],
      "g-jagr-ele": [
        25, 27, 29, 32, 34, 38, 41, 45, 49, 53, 59, 64, 70, 75, 81, 90, 98, 106,
        114, 122, 136, 145, 153, 162, 171, 184, 196, 208, 220, 232, 251, 266, 282,
        297, 313, 337, 358, 379, 400, 421, 453, 481, 509, 537, 565, 607, 644, 681,
        718, 754,
      ],
      "tobi-atk": [
        90, 97, 103, 110, 116, 128, 137, 147, 156, 165, 182, 196, 209, 222, 236,
        260, 279, 298, 317, 335, 370, 388, 406, 425, 443, 475, 499, 522, 546, 569,
        611, 641, 671, 701, 732, 784, 823, 862, 901, 939, 1007, 1057, 1107, 1156,
        1206, 1293, 1357, 1421, 1485, 1549,
      ],
      "tobi-ele": [
        30, 33, 36, 38, 41, 47, 52, 56, 61, 65, 75, 82, 89, 96, 103, 117, 128,
        138, 149, 159, 181, 193, 204, 216, 227, 251, 267, 283, 300, 316, 349, 371,
        393, 414, 436, 481, 511, 541, 571, 601, 663, 704, 745, 785, 826, 910, 965,
        1021, 1076, 1131,
      ],
      "legi-atk": [
        90, 97, 103, 110, 116, 127, 137, 146, 155, 164, 180, 193, 207, 220, 233,
        256, 274, 293, 311, 330, 361, 379, 397, 415, 433, 461, 484, 507, 530, 553,
        589, 618, 647, 676, 705, 751, 788, 826, 863, 900, 958, 1005, 1053, 1100,
        1147, 1221, 1281, 1342, 1402, 1463,
      ],
      "legi-ele": [
        39, 43, 46, 50, 54, 61, 67, 73, 79, 85, 97, 106, 115, 124, 133, 150, 164,
        177, 191, 205, 232, 246, 261, 276, 291, 320, 341, 361, 382, 402, 443, 471,
        499, 526, 554, 608, 646, 684, 722, 760, 835, 887, 938, 989, 1041, 1142,
        1211, 1281, 1350, 1420,
      ],
      "common-atk": [
        100, 107, 115, 122, 129, 144, 154, 165, 175, 186, 207, 222, 237, 253, 268,
        299, 321, 342, 364, 385, 430, 451, 473, 494, 515, 559, 587, 614, 642, 670,
        727, 763, 799, 835, 871, 945, 992, 1038, 1085, 1132, 1228, 1289, 1349,
        1410, 1471, 1596, 1675, 1754, 1833, 1912,
      ],
      "common-ele": [
        50, 58, 67, 75, 83, 100, 108, 117, 125, 133, 150, 158, 167, 175, 183, 200,
        208, 217, 225, 233, 250, 258, 267, 275, 283, 300, 304, 308, 312, 317, 325,
        329, 333, 337, 342, 350, 354, 358, 362, 367, 375, 379, 383, 387, 392, 400,
        404, 408, 412, 417,
      ],
      "common-crit": [
        5, 5, 5, 5, 5, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15, 15, 15, 15, 15,
        15, 15, 15, 15, 15, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 25, 25, 25,
        25, 25, 25, 25, 25, 25, 25, 30, 30, 30, 30, 30,
      ],
      "rathi-atk": [
        95, 102, 109, 116, 123, 137, 147, 157, 166, 176, 197, 211, 225, 240, 254,
        284, 305, 325, 346, 366, 409, 429, 449, 469, 489, 531, 557, 584, 610, 636,
        691, 725, 759, 793, 827, 898, 942, 986, 1031, 1075, 1167, 1224, 1282,
        1340, 1397, 1516, 1591, 1666, 1741, 1817,
      ],
      "rathi-ele": [
        58, 67, 76, 86, 95, 116, 126, 135, 145, 154, 176, 185, 195, 204, 214, 236,
        246, 255, 265, 275, 298, 307, 317, 327, 337, 360, 365, 370, 375, 380, 393,
        398, 403, 408, 413, 427, 432, 437, 442, 447, 461, 466, 471, 476, 482, 496,
        501, 506, 511, 516,
      ],
      "p-rathi-atk": [
        110, 118, 126, 134, 142, 158, 170, 181, 193, 204, 228, 244, 261, 278, 294,
        329, 353, 376, 400, 424, 473, 496, 520, 543, 567, 615, 645, 676, 706, 737,
        800, 839, 879, 918, 958, 1040, 1091, 1142, 1194, 1245, 1351, 1418, 1484,
        1551, 1618, 1756, 1843, 1929, 2016, 2103,
      ],
      "p-rathi-ele": [
        38, 44, 50, 56, 62, 75, 81, 87, 94, 100, 113, 119, 125, 131, 137, 150,
        156, 162, 169, 175, 188, 194, 200, 206, 212, 225, 228, 231, 234, 237, 244,
        247, 250, 253, 256, 263, 266, 269, 272, 275, 281, 284, 287, 291, 294, 300,
        303, 306, 309, 312,
      ],
      "barr-atk": [
        110, 118, 126, 134, 142, 158, 170, 181, 193, 204, 228, 244, 261, 278, 294,
        329, 353, 376, 400, 424, 473, 496, 520, 543, 567, 615, 645, 676, 706, 737,
        800, 839, 879, 918, 958, 1040, 1091, 1142, 1194, 1245, 1351, 1418, 1484,
        1551, 1618, 1756, 1843, 1929, 2016, 2103,
      ],
      "paol-atk": [
        115, 123, 132, 140, 148, 165, 177, 189, 201, 212, 236, 253, 271, 288, 305,
        339, 364, 388, 413, 437, 486, 510, 534, 558, 582, 629, 660, 691, 722, 754,
        814, 855, 895, 935, 975, 1054, 1106, 1158, 1210, 1262, 1363, 1430, 1498,
        1565, 1633, 1764, 1851, 1938, 2026, 2113,
      ],
      "diab-atk": [
        115, 123, 132, 140, 148, 167, 179, 191, 203, 215, 242, 260, 278, 295, 313,
        353, 378, 404, 429, 455, 512, 537, 562, 588, 613, 671, 704, 737, 771, 804,
        880, 923, 967, 1010, 1054, 1153, 1210, 1267, 1324, 1381, 1510, 1585, 1660,
        1734, 1809, 1979, 2077, 2175, 2273, 2371,
      ],
      "b-diab-atk": [
        130, 139, 149, 158, 168, 189, 202, 216, 229, 243, 273, 293, 313, 333, 353,
        398, 426, 455, 484, 513, 576, 605, 633, 662, 690, 755, 792, 829, 867, 904,
        989, 1038, 1087, 1135, 1184, 1295, 1359, 1423, 1487, 1551, 1695, 1778,
        1862, 1946, 2030, 2218, 2328, 2438, 2548, 2658,
      ],
      "b-diab-crit": [
        -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30,
        -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30,
        -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30, -30,
        -30, -30, -30, -30, -30,
      ],
      "a-ratha-atk": [
        100, 107, 115, 122, 129, 145, 155, 166, 176, 187, 209, 225, 240, 256, 271,
        304, 326, 348, 370, 392, 440, 462, 484, 506, 528, 576, 604, 633, 661, 690,
        753, 790, 828, 865, 902, 985, 1033, 1082, 1131, 1179, 1287, 1351, 1414,
        1478, 1541, 1682, 1765, 1849, 1932, 2015,
      ],
      "a-ratha-ele": [
        24, 26, 28, 31, 33, 37, 41, 44, 48, 51, 58, 63, 68, 74, 79, 88, 96, 104,
        112, 120, 134, 142, 151, 160, 168, 182, 194, 205, 217, 229, 248, 263, 279,
        294, 310, 334, 355, 376, 397, 418, 451, 479, 506, 534, 562, 605, 642, 679,
        715, 752,
      ],
      "bari-atk": [
        80, 87, 93, 99, 105, 116, 124, 132, 140, 148, 164, 176, 188, 200, 211,
        234, 251, 268, 285, 301, 334, 350, 367, 383, 400, 430, 452, 473, 494, 516,
        555, 583, 610, 638, 665, 716, 752, 787, 822, 858, 923, 969, 1015, 1060,
        1106, 1191, 1250, 1309, 1367, 1426,
      ],
      "bari-crit": [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 10, 10, 10,
        10, 10, 10, 10, 10, 10, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 20, 20,
        20, 20, 20, 20, 20, 20, 20, 20, 20,
      ],
    },
    forgeWeaponCost: {
      1 => [10, 2, 2],
      2 => [300, 3, 1, 1],
      3 => [600, 5, 2, 3],
      4 => [900, 4, 2, 2, 8],
      5 => [1500, 6, 2, 2, 10],
    },
    forgeArmorCost: {
      1 => [10, 2, 2],
      2 => [300, 2, 1, 1],
      3 => [600, 4, 2, 2],
      4 => [900, 3, 1, 2, 6],
      5 => [1500, 4, 2, 2, 7],
    },
    weaponCost: {
      1 => {
        1 => [10, 2, 2],
        2 => [20, 2, 2],
        3 => [30, 2, 1],
        4 => [40, 2, 2],
        5 => [50, 2, 2],
      },
      2 => {
        1 => [300, 3, 1, 1],
        2 => [100, 3, 4, 4],
        3 => [150, 3, 3, 3],
        4 => [200, 3, 4, 4],
        5 => [250, 3, 1, 3],
      },
      3 => {
        1 => [600, 5, 2, 3],
        2 => [200, 5, 12, 8],
        3 => [300, 5, 6, 5],
        4 => [400, 5, 12, 8],
        5 => [500, 5, 2, 6],
      },
      4 => {
        1 => [900, 8, 4, 2, 8],
        2 => [300, 8, 24, 16],
        3 => [450, 8, 9, 8],
        4 => [600, 8, 24, 16],
        5 => [750, 8, 3, 12],
      },
      5 => {
        1 => [1500, 12, 6, 4, 10],
        2 => [500, 12, 32, 24],
        3 => [750, 12, 12, 15],
        4 => [1000.0, 12, 32, 24],
        5 => [1250, 12, 4, 16],
      },
      6 => {
        1 => [3000.0, 18, 6, 2, 1],
        2 => [1000.0, 18, 44, 32, 4],
        3 => [1500, 18, 20, 15, 20],
        4 => [2000.0, 18, 44, 32, 4],
        5 => [2500, 18, 20, 7, 20],
      },
      7 => {
        1 => [6000.0, 24, 12, 3, 3],
        2 => [2000.0, 24, 51, 42, 6],
        3 => [3000.0, 24, 30, 20, 31],
        4 => [4000.0, 24, 51, 42, 6],
        5 => [5000.0, 24, 30, 11, 31],
      },
      8 => {
        1 => [12000.0, 5, 4, 5],
        2 => [4000.0, 40, 64, 53, 4],
        3 => [6000.0, 30, 4, 40, 41],
        4 => [8000.0, 20, 64, 53, 4],
        5 => [10000.0, 100, 4, 17, 41],
      },
      9 => {
        1 => [30000.0, 10, 6, 7],
        2 => [10000.0, 50, 73, 61, 6],
        3 => [15000.0, 40, 6, 49, 52],
        4 => [20000.0, 30, 73, 61, 6],
        5 => [25000.0, 200, 6, 21, 52],
      },
      10 => {
        1 => [75000.0, 20, 10, 9],
        2 => [25000.0, 60, 85, 73, 8],
        3 => [37500, 50, 20, 59, 63],
        4 => [50000.0, 40, 85, 73, 8],
        5 => [62500, 300, 30, 31, 63],
      },
    },
    armorCost: {
      1 => {
        1 => [10, 2, 2],
        2 => [20, 2, 2],
        3 => [30, 2, 1],
        4 => [40, 2, 2],
        5 => [50, 2, 2],
      },
      2 => {
        1 => [300, 2, 1, 1],
        2 => [100, 2, 4, 3],
        3 => [150, 2, 2, 2],
        4 => [200, 2, 4, 3],
        5 => [250, 2, 1, 2],
      },
      3 => {
        1 => [600, 4, 2, 2],
        2 => [200, 4, 9, 6],
        3 => [300, 4, 3, 4],
        4 => [400, 4, 9, 6],
        5 => [500, 4, 1, 4],
      },
      4 => {
        1 => [900, 6, 2, 2, 6],
        2 => [300, 6, 17, 11],
        3 => [450, 6, 5, 6],
        4 => [600, 6, 17, 11],
        5 => [750, 6, 2, 8],
      },
      5 => {
        1 => [1500, 8, 3, 3, 7],
        2 => [500, 8, 22, 17],
        3 => [750, 8, 6, 11],
        4 => [1000.0, 8, 22, 17],
        5 => [1250, 8, 3, 11],
      },
      6 => {
        1 => [3000.0, 13, 3, 2, 1],
        2 => [1000.0, 13, 31, 22, 2],
        3 => [1500, 13, 10, 8, 14],
        4 => [2000.0, 13, 31, 22, 2],
        5 => [2500, 13, 14, 5, 14],
      },
      7 => {
        1 => [6000.0, 17, 6, 2, 3],
        2 => [2000.0, 17, 36, 29, 3],
        3 => [3000.0, 17, 15, 10, 22],
        4 => [4000.0, 17, 36, 29, 3],
        5 => [5000.0, 17, 21, 8, 22],
      },
      8 => {
        1 => [12000.0, 3, 2, 5],
        2 => [4000.0, 20, 45, 37, 2],
        3 => [6000.0, 15, 2, 28, 29],
        4 => [8000.0, 10, 45, 37, 2],
        5 => [10000.0, 70, 2, 12, 29],
      },
      9 => {
        1 => [30000.0, 5, 3, 7],
        2 => [10000.0, 25, 51, 43, 3],
        3 => [15000.0, 20, 3, 34, 36],
        4 => [20000.0, 15, 51, 43, 3],
        5 => [25000.0, 140, 3, 15, 36],
      },
      10 => {
        1 => [75000.0, 10, 5, 9],
        2 => [25000.0, 30, 60, 51, 4],
        3 => [37500, 25, 10, 41, 44],
        4 => [50000.0, 20, 60, 51, 4],
        5 => [62500, 210, 15, 22, 44],
      },
    },
    itemType: {
      alloy: ["b", "g", "2", "g-jagr"],
      bone: ["c", "g", "1", "g-jagr"],
      leather: ["b", "g", "2", "g-jagr"],
      "g-jagr": ["b", "b", "2", "jyur"],
      kulu: ["c", "g", "1", "g-jagr"],
      puke: ["a", "e", "2", "rathi"],
      barr: ["a", "g", "1", "diab"],
      "g-girr": ["b", "d", "2", "tobi"],
      tobi: ["c", "f", "1", "g-girr"],
      paol: ["a", "g", "2", "legi"],
      jyur: ["a", "b", "1", "g-jagr"],
      anja: ["c", "a", "1", "ratha"],
      rathi: ["c", "e", "1", "puke"],
      legi: ["b", "c", "2", "paol"],
      diab: ["a", "g", "1", "barr"],
      ratha: ["b", "a", "2", "anja"],
      "b-diab": ["a", "g", "1", "diab"],
      "p-rathi": ["c", "e", "1", "rathi"],
      "a-ratha": ["b", "a", "2", "ratha"],
      halloween: ["c", "a", "1", "g-jagr"],
      rado: ["c", "h", "1", "g-girr"],
      banb: ["c", "g", "1", "barr"],
      bari: ["b", "c", "2", "banb"],
      zino: ["a", "f", "2", "tobi"],
    },
    costType: {
      1 => {
        1 => ["z", "a", "ha"],
        2 => ["z", "a", "j"],
        3 => ["z", "a", "b"],
        4 => ["z", "a", "j"],
        5 => ["z", "a", "ha"],
      },
      2 => {
        1 => ["z", "a", "c", "hb"],
        2 => ["z", "a", "j", "ha"],
        3 => ["z", "a", "b", "g"],
        4 => ["z", "a", "j", "ha"],
        5 => ["z", "a", "hc", "f"],
      },
      3 => {
        1 => ["z", "a", "c", "hb"],
        2 => ["z", "a", "j", "ha"],
        3 => ["z", "a", "b", "g"],
        4 => ["z", "a", "j", "ha"],
        5 => ["z", "a", "hc", "f"],
      },
      4 => {
        1 => ["z", "a", "c", "d", "hb"],
        2 => ["z", "a", "j", "ha"],
        3 => ["z", "a", "b", "g"],
        4 => ["z", "a", "j", "ha"],
        5 => ["z", "a", "hc", "f"],
      },
      5 => {
        1 => ["z", "a", "c", "d", "hb"],
        2 => ["z", "a", "j", "ha"],
        3 => ["z", "a", "b", "g"],
        4 => ["z", "a", "j", "ha"],
        5 => ["z", "a", "hc", "f"],
      },
      6 => {
        1 => ["z", "a", "d", "e", "k"],
        2 => ["z", "a", "j", "ha", "ib"],
        3 => ["z", "a", "b", "c", "g"],
        4 => ["z", "a", "j", "ha", "ic"],
        5 => ["z", "a", "hb", "hc", "f"],
      },
      7 => {
        1 => ["z", "a", "d", "e", "k"],
        2 => ["z", "a", "j", "ha", "ib"],
        3 => ["z", "a", "b", "c", "g"],
        4 => ["z", "a", "j", "ha", "ic"],
        5 => ["z", "a", "hb", "hc", "f"],
      },
      8 => {
        1 => ["z", "e", "l", "k"],
        2 => ["z", "b", "j", "ha", "id"],
        3 => ["z", "c", "l", "hb", "g"],
        4 => ["z", "d", "j", "ha", "ie"],
        5 => ["z", "a", "l", "hc", "f"],
      },
      9 => {
        1 => ["z", "e", "l", "k"],
        2 => ["z", "b", "j", "ha", "id"],
        3 => ["z", "c", "l", "hb", "g"],
        4 => ["z", "d", "j", "ha", "ie"],
        5 => ["z", "a", "l", "hc", "f"],
      },
      10 => {
        1 => ["z", "e", "l", "k"],
        2 => ["z", "b", "j", "ha", "id"],
        3 => ["z", "c", "l", "hb", "g"],
        4 => ["z", "d", "j", "ha", "ie"],
        5 => ["z", "a", "l", "hc", "f"],
      },
    },
    item: {
      alloy: {
        a2: "Iron Ore",
        b: "Machalite Ore",
        c: "Dragonite Ore",
      },
      bone: {
        b: "2024 Weapon Ticket",
      },
      leather: {
        a1: "Iron Ore",
        b: "Machalite Ore",
        c: "Dragonite Ore",
      },
      "g-jagr": {
        a1: "Great Jagras Hide",
        a2: "Great Jagras Scale",
        b: "Great Jagras Claw",
        c: "Great Jagras Mane",
        d: "Great Jagras Primescale",
        e: "Fanged Wyvern Gem",
      },
      kulu: {
        a1: "Kulu-Ya-Ku Hide",
        a2: "Kulu-Ya-Ku Scale",
        b: "Kulu-Ya-Ku Beak",
        c: "Kulu-Ya-Ku Plume",
        d: "Kulu-Ya-Ku Primescale",
        e: "Kulu-Ya-Ku Primehide",
      },
      puke: {
        a1: "Pukei-Pukei Shell",
        a2: "Pukei-Pukei Scale",
        b: "Pukei-Pukei Tail",
        c: "Pukei-Pukei Sac",
        d: "Pukei-Pukei Quill",
        e: "Pukei-Pukei Primescale",
      },
      barr: {
        a1: "Barroth Shell",
        a2: "Barroth Claw",
        b: "Barroth Tail",
        c: "Barroth Scalp",
        d: "Barroth Ridge",
        e: "Barroth Primeshell",
      },
      "g-girr": {
        a1: "Great Girros Scale",
        a2: "Great Girros Fang",
        b: "Great Girros Tail",
        c: "Great Girros Hood",
        d: "Great Girros Primescale",
        e: "Great Girros Primefang",
      },
      tobi: {
        a1: "Tobi-Kadachi Scale",
        a2: "Tobi-Kadachi Claw",
        b: "Tobi-Kadachi Pelt",
        c: "Tobi-Kadachi Membrane",
        d: "Tobi-Kadachi Primescale",
        e: "Tobi-Kadachi Electrode",
      },
      paol: {
        a1: "Paolumu Pelt",
        a2: "Paolumu Scale",
        b: "Paolumu Webbing",
        c: "Paolumu Shell",
        d: "Paolumu Primescale",
        e: "Paolumu Primeshell",
      },
      jyur: {
        a1: "Jyuratodus Shell",
        a2: "Jyuratodus Scale",
        b: "Jyuratodus Fang",
        c: "Jyuratodus Fin",
        d: "Jyuratodus Primescale",
        e: "Jyuratodus Primeshell",
      },
      anja: {
        a1: "Anjanath Scale",
        a2: "Anjanath Fang",
        b: "Anjanath Tail",
        c: "Anjanath Nosebone",
        d: "Anjanath Primescale",
        e: "Anjanath Plate",
      },
      rathi: {
        a1: "Rathian Shell",
        a2: "Rathian Scale",
        b: "Rathian Webbing",
        c: "Rathian Spike",
        d: "Rathian Primescale",
        e: "Rathian Plate",
      },
      legi: {
        a1: "Legiana Hide",
        a2: "Legiana Scale",
        b: "Legiana Claw",
        c: "Legiana Webbing",
        d: "Legiana Primescale",
        e: "Legiana Plate",
      },
      diab: {
        a1: "Diablos Shell",
        a2: "Diablos Fang",
        b: "Diablos Tailcase",
        c: "Diablos Ridge",
        d: "Diablos Primeshell",
        e: "Diablos Marrow",
      },
      ratha: {
        a1: "Rathalos Wingtalon",
        a2: "Rathalos Scale",
        b: "Rathalos Tail",
        c: "Rathalos Marrow",
        d: "Rathalos Primescale",
        e: "Rathalos Plate",
      },
      "b-diab": {
        a1: "Black Diablos Shell",
        a2: "Black Diablos Fang",
        b: "Black Diablos Tailcase",
        c: "Black Diablos Ridge",
        d: "Black Diablos Primeshell",
        e: "Black Diablos Marrow",
      },
      "p-rathi": {
        a1: "Pink Rathian Shell",
        a2: "Pink Rathian Scale",
        b: "Pink Rathian Webbing",
        c: "Pink Rathian Spike",
        d: "Pink Rathian Primescale",
        e: "Pink Rathian Plate",
      },
      "a-ratha": {
        a1: "Azure Rathalos Wingtalon",
        a2: "Azure Rathalos Scale",
        b: "Azure Rathalos Tail",
        c: "Azure Rathalos Marrow",
        d: "Azure Rathalos Primescale",
        e: "Azure Rathalos Plate",
      },
      rado: {
        a1: "Radobaan Shell",
        a2: "Radobaan Scale",
        b: "Radobaan Tail",
        c: "Radobaan Oilshell",
        d: "Radobaan Primescale",
        e: "Radobaan Marrow",
      },
      banb: {
        a1: "Banbaro Ridge",
        a2: "Banbaro Shell",
        b: "Banbaro Tail",
        c: "Banbaro Pelt",
        d: "Banbaro Primeshell",
        e: "Banbaro Great Horn",
      },
      bari: {
        a1: "Barioth Shell",
        a2: "Barioth Claw",
        b: "Barioth Tail",
        c: "Barioth Spike",
        d: "Barioth Primeclaw",
        e: "Amber Fang",
      },
      zino: {
        a1: "Zinogre Shell",
        a2: "Zinogre Claw",
        b: "Zinogre Tail",
        c: "Zinogre Shockfur",
        d: "Zinogre Primeclaw",
        e: "Zinogre Horn",
        f: "Zinogre Plate",
      },
      halloween: {
        a1: "Kulu-Ya-Ku Hide",
        b: "Pumpkin Ticket",
        c: "Kulu-Ya-Ku Plume",
        d: "Kulu-Ya-Ku Primescale",
        e: "Kulu-Ya-Ku Primehide",
      },
      "ny-24": {
        b: "2024 Armor Ticket",
      },
      f: {
        a: "Carpenterbug",
        b: "Earth Crystal",
        c: "Monster Bone+",
      },
      g: {
        a: "Fire Herb",
        b: "Flowfern",
        c: "Snow Herb",
        d: "Parashroom",
        e: "Toadstool",
        f: "Thunderbug",
        g: "Godbug",
        h: "Sleep Herb",
      },
      h1: {
        a: "Monster Bone S",
        b: "Monster Bone M",
        c: "Monster Bone L",
      },
      h2: {
        a: "Iron Ore",
        b: "Machalite Ore",
        c: "Dragonite Ore",
      },
      j1: "Wingdrake Hide",
      j2: "Sharp Claw",
      k1: "Armor Refining Parts",
      k2: "Weapon Refining Parts",
      l: "Wyvern Gem Shard",
      z: "Zenny",
    },
  }

  def translation_table(equipable, data)
    if equipable.monster.nil?
      printf("no_monster: %s\n", equipable.name)
    end
    mon_key = equipable.monster&.key&.to_sym || :alloy

    main_map = {
      j1: "Wingdrake Hide",
      j2: "Sharp Claw",
      k1: "Armor Refining Parts",
      k2: "Weapon Refining Parts",
      l: "Wyvern Gem Shard",
      z: "Zenny",
    }

    a = equipable.armor? ? :a1 : :a2
    j = equipable.armor? ? :j1 : :j2
    k = equipable.armor? ? :k1 : :k2
    
    f_code, g_code, h_code, alt_mon = data[:itemType][mon_key]

    f_map = {
      a: 'Carpenterbug',
      b: 'Earth Crystal',
      c: 'Monster Bone+',
    }
    g_map = {
      a: "Fire Herb",
      b: "Flowfern",
      c: "Snow Herb",
      d: "Parashroom",
      e: "Toadstool",
      f: "Thunderbug",
      g: "Godbug",
      h: "Sleep Herb",
    }
    h_map =
      if h_code == "1"
        {
          ha: 'Monster Bone S',
          hb: 'Monster Bone M',
          hc: 'Monster Bone L',
        }
      else
        {
          ha: 'Iron Ore',
          hb: 'Machalite Ore',
          hc: 'Dragonite Ore',
        }
      end
    monster_items = data[:item][mon_key]
    alt_monster_items = data[:item][alt_mon.to_sym].transform_keys { |k| ['i', k].join.to_sym }

    {
      a: monster_items[a],
      **monster_items.slice(*%i[b c d e]),
      f: f_map[f_code.to_sym],
      g: g_map[g_code.to_sym],
      **h_map,
      **alt_monster_items.slice(*['ib', 'ic', 'id', 'ie'].map(&:to_sym)),
      j: main_map[j],
      k: main_map[k],
      l: main_map[:l],
      z: main_map[:z],
    }
  end

  equipables = {}
  weapons = [
    [3, 'Aqua Messer 1', 182, 0, water, 75, :shield_sword, 'Aqua Messer', jyuratodus],
    [4, 'Aqua Messer 2', 260, 0, water, 117, :shield_sword, 'Aqua Messer', jyuratodus],
    [5, 'Aqua Messer 3', 370, 0, water, 181, :shield_sword, 'Aqua Messer', jyuratodus],
    [6, 'Rogue Wave 1', 475, 0, water, 251, :shield_sword, 'Aqua Messer', jyuratodus],
    [7, 'Rogue Wave 2', 611, 0, water, 349, :shield_sword, 'Aqua Messer', jyuratodus],
    [8, 'Rogue Wave 3', 784, 0, water, 481, :shield_sword, 'Aqua Messer', jyuratodus],
    [9, 'Rogue Wave 4', 1007, 0, water, 663, :shield_sword, 'Aqua Messer', jyuratodus],
    [10, 'Rogue Wave 5', 1293, 0, water, 910, :shield_sword, 'Aqua Messer', jyuratodus],

    [4, 'Blazing Edge 1', 260, 0, fire, 117, :shield_sword, 'Blazing Edge', anjanath],
    [5, 'Blazing Edge 2', 370, 0, fire, 181, :shield_sword, 'Blazing Edge', anjanath],
    [6, 'Flammensucher 1', 475, 0, fire, 251, :shield_sword, 'Blazing Edge', anjanath],
    [7, 'Flammensucher 2', 611, 0, fire, 349, :shield_sword, 'Blazing Edge', anjanath],
    [8, 'Flammensucher 3', 784, 0, fire, 481, :shield_sword, 'Blazing Edge', anjanath],
    [9, 'Flammensucher 4', 1007, 0, fire, 663, :shield_sword, 'Blazing Edge', anjanath],
    [10, 'Flammensucher 5', 1293, 0, fire, 910, :shield_sword, 'Blazing Edge', anjanath],

    [1, 'Blooming Knife 1', 100, 0, poison, 50, :shield_sword, 'Blooming Knife', pukei_pukei],
    [2, 'Blooming Knife 2', 144, 0, poison, 100, :shield_sword, 'Blooming Knife', pukei_pukei],
    [3, 'Blooming Knife 3', 207, 0, poison, 150, :shield_sword, 'Blooming Knife', pukei_pukei],
    [4, 'Blooming Knife 4', 299, 0, poison, 200, :shield_sword, 'Blooming Knife', pukei_pukei],
    [5, 'Blooming Knife 5', 430, 0, poison, 250, :shield_sword, 'Blooming Knife', pukei_pukei],
    [6, 'Datura Blossom 1', 559, 0, poison, 300, :shield_sword, 'Blooming Knife', pukei_pukei],
    [7, 'Datura Blossom 2', 727, 0, poison, 325, :shield_sword, 'Blooming Knife', pukei_pukei],
    [8, 'Datura Blossom 3', 945, 0, poison, 350, :shield_sword, 'Blooming Knife', pukei_pukei],
    [9, 'Datura Blossom 4', 1228, 0, poison, 375, :shield_sword, 'Blooming Knife', pukei_pukei],
    [10, 'Datura Blossom 5', 1596, 0, poison, 400, :shield_sword, 'Blooming Knife', pukei_pukei],

    [1, 'Carapace Edge 1', 110, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [2, 'Carapace Edge 2', 158, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [3, 'Carapace Edge 3', 228, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [4, 'Carapace Edge 4', 329, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [5, 'Carapace Edge 5', 473, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [6, 'Barroth Club 1', 615, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [7, 'Barroth Club 2', 800, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [8, 'Barroth Club 3', 1040, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [9, 'Barroth Club 4', 1351, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],
    [10, 'Barroth Club 5', 1756, 0, nil, 0, :shield_sword, 'Carapace Edge', barroth],

    [5, 'Flame Knife 1', 361, 0, fire, 232, :shield_sword, 'Flame Knife', rathalos],
    [6, 'Heat Edge 1', 461, 0, fire, 320, :shield_sword, 'Flame Knife', rathalos],
    [7, 'Heat Edge 2', 589, 0, fire, 443, :shield_sword, 'Flame Knife', rathalos],
    [8, 'Heat Edge 3', 751, 0, fire, 608, :shield_sword, 'Flame Knife', rathalos],
    [9, 'Heat Edge 4', 958, 0, fire, 835, :shield_sword, 'Flame Knife', rathalos],
    [10, 'Heat Edge 5', 1221, 0, fire, 1142, :shield_sword, 'Flame Knife', rathalos],

    [2, "Girros Knife 1", 144, 0, paralysis, 100, :shield_sword, 'Girros Knife', great_girros],
    [3, "Girros Knife 2", 207, 0, paralysis, 150, :shield_sword, 'Girros Knife', great_girros],
    [4, "Girros Knife 3", 299, 0, paralysis, 200, :shield_sword, 'Girros Knife', great_girros],
    [5, "Girros Knife 4", 430, 0, paralysis, 250, :shield_sword, 'Girros Knife', great_girros],
    [6, "Malady's Tabar 1", 559, 0, paralysis, 300, :shield_sword, 'Girros Knife', great_girros],
    [7, "Malady's Tabar 2", 727, 0, paralysis, 325, :shield_sword, 'Girros Knife', great_girros],
    [8, "Malady's Tabar 3", 945, 0, paralysis, 350, :shield_sword, 'Girros Knife', great_girros],
    [9, "Malady's Tabar 4", 1228, 0, paralysis, 375, :shield_sword, 'Girros Knife', great_girros],
    [10, "Malady's Tabar 5", 1596, 0, paralysis, 400, :shield_sword, 'Girros Knife', great_girros],

    [5, "Glacial Grace 1", 361, 0, ice, 232, :shield_sword, 'Glacial Grace', legiana],
    [6, "Rimespire 1", 461, 0, ice, 320, :shield_sword, 'Glacial Grace', legiana],
    [7, "Rimespire 2", 589, 0, ice, 443, :shield_sword, 'Glacial Grace', legiana],
    [8, "Rimespire 3", 751, 0, ice, 608, :shield_sword, 'Glacial Grace', legiana],
    [9, "Rimespire 4", 958, 0, ice, 835, :shield_sword, 'Glacial Grace', legiana],
    [10, "Rimespire 5", 1221, 0, ice, 1142, :shield_sword, 'Glacial Grace', legiana],

    [1, "Hunter's Knife 1", 100, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [2, "Hunter's Knife 2", 144, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [3, "Hunter's Knife 3", 207, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [4, "Hunter's Knife 4", 299, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [5, "Hunter's Knife 5", 430, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [6, "Steel Knife 1", 559, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [7, "Steel Knife 2", 727, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [8, "Steel Knife 3", 945, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [9, "Steel Knife 4", 1228, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],
    [10, "Steel Knife 5", 1596, 0, nil, 0, :shield_sword, "Hunter's Knife", nil],

    [1, "Jagras Edge 1", 95, 0, water, 25, :shield_sword, "Jagras Edge", great_jagras],
    [2, "Jagras Edge 2", 135, 0, water, 38, :shield_sword, "Jagras Edge", great_jagras],
    [3, "Jagras Edge 3", 193, 0, water, 59, :shield_sword, "Jagras Edge", great_jagras],
    [4, "Jagras Edge 4", 275, 0, water, 90, :shield_sword, "Jagras Edge", great_jagras],
    [5, "Jagras Edge 5", 391, 0, water, 136, :shield_sword, "Jagras Edge", great_jagras],
    [6, "Jagras Garotte 1", 503, 0, water, 184, :shield_sword, "Jagras Edge", great_jagras],
    [7, "Jagras Garotte 2", 647, 0, water, 251, :shield_sword, "Jagras Edge", great_jagras],
    [8, "Jagras Garotte 3", 832, 0, water, 337, :shield_sword, "Jagras Edge", great_jagras],
    [9, "Jagras Garotte 4", 1068, 0, water, 453, :shield_sword, "Jagras Edge", great_jagras],
    [10, "Jagras Garotte 5", 1373, 0, water, 607, :shield_sword, "Jagras Edge", great_jagras],

    [3, "Lumu Knife 1", 236, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [4, "Lumu Knife 2", 339, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [5, "Lumu Knife 3", 486, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [6, "Lumu Tabar 1", 629, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [7, "Lumu Tabar 2", 814, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [8, "Lumu Tabar 3", 1054, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [9, "Lumu Tabar 4", 1363, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],
    [10, "Lumu Tabar 5", 1764, 0, nil, 0, :shield_sword, "Lumu Knife", paolumu],

    [4, "Princess Rapier 1", 284, 0, poison, 236, :shield_sword, "Princess Rapier", rathian],
    [5, "Princess Rapier 2", 409, 0, poison, 298, :shield_sword, "Princess Rapier", rathian],
    [6, "Queen Rapier 1", 531, 0, poison, 360, :shield_sword, "Princess Rapier", rathian],
    [7, "Queen Rapier 2", 691, 0, poison, 393, :shield_sword, "Princess Rapier", rathian],
    [8, "Queen Rapier 3", 898, 0, poison, 427, :shield_sword, "Princess Rapier", rathian],
    [9, "Queen Rapier 4", 1167, 0, poison, 461, :shield_sword, "Princess Rapier", rathian],
    [10, "Queen Rapier 5", 1516, 0, poison, 496, :shield_sword, "Princess Rapier", rathian],

    [5, "Queen Rose 1", 473, 0, poison, 188, :shield_sword, "Queen Rose", pink_rathian],
    [6, "Royal Rose 1", 615, 0, poison, 225, :shield_sword, "Queen Rose", pink_rathian],
    [7, "Royal Rose 2", 800, 0, poison, 244, :shield_sword, "Queen Rose", pink_rathian],
    [8, "Royal Rose 3", 1040, 0, poison, 263, :shield_sword, "Queen Rose", pink_rathian],
    [9, "Royal Rose 4", 1351, 0, poison, 281, :shield_sword, "Queen Rose", pink_rathian],
    [10, "Royal Rose 5", 1756, 0, poison, 300, :shield_sword, "Queen Rose", pink_rathian],

    [2, "Thunder Edge 1", 128, 0, thunder, 47, :shield_sword, "Thunder Edge", tobi_kadachi],
    [3, "Thunder Edge 2", 182, 0, thunder, 75, :shield_sword, "Thunder Edge", tobi_kadachi],
    [4, "Thunder Edge 3", 260, 0, thunder, 117, :shield_sword, "Thunder Edge", tobi_kadachi],
    [5, "Thunder Edge 4", 370, 0, thunder, 181, :shield_sword, "Thunder Edge", tobi_kadachi],
    [6, "Lightning Nemesis 1", 475, 0, thunder, 251, :shield_sword, "Thunder Edge", tobi_kadachi],
    [7, "Lightning Nemesis 2", 611, 0, thunder, 349, :shield_sword, "Thunder Edge", tobi_kadachi],
    [8, "Lightning Nemesis 3", 784, 0, thunder, 481, :shield_sword, "Thunder Edge", tobi_kadachi],
    [9, "Lightning Nemesis 4", 1007, 0, thunder, 663, :shield_sword, "Thunder Edge", tobi_kadachi],
    [10, "Lightning Nemesis 5", 1293, 0, thunder, 910, :shield_sword, "Thunder Edge", tobi_kadachi],

    [2, "Spiked Edge 1", 144, 0, sleep, 100, :shield_sword, "Spiked Edge", radobaan],
    [3, "Spiked Edge 2", 207, 0, sleep, 150, :shield_sword, "Spiked Edge", radobaan],
    [4, "Spiked Edge 3", 299, 0, sleep, 200, :shield_sword, "Spiked Edge", radobaan],
    [5, "Spiked Edge 4", 430, 0, sleep, 250, :shield_sword, "Spiked Edge", radobaan],
    [6, "Baan Claw 1", 559, 0, sleep, 300, :shield_sword, "Spiked Edge", radobaan],
    [7, "Baan Claw 2", 727, 0, sleep, 325, :shield_sword, "Spiked Edge", radobaan],
    [8, "Baan Claw 3", 945, 0, sleep, 350, :shield_sword, "Spiked Edge", radobaan],
    [9, "Baan Claw 4", 1228, 0, sleep, 375, :shield_sword, "Spiked Edge", radobaan],
    [10, "Baan Claw 5", 1596, 0, sleep, 400, :shield_sword, "Spiked Edge", radobaan],

    [4, "Icicle Spike 1", 234, 5, ice, 117, :shield_sword, "Icicle Spike", barioth],
    [5, "Icicle Spike 2", 334, 10, ice, 181, :shield_sword, "Icicle Spike", barioth],
    [6, "Icicle Spike+ 1", 430, 10, ice, 251, :shield_sword, "Icicle Spike", barioth],
    [7, "Icicle Spike+ 2", 555, 15, ice, 349, :shield_sword, "Icicle Spike", barioth],
    [8, "Icicle Spike+ 3", 716, 15, ice, 481, :shield_sword, "Icicle Spike", barioth],
    [9, "Icicle Spike+ 4", 923, 20, ice, 663, :shield_sword, "Icicle Spike", barioth],
    [10, "Icicle Spike+ 5", 1191, 20, ice, 910, :shield_sword, "Icicle Spike", barioth],

    [5, "Usurper's Firebolt 1", 361, 0, thunder, 232, :shield_sword, "Usurper's Firebolt", zinogre],
    [6, "Usurper's Firebolt 2", 461, 0, thunder, 320, :shield_sword, "Usurper's Firebolt", zinogre],
    [7, "Usurper's Firebolt 3", 589, 0, thunder, 443, :shield_sword, "Usurper's Firebolt", zinogre],
    [8, "Usurper's Firebolt 4", 751, 0, thunder, 608, :shield_sword, "Usurper's Firebolt", zinogre],
    [9, "Usurper's Firebolt 5", 958, 0, thunder, 835, :shield_sword, "Usurper's Firebolt", zinogre],
    [10, "Despot's Crookbolt 1", 1221, 0, thunder, 1142, :shield_sword, "Usurper's Firebolt", zinogre],

    [5, "Blue Corona 1", 440, 0, fire, 134, :shield_sword, "Blue Corona", azure_rathalos],
    [6, "Blue Corona 2", 576, 0, fire, 182, :shield_sword, "Blue Corona", azure_rathalos],
    [7, "Blue Corona 3", 753, 0, fire, 248, :shield_sword, "Blue Corona", azure_rathalos],
    [8, "Blue Corona 4", 985, 0, fire, 334, :shield_sword, "Blue Corona", azure_rathalos],
    [9, "Blue Corona 5", 1287, 0, fire, 451, :shield_sword, "Blue Corona", azure_rathalos],
    [10, "Blue Corona 6", 1682, 0, fire, 605, :shield_sword, "Blue Corona", azure_rathalos],

    [3, "Aqua Slasher 1", 182, 0, water, 75, :great_sword, "Aqua Slasher", jyuratodus],
    [4, "Aqua Slasher 2", 260, 0, water, 117, :great_sword, "Aqua Slasher", jyuratodus],
    [5, "Aqua Slasher 3", 370, 0, water, 181, :great_sword, "Aqua Slasher", jyuratodus],
    [6, "Water Golem 1", 475, 0, water, 251, :great_sword, "Aqua Slasher", jyuratodus],
    [7, "Water Golem 2", 611, 0, water, 349, :great_sword, "Aqua Slasher", jyuratodus],
    [8, "Water Golem 3", 784, 0, water, 481, :great_sword, "Aqua Slasher", jyuratodus],
    [9, "Water Golem 4", 1007, 0, water, 663, :great_sword, "Aqua Slasher", jyuratodus],
    [10, "Water Golem 5", 1293, 0, water, 910, :great_sword, "Aqua Slasher", jyuratodus],

    [1, "Blooming Blade 1", 100, 0, poison, 50, :great_sword, "Blooming Blade", pukei_pukei],
    [2, "Blooming Blade 2", 144, 0, poison, 100, :great_sword, "Blooming Blade", pukei_pukei],
    [3, "Blooming Blade 3", 207, 0, poison, 150, :great_sword, "Blooming Blade", pukei_pukei],
    [4, "Blooming Blade 4", 299, 0, poison, 200, :great_sword, "Blooming Blade", pukei_pukei],
    [5, "Blooming Blade 5", 430, 0, poison, 250, :great_sword, "Blooming Blade", pukei_pukei],
    [6, "Datura Blaze 1", 559, 0, poison, 300, :great_sword, "Blooming Blade", pukei_pukei],
    [7, "Datura Blaze 2", 727, 0, poison, 325, :great_sword, "Blooming Blade", pukei_pukei],
    [8, "Datura Blaze 3", 945, 0, poison, 350, :great_sword, "Blooming Blade", pukei_pukei],
    [9, "Datura Blaze 4", 1228, 0, poison, 375, :great_sword, "Blooming Blade", pukei_pukei],
    [10, "Datura Blaze 5", 1596, 0, poison, 400, :great_sword, "Blooming Blade", pukei_pukei],

    [1, "Buster Sword 1", 100, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [2, "Buster Sword 2", 144, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [3, "Buster Sword 3", 207, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [4, "Buster Sword 4", 299, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [5, "Buster Sword 5", 430, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [6, "Buster Blade 1", 559, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [7, "Buster Blade 2", 727, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [8, "Buster Blade 3", 945, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [9, "Buster Blade 4", 1228, 0, nil, 0, :great_sword, "Buster Sword", nil],
    [10, "Buster Blade 5", 1596, 0, nil, 0, :great_sword, "Buster Sword", nil],

    [1, "Carapace Buster 1", 110, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [2, "Carapace Buster 2", 158, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [3, "Carapace Buster 3", 228, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [4, "Carapace Buster 4", 329, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [5, "Carapace Buster 5", 473, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [6, "Barroth Shredder 1", 615, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [7, "Barroth Shredder 2", 800, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [8, "Barroth Shredder 3", 1040, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [9, "Barroth Shredder 4", 1351, 0, nil, 0, :great_sword, "Carapace Buster", barroth],
    [10, "Barroth Shredder 5", 1756, 0, nil, 0, :great_sword, "Carapace Buster", barroth],

    [5, "Flame Blade 1", 361, 0, fire, 232, :great_sword, "Flame Blade", rathalos],
    [6, "Red Wing 1", 461, 0, fire, 320, :great_sword, "Flame Blade", rathalos],
    [7, "Red Wing 2", 589, 0, fire, 443, :great_sword, "Flame Blade", rathalos],
    [8, "Red Wing 3", 751, 0, fire, 608, :great_sword, "Flame Blade", rathalos],
    [9, "Red Wing 4", 958, 0, fire, 835, :great_sword, "Flame Blade", rathalos],
    [10, "Red Wing 5", 1221, 0, fire, 1142, :great_sword, "Flame Blade", rathalos],

    [4, "Flammenzahn 1", 260, 0, fire, 117, :great_sword, "Flammenzahn", anjanath],
    [5, "Flammenzahn 2", 370, 0, fire, 181, :great_sword, "Flammenzahn", anjanath],
    [6, "Flammenzahn+ 1", 475, 0, fire, 251, :great_sword, "Flammenzahn", anjanath],
    [7, "Flammenzahn+ 2", 611, 0, fire, 349, :great_sword, "Flammenzahn", anjanath],
    [8, "Flammenzahn+ 3", 784, 0, fire, 481, :great_sword, "Flammenzahn", anjanath],
    [9, "Flammenzahn+ 4", 1007, 0, fire, 663, :great_sword, "Flammenzahn", anjanath],
    [10, "Flammenzahn+ 5", 1293, 0, fire, 910, :great_sword, "Flammenzahn", anjanath],

    [5, "Freeze Blade 1", 361, 0, ice, 232, :great_sword, "Freeze Blade", legiana],
    [6, "Frost Blaze 1", 461, 0, ice, 320, :great_sword, "Freeze Blade", legiana],
    [7, "Frost Blaze 2", 589, 0, ice, 443, :great_sword, "Freeze Blade", legiana],
    [8, "Frost Blaze 3", 751, 0, ice, 608, :great_sword, "Freeze Blade", legiana],
    [9, "Frost Blaze 4", 958, 0, ice, 835, :great_sword, "Freeze Blade", legiana],
    [10, "Frost Blaze 5", 1221, 0, ice, 1142, :great_sword, "Freeze Blade", legiana],

    [2, "Girros Blade 1", 144, 0, paralysis, 100, :great_sword, "Girros Blade", great_girros],
    [3, "Girros Blade 2", 207, 0, paralysis, 150, :great_sword, "Girros Blade", great_girros],
    [4, "Girros Blade 3", 299, 0, paralysis, 200, :great_sword, "Girros Blade", great_girros],
    [5, "Girros Blade 4", 430, 0, paralysis, 250, :great_sword, "Girros Blade", great_girros],
    [6, "Malady's Kiss 1", 559, 0, paralysis, 300, :great_sword, "Girros Blade", great_girros],
    [7, "Malady's Kiss 2", 727, 0, paralysis, 325, :great_sword, "Girros Blade", great_girros],
    [8, "Malady's Kiss 3", 945, 0, paralysis, 350, :great_sword, "Girros Blade", great_girros],
    [9, "Malady's Kiss 4", 1228, 0, paralysis, 375, :great_sword, "Girros Blade", great_girros],
    [10, "Malady's Kiss 5", 1596, 0, paralysis, 400, :great_sword, "Girros Blade", great_girros],

    [1, "Jagras Blade 1", 95, 0, water, 25, :great_sword, "Jagras Blade", great_jagras],
    [2, "Jagras Blade 2", 135, 0, water, 38, :great_sword, "Jagras Blade", great_jagras],
    [3, "Jagras Blade 3", 193, 0, water, 59, :great_sword, "Jagras Blade", great_jagras],
    [4, "Jagras Blade 4", 275, 0, water, 90, :great_sword, "Jagras Blade", great_jagras],
    [5, "Jagras Blade 5", 391, 0, water, 136, :great_sword, "Jagras Blade", great_jagras],
    [6, "Jagras Hacker 1", 503, 0, water, 184, :great_sword, "Jagras Blade", great_jagras],
    [7, "Jagras Hacker 2", 647, 0, water, 251, :great_sword, "Jagras Blade", great_jagras],
    [8, "Jagras Hacker 3", 832, 0, water, 337, :great_sword, "Jagras Blade", great_jagras],
    [9, "Jagras Hacker 4", 1068, 0, water, 453, :great_sword, "Jagras Blade", great_jagras],
    [10, "Jagras Hacker 5", 1373, 0, water, 607, :great_sword, "Jagras Blade", great_jagras],

    [2, "Thunder Blade 1", 128, 0, thunder, 47, :great_sword, "Thunder Blade", tobi_kadachi],
    [3, "Thunder Blade 2", 182, 0, thunder, 75, :great_sword, "Thunder Blade", tobi_kadachi],
    [4, "Thunder Blade 3", 260, 0, thunder, 117, :great_sword, "Thunder Blade", tobi_kadachi],
    [5, "Thunder Blade 4", 370, 0, thunder, 181, :great_sword, "Thunder Blade", tobi_kadachi],
    [6, "Lightning Punisher 1", 475, 0, thunder, 251, :great_sword, "Thunder Blade", tobi_kadachi],
    [7, "Lightning Punisher 2", 611, 0, thunder, 349, :great_sword, "Thunder Blade", tobi_kadachi],
    [8, "Lightning Punisher 3", 784, 0, thunder, 481, :great_sword, "Thunder Blade", tobi_kadachi],
    [9, "Lightning Punisher 4", 1007, 0, thunder, 663, :great_sword, "Thunder Blade", tobi_kadachi],
    [10, "Lightning Punisher 5", 1293, 0, thunder, 910, :great_sword, "Thunder Blade", tobi_kadachi],

    [2, "Spiked Blade 1", 144, 0, sleep, 100, :great_sword, "Spiked Blade", radobaan],
    [3, "Spiked Blade 2", 207, 0, sleep, 150, :great_sword, "Spiked Blade", radobaan],
    [4, "Spiked Blade 3", 299, 0, sleep, 200, :great_sword, "Spiked Blade", radobaan],
    [5, "Spiked Blade 4", 430, 0, sleep, 250, :great_sword, "Spiked Blade", radobaan],
    [6, "Radobaan Slab 1", 559, 0, sleep, 300, :great_sword, "Spiked Blade", radobaan],
    [7, "Radobaan Slab 2", 727, 0, sleep, 325, :great_sword, "Spiked Blade", radobaan],
    [8, "Radobaan Slab 3", 945, 0, sleep, 350, :great_sword, "Spiked Blade", radobaan],
    [9, "Radobaan Slab 4", 1228, 0, sleep, 375, :great_sword, "Spiked Blade", radobaan],
    [10, "Radobaan Slab 5", 1596, 0, sleep, 400, :great_sword, "Spiked Blade", radobaan],

    [3, "Mammoth Greataxe 1", 236, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [4, "Mammoth Greataxe 2", 339, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [5, "Mammoth Greataxe 3", 486, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [6, "Mammoth Greataxe 4", 629, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [7, "Mammoth Greataxe 5", 814, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [8, "Mammoth Greataxe 6", 1054, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [9, "Mammoth Greataxe 7", 1363, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],
    [10, "Mammoth Greataxe 8", 1764, 0, nil, 0, :great_sword, "Mammoth Greataxe", banbaro],

    [4, "Icicle Fang 1", 234, 5, ice, 117, :great_sword, "Icicle Fang", barioth],
    [5, "Icicle Fang 2", 334, 10, ice, 181, :great_sword, "Icicle Fang", barioth],
    [6, "Icicle Fang+ 1", 430, 10, ice, 251, :great_sword, "Icicle Fang", barioth],
    [7, "Icicle Fang+ 2", 555, 15, ice, 349, :great_sword, "Icicle Fang", barioth],
    [8, "Icicle Fang+ 3", 716, 15, ice, 481, :great_sword, "Icicle Fang", barioth],
    [9, "Icicle Fang+ 4", 923, 20, ice, 663, :great_sword, "Icicle Fang", barioth],
    [10, "Icicle Fang+ 5", 1191, 20, ice, 910, :great_sword, "Icicle Fang", barioth],

    [5, "Severing Bolt 1", 361, 0, thunder, 232, :great_sword, "Severing Bolt", zinogre],
    [6, "Severing Bolt 2", 461, 0, thunder, 320, :great_sword, "Severing Bolt", zinogre],
    [7, "Severing Bolt 3", 589, 0, thunder, 443, :great_sword, "Severing Bolt", zinogre],
    [8, "Severing Bolt 4", 751, 0, thunder, 608, :great_sword, "Severing Bolt", zinogre],
    [9, "Severing Bolt 5", 958, 0, thunder, 835, :great_sword, "Severing Bolt", zinogre],
    [10, "Severing Bolt 6", 1221, 0, thunder, 1142, :great_sword, "Severing Bolt", zinogre],

    [5, "Blue Wing 1", 440, 0, fire, 134, :great_sword, "Blue Wing", azure_rathalos],
    [6, "Rathalos Glinsword 1", 576, 0, fire, 182, :great_sword, "Blue Wing", azure_rathalos],
    [7, "Rathalos Glinsword 2", 753, 0, fire, 248, :great_sword, "Blue Wing", azure_rathalos],
    [8, "Rathalos Glinsword 3", 985, 0, fire, 334, :great_sword, "Blue Wing", azure_rathalos],
    [9, "Rathalos Glinsword 4", 1287, 0, fire, 451, :great_sword, "Blue Wing", azure_rathalos],
    [10, "Rathalos Glinsword 5", 1682, 0, fire, 605, :great_sword, "Blue Wing", azure_rathalos],

    # long_sword
    [4, "Blazing Shotel 1", 260, 0, fire, 117, :long_sword, "Blazing Shotel", anjanath],
    [5, "Blazing Shotel 2", 370, 0, fire, 181, :long_sword, "Blazing Shotel", anjanath],
    [6, "Anja Scimitar 1", 475, 0, fire, 251, :long_sword, "Blazing Shotel", anjanath],
    [7, "Anja Scimitar 2", 611, 0, fire, 349, :long_sword, "Blazing Shotel", anjanath],
    [8, "Anja Scimitar 3", 784, 0, fire, 481, :long_sword, "Blazing Shotel", anjanath],
    [9, "Anja Scimitar 4", 1007, 0, fire, 663, :long_sword, "Blazing Shotel", anjanath],
    [10, "Anja Scimitar 5", 1293, 0, fire, 910, :long_sword, "Blazing Shotel", anjanath],

    [1, "First Dance 1", 100, 5, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [2, "First Dance 2", 144, 10, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [3, "First Dance 3", 207, 10, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [4, "First Dance 4", 299, 15, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [5, "First Dance 5", 430, 15, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [6, "Last Dance 1", 559, 20, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [7, "Last Dance 2", 727, 20, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [8, "Last Dance 3", 945, 25, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [9, "Last Dance 4", 1228, 25, nil, 0, :long_sword, "First Dance", kulu_ya_ku],
    [10, "Last Dance 5", 1596, 30, nil, 0, :long_sword, "First Dance", kulu_ya_ku],

    [5, "Glacial Shotel 1", 361, 0, ice, 232, :long_sword, "Glacial Shotel", legiana],
    [6, "Stealer 1", 461, 0, ice, 320, :long_sword, "Glacial Shotel", legiana],
    [7, "Stealer 2", 589, 0, ice, 443, :long_sword, "Glacial Shotel", legiana],
    [8, "Stealer 3", 751, 0, ice, 608, :long_sword, "Glacial Shotel", legiana],
    [9, "Stealer 4", 958, 0, ice, 835, :long_sword, "Glacial Shotel", legiana],
    [10, "Stealer 5", 1221, 0, ice, 1142, :long_sword, "Glacial Shotel", legiana],

    [1, "Iron Katana 1", 100, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [2, "Iron Katana 2", 144, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [3, "Iron Katana 3", 207, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [4, "Iron Katana 4", 299, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [5, "Iron Katana 5", 430, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [6, "Iron Grace 1", 559, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [7, "Iron Grace 2", 727, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [8, "Iron Grace 3", 945, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [9, "Iron Grace 4", 1228, 0, nil, 0, :long_sword, "Iron Katana", nil],
    [10, "Iron Grace 5", 1596, 0, nil, 0, :long_sword, "Iron Katana", nil],

    [3, "Jyura Shotel 1", 182, 0, water, 75, :long_sword, "Jyura Shotel", jyuratodus],
    [4, "Jyura Shotel 2", 260, 0, water, 117, :long_sword, "Jyura Shotel", jyuratodus],
    [5, "Jyura Shotel 3", 370, 0, water, 181, :long_sword, "Jyura Shotel", jyuratodus],
    [6, "Dipterus 1", 475, 0, water, 251, :long_sword, "Jyura Shotel", jyuratodus],
    [7, "Dipterus 2", 611, 0, water, 349, :long_sword, "Jyura Shotel", jyuratodus],
    [8, "Dipterus 3", 784, 0, water, 481, :long_sword, "Jyura Shotel", jyuratodus],
    [9, "Dipterus 4", 1007, 0, water, 663, :long_sword, "Jyura Shotel", jyuratodus],
    [10, "Dipterus 5", 1293, 0, water, 910, :long_sword, "Jyura Shotel", jyuratodus],

    [2, "Pulsar Shotel 1", 128, 0, thunder, 47, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [3, "Pulsar Shotel 2", 182, 0, thunder, 75, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [4, "Pulsar Shotel 3", 260, 0, thunder, 117, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [5, "Pulsar Shotel 4", 370, 0, thunder, 181, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [6, "Kadachi Fang 1", 475, 0, thunder, 251, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [7, "Kadachi Fang 2", 611, 0, thunder, 349, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [8, "Kadachi Fang 3", 784, 0, thunder, 481, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [9, "Kadachi Fang 4", 1007, 0, thunder, 663, :long_sword, "Pulsar Shotel", tobi_kadachi],
    [10, "Kadachi Fang 5", 1293, 0, thunder, 910, :long_sword, "Pulsar Shotel", tobi_kadachi],

    [5, "Wyvern Blade \"Blossom\" 1", 473, 0, poison, 188, :long_sword, "Wyvern Blade \"Blossom\"", pink_rathian],
    [6, "Wyvern Blade \"Blossom+\" 1", 615, 0, poison, 225, :long_sword, "Wyvern Blade \"Blossom\"", pink_rathian],
    [7, "Wyvern Blade \"Blossom+\" 2", 800, 0, poison, 244, :long_sword, "Wyvern Blade \"Blossom\"", pink_rathian],
    [8, "Wyvern Blade \"Blossom+\" 3", 1040, 0, poison, 263, :long_sword, "Wyvern Blade \"Blossom\"", pink_rathian],
    [9, "Wyvern Blade \"Blossom+\" 4", 1351, 0, poison, 281, :long_sword, "Wyvern Blade \"Blossom\"", pink_rathian],
    [10, "Wyvern Blade \"Blossom+\" 5", 1756, 0, poison, 300, :long_sword, "Wyvern Blade \"Blossom\"", pink_rathian],

    [5, "Wyvern Blade \"Fall\" 1", 361, 0, fire, 232, :long_sword, "Wyvern Blade \"Fall\"", rathalos],
    [6, "Wyvern Blade \"Blood\" 1", 461, 0, fire, 320, :long_sword, "Wyvern Blade \"Fall\"", rathalos],
    [7, "Wyvern Blade \"Blood\" 2", 589, 0, fire, 443, :long_sword, "Wyvern Blade \"Fall\"", rathalos],
    [8, "Wyvern Blade \"Blood\" 3", 751, 0, fire, 608, :long_sword, "Wyvern Blade \"Fall\"", rathalos],
    [9, "Wyvern Blade \"Blood\" 4", 958, 0, fire, 835, :long_sword, "Wyvern Blade \"Fall\"", rathalos],
    [10, "Wyvern Blade \"Blood\" 5", 1221, 0, fire, 1142, :long_sword, "Wyvern Blade \"Fall\"", rathalos],

    [4, "Wyvern Blade \"Leaf\" 1", 284, 0, poison, 236, :long_sword, "Wyvern Blade \"Leaf\"", rathian],
    [5, "Wyvern Blade \"Leaf\" 2", 409, 0, poison, 298, :long_sword, "Wyvern Blade \"Leaf\"", rathian],
    [6, "Wyvern Blade \"Verde\" 1", 531, 0, poison, 360, :long_sword, "Wyvern Blade \"Leaf\"", rathian],
    [7, "Wyvern Blade \"Verde\" 2", 691, 0, poison, 393, :long_sword, "Wyvern Blade \"Leaf\"", rathian],
    [8, "Wyvern Blade \"Verde\" 3", 898, 0, poison, 427, :long_sword, "Wyvern Blade \"Leaf\"", rathian],
    [9, "Wyvern Blade \"Verde\" 4", 1167, 0, poison, 461, :long_sword, "Wyvern Blade \"Leaf\"", rathian],
    [10, "Wyvern Blade \"Verde\" 5", 1516, 0, poison, 496, :long_sword, "Wyvern Blade \"Leaf\"", rathian],

    [3, "Mammoth Longblade 1", 236, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [4, "Mammoth Longblade 2", 339, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [5, "Mammoth Longblade 3", 486, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [6, "Mammoth Longblade 4", 629, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [7, "Mammoth Longblade 5", 814, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [8, "Mammoth Longblade 6", 1054, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [9, "Mammoth Longblade 7", 1363, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],
    [10, "Mammoth Longblade 8", 1764, 0, nil, 0, :long_sword, "Mammoth Longblade", banbaro],

    [4, "Ambertooth 1", 234, 5, ice, 117, :long_sword, "Ambertooth", barioth],
    [5, "Ambertooth 2", 334, 10, ice, 181, :long_sword, "Ambertooth", barioth],
    [6, "Ambertooth 3", 430, 10, ice, 251, :long_sword, "Ambertooth", barioth],
    [7, "Ambertooth 4", 555, 15, ice, 349, :long_sword, "Ambertooth", barioth],
    [8, "Ambertooth 5", 716, 15, ice, 481, :long_sword, "Ambertooth", barioth],
    [9, "Ambertooth 6", 923, 20, ice, 663, :long_sword, "Ambertooth", barioth],
    [10, "Ambertooth 7", 1191, 20, ice, 910, :long_sword, "Ambertooth", barioth],

    [5, "Usurper's Boltslicer 1", 361, 0, thunder, 232, :long_sword, "Usurper's Boltslicer", zinogre],
    [6, "Usurper's Boltslicer 2", 461, 0, thunder, 320, :long_sword, "Usurper's Boltslicer", zinogre],
    [7, "Usurper's Boltslicer 3", 589, 0, thunder, 443, :long_sword, "Usurper's Boltslicer", zinogre],
    [8, "Usurper's Boltslicer 4", 751, 0, thunder, 608, :long_sword, "Usurper's Boltslicer", zinogre],
    [9, "Usurper's Boltslicer 5", 958, 0, thunder, 835, :long_sword, "Usurper's Boltslicer", zinogre],
    [10, "Despot's Boltbreaker 1", 1221, 0, thunder, 1142, :long_sword, "Usurper's Boltslicer", zinogre],

    [5, "Wyvern Blade \"Azure\" 1", 440, 0, fire, 134, :long_sword, "Wyvern Blade \"Azure\"", azure_rathalos],
    [6, "Wyvern Blade \"Indigo\" 1", 576, 0, fire, 182, :long_sword, "Wyvern Blade \"Azure\"", azure_rathalos],
    [7, "Wyvern Blade \"Indigo\" 2", 753, 0, fire, 248, :long_sword, "Wyvern Blade \"Azure\"", azure_rathalos],
    [8, "Wyvern Blade \"Indigo\" 3", 985, 0, fire, 334, :long_sword, "Wyvern Blade \"Azure\"", azure_rathalos],
    [9, "Wyvern Blade \"Indigo\" 4", 1287, 0, fire, 451, :long_sword, "Wyvern Blade \"Azure\"", azure_rathalos],
    [10, "Wyvern Blade \"Indigo\" 5", 1682, 0, fire, 605, :long_sword, "Wyvern Blade \"Azure\"", azure_rathalos],
    # hammer

    [3, "Aqua Hammer 1", 182, 0, water, 75, :hammer, "Aqua Hammer", jyuratodus],
    [4, "Aqua Hammer 2", 260, 0, water, 117, :hammer, "Aqua Hammer", jyuratodus],
    [5, "Aqua Hammer 3", 370, 0, water, 181, :hammer, "Aqua Hammer", jyuratodus],
    [6, "Water Basher 1", 475, 0, water, 251, :hammer, "Aqua Hammer", jyuratodus],
    [7, "Water Basher 2", 611, 0, water, 349, :hammer, "Aqua Hammer", jyuratodus],
    [8, "Water Basher 3", 784, 0, water, 481, :hammer, "Aqua Hammer", jyuratodus],
    [9, "Water Basher 4", 1007, 0, water, 663, :hammer, "Aqua Hammer", jyuratodus],
    [10, "Water Basher 5", 1293, 0, water, 910, :hammer, "Aqua Hammer", jyuratodus],

    [4, "Blazing Hammer 1", 260, 0, fire, 117, :hammer, "Blazing Hammer", anjanath],
    [5, "Blazing Hammer 2", 370, 0, fire, 181, :hammer, "Blazing Hammer", anjanath],
    [6, "Anja Striker 1", 475, 0, fire, 251, :hammer, "Blazing Hammer", anjanath],
    [7, "Anja Striker 2", 611, 0, fire, 349, :hammer, "Blazing Hammer", anjanath],
    [8, "Anja Striker 3", 784, 0, fire, 481, :hammer, "Blazing Hammer", anjanath],
    [9, "Anja Striker 4", 1007, 0, fire, 663, :hammer, "Blazing Hammer", anjanath],
    [10, "Anja Striker 5", 1293, 0, fire, 910, :hammer, "Blazing Hammer", anjanath],

    [1, "Blooming Hammer 1", 100, 0, poison, 50, :hammer, "Blooming Hammer", pukei_pukei],
    [2, "Blooming Hammer 2", 144, 0, poison, 100, :hammer, "Blooming Hammer", pukei_pukei],
    [3, "Blooming Hammer 3", 207, 0, poison, 150, :hammer, "Blooming Hammer", pukei_pukei],
    [4, "Blooming Hammer 4", 299, 0, poison, 200, :hammer, "Blooming Hammer", pukei_pukei],
    [5, "Blooming Hammer 5", 430, 0, poison, 250, :hammer, "Blooming Hammer", pukei_pukei],
    [6, "Buon Fiore 1", 559, 0, poison, 300, :hammer, "Blooming Hammer", pukei_pukei],
    [7, "Buon Fiore 2", 727, 0, poison, 325, :hammer, "Blooming Hammer", pukei_pukei],
    [8, "Buon Fiore 3", 945, 0, poison, 350, :hammer, "Blooming Hammer", pukei_pukei],
    [9, "Buon Fiore 4", 1228, 0, poison, 375, :hammer, "Blooming Hammer", pukei_pukei],
    [10, "Buon Fiore 5", 1596, 0, poison, 400, :hammer, "Blooming Hammer", pukei_pukei],

    [1, "Carapace Sledge 1", 110, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [2, "Carapace Sledge 2", 158, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [3, "Carapace Sledge 3", 228, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [4, "Carapace Sledge 4", 329, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [5, "Carapace Sledge 5", 473, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [6, "Barroth Breaker 1", 615, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [7, "Barroth Breaker 2", 800, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [8, "Barroth Breaker 3", 1040, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [9, "Barroth Breaker 4", 1351, 0, nil, 0, :hammer, "Carapace Sledge", barroth],
    [10, "Barroth Breaker 5", 1756, 0, nil, 0, :hammer, "Carapace Sledge", barroth],

    [5, "Chaos Shatterer 1", 576, -30, nil, 0, :hammer, "Chaos Shatterer", black_diablos],
    [6, "Chaos Shatterer 2", 755, -30, nil, 0, :hammer, "Chaos Shatterer", black_diablos],
    [7, "Chaos Shatterer 3", 989, -30, nil, 0, :hammer, "Chaos Shatterer", black_diablos],
    [8, "Chaos Shatterer 4", 1295, -30, nil, 0, :hammer, "Chaos Shatterer", black_diablos],
    [9, "Chaos Shatterer 5", 1695, -30, nil, 0, :hammer, "Chaos Shatterer", black_diablos],
    [10, "Chaos Shatterer 6", 2218, -30, nil, 0, :hammer, "Chaos Shatterer", black_diablos],

    [5, "Diablos Sledge 1", 512, 0, nil, 0, :hammer, "Diablos Sledge", diablos],
    [6, "Diablos Shatterer 1", 671, 0, nil, 0, :hammer, "Diablos Sledge", diablos],
    [7, "Diablos Shatterer 2", 880, 0, nil, 0, :hammer, "Diablos Sledge", diablos],
    [8, "Diablos Shatterer 3", 1153, 0, nil, 0, :hammer, "Diablos Sledge", diablos],
    [9, "Diablos Shatterer 4", 1510, 0, nil, 0, :hammer, "Diablos Sledge", diablos],
    [10, "Diablos Shatterer 5", 1979, 0, nil, 0, :hammer, "Diablos Sledge", diablos],

    [2, "Girros Hammer 1", 144, 0, paralysis, 100, :hammer, "Girros Hammer", great_girros],
    [3, "Girros Hammer 2", 207, 0, paralysis, 150, :hammer, "Girros Hammer", great_girros],
    [4, "Girros Hammer 3", 299, 0, paralysis, 200, :hammer, "Girros Hammer", great_girros],
    [5, "Girros Hammer 4", 430, 0, paralysis, 250, :hammer, "Girros Hammer", great_girros],
    [6, "Malady's Fist 1", 559, 0, paralysis, 300, :hammer, "Girros Hammer", great_girros],
    [7, "Malady's Fist 2", 727, 0, paralysis, 325, :hammer, "Girros Hammer", great_girros],
    [8, "Malady's Fist 3", 945, 0, paralysis, 350, :hammer, "Girros Hammer", great_girros],
    [9, "Malady's Fist 4", 1228, 0, paralysis, 375, :hammer, "Girros Hammer", great_girros],
    [10, "Malady's Fist 5", 1596, 0, paralysis, 400, :hammer, "Girros Hammer", great_girros],

    [1, "Iron Hammer 1", 100, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [2, "Iron Hammer 2", 144, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [3, "Iron Hammer 3", 207, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [4, "Iron Hammer 4", 299, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [5, "Iron Hammer 5", 430, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [6, "Iron Demon 1", 559, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [7, "Iron Demon 2", 727, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [8, "Iron Demon 3", 945, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [9, "Iron Demon 4", 1228, 0, nil, 0, :hammer, "Iron Hammer", nil],
    [10, "Iron Demon 5", 1596, 0, nil, 0, :hammer, "Iron Hammer", nil],

    [1, "Kulu Beak 1", 100, 5, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [2, "Kulu Beak 2", 144, 10, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [3, "Kulu Beak 3", 207, 10, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [4, "Kulu Beak 4", 299, 15, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [5, "Kulu Beak 5", 430, 15, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [6, "Crushing Beak 1", 559, 20, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [7, "Crushing Beak 2", 727, 20, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [8, "Crushing Beak 3", 945, 25, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [9, "Crushing Beak 4", 1228, 25, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],
    [10, "Crushing Beak 5", 1596, 30, nil, 0, :hammer, "Kulu Beak", kulu_ya_ku],

    [2, "Thunder Hammer 1", 128, 0, thunder, 47, :hammer, "Thunder Hammer", tobi_kadachi],
    [3, "Thunder Hammer 2", 182, 0, thunder, 75, :hammer, "Thunder Hammer", tobi_kadachi],
    [4, "Thunder Hammer 3", 260, 0, thunder, 117, :hammer, "Thunder Hammer", tobi_kadachi],
    [5, "Thunder Hammer 4", 370, 0, thunder, 181, :hammer, "Thunder Hammer", tobi_kadachi],
    [6, "Lightning Bash 1", 475, 0, thunder, 251, :hammer, "Thunder Hammer", tobi_kadachi],
    [7, "Lightning Bash 2", 611, 0, thunder, 349, :hammer, "Thunder Hammer", tobi_kadachi],
    [8, "Lightning Bash 3", 784, 0, thunder, 481, :hammer, "Thunder Hammer", tobi_kadachi],
    [9, "Lightning Bash 4", 1007, 0, thunder, 663, :hammer, "Thunder Hammer", tobi_kadachi],
    [10, "Lightning Bash 5", 1293, 0, thunder, 910, :hammer, "Thunder Hammer", tobi_kadachi],

    [2, "Bone Spike 1", 144, 0, sleep, 100, :hammer, "Bone Spike", radobaan],
    [3, "Bone Spike 2", 207, 0, sleep, 150, :hammer, "Bone Spike", radobaan],
    [4, "Bone Spike 3", 299, 0, sleep, 200, :hammer, "Bone Spike", radobaan],
    [5, "Bone Spike 4", 430, 0, sleep, 250, :hammer, "Bone Spike", radobaan],
    [6, "Baan Strike 1", 559, 0, sleep, 300, :hammer, "Bone Spike", radobaan],
    [7, "Baan Strike 2", 727, 0, sleep, 325, :hammer, "Bone Spike", radobaan],
    [8, "Baan Strike 3", 945, 0, sleep, 350, :hammer, "Bone Spike", radobaan],
    [9, "Baan Strike 4", 1228, 0, sleep, 375, :hammer, "Bone Spike", radobaan],
    [10, "Baan Strike 5", 1596, 0, sleep, 400, :hammer, "Bone Spike", radobaan],

    [3, "Mammoth Hoof 1", 236, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [4, "Mammoth Hoof 2", 339, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [5, "Mammoth Hoof 3", 486, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [6, "Mammoth Hoof 4", 629, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [7, "Mammoth Hoof 5", 814, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [8, "Mammoth Hoof 6", 1054, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [9, "Mammoth Hoof 7", 1363, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],
    [10, "Mammoth Hoof 8", 1764, 0, nil, 0, :hammer, "Mammoth Hoof", banbaro],

    [4, "Glacial Bash 1", 234, 5, ice, 117, :hammer, "Glacial Bash", barioth],
    [5, "Glacial Bash 2", 334, 10, ice, 181, :hammer, "Glacial Bash", barioth],
    [6, "Glacial Bash 3", 430, 10, ice, 251, :hammer, "Glacial Bash", barioth],
    [7, "Glacial Bash 4", 555, 15, ice, 349, :hammer, "Glacial Bash", barioth],
    [8, "Glacial Bash 5", 716, 15, ice, 481, :hammer, "Glacial Bash", barioth],
    [9, "Glacial Bash 6", 923, 20, ice, 663, :hammer, "Glacial Bash", barioth],
    [10, "Glacial Bash 7", 1191, 20, ice, 910, :hammer, "Glacial Bash", barioth],

    [5, "Usurper's Thunder 1", 361, 0, thunder, 232, :hammer, "Usurper's Thunder", zinogre],
    [6, "Usurper's Thunder 2", 461, 0, thunder, 320, :hammer, "Usurper's Thunder", zinogre],
    [7, "Usurper's Thunder 3", 589, 0, thunder, 443, :hammer, "Usurper's Thunder", zinogre],
    [8, "Usurper's Thunder 4", 751, 0, thunder, 608, :hammer, "Usurper's Thunder", zinogre],
    [9, "Usurper's Thunder 5", 958, 0, thunder, 835, :hammer, "Usurper's Thunder", zinogre],
    [10, "Despot's Crackle 1", 1221, 0, thunder, 1142, :hammer, "Usurper's Thunder", zinogre],
    # dual_blades

    [2, "Matched Slicers 1", 144, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [3, "Matched Slicers 2", 207, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [4, "Matched Slicers 3", 299, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [5, "Matched Slicers 4", 430, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [6, "Dual Slicers 1", 559, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [7, "Dual Slicers 2", 727, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [8, "Dual Slicers 3", 945, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [9, "Dual Slicers 4", 1228, 0, nil, 0, :dual_blades, "Matched Slicers", nil],
    [10, "Dual Slicers 5", 1596, 0, nil, 0, :dual_blades, "Matched Slicers", nil],

    [2, "Rending Beaks 1", 144, 10, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [3, "Rending Beaks 2", 207, 10, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [4, "Rending Beaks 3", 299, 15, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [5, "Rending Beaks 4", 430, 15, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [6, "Arcanaria 1", 559, 20, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [7, "Arcanaria 2", 727, 20, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [8, "Arcanaria 3", 945, 25, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [9, "Arcanaria 4", 1228, 25, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],
    [10, "Arcanaria 5", 1596, 30, nil, 0, :dual_blades, "Rending Beaks", kulu_ya_ku],

    [2, "Pulsar Hatchets 1", 128, 0, thunder, 47, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [3, "Pulsar Hatchets 2", 182, 0, thunder, 75, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [4, "Pulsar Hatchets 3", 260, 0, thunder, 117, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [5, "Pulsar Hatchets 4", 370, 0, thunder, 181, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [6, "Kadachi Claws 1", 475, 0, thunder, 251, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [7, "Kadachi Claws 2", 611, 0, thunder, 349, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [8, "Kadachi Claws 3", 784, 0, thunder, 481, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [9, "Kadachi Claws 4", 1007, 0, thunder, 663, :dual_blades, "Pulsar Hatchets", tobi_kadachi],
    [10, "Kadachi Claws 5", 1293, 0, thunder, 910, :dual_blades, "Pulsar Hatchets", tobi_kadachi],

    [3, "Madness Pangas 1", 182, 0, water, 75, :dual_blades, "Madness Pangas", jyuratodus],
    [4, "Madness Pangas 2", 260, 0, water, 117, :dual_blades, "Madness Pangas", jyuratodus],
    [5, "Madness Pangas 3", 370, 0, water, 181, :dual_blades, "Madness Pangas", jyuratodus],
    [6, "Jyura Hatchets 1", 475, 0, water, 251, :dual_blades, "Madness Pangas", jyuratodus],
    [7, "Jyura Hatchets 2", 611, 0, water, 349, :dual_blades, "Madness Pangas", jyuratodus],
    [8, "Jyura Hatchets 3", 784, 0, water, 481, :dual_blades, "Madness Pangas", jyuratodus],
    [9, "Jyura Hatchets 4", 1007, 0, water, 663, :dual_blades, "Madness Pangas", jyuratodus],
    [10, "Jyura Hatchets 5", 1293, 0, water, 910, :dual_blades, "Madness Pangas", jyuratodus],

    [4, "Blazing Hatchets 1", 260, 0, fire, 117, :dual_blades, "Blazing Hatchets", anjanath],
    [5, "Blazing Hatchets 2", 370, 0, fire, 181, :dual_blades, "Blazing Hatchets", anjanath],
    [6, "Anja Cyclone 1", 475, 0, fire, 251, :dual_blades, "Blazing Hatchets", anjanath],
    [7, "Anja Cyclone 2", 611, 0, fire, 349, :dual_blades, "Blazing Hatchets", anjanath],
    [8, "Anja Cyclone 3", 784, 0, fire, 481, :dual_blades, "Blazing Hatchets", anjanath],
    [9, "Anja Cyclone 4", 1007, 0, fire, 663, :dual_blades, "Blazing Hatchets", anjanath],
    [10, "Anja Cyclone 5", 1293, 0, fire, 910, :dual_blades, "Blazing Hatchets", anjanath],

    [5, "Freeze Daggers 1", 361, 0, ice, 232, :dual_blades, "Freeze Daggers", legiana],
    [6, "Freeze Chain 1", 461, 0, ice, 320, :dual_blades, "Freeze Daggers", legiana],
    [7, "Freeze Chain 2", 589, 0, ice, 443, :dual_blades, "Freeze Daggers", legiana],
    [8, "Freeze Chain 3", 751, 0, ice, 608, :dual_blades, "Freeze Daggers", legiana],
    [9, "Freeze Chain 4", 958, 0, ice, 835, :dual_blades, "Freeze Daggers", legiana],
    [10, "Freeze Chain 5", 1221, 0, ice, 1142, :dual_blades, "Freeze Daggers", legiana],

    [5, "Diablos Hatchets 1", 512, 0, nil, 0, :dual_blades, "Diablos Hatchets", diablos],
    [6, "Diablos Clubs 1", 671, 0, nil, 0, :dual_blades, "Diablos Hatchets", diablos],
    [7, "Diablos Clubs 2", 880, 0, nil, 0, :dual_blades, "Diablos Hatchets", diablos],
    [8, "Diablos Clubs 3", 1153, 0, nil, 0, :dual_blades, "Diablos Hatchets", diablos],
    [9, "Diablos Clubs 4", 1510, 0, nil, 0, :dual_blades, "Diablos Hatchets", diablos],
    [10, "Diablos Clubs 5", 1979, 0, nil, 0, :dual_blades, "Diablos Hatchets", diablos],

    [5, "Thanatos Mauls 1", 576, -30, nil, 0, :dual_blades, "Thanatos Mauls", black_diablos],
    [6, "Thanatos Mauls 2", 755, -30, nil, 0, :dual_blades, "Thanatos Mauls", black_diablos],
    [7, "Thanatos Mauls 3", 989, -30, nil, 0, :dual_blades, "Thanatos Mauls", black_diablos],
    [8, "Thanatos Mauls 4", 1295, -30, nil, 0, :dual_blades, "Thanatos Mauls", black_diablos],
    [9, "Thanatos Mauls 5", 1695, -30, nil, 0, :dual_blades, "Thanatos Mauls", black_diablos],
    [10, "Thanatos Mauls 6", 2218, -30, nil, 0, :dual_blades, "Thanatos Mauls", black_diablos],


    [3, "Mammoth Direbones 1", 236, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [4, "Mammoth Direbones 2", 339, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [5, "Mammoth Direbones 3", 486, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [6, "Mammoth Direbones 4", 629, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [7, "Mammoth Direbones 5", 814, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [8, "Mammoth Direbones 6", 1054, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [9, "Mammoth Direbones 7", 1363, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],
    [10, "Mammoth Direbones 8", 1764, 0, nil, 0, :dual_blades, "Mammoth Direbones", banbaro],

    [4, "Blizzarioths 1", 234, 5, ice, 117, :dual_blades, "Blizzarioths", barioth],
    [5, "Blizzarioths 2", 334, 10, ice, 181, :dual_blades, "Blizzarioths", barioth],
    [6, "Blizzarioths+ 1", 430, 10, ice, 251, :dual_blades, "Blizzarioths", barioth],
    [7, "Blizzarioths+ 2", 555, 15, ice, 349, :dual_blades, "Blizzarioths", barioth],
    [8, "Blizzarioths+ 3", 716, 15, ice, 481, :dual_blades, "Blizzarioths", barioth],
    [9, "Blizzarioths+ 4", 923, 20, ice, 663, :dual_blades, "Blizzarioths", barioth],
    [10, "Blizzarioths+ 5", 1191, 20, ice, 910, :dual_blades, "Blizzarioths", barioth],

    [5, "Usurper's Fulgur 1", 361, 0, thunder, 232, :dual_blades, "Usurper's Fulgur", zinogre],
    [6, "Usurper's Fulgur 2", 461, 0, thunder, 320, :dual_blades, "Usurper's Fulgur", zinogre],
    [7, "Usurper's Fulgur 3", 589, 0, thunder, 443, :dual_blades, "Usurper's Fulgur", zinogre],
    [8, "Usurper's Fulgur 4", 751, 0, thunder, 608, :dual_blades, "Usurper's Fulgur", zinogre],
    [9, "Usurper's Fulgur 5", 958, 0, thunder, 835, :dual_blades, "Usurper's Fulgur", zinogre],
    [10, "Despot's Blitz 1", 1221, 0, thunder, 1142, :dual_blades, "Usurper's Fulgur", zinogre],
    # :bow

    [3, "Aqua Arrow 1", 182, 0, water, 75, :bow, "Aqua Arrow", jyuratodus],
    [4, "Aqua Arrow 2", 260, 0, water, 117, :bow, "Aqua Arrow", jyuratodus],
    [5, "Aqua Arrow 3", 370, 0, water, 181, :bow, "Aqua Arrow", jyuratodus],
    [6, "Water Shot 1", 475, 0, water, 251, :bow, "Aqua Arrow", jyuratodus],
    [7, "Water Shot 2", 611, 0, water, 349, :bow, "Aqua Arrow", jyuratodus],
    [8, "Water Shot 3", 784, 0, water, 481, :bow, "Aqua Arrow", jyuratodus],
    [9, "Water Shot 4", 1007, 0, water, 663, :bow, "Aqua Arrow", jyuratodus],
    [10, "Water Shot 5", 1293, 0, water, 910, :bow, "Aqua Arrow", jyuratodus],

    [4, "Blazing Bow 1", 260, 0, fire, 117, :bow, "Blazing Bow", anjanath],
    [5, "Blazing Bow 2", 370, 0, fire, 181, :bow, "Blazing Bow", anjanath],
    [6, "Anja Arch 1", 475, 0, fire, 251, :bow, "Blazing Bow", anjanath],
    [7, "Anja Arch 2", 611, 0, fire, 349, :bow, "Blazing Bow", anjanath],
    [8, "Anja Arch 3", 784, 0, fire, 481, :bow, "Blazing Bow", anjanath],
    [9, "Anja Arch 4", 1007, 0, fire, 663, :bow, "Blazing Bow", anjanath],
    [10, "Anja Arch 5", 1293, 0, fire, 910, :bow, "Blazing Bow", anjanath],

    [1, "Blooming Arch 1", 100, 0, poison, 50, :bow, "Blooming Arch", pukei_pukei],
    [2, "Blooming Arch 2", 144, 0, poison, 100, :bow, "Blooming Arch", pukei_pukei],
    [3, "Blooming Arch 3", 207, 0, poison, 150, :bow, "Blooming Arch", pukei_pukei],
    [4, "Blooming Arch 4", 299, 0, poison, 200, :bow, "Blooming Arch", pukei_pukei],
    [5, "Blooming Arch 5", 430, 0, poison, 250, :bow, "Blooming Arch", pukei_pukei],
    [6, "Datura String 1", 559, 0, poison, 300, :bow, "Blooming Arch", pukei_pukei],
    [7, "Datura String 2", 727, 0, poison, 325, :bow, "Blooming Arch", pukei_pukei],
    [8, "Datura String 3", 945, 0, poison, 350, :bow, "Blooming Arch", pukei_pukei],
    [9, "Datura String 4", 1228, 0, poison, 375, :bow, "Blooming Arch", pukei_pukei],
    [10, "Datura String 5", 1596, 0, poison, 400, :bow, "Blooming Arch", pukei_pukei],

    [5, "Diablos Bow 1", 512, 0, nil, 0, :bow, "Diablos Bow", diablos],
    [6, "Diablos Coilbender 1", 671, 0, nil, 0, :bow, "Diablos Bow", diablos],
    [7, "Diablos Coilbender 2", 880, 0, nil, 0, :bow, "Diablos Bow", diablos],
    [8, "Diablos Coilbender 3", 1153, 0, nil, 0, :bow, "Diablos Bow", diablos],
    [9, "Diablos Coilbender 4", 1510, 0, nil, 0, :bow, "Diablos Bow", diablos],
    [10, "Diablos Coilbender 5", 1979, 0, nil, 0, :bow, "Diablos Bow", diablos],

    [5, "Galebender 1", 576, -30, nil, 0, :bow, "Galebender", black_diablos],
    [6, "Cera Coilbender 1", 755, -30, nil, 0, :bow, "Galebender", black_diablos],
    [7, "Cera Coilbender 2", 989, -30, nil, 0, :bow, "Galebender", black_diablos],
    [8, "Cera Coilbender 3", 1295, -30, nil, 0, :bow, "Galebender", black_diablos],
    [9, "Cera Coilbender 4", 1695, -30, nil, 0, :bow, "Galebender", black_diablos],
    [10, "Cera Coilbender 5", 2218, -30, nil, 0, :bow, "Galebender", black_diablos],

    [5, "Glacial Arrow 1", 361, 0, ice, 232, :bow, "Glacial Arrow", legiana],
    [6, "Snowfletcher 1", 461, 0, ice, 320, :bow, "Glacial Arrow", legiana],
    [7, "Snowfletcher 2", 589, 0, ice, 443, :bow, "Glacial Arrow", legiana],
    [8, "Snowfletcher 3", 751, 0, ice, 608, :bow, "Glacial Arrow", legiana],
    [9, "Snowfletcher 4", 958, 0, ice, 835, :bow, "Glacial Arrow", legiana],
    [10, "Snowfletcher 5", 1221, 0, ice, 1142, :bow, "Glacial Arrow", legiana],

    [1, "Iron Bow 1", 100, 0, nil, 0, :bow, "Iron Bow", nil],
    [2, "Iron Bow 2", 144, 0, nil, 0, :bow, "Iron Bow", nil],
    [3, "Iron Bow 3", 207, 0, nil, 0, :bow, "Iron Bow", nil],
    [4, "Iron Bow 4", 299, 0, nil, 0, :bow, "Iron Bow", nil],
    [5, "Iron Bow 5", 430, 0, nil, 0, :bow, "Iron Bow", nil],
    [6, "Steel Bow 1", 559, 0, nil, 0, :bow, "Iron Bow", nil],
    [7, "Steel Bow 2", 727, 0, nil, 0, :bow, "Iron Bow", nil],
    [8, "Steel Bow 3", 945, 0, nil, 0, :bow, "Iron Bow", nil],
    [9, "Steel Bow 4", 1228, 0, nil, 0, :bow, "Iron Bow", nil],
    [10, "Steel Bow 5", 1596, 0, nil, 0, :bow, "Iron Bow", nil],

    [1, "Kulu Arrow 1", 100, 5, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [2, "Kulu Arrow 2", 144, 10, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [3, "Kulu Arrow 3", 207, 10, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [4, "Kulu Arrow 4", 299, 15, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [5, "Kulu Arrow 5", 430, 15, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [6, "Archer's Dance 1", 559, 20, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [7, "Archer's Dance 2", 727, 20, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [8, "Archer's Dance 3", 945, 25, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [9, "Archer's Dance 4", 1228, 25, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],
    [10, "Archer's Dance 5", 1596, 30, nil, 0, :bow, "Kulu Arrow", kulu_ya_ku],

    [4, "Princess Arrow 1", 284, 0, poison, 236, :bow, "Princess Arrow", rathian],
    [5, "Princess Arrow 2", 409, 0, poison, 298, :bow, "Princess Arrow", rathian],
    [6, "Princess Arrow 3", 531, 0, poison, 360, :bow, "Princess Arrow", rathian],
    [7, "Princess Arrow 4", 691, 0, poison, 393, :bow, "Princess Arrow", rathian],
    [8, "Princess Arrow 5", 898, 0, poison, 427, :bow, "Princess Arrow", rathian],
    [9, "Princess Arrow 6", 1167, 0, poison, 461, :bow, "Princess Arrow", rathian],
    [10, "Princess Arrow 7", 1516, 0, poison, 496, :bow, "Princess Arrow", rathian],

    [2, "Pulsar Bow 1", 128, 0, thunder, 47, :bow, "Pulsar Bow", tobi_kadachi],
    [3, "Pulsar Bow 2", 182, 0, thunder, 75, :bow, "Pulsar Bow", tobi_kadachi],
    [4, "Pulsar Bow 3", 260, 0, thunder, 117, :bow, "Pulsar Bow", tobi_kadachi],
    [5, "Pulsar Bow 4", 370, 0, thunder, 181, :bow, "Pulsar Bow", tobi_kadachi],
    [6, "Kadachi Strikebow 1", 475, 0, thunder, 251, :bow, "Pulsar Bow", tobi_kadachi],
    [7, "Kadachi Strikebow 2", 611, 0, thunder, 349, :bow, "Pulsar Bow", tobi_kadachi],
    [8, "Kadachi Strikebow 3", 784, 0, thunder, 481, :bow, "Pulsar Bow", tobi_kadachi],
    [9, "Kadachi Strikebow 4", 1007, 0, thunder, 663, :bow, "Pulsar Bow", tobi_kadachi],
    [10, "Kadachi Strikebow 5", 1293, 0, thunder, 910, :bow, "Pulsar Bow", tobi_kadachi],

    [5, "Rathslinger 1", 361, 0, fire, 232, :bow, "Rathslinger", rathalos],
    [6, "Rathslinger 2", 461, 0, fire, 320, :bow, "Rathslinger", rathalos],
    [7, "Rathslinger 3", 589, 0, fire, 443, :bow, "Rathslinger", rathalos],
    [8, "Rathslinger 4", 751, 0, fire, 608, :bow, "Rathslinger", rathalos],
    [9, "Rathslinger 5", 958, 0, fire, 835, :bow, "Rathslinger", rathalos],
    [10, "Rathslinger 6", 1221, 0, fire, 1142, :bow, "Rathslinger", rathalos],

    [5, "Rosen Arrow 1", 370, 0, dragon, 181, :bow, "Rosen Arrow", pink_rathian],
    [6, "Rosen Arrow 2", 475, 0, dragon, 251, :bow, "Rosen Arrow", pink_rathian],
    [7, "Rosen Arrow 3", 611, 0, dragon, 349, :bow, "Rosen Arrow", pink_rathian],
    [8, "Rosen Arrow 4", 784, 0, dragon, 481, :bow, "Rosen Arrow", pink_rathian],
    [9, "Rosen Arrow 5", 1007, 0, dragon, 663, :bow, "Rosen Arrow", pink_rathian],
    [10, "Rosen Arrow 6", 1293, 0, dragon, 910, :bow, "Rosen Arrow", pink_rathian],

    [3, "Mammoth Greatbow 1", 236, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [4, "Mammoth Greatbow 2", 339, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [5, "Mammoth Greatbow 3", 486, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [6, "Mammoth Greatbow 4", 629, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [7, "Mammoth Greatbow 5", 814, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [8, "Mammoth Greatbow 6", 1054, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [9, "Mammoth Greatbow 7", 1363, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],
    [10, "Mammoth Greatbow 8", 1764, 0, nil, 0, :bow, "Mammoth Greatbow", banbaro],

    [4, "Icicle Blizzard 1", 234, 5, ice, 117, :bow, "Icicle Blizzard", barioth],
    [5, "Icicle Blizzard 2", 334, 10, ice, 181, :bow, "Icicle Blizzard", barioth],
    [6, "Icicle Blizzard 3", 430, 10, ice, 251, :bow, "Icicle Blizzard", barioth],
    [7, "Icicle Blizzard 4", 555, 15, ice, 349, :bow, "Icicle Blizzard", barioth],
    [8, "Icicle Blizzard 5", 716, 15, ice, 481, :bow, "Icicle Blizzard", barioth],
    [9, "Icicle Blizzard 6", 923, 20, ice, 663, :bow, "Icicle Blizzard", barioth],
    [10, "Icicle Blizzard 7", 1191, 20, ice, 910, :bow, "Icicle Blizzard", barioth],

    [5, "Usurper's Rumble 1", 361, 0, thunder, 232, :bow, "Usurper's Rumble", zinogre],
    [6, "Usurper's Rumble 2", 461, 0, thunder, 320, :bow, "Usurper's Rumble", zinogre],
    [7, "Usurper's Rumble 3", 589, 0, thunder, 443, :bow, "Usurper's Rumble", zinogre],
    [8, "Usurper's Rumble 4", 751, 0, thunder, 608, :bow, "Usurper's Rumble", zinogre],
    [9, "Usurper's Rumble 5", 958, 0, thunder, 835, :bow, "Usurper's Rumble", zinogre],
    [10, "Despot's Earlybolt 1", 1221, 0, thunder, 1142, :bow, "Usurper's Rumble", zinogre],

    [3, "Hunter's Bow 1", 207, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [4, "Hunter's Bow 2", 299, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [5, "Hunter's Bow 3", 430, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [6, "Hunter's Stoutbow 1", 559, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [7, "Hunter's Stoutbow 2", 727, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [8, "Hunter's Stoutbow 3", 945, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [9, "Hunter's Stoutbow 4", 1228, 0, nil, 0, :bow, "Hunter's Bow", nil],
    [10, "Hunter's Stoutbow 5", 1596, 0, nil, 0, :bow, "Hunter's Bow", nil],

    [5, "Azure Mightbow 1", 440, 0, fire, 134, :bow, "Azure Mightbow", azure_rathalos],
    [6, "Azure Mightbow 2", 576, 0, fire, 182, :bow, "Azure Mightbow", azure_rathalos],
    [7, "Azure Mightbow 3", 753, 0, fire, 248, :bow, "Azure Mightbow", azure_rathalos],
    [8, "Azure Mightbow 4", 985, 0, fire, 334, :bow, "Azure Mightbow", azure_rathalos],
    [9, "Azure Mightbow 5", 1287, 0, fire, 451, :bow, "Azure Mightbow", azure_rathalos],
    [10, "Azure Mightbow 6", 1682, 0, fire, 605, :bow, "Azure Mightbow", azure_rathalos],

    # #lance

    [2, "Iron Lance 1", 144, 0, nil, 0, :lance, "Iron Lance", nil],
    [3, "Iron Lance 2", 207, 0, nil, 0, :lance, "Iron Lance", nil],
    [4, "Iron Lance 3", 299, 0, nil, 0, :lance, "Iron Lance", nil],
    [5, "Iron Lance 4", 430, 0, nil, 0, :lance, "Iron Lance", nil],
    [6, "Steel Lance 1", 559, 0, nil, 0, :lance, "Iron Lance", nil],
    [7, "Steel Lance 2", 727, 0, nil, 0, :lance, "Iron Lance", nil],
    [8, "Steel Lance 3", 945, 0, nil, 0, :lance, "Iron Lance", nil],
    [9, "Steel Lance 4", 1228, 0, nil, 0, :lance, "Iron Lance", nil],
    [10, "Steel Lance 5", 1596, 0, nil, 0, :lance, "Iron Lance", nil],

    [2, "Kulu Lance 1", 144, 10, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [3, "Kulu Lance 2", 207, 10, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [4, "Kulu Lance 3", 299, 15, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [5, "Kulu Lance 4", 430, 15, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [6, "Kulu Hasta 1", 559, 20, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [7, "Kulu Hasta 2", 727, 20, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [8, "Kulu Hasta 3", 945, 25, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [9, "Kulu Hasta 4", 1228, 25, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],
    [10, "Kulu Hasta 5", 1596, 30, nil, 0, :lance, "Kulu Lance", kulu_ya_ku],

    [2, "Blooming Lance 1", 144, 0, poison, 100, :lance, "Blooming Lance", pukei_pukei],
    [3, "Blooming Lance 2", 207, 0, poison, 150, :lance, "Blooming Lance", pukei_pukei],
    [4, "Blooming Lance 3", 299, 0, poison, 200, :lance, "Blooming Lance", pukei_pukei],
    [5, "Blooming Lance 4", 430, 0, poison, 250, :lance, "Blooming Lance", pukei_pukei],
    [6, "Datura Pike 1", 559, 0, poison, 300, :lance, "Blooming Lance", pukei_pukei],
    [7, "Datura Pike 2", 727, 0, poison, 325, :lance, "Blooming Lance", pukei_pukei],
    [8, "Datura Pike 3", 945, 0, poison, 350, :lance, "Blooming Lance", pukei_pukei],
    [9, "Datura Pike 4", 1228, 0, poison, 375, :lance, "Blooming Lance", pukei_pukei],
    [10, "Datura Pike 5", 1596, 0, poison, 400, :lance, "Blooming Lance", pukei_pukei],

    [2, "Carapace Lance 1", 158, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [3, "Carapace Lance 2", 228, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [4, "Carapace Lance 3", 329, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [5, "Carapace Lance 4", 473, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [6, "Barroth Stinger 1", 615, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [7, "Barroth Stinger 2", 800, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [8, "Barroth Stinger 3", 1040, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [9, "Barroth Stinger 4", 1351, 0, nil, 0, :lance, "Carapace Lance", barroth],
    [10, "Barroth Stinger 5", 1756, 0, nil, 0, :lance, "Carapace Lance", barroth],

    [2, "Thunder Lance 1", 128, 0, thunder, 47, :lance, "Thunder Lance", tobi_kadachi],
    [3, "Thunder Lance 2", 182, 0, thunder, 75, :lance, "Thunder Lance", tobi_kadachi],
    [4, "Thunder Lance 3", 260, 0, thunder, 117, :lance, "Thunder Lance", tobi_kadachi],
    [5, "Thunder Lance 4", 370, 0, thunder, 181, :lance, "Thunder Lance", tobi_kadachi],
    [6, "Lightning Spire 1", 475, 0, thunder, 251, :lance, "Thunder Lance", tobi_kadachi],
    [7, "Lightning Spire 2", 611, 0, thunder, 349, :lance, "Thunder Lance", tobi_kadachi],
    [8, "Lightning Spire 3", 784, 0, thunder, 481, :lance, "Thunder Lance", tobi_kadachi],
    [9, "Lightning Spire 4", 1007, 0, thunder, 663, :lance, "Thunder Lance", tobi_kadachi],
    [10, "Lightning Spire 5", 1293, 0, thunder, 910, :lance, "Thunder Lance", tobi_kadachi],

    [3, "Aqua Horn 1", 182, 0, water, 75, :lance, "Aqua Horn", jyuratodus],
    [4, "Aqua Horn 2", 260, 0, water, 117, :lance, "Aqua Horn", jyuratodus],
    [5, "Aqua Horn 3", 370, 0, water, 181, :lance, "Aqua Horn", jyuratodus],
    [6, "Water Spike 1", 475, 0, water, 251, :lance, "Aqua Horn", jyuratodus],
    [7, "Water Spike 2", 611, 0, water, 349, :lance, "Aqua Horn", jyuratodus],
    [8, "Water Spike 3", 784, 0, water, 481, :lance, "Aqua Horn", jyuratodus],
    [9, "Water Spike 4", 1007, 0, water, 663, :lance, "Aqua Horn", jyuratodus],
    [10, "Water Spike 5", 1293, 0, water, 910, :lance, "Aqua Horn", jyuratodus],

    [5, "Glacial Lance 1", 361, 0, ice, 232, :lance, "Glacial Lance", legiana],
    [6, "Legiana Halberd 1", 461, 0, ice, 320, :lance, "Glacial Lance", legiana],
    [7, "Legiana Halberd 2", 589, 0, ice, 443, :lance, "Glacial Lance", legiana],
    [8, "Legiana Halberd 3", 751, 0, ice, 608, :lance, "Glacial Lance", legiana],
    [9, "Legiana Halberd 4", 958, 0, ice, 835, :lance, "Glacial Lance", legiana],
    [10, "Legiana Halberd 5", 1221, 0, ice, 1142, :lance, "Glacial Lance", legiana],

    [5, "Flame Lance 1", 361, 0, fire, 232, :lance, "Flame Lance", rathalos],
    [6, "Red Tail 1", 461, 0, fire, 320, :lance, "Flame Lance", rathalos],
    [7, "Red Tail 2", 589, 0, fire, 443, :lance, "Flame Lance", rathalos],
    [8, "Red Tail 3", 751, 0, fire, 608, :lance, "Flame Lance", rathalos],
    [9, "Red Tail 4", 958, 0, fire, 835, :lance, "Flame Lance", rathalos],
    [10, "Red Tail 5", 1221, 0, fire, 1142, :lance, "Flame Lance", rathalos],

    [4, "Tusk Lance 1", 234, 5, ice, 117, :lance, "Tusk Lance", barioth],
    [5, "Tusk Lance 2", 334, 10, ice, 181, :lance, "Tusk Lance", barioth],
    [6, "Tusk Lance+ 1", 430, 10, ice, 251, :lance, "Tusk Lance", barioth],
    [7, "Tusk Lance+ 2", 555, 15, ice, 349, :lance, "Tusk Lance", barioth],
    [8, "Tusk Lance+ 3", 716, 15, ice, 481, :lance, "Tusk Lance", barioth],
    [9, "Tusk Lance+ 4", 923, 20, ice, 663, :lance, "Tusk Lance", barioth],
    [10, "Tusk Lance+ 5", 1191, 20, ice, 910, :lance, "Tusk Lance", barioth],

    [5, "Thunderpierce 1", 361, 0, thunder, 232, :lance, "Thunderpierce", zinogre],
    [6, "Thunderpierce 2", 461, 0, thunder, 320, :lance, "Thunderpierce", zinogre],
    [7, "Thunderpierce 3", 589, 0, thunder, 443, :lance, "Thunderpierce", zinogre],
    [8, "Thunderpierce 4", 751, 0, thunder, 608, :lance, "Thunderpierce", zinogre],
    [9, "Thunderpierce 5", 958, 0, thunder, 835, :lance, "Thunderpierce", zinogre],
    [10, "Thunderpierce 6", 1221, 0, thunder, 1142, :lance, "Thunderpierce", zinogre],

    [5, "Blue Tail 1", 440, 0, fire, 134, :lance, "Blue Tail", azure_rathalos],
    [6, "Blue Prominence 1", 576, 0, fire, 182, :lance, "Blue Tail", azure_rathalos],
    [7, "Blue Prominence 2", 753, 0, fire, 248, :lance, "Blue Tail", azure_rathalos],
    [8, "Blue Prominence 3", 985, 0, fire, 334, :lance, "Blue Tail", azure_rathalos],
    [9, "Blue Prominence 4", 1287, 0, fire, 451, :lance, "Blue Tail", azure_rathalos],
    [10, "Blue Prominence 5", 1682, 0, fire, 605, :lance, "Blue Tail", azure_rathalos],

    # :light_gun

    [4, "Blazing Rifle 1", 260, 0, fire, 117, :light_gun, "Blazing Rifle", anjanath],
    [5, "Blazing Rifle 2", 370, 0, fire, 181, :light_gun, "Blazing Rifle", anjanath],
    [6, "Anja Buster 1", 475, 0, fire, 251, :light_gun, "Blazing Rifle", anjanath],
    [7, "Anja Buster 2", 611, 0, fire, 349, :light_gun, "Blazing Rifle", anjanath],
    [8, "Anja Buster 3", 784, 0, fire, 481, :light_gun, "Blazing Rifle", anjanath],
    [9, "Anja Buster 4", 1007, 0, fire, 663, :light_gun, "Blazing Rifle", anjanath],
    [10, "Anja Buster 5", 1293, 0, fire, 910, :light_gun, "Blazing Rifle", anjanath],

    [1, "Carapace Rifle 1", 110, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [2, "Carapace Rifle 2", 158, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [3, "Carapace Rifle 3", 228, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [4, "Carapace Rifle 4", 329, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [5, "Carapace Rifle 5", 473, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [6, "Barroth Shot 1", 615, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [7, "Barroth Shot 2", 800, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [8, "Barroth Shot 3", 1040, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [9, "Barroth Shot 4", 1351, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],
    [10, "Barroth Shot 5", 1756, 0, nil, 0, :light_gun, "Carapace Rifle", barroth],

    [1, "Chain Blitz 1", 100, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [2, "Chain Blitz 2", 144, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [3, "Chain Blitz 3", 207, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [4, "Chain Blitz 4", 299, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [5, "Chain Blitz 5", 430, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [6, "High Chain Blitz 1", 559, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [7, "High Chain Blitz 2", 727, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [8, "High Chain Blitz 3", 945, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [9, "High Chain Blitz 4", 1228, 0, nil, 0, :light_gun, "Chain Blitz", nil],
    [10, "High Chain Blitz 5", 1596, 0, nil, 0, :light_gun, "Chain Blitz", nil],

    [5, "Flame Blitz 1", 361, 0, fire, 232, :light_gun, "Flame Blitz", rathalos],
    [6, "Rathbuster 1", 461, 0, fire, 320, :light_gun, "Flame Blitz", rathalos],
    [7, "Rathbuster 2", 589, 0, fire, 443, :light_gun, "Flame Blitz", rathalos],
    [8, "Rathbuster 3", 751, 0, fire, 608, :light_gun, "Flame Blitz", rathalos],
    [9, "Rathbuster 4", 958, 0, fire, 835, :light_gun, "Flame Blitz", rathalos],
    [10, "Rathbuster 5", 1221, 0, fire, 1142, :light_gun, "Flame Blitz", rathalos],

    [1, "Jagras Blitz 1", 95, 0, water, 25, :light_gun, "Jagras Blitz", great_jagras],
    [2, "Jagras Blitz 2", 135, 0, water, 38, :light_gun, "Jagras Blitz", great_jagras],
    [3, "Jagras Blitz 3", 193, 0, water, 59, :light_gun, "Jagras Blitz", great_jagras],
    [4, "Jagras Blitz 4", 275, 0, water, 90, :light_gun, "Jagras Blitz", great_jagras],
    [5, "Jagras Blitz 5", 391, 0, water, 136, :light_gun, "Jagras Blitz", great_jagras],
    [6, "Jagras Fire 1", 503, 0, water, 184, :light_gun, "Jagras Blitz", great_jagras],
    [7, "Jagras Fire 2", 647, 0, water, 251, :light_gun, "Jagras Blitz", great_jagras],
    [8, "Jagras Fire 3", 832, 0, water, 337, :light_gun, "Jagras Blitz", great_jagras],
    [9, "Jagras Fire 4", 1068, 0, water, 453, :light_gun, "Jagras Blitz", great_jagras],
    [10, "Jagras Fire 5", 1373, 0, water, 607, :light_gun, "Jagras Blitz", great_jagras],

    [3, "Lumu Blitz 1", 236, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [4, "Lumu Blitz 2", 339, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [5, "Lumu Blitz 3", 486, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [6, "Lumu Typhon 1", 629, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [7, "Lumu Typhon 2", 814, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [8, "Lumu Typhon 3", 1054, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [9, "Lumu Typhon 4", 1363, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],
    [10, "Lumu Typhon 5", 1764, 0, nil, 0, :light_gun, "Lumu Blitz", paolumu],

    [3, "Madness Rifle 1", 182, 0, water, 75, :light_gun, "Madness Rifle", jyuratodus],
    [4, "Madness Rifle 2", 260, 0, water, 117, :light_gun, "Madness Rifle", jyuratodus],
    [5, "Madness Rifle 3", 370, 0, water, 181, :light_gun, "Madness Rifle", jyuratodus],
    [6, "Jyura Bullet 1", 475, 0, water, 251, :light_gun, "Madness Rifle", jyuratodus],
    [7, "Jyura Bullet 2", 611, 0, water, 349, :light_gun, "Madness Rifle", jyuratodus],
    [8, "Jyura Bullet 3", 784, 0, water, 481, :light_gun, "Madness Rifle", jyuratodus],
    [9, "Jyura Bullet 4", 1007, 0, water, 663, :light_gun, "Madness Rifle", jyuratodus],
    [10, "Jyura Bullet 5", 1293, 0, water, 910, :light_gun, "Madness Rifle", jyuratodus],

    [5, "Snow Blitz 1", 361, 0, ice, 232, :light_gun, "Snow Blitz", legiana],
    [6, "Frost Blitz 1", 461, 0, ice, 320, :light_gun, "Snow Blitz", legiana],
    [7, "Frost Blitz 2", 589, 0, ice, 443, :light_gun, "Snow Blitz", legiana],
    [8, "Frost Blitz 3", 751, 0, ice, 608, :light_gun, "Snow Blitz", legiana],
    [9, "Frost Blitz 4", 958, 0, ice, 835, :light_gun, "Snow Blitz", legiana],
    [10, "Frost Blitz 5", 1221, 0, ice, 1142, :light_gun, "Snow Blitz", legiana],

    [2, "Thunder Blitz 1", 128, 0, thunder, 47, :light_gun, "Thunder Blitz", tobi_kadachi],
    [3, "Thunder Blitz 2", 182, 0, thunder, 75, :light_gun, "Thunder Blitz", tobi_kadachi],
    [4, "Thunder Blitz 3", 260, 0, thunder, 117, :light_gun, "Thunder Blitz", tobi_kadachi],
    [5, "Thunder Blitz 4", 370, 0, thunder, 181, :light_gun, "Thunder Blitz", tobi_kadachi],
    [6, "Lightning Blitz 1", 475, 0, thunder, 251, :light_gun, "Thunder Blitz", tobi_kadachi],
    [7, "Lightning Blitz 2", 611, 0, thunder, 349, :light_gun, "Thunder Blitz", tobi_kadachi],
    [8, "Lightning Blitz 3", 784, 0, thunder, 481, :light_gun, "Thunder Blitz", tobi_kadachi],
    [9, "Lightning Blitz 4", 1007, 0, thunder, 663, :light_gun, "Thunder Blitz", tobi_kadachi],
    [10, "Lightning Blitz 5", 1293, 0, thunder, 910, :light_gun, "Thunder Blitz", tobi_kadachi],

    [3, "Mammoth Bowgun 1", 236, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [4, "Mammoth Bowgun 2", 339, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [5, "Mammoth Bowgun 3", 486, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [6, "Mammoth Bowgun 4", 629, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [7, "Mammoth Bowgun 5", 814, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [8, "Mammoth Bowgun 6", 1054, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [9, "Mammoth Bowgun 7", 1363, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],
    [10, "Mammoth Bowgun 8", 1764, 0, nil, 0, :light_gun, "Mammoth Bowgun", banbaro],

    [4, "Blizzard Cannon 1", 234, 5, ice, 117, :light_gun, "Blizzard Cannon", barioth],
    [5, "Blizzard Cannon 2", 334, 10, ice, 181, :light_gun, "Blizzard Cannon", barioth],
    [6, "Blizzard Cannon+ 1", 430, 10, ice, 251, :light_gun, "Blizzard Cannon", barioth],
    [7, "Blizzard Cannon+ 2", 555, 15, ice, 349, :light_gun, "Blizzard Cannon", barioth],
    [8, "Blizzard Cannon+ 3", 716, 15, ice, 481, :light_gun, "Blizzard Cannon", barioth],
    [9, "Blizzard Cannon+ 4", 923, 20, ice, 663, :light_gun, "Blizzard Cannon", barioth],
    [10, "Blizzard Cannon+ 5", 1191, 20, ice, 910, :light_gun, "Blizzard Cannon", barioth],

    [5, "Usurper's Crime 1", 361, 0, thunder, 232, :light_gun, "Usurper's Crime", zinogre],
    [6, "Usurper's Crime 2", 461, 0, thunder, 320, :light_gun, "Usurper's Crime", zinogre],
    [7, "Usurper's Crime 3", 589, 0, thunder, 443, :light_gun, "Usurper's Crime", zinogre],
    [8, "Usurper's Crime 4", 751, 0, thunder, 608, :light_gun, "Usurper's Crime", zinogre],
    [9, "Usurper's Crime 5", 958, 0, thunder, 835, :light_gun, "Usurper's Crime", zinogre],
    [10, "Despot's Wildfire 1", 1221, 0, thunder, 1142, :light_gun, "Usurper's Crime", zinogre],

    [3, "Hunter's Rifle 1", 207, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [4, "Hunter's Rifle 2", 299, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [5, "Hunter's Rifle 3", 430, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [6, "Power Rifle 1", 559, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [7, "Power Rifle 2", 727, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [8, "Power Rifle 3", 945, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [9, "Power Rifle 4", 1228, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],
    [10, "Power Rifle 5", 1596, 0, nil, 0, :light_gun, "Hunter's Rifle", nil],

    [5, "Azure Soulscorcher 1", 440, 0, fire, 134, :light_gun, "Azure Soulscorcher", azure_rathalos],
    [6, "Azure Soulscorcher 2", 576, 0, fire, 182, :light_gun, "Azure Soulscorcher", azure_rathalos],
    [7, "Azure Soulscorcher 3", 753, 0, fire, 248, :light_gun, "Azure Soulscorcher", azure_rathalos],
    [8, "Azure Soulscorcher 4", 985, 0, fire, 334, :light_gun, "Azure Soulscorcher", azure_rathalos],
    [9, "Azure Soulscorcher 5", 1287, 0, fire, 451, :light_gun, "Azure Soulscorcher", azure_rathalos],
    [10, "Azure Soulscorcher 6", 1682, 0, fire, 605, :light_gun, "Azure Soulscorcher", azure_rathalos],
  ].each do |grade, name, power, affinity, element, element_power, subgroup, key, mon|
    group = :weapon

    mon_key = mon&.key&.to_sym
    next if mon_key.nil?
    info = mon_info.fetch(mon_key, {})

    unlock = info[:unlock]
    starter = info[:starter] == 1
    event_only = info[:eventOnly] == 1
    all_eff = info[:eff][:all]
    safe_subgroup = subgroup.to_s.tr(?_, ?-).to_sym
    eff_key = info[:eff].fetch(safe_subgroup, all_eff)

    eq_key = [key, group, subgroup]
    equipables[eq_key] ||= Equipable.find_or_create_by(key: key, group: group, sub_group: subgroup) { |eq|
      eq.attributes = {
        name: name.sub(/\s+\d+$/, ''),
        set_name: key,
        unlock_grade: unlock,
        starter: starter,
        event_only: event_only,
        atk_scheme: info.fetch(eff_key.to_sym)[:base],
        crit_scheme: info.fetch(eff_key.to_sym)[:crit],
        elem_scheme: info.fetch(eff_key.to_sym)[:ele],
        element: element,
        monster: mon,
      }
    }

    next if mon_key.nil?

    equipable = equipables[eq_key]
    table = translation_table(equipable, all)

    gr = grade
    all[:costType][gr].each do |subgr, items|
      flat_gr = ((5 * (gr - 1)) + subgr) - 1
      atk = all[:weaponVal][equipable.atk_scheme&.to_sym]&.[](flat_gr)
      crit = all[:weaponVal][equipable.crit_scheme&.to_sym]&.[](flat_gr)
      elem = all[:weaponVal][equipable.elem_scheme&.to_sym]&.[](flat_gr)
      stat = EquipableStat.create(
        name: name,
        grade: gr,
        sub_grade: subgr, 
        atk: atk,
        crit: crit,
        elem: elem,
        forge: !starter,
        equipable: equipable,
      )
      cost_set =
        if unlock == gr && subgr == 1 && !starter
          equipable.armor? ? all[:forgeArmorCost][gr] : all[:forgeWeaponCost][gr]
        else
          equipable.armor? ? all[:armorCost][gr][subgr] : all[:weaponCost][gr][subgr]
        end
      cost_set = cost_set.map(&:to_i)
      items.each.with_index do |item_code, item_idx|
        item_name = table[item_code.to_sym]
        item = Item.find_by(name: item_name)
        next if item.nil?
        ItemStat.create(
          item: item,
          equipable_stat: stat,
          grade: gr,
          sub_grade: subgr, 
          qty: cost_set[item_idx],
          equipable: equipable,
          monster: mon
        )
      end
    end
  end



  armor = [
    # TODO: Leather Set

    [1, "Jagras Helm 1", 20, "Jagras Set", great_jagras, :helm],
    [2, "Jagras Helm 2", 34, "Jagras Set", great_jagras, :helm],
    [3, "Jagras Helm 3", 49, "Jagras Set", great_jagras, :helm],
    [4, "Jagras Helm 4", 65, "Jagras Set", great_jagras, :helm],
    [5, "Jagras Helm 5", 82, "Jagras Set", great_jagras, :helm],
    [6, "Jagras Helm 6", 100, "Jagras Set", great_jagras, :helm],
    [7, "Jagras Helm 7", 119, "Jagras Set", great_jagras, :helm],
    [8, "Jagras Helm 8", 139, "Jagras Set", great_jagras, :helm],
    [9, "Jagras Helm 9", 160, "Jagras Set", great_jagras, :helm],
    [10, "Jagras Helm 10", 182, "Jagras Set", great_jagras, :helm],

    [1, "Jagras Mail 1", 20, "Jagras Set", great_jagras, :mail],
    [2, "Jagras Mail 2", 34, "Jagras Set", great_jagras, :mail],
    [3, "Jagras Mail 3", 49, "Jagras Set", great_jagras, :mail],
    [4, "Jagras Mail 4", 65, "Jagras Set", great_jagras, :mail],
    [5, "Jagras Mail 5", 82, "Jagras Set", great_jagras, :mail],
    [6, "Jagras Mail 6", 100, "Jagras Set", great_jagras, :mail],
    [7, "Jagras Mail 7", 119, "Jagras Set", great_jagras, :mail],
    [8, "Jagras Mail 8", 139, "Jagras Set", great_jagras, :mail],
    [9, "Jagras Mail 9", 160, "Jagras Set", great_jagras, :mail],
    [10, "Jagras Mail 10", 182, "Jagras Set", great_jagras, :mail],

    [1, "Jagras Vambraces 1", 20, "Jagras Set", great_jagras, :gloves],
    [2, "Jagras Vambraces 2", 34, "Jagras Set", great_jagras, :gloves],
    [3, "Jagras Vambraces 3", 49, "Jagras Set", great_jagras, :gloves],
    [4, "Jagras Vambraces 4", 65, "Jagras Set", great_jagras, :gloves],
    [5, "Jagras Vambraces 5", 82, "Jagras Set", great_jagras, :gloves],
    [6, "Jagras Vambraces 6", 100, "Jagras Set", great_jagras, :gloves],
    [7, "Jagras Vambraces 7", 119, "Jagras Set", great_jagras, :gloves],
    [8, "Jagras Vambraces 8", 139, "Jagras Set", great_jagras, :gloves],
    [9, "Jagras Vambraces 9", 160, "Jagras Set", great_jagras, :gloves],
    [10, "Jagras Vambraces 10", 182, "Jagras Set", great_jagras, :gloves],

    [1, "Jagras Coil 1", 20, "Jagras Set", great_jagras, :belt],
    [2, "Jagras Coil 2", 34, "Jagras Set", great_jagras, :belt],
    [3, "Jagras Coil 3", 49, "Jagras Set", great_jagras, :belt],
    [4, "Jagras Coil 4", 65, "Jagras Set", great_jagras, :belt],
    [5, "Jagras Coil 5", 82, "Jagras Set", great_jagras, :belt],
    [6, "Jagras Coil 6", 100, "Jagras Set", great_jagras, :belt],
    [7, "Jagras Coil 7", 119, "Jagras Set", great_jagras, :belt],
    [8, "Jagras Coil 8", 139, "Jagras Set", great_jagras, :belt],
    [9, "Jagras Coil 9", 160, "Jagras Set", great_jagras, :belt],
    [10, "Jagras Coil 10", 182, "Jagras Set", great_jagras, :belt],

    [1, "Jagras Greaves 1", 20, "Jagras Set", great_jagras, :greaves],
    [2, "Jagras Greaves 2", 34, "Jagras Set", great_jagras, :greaves],
    [3, "Jagras Greaves 3", 49, "Jagras Set", great_jagras, :greaves],
    [4, "Jagras Greaves 4", 65, "Jagras Set", great_jagras, :greaves],
    [5, "Jagras Greaves 5", 82, "Jagras Set", great_jagras, :greaves],
    [6, "Jagras Greaves 6", 100, "Jagras Set", great_jagras, :greaves],
    [7, "Jagras Greaves 7", 119, "Jagras Set", great_jagras, :greaves],
    [8, "Jagras Greaves 8", 139, "Jagras Set", great_jagras, :greaves],
    [9, "Jagras Greaves 9", 160, "Jagras Set", great_jagras, :greaves],
    [10, "Jagras Greaves 10", 182, "Jagras Set", great_jagras, :greaves],


    [1, "Kulu Helm 1", 20, "Kulu Set", kulu_ya_ku, :helm],
    [2, "Kulu Helm 2", 34, "Kulu Set", kulu_ya_ku, :helm],
    [3, "Kulu Helm 3", 49, "Kulu Set", kulu_ya_ku, :helm],
    [4, "Kulu Helm 4", 65, "Kulu Set", kulu_ya_ku, :helm],
    [5, "Kulu Helm 5", 82, "Kulu Set", kulu_ya_ku, :helm],
    [6, "Kulu Helm 6", 100, "Kulu Set", kulu_ya_ku, :helm],
    [7, "Kulu Helm 7", 119, "Kulu Set", kulu_ya_ku, :helm],
    [8, "Kulu Helm 8", 139, "Kulu Set", kulu_ya_ku, :helm],
    [9, "Kulu Helm 9", 160, "Kulu Set", kulu_ya_ku, :helm],
    [10, "Kulu Helm 10", 182, "Kulu Set", kulu_ya_ku, :helm],

    [1, "Kulu Mail 1", 20, "Kulu Set", kulu_ya_ku, :mail],
    [2, "Kulu Mail 2", 34, "Kulu Set", kulu_ya_ku, :mail],
    [3, "Kulu Mail 3", 49, "Kulu Set", kulu_ya_ku, :mail],
    [4, "Kulu Mail 4", 65, "Kulu Set", kulu_ya_ku, :mail],
    [5, "Kulu Mail 5", 82, "Kulu Set", kulu_ya_ku, :mail],
    [6, "Kulu Mail 6", 100, "Kulu Set", kulu_ya_ku, :mail],
    [7, "Kulu Mail 7", 119, "Kulu Set", kulu_ya_ku, :mail],
    [8, "Kulu Mail 8", 139, "Kulu Set", kulu_ya_ku, :mail],
    [9, "Kulu Mail 9", 160, "Kulu Set", kulu_ya_ku, :mail],
    [10, "Kulu Mail 10", 182, "Kulu Set", kulu_ya_ku, :mail],

    [1, "Kulu Vambraces 1", 20, "Kulu Set", kulu_ya_ku, :gloves],
    [2, "Kulu Vambraces 2", 34, "Kulu Set", kulu_ya_ku, :gloves],
    [3, "Kulu Vambraces 3", 49, "Kulu Set", kulu_ya_ku, :gloves],
    [4, "Kulu Vambraces 4", 65, "Kulu Set", kulu_ya_ku, :gloves],
    [5, "Kulu Vambraces 5", 82, "Kulu Set", kulu_ya_ku, :gloves],
    [6, "Kulu Vambraces 6", 100, "Kulu Set", kulu_ya_ku, :gloves],
    [7, "Kulu Vambraces 7", 119, "Kulu Set", kulu_ya_ku, :gloves],
    [8, "Kulu Vambraces 8", 139, "Kulu Set", kulu_ya_ku, :gloves],
    [9, "Kulu Vambraces 9", 160, "Kulu Set", kulu_ya_ku, :gloves],
    [10, "Kulu Vambraces 10", 182, "Kulu Set", kulu_ya_ku, :gloves],

    [1, "Kulu Coil 1", 20, "Kulu Set", kulu_ya_ku, :belt],
    [2, "Kulu Coil 2", 34, "Kulu Set", kulu_ya_ku, :belt],
    [3, "Kulu Coil 3", 49, "Kulu Set", kulu_ya_ku, :belt],
    [4, "Kulu Coil 4", 65, "Kulu Set", kulu_ya_ku, :belt],
    [5, "Kulu Coil 5", 82, "Kulu Set", kulu_ya_ku, :belt],
    [6, "Kulu Coil 6", 100, "Kulu Set", kulu_ya_ku, :belt],
    [7, "Kulu Coil 7", 119, "Kulu Set", kulu_ya_ku, :belt],
    [8, "Kulu Coil 8", 139, "Kulu Set", kulu_ya_ku, :belt],
    [9, "Kulu Coil 9", 160, "Kulu Set", kulu_ya_ku, :belt],
    [10, "Kulu Coil 10", 182, "Kulu Set", kulu_ya_ku, :belt],

    [1, "Kulu Greaves 1", 20, "Kulu Set", kulu_ya_ku, :greaves],
    [2, "Kulu Greaves 2", 34, "Kulu Set", kulu_ya_ku, :greaves],
    [3, "Kulu Greaves 3", 49, "Kulu Set", kulu_ya_ku, :greaves],
    [4, "Kulu Greaves 4", 65, "Kulu Set", kulu_ya_ku, :greaves],
    [5, "Kulu Greaves 5", 82, "Kulu Set", kulu_ya_ku, :greaves],
    [6, "Kulu Greaves 6", 100, "Kulu Set", kulu_ya_ku, :greaves],
    [7, "Kulu Greaves 7", 119, "Kulu Set", kulu_ya_ku, :greaves],
    [8, "Kulu Greaves 8", 139, "Kulu Set", kulu_ya_ku, :greaves],
    [9, "Kulu Greaves 9", 160, "Kulu Set", kulu_ya_ku, :greaves],
    [10, "Kulu Greaves 10", 182, "Kulu Set", kulu_ya_ku, :greaves],


    [1, "Pukei Helm 1", 20, "Pukei Set", pukei_pukei, :helm],
    [2, "Pukei Helm 2", 34, "Pukei Set", pukei_pukei, :helm],
    [3, "Pukei Helm 3", 49, "Pukei Set", pukei_pukei, :helm],
    [4, "Pukei Helm 4", 65, "Pukei Set", pukei_pukei, :helm],
    [5, "Pukei Helm 5", 82, "Pukei Set", pukei_pukei, :helm],
    [6, "Pukei Helm 6", 100, "Pukei Set", pukei_pukei, :helm],
    [7, "Pukei Helm 7", 119, "Pukei Set", pukei_pukei, :helm],
    [8, "Pukei Helm 8", 139, "Pukei Set", pukei_pukei, :helm],
    [9, "Pukei Helm 9", 160, "Pukei Set", pukei_pukei, :helm],
    [10, "Pukei Helm 10", 182, "Pukei Set", pukei_pukei, :helm],

    [1, "Pukei Mail 1", 20, "Pukei Set", pukei_pukei, :mail],
    [2, "Pukei Mail 2", 34, "Pukei Set", pukei_pukei, :mail],
    [3, "Pukei Mail 3", 49, "Pukei Set", pukei_pukei, :mail],
    [4, "Pukei Mail 4", 65, "Pukei Set", pukei_pukei, :mail],
    [5, "Pukei Mail 5", 82, "Pukei Set", pukei_pukei, :mail],
    [6, "Pukei Mail 6", 100, "Pukei Set", pukei_pukei, :mail],
    [7, "Pukei Mail 7", 119, "Pukei Set", pukei_pukei, :mail],
    [8, "Pukei Mail 8", 139, "Pukei Set", pukei_pukei, :mail],
    [9, "Pukei Mail 9", 160, "Pukei Set", pukei_pukei, :mail],
    [10, "Pukei Mail 10", 182, "Pukei Set", pukei_pukei, :mail],

    [1, "Pukei Vambraces 1", 20, "Pukei Set", pukei_pukei, :gloves],
    [2, "Pukei Vambraces 2", 34, "Pukei Set", pukei_pukei, :gloves],
    [3, "Pukei Vambraces 3", 49, "Pukei Set", pukei_pukei, :gloves],
    [4, "Pukei Vambraces 4", 65, "Pukei Set", pukei_pukei, :gloves],
    [5, "Pukei Vambraces 5", 82, "Pukei Set", pukei_pukei, :gloves],
    [6, "Pukei Vambraces 6", 100, "Pukei Set", pukei_pukei, :gloves],
    [7, "Pukei Vambraces 7", 119, "Pukei Set", pukei_pukei, :gloves],
    [8, "Pukei Vambraces 8", 139, "Pukei Set", pukei_pukei, :gloves],
    [9, "Pukei Vambraces 9", 160, "Pukei Set", pukei_pukei, :gloves],
    [10, "Pukei Vambraces 10", 182, "Pukei Set", pukei_pukei, :gloves],

    [1, "Pukei Coil 1", 20, "Pukei Set", pukei_pukei, :belt],
    [2, "Pukei Coil 2", 34, "Pukei Set", pukei_pukei, :belt],
    [3, "Pukei Coil 3", 49, "Pukei Set", pukei_pukei, :belt],
    [4, "Pukei Coil 4", 65, "Pukei Set", pukei_pukei, :belt],
    [5, "Pukei Coil 5", 82, "Pukei Set", pukei_pukei, :belt],
    [6, "Pukei Coil 6", 100, "Pukei Set", pukei_pukei, :belt],
    [7, "Pukei Coil 7", 119, "Pukei Set", pukei_pukei, :belt],
    [8, "Pukei Coil 8", 139, "Pukei Set", pukei_pukei, :belt],
    [9, "Pukei Coil 9", 160, "Pukei Set", pukei_pukei, :belt],
    [10, "Pukei Coil 10", 182, "Pukei Set", pukei_pukei, :belt],

    [1, "Pukei Greaves 1", 20, "Pukei Set", pukei_pukei, :greaves],
    [2, "Pukei Greaves 2", 34, "Pukei Set", pukei_pukei, :greaves],
    [3, "Pukei Greaves 3", 49, "Pukei Set", pukei_pukei, :greaves],
    [4, "Pukei Greaves 4", 65, "Pukei Set", pukei_pukei, :greaves],
    [5, "Pukei Greaves 5", 82, "Pukei Set", pukei_pukei, :greaves],
    [6, "Pukei Greaves 6", 100, "Pukei Set", pukei_pukei, :greaves],
    [7, "Pukei Greaves 7", 119, "Pukei Set", pukei_pukei, :greaves],
    [8, "Pukei Greaves 8", 139, "Pukei Set", pukei_pukei, :greaves],
    [9, "Pukei Greaves 9", 160, "Pukei Set", pukei_pukei, :greaves],
    [10, "Pukei Greaves 10", 182, "Pukei Set", pukei_pukei, :greaves],


    [1, "Barroth Helm 1", 20, "Barroth Set", barroth, :helm],
    [2, "Barroth Helm 2", 34, "Barroth Set", barroth, :helm],
    [3, "Barroth Helm 3", 49, "Barroth Set", barroth, :helm],
    [4, "Barroth Helm 4", 65, "Barroth Set", barroth, :helm],
    [5, "Barroth Helm 5", 82, "Barroth Set", barroth, :helm],
    [6, "Barroth Helm 6", 100, "Barroth Set", barroth, :helm],
    [7, "Barroth Helm 7", 119, "Barroth Set", barroth, :helm],
    [8, "Barroth Helm 8", 139, "Barroth Set", barroth, :helm],
    [9, "Barroth Helm 9", 160, "Barroth Set", barroth, :helm],
    [10, "Barroth Helm 10", 182, "Barroth Set", barroth, :helm],

    [1, "Barroth Mail 1", 20, "Barroth Set", barroth, :mail],
    [2, "Barroth Mail 2", 34, "Barroth Set", barroth, :mail],
    [3, "Barroth Mail 3", 49, "Barroth Set", barroth, :mail],
    [4, "Barroth Mail 4", 65, "Barroth Set", barroth, :mail],
    [5, "Barroth Mail 5", 82, "Barroth Set", barroth, :mail],
    [6, "Barroth Mail 6", 100, "Barroth Set", barroth, :mail],
    [7, "Barroth Mail 7", 119, "Barroth Set", barroth, :mail],
    [8, "Barroth Mail 8", 139, "Barroth Set", barroth, :mail],
    [9, "Barroth Mail 9", 160, "Barroth Set", barroth, :mail],
    [10, "Barroth Mail 10", 182, "Barroth Set", barroth, :mail],

    [1, "Barroth Vambraces 1", 20, "Barroth Set", barroth, :gloves],
    [2, "Barroth Vambraces 2", 34, "Barroth Set", barroth, :gloves],
    [3, "Barroth Vambraces 3", 49, "Barroth Set", barroth, :gloves],
    [4, "Barroth Vambraces 4", 65, "Barroth Set", barroth, :gloves],
    [5, "Barroth Vambraces 5", 82, "Barroth Set", barroth, :gloves],
    [6, "Barroth Vambraces 6", 100, "Barroth Set", barroth, :gloves],
    [7, "Barroth Vambraces 7", 119, "Barroth Set", barroth, :gloves],
    [8, "Barroth Vambraces 8", 139, "Barroth Set", barroth, :gloves],
    [9, "Barroth Vambraces 9", 160, "Barroth Set", barroth, :gloves],
    [10, "Barroth Vambraces 10", 182, "Barroth Set", barroth, :gloves],

    [1, "Barroth Coil 1", 20, "Barroth Set", barroth, :belt],
    [2, "Barroth Coil 2", 34, "Barroth Set", barroth, :belt],
    [3, "Barroth Coil 3", 49, "Barroth Set", barroth, :belt],
    [4, "Barroth Coil 4", 65, "Barroth Set", barroth, :belt],
    [5, "Barroth Coil 5", 82, "Barroth Set", barroth, :belt],
    [6, "Barroth Coil 6", 100, "Barroth Set", barroth, :belt],
    [7, "Barroth Coil 7", 119, "Barroth Set", barroth, :belt],
    [8, "Barroth Coil 8", 139, "Barroth Set", barroth, :belt],
    [9, "Barroth Coil 9", 160, "Barroth Set", barroth, :belt],
    [10, "Barroth Coil 10", 182, "Barroth Set", barroth, :belt],

    [1, "Barroth Greaves 1", 20, "Barroth Set", barroth, :greaves],
    [2, "Barroth Greaves 2", 34, "Barroth Set", barroth, :greaves],
    [3, "Barroth Greaves 3", 49, "Barroth Set", barroth, :greaves],
    [4, "Barroth Greaves 4", 65, "Barroth Set", barroth, :greaves],
    [5, "Barroth Greaves 5", 82, "Barroth Set", barroth, :greaves],
    [6, "Barroth Greaves 6", 100, "Barroth Set", barroth, :greaves],
    [7, "Barroth Greaves 7", 119, "Barroth Set", barroth, :greaves],
    [8, "Barroth Greaves 8", 139, "Barroth Set", barroth, :greaves],
    [9, "Barroth Greaves 9", 160, "Barroth Set", barroth, :greaves],
    [10, "Barroth Greaves 10", 182, "Barroth Set", barroth, :greaves],


    [1, "Girros Helm 1", 20, "Girros Set", great_girros, :helm],
    [2, "Girros Helm 2", 34, "Girros Set", great_girros, :helm],
    [3, "Girros Helm 3", 49, "Girros Set", great_girros, :helm],
    [4, "Girros Helm 4", 65, "Girros Set", great_girros, :helm],
    [5, "Girros Helm 5", 82, "Girros Set", great_girros, :helm],
    [6, "Girros Helm 6", 100, "Girros Set", great_girros, :helm],
    [7, "Girros Helm 7", 119, "Girros Set", great_girros, :helm],
    [8, "Girros Helm 8", 139, "Girros Set", great_girros, :helm],
    [9, "Girros Helm 9", 160, "Girros Set", great_girros, :helm],
    [10, "Girros Helm 10", 182, "Girros Set", great_girros, :helm],

    [1, "Girros Mail 1", 20, "Girros Set", great_girros, :mail],
    [2, "Girros Mail 2", 34, "Girros Set", great_girros, :mail],
    [3, "Girros Mail 3", 49, "Girros Set", great_girros, :mail],
    [4, "Girros Mail 4", 65, "Girros Set", great_girros, :mail],
    [5, "Girros Mail 5", 82, "Girros Set", great_girros, :mail],
    [6, "Girros Mail 6", 100, "Girros Set", great_girros, :mail],
    [7, "Girros Mail 7", 119, "Girros Set", great_girros, :mail],
    [8, "Girros Mail 8", 139, "Girros Set", great_girros, :mail],
    [9, "Girros Mail 9", 160, "Girros Set", great_girros, :mail],
    [10, "Girros Mail 10", 182, "Girros Set", great_girros, :mail],

    [1, "Girros Vambraces 1", 20, "Girros Set", great_girros, :gloves],
    [2, "Girros Vambraces 2", 34, "Girros Set", great_girros, :gloves],
    [3, "Girros Vambraces 3", 49, "Girros Set", great_girros, :gloves],
    [4, "Girros Vambraces 4", 65, "Girros Set", great_girros, :gloves],
    [5, "Girros Vambraces 5", 82, "Girros Set", great_girros, :gloves],
    [6, "Girros Vambraces 6", 100, "Girros Set", great_girros, :gloves],
    [7, "Girros Vambraces 7", 119, "Girros Set", great_girros, :gloves],
    [8, "Girros Vambraces 8", 139, "Girros Set", great_girros, :gloves],
    [9, "Girros Vambraces 9", 160, "Girros Set", great_girros, :gloves],
    [10, "Girros Vambraces 10", 182, "Girros Set", great_girros, :gloves],

    [1, "Girros Coil 1", 20, "Girros Set", great_girros, :belt],
    [2, "Girros Coil 2", 34, "Girros Set", great_girros, :belt],
    [3, "Girros Coil 3", 49, "Girros Set", great_girros, :belt],
    [4, "Girros Coil 4", 65, "Girros Set", great_girros, :belt],
    [5, "Girros Coil 5", 82, "Girros Set", great_girros, :belt],
    [6, "Girros Coil 6", 100, "Girros Set", great_girros, :belt],
    [7, "Girros Coil 7", 119, "Girros Set", great_girros, :belt],
    [8, "Girros Coil 8", 139, "Girros Set", great_girros, :belt],
    [9, "Girros Coil 9", 160, "Girros Set", great_girros, :belt],
    [10, "Girros Coil 10", 182, "Girros Set", great_girros, :belt],

    [1, "Girros Greaves 1", 20, "Girros Set", great_girros, :greaves],
    [2, "Girros Greaves 2", 34, "Girros Set", great_girros, :greaves],
    [3, "Girros Greaves 3", 49, "Girros Set", great_girros, :greaves],
    [4, "Girros Greaves 4", 65, "Girros Set", great_girros, :greaves],
    [5, "Girros Greaves 5", 82, "Girros Set", great_girros, :greaves],
    [6, "Girros Greaves 6", 100, "Girros Set", great_girros, :greaves],
    [7, "Girros Greaves 7", 119, "Girros Set", great_girros, :greaves],
    [8, "Girros Greaves 8", 139, "Girros Set", great_girros, :greaves],
    [9, "Girros Greaves 9", 160, "Girros Set", great_girros, :greaves],
    [10, "Girros Greaves 10", 182, "Girros Set", great_girros, :greaves],


    [1, "Kadachi Helm 1", 20, "Kadachi Set", tobi_kadachi, :helm],
    [2, "Kadachi Helm 2", 34, "Kadachi Set", tobi_kadachi, :helm],
    [3, "Kadachi Helm 3", 49, "Kadachi Set", tobi_kadachi, :helm],
    [4, "Kadachi Helm 4", 65, "Kadachi Set", tobi_kadachi, :helm],
    [5, "Kadachi Helm 5", 82, "Kadachi Set", tobi_kadachi, :helm],
    [6, "Kadachi Helm 6", 100, "Kadachi Set", tobi_kadachi, :helm],
    [7, "Kadachi Helm 7", 119, "Kadachi Set", tobi_kadachi, :helm],
    [8, "Kadachi Helm 8", 139, "Kadachi Set", tobi_kadachi, :helm],
    [9, "Kadachi Helm 9", 160, "Kadachi Set", tobi_kadachi, :helm],
    [10, "Kadachi Helm 10", 182, "Kadachi Set", tobi_kadachi, :helm],

    [1, "Kadachi Mail 1", 20, "Kadachi Set", tobi_kadachi, :mail],
    [2, "Kadachi Mail 2", 34, "Kadachi Set", tobi_kadachi, :mail],
    [3, "Kadachi Mail 3", 49, "Kadachi Set", tobi_kadachi, :mail],
    [4, "Kadachi Mail 4", 65, "Kadachi Set", tobi_kadachi, :mail],
    [5, "Kadachi Mail 5", 82, "Kadachi Set", tobi_kadachi, :mail],
    [6, "Kadachi Mail 6", 100, "Kadachi Set", tobi_kadachi, :mail],
    [7, "Kadachi Mail 7", 119, "Kadachi Set", tobi_kadachi, :mail],
    [8, "Kadachi Mail 8", 139, "Kadachi Set", tobi_kadachi, :mail],
    [9, "Kadachi Mail 9", 160, "Kadachi Set", tobi_kadachi, :mail],
    [10, "Kadachi Mail 10", 182, "Kadachi Set", tobi_kadachi, :mail],

    [1, "Kadachi Vambraces 1", 20, "Kadachi Set", tobi_kadachi, :gloves],
    [2, "Kadachi Vambraces 2", 34, "Kadachi Set", tobi_kadachi, :gloves],
    [3, "Kadachi Vambraces 3", 49, "Kadachi Set", tobi_kadachi, :gloves],
    [4, "Kadachi Vambraces 4", 65, "Kadachi Set", tobi_kadachi, :gloves],
    [5, "Kadachi Vambraces 5", 82, "Kadachi Set", tobi_kadachi, :gloves],
    [6, "Kadachi Vambraces 6", 100, "Kadachi Set", tobi_kadachi, :gloves],
    [7, "Kadachi Vambraces 7", 119, "Kadachi Set", tobi_kadachi, :gloves],
    [8, "Kadachi Vambraces 8", 139, "Kadachi Set", tobi_kadachi, :gloves],
    [9, "Kadachi Vambraces 9", 160, "Kadachi Set", tobi_kadachi, :gloves],
    [10, "Kadachi Vambraces 10", 182, "Kadachi Set", tobi_kadachi, :gloves],

    [1, "Kadachi Coil 1", 20, "Kadachi Set", tobi_kadachi, :belt],
    [2, "Kadachi Coil 2", 34, "Kadachi Set", tobi_kadachi, :belt],
    [3, "Kadachi Coil 3", 49, "Kadachi Set", tobi_kadachi, :belt],
    [4, "Kadachi Coil 4", 65, "Kadachi Set", tobi_kadachi, :belt],
    [5, "Kadachi Coil 5", 82, "Kadachi Set", tobi_kadachi, :belt],
    [6, "Kadachi Coil 6", 100, "Kadachi Set", tobi_kadachi, :belt],
    [7, "Kadachi Coil 7", 119, "Kadachi Set", tobi_kadachi, :belt],
    [8, "Kadachi Coil 8", 139, "Kadachi Set", tobi_kadachi, :belt],
    [9, "Kadachi Coil 9", 160, "Kadachi Set", tobi_kadachi, :belt],
    [10, "Kadachi Coil 10", 182, "Kadachi Set", tobi_kadachi, :belt],

    [1, "Kadachi Greaves 1", 20, "Kadachi Set", tobi_kadachi, :greaves],
    [2, "Kadachi Greaves 2", 34, "Kadachi Set", tobi_kadachi, :greaves],
    [3, "Kadachi Greaves 3", 49, "Kadachi Set", tobi_kadachi, :greaves],
    [4, "Kadachi Greaves 4", 65, "Kadachi Set", tobi_kadachi, :greaves],
    [5, "Kadachi Greaves 5", 82, "Kadachi Set", tobi_kadachi, :greaves],
    [6, "Kadachi Greaves 6", 100, "Kadachi Set", tobi_kadachi, :greaves],
    [7, "Kadachi Greaves 7", 119, "Kadachi Set", tobi_kadachi, :greaves],
    [8, "Kadachi Greaves 8", 139, "Kadachi Set", tobi_kadachi, :greaves],
    [9, "Kadachi Greaves 9", 160, "Kadachi Set", tobi_kadachi, :greaves],
    [10, "Kadachi Greaves 10", 182, "Kadachi Set", tobi_kadachi, :greaves],


    [1, "Lumu Helm 1", 20, "Lumu Set", paolumu, :helm],
    [2, "Lumu Helm 2", 34, "Lumu Set", paolumu, :helm],
    [3, "Lumu Helm 3", 49, "Lumu Set", paolumu, :helm],
    [4, "Lumu Helm 4", 65, "Lumu Set", paolumu, :helm],
    [5, "Lumu Helm 5", 82, "Lumu Set", paolumu, :helm],
    [6, "Lumu Helm 6", 100, "Lumu Set", paolumu, :helm],
    [7, "Lumu Helm 7", 119, "Lumu Set", paolumu, :helm],
    [8, "Lumu Helm 8", 139, "Lumu Set", paolumu, :helm],
    [9, "Lumu Helm 9", 160, "Lumu Set", paolumu, :helm],
    [10, "Lumu Helm 10", 182, "Lumu Set", paolumu, :helm],

    [1, "Lumu Mail 1", 20, "Lumu Set", paolumu, :mail],
    [2, "Lumu Mail 2", 34, "Lumu Set", paolumu, :mail],
    [3, "Lumu Mail 3", 49, "Lumu Set", paolumu, :mail],
    [4, "Lumu Mail 4", 65, "Lumu Set", paolumu, :mail],
    [5, "Lumu Mail 5", 82, "Lumu Set", paolumu, :mail],
    [6, "Lumu Mail 6", 100, "Lumu Set", paolumu, :mail],
    [7, "Lumu Mail 7", 119, "Lumu Set", paolumu, :mail],
    [8, "Lumu Mail 8", 139, "Lumu Set", paolumu, :mail],
    [9, "Lumu Mail 9", 160, "Lumu Set", paolumu, :mail],
    [10, "Lumu Mail 10", 182, "Lumu Set", paolumu, :mail],

    [1, "Lumu Vambraces 1", 20, "Lumu Set", paolumu, :gloves],
    [2, "Lumu Vambraces 2", 34, "Lumu Set", paolumu, :gloves],
    [3, "Lumu Vambraces 3", 49, "Lumu Set", paolumu, :gloves],
    [4, "Lumu Vambraces 4", 65, "Lumu Set", paolumu, :gloves],
    [5, "Lumu Vambraces 5", 82, "Lumu Set", paolumu, :gloves],
    [6, "Lumu Vambraces 6", 100, "Lumu Set", paolumu, :gloves],
    [7, "Lumu Vambraces 7", 119, "Lumu Set", paolumu, :gloves],
    [8, "Lumu Vambraces 8", 139, "Lumu Set", paolumu, :gloves],
    [9, "Lumu Vambraces 9", 160, "Lumu Set", paolumu, :gloves],
    [10, "Lumu Vambraces 10", 182, "Lumu Set", paolumu, :gloves],

    [1, "Lumu Coil 1", 20, "Lumu Set", paolumu, :belt],
    [2, "Lumu Coil 2", 34, "Lumu Set", paolumu, :belt],
    [3, "Lumu Coil 3", 49, "Lumu Set", paolumu, :belt],
    [4, "Lumu Coil 4", 65, "Lumu Set", paolumu, :belt],
    [5, "Lumu Coil 5", 82, "Lumu Set", paolumu, :belt],
    [6, "Lumu Coil 6", 100, "Lumu Set", paolumu, :belt],
    [7, "Lumu Coil 7", 119, "Lumu Set", paolumu, :belt],
    [8, "Lumu Coil 8", 139, "Lumu Set", paolumu, :belt],
    [9, "Lumu Coil 9", 160, "Lumu Set", paolumu, :belt],
    [10, "Lumu Coil 10", 182, "Lumu Set", paolumu, :belt],

    [1, "Lumu Greaves 1", 20, "Lumu Set", paolumu, :greaves],
    [2, "Lumu Greaves 2", 34, "Lumu Set", paolumu, :greaves],
    [3, "Lumu Greaves 3", 49, "Lumu Set", paolumu, :greaves],
    [4, "Lumu Greaves 4", 65, "Lumu Set", paolumu, :greaves],
    [5, "Lumu Greaves 5", 82, "Lumu Set", paolumu, :greaves],
    [6, "Lumu Greaves 6", 100, "Lumu Set", paolumu, :greaves],
    [7, "Lumu Greaves 7", 119, "Lumu Set", paolumu, :greaves],
    [8, "Lumu Greaves 8", 139, "Lumu Set", paolumu, :greaves],
    [9, "Lumu Greaves 9", 160, "Lumu Set", paolumu, :greaves],
    [10, "Lumu Greaves 10", 182, "Lumu Set", paolumu, :greaves],


    [1, "Jyuratodus Helm 1", 20, "Jyuratodus Set", jyuratodus, :helm],
    [2, "Jyuratodus Helm 2", 34, "Jyuratodus Set", jyuratodus, :helm],
    [3, "Jyuratodus Helm 3", 49, "Jyuratodus Set", jyuratodus, :helm],
    [4, "Jyuratodus Helm 4", 65, "Jyuratodus Set", jyuratodus, :helm],
    [5, "Jyuratodus Helm 5", 82, "Jyuratodus Set", jyuratodus, :helm],
    [6, "Jyuratodus Helm 6", 100, "Jyuratodus Set", jyuratodus, :helm],
    [7, "Jyuratodus Helm 7", 119, "Jyuratodus Set", jyuratodus, :helm],
    [8, "Jyuratodus Helm 8", 139, "Jyuratodus Set", jyuratodus, :helm],
    [9, "Jyuratodus Helm 9", 160, "Jyuratodus Set", jyuratodus, :helm],
    [10, "Jyuratodus Helm 10", 182, "Jyuratodus Set", jyuratodus, :helm],

    [1, "Jyuratodus Mail 1", 20, "Jyuratodus Set", jyuratodus, :mail],
    [2, "Jyuratodus Mail 2", 34, "Jyuratodus Set", jyuratodus, :mail],
    [3, "Jyuratodus Mail 3", 49, "Jyuratodus Set", jyuratodus, :mail],
    [4, "Jyuratodus Mail 4", 65, "Jyuratodus Set", jyuratodus, :mail],
    [5, "Jyuratodus Mail 5", 82, "Jyuratodus Set", jyuratodus, :mail],
    [6, "Jyuratodus Mail 6", 100, "Jyuratodus Set", jyuratodus, :mail],
    [7, "Jyuratodus Mail 7", 119, "Jyuratodus Set", jyuratodus, :mail],
    [8, "Jyuratodus Mail 8", 139, "Jyuratodus Set", jyuratodus, :mail],
    [9, "Jyuratodus Mail 9", 160, "Jyuratodus Set", jyuratodus, :mail],
    [10, "Jyuratodus Mail 10", 182, "Jyuratodus Set", jyuratodus, :mail],

    [1, "Jyuratodus Vambraces 1", 20, "Jyuratodus Set", jyuratodus, :gloves],
    [2, "Jyuratodus Vambraces 2", 34, "Jyuratodus Set", jyuratodus, :gloves],
    [3, "Jyuratodus Vambraces 3", 49, "Jyuratodus Set", jyuratodus, :gloves],
    [4, "Jyuratodus Vambraces 4", 65, "Jyuratodus Set", jyuratodus, :gloves],
    [5, "Jyuratodus Vambraces 5", 82, "Jyuratodus Set", jyuratodus, :gloves],
    [6, "Jyuratodus Vambraces 6", 100, "Jyuratodus Set", jyuratodus, :gloves],
    [7, "Jyuratodus Vambraces 7", 119, "Jyuratodus Set", jyuratodus, :gloves],
    [8, "Jyuratodus Vambraces 8", 139, "Jyuratodus Set", jyuratodus, :gloves],
    [9, "Jyuratodus Vambraces 9", 160, "Jyuratodus Set", jyuratodus, :gloves],
    [10, "Jyuratodus Vambraces 10", 182, "Jyuratodus Set", jyuratodus, :gloves],

    [1, "Jyuratodus Coil 1", 20, "Jyuratodus Set", jyuratodus, :belt],
    [2, "Jyuratodus Coil 2", 34, "Jyuratodus Set", jyuratodus, :belt],
    [3, "Jyuratodus Coil 3", 49, "Jyuratodus Set", jyuratodus, :belt],
    [4, "Jyuratodus Coil 4", 65, "Jyuratodus Set", jyuratodus, :belt],
    [5, "Jyuratodus Coil 5", 82, "Jyuratodus Set", jyuratodus, :belt],
    [6, "Jyuratodus Coil 6", 100, "Jyuratodus Set", jyuratodus, :belt],
    [7, "Jyuratodus Coil 7", 119, "Jyuratodus Set", jyuratodus, :belt],
    [8, "Jyuratodus Coil 8", 139, "Jyuratodus Set", jyuratodus, :belt],
    [9, "Jyuratodus Coil 9", 160, "Jyuratodus Set", jyuratodus, :belt],
    [10, "Jyuratodus Coil 10", 182, "Jyuratodus Set", jyuratodus, :belt],

    [1, "Jyuratodus Greaves 1", 20, "Jyuratodus Set", jyuratodus, :greaves],
    [2, "Jyuratodus Greaves 2", 34, "Jyuratodus Set", jyuratodus, :greaves],
    [3, "Jyuratodus Greaves 3", 49, "Jyuratodus Set", jyuratodus, :greaves],
    [4, "Jyuratodus Greaves 4", 65, "Jyuratodus Set", jyuratodus, :greaves],
    [5, "Jyuratodus Greaves 5", 82, "Jyuratodus Set", jyuratodus, :greaves],
    [6, "Jyuratodus Greaves 6", 100, "Jyuratodus Set", jyuratodus, :greaves],
    [7, "Jyuratodus Greaves 7", 119, "Jyuratodus Set", jyuratodus, :greaves],
    [8, "Jyuratodus Greaves 8", 139, "Jyuratodus Set", jyuratodus, :greaves],
    [9, "Jyuratodus Greaves 9", 160, "Jyuratodus Set", jyuratodus, :greaves],
    [10, "Jyuratodus Greaves 10", 182, "Jyuratodus Set", jyuratodus, :greaves],


    [1, "Anjanath Helm 1", 20, "Anjanath Set", anjanath, :helm],
    [2, "Anjanath Helm 2", 34, "Anjanath Set", anjanath, :helm],
    [3, "Anjanath Helm 3", 49, "Anjanath Set", anjanath, :helm],
    [4, "Anjanath Helm 4", 65, "Anjanath Set", anjanath, :helm],
    [5, "Anjanath Helm 5", 82, "Anjanath Set", anjanath, :helm],
    [6, "Anjanath Helm 6", 100, "Anjanath Set", anjanath, :helm],
    [7, "Anjanath Helm 7", 119, "Anjanath Set", anjanath, :helm],
    [8, "Anjanath Helm 8", 139, "Anjanath Set", anjanath, :helm],
    [9, "Anjanath Helm 9", 160, "Anjanath Set", anjanath, :helm],
    [10, "Anjanath Helm 10", 182, "Anjanath Set", anjanath, :helm],

    [1, "Anjanath Mail 1", 20, "Anjanath Set", anjanath, :mail],
    [2, "Anjanath Mail 2", 34, "Anjanath Set", anjanath, :mail],
    [3, "Anjanath Mail 3", 49, "Anjanath Set", anjanath, :mail],
    [4, "Anjanath Mail 4", 65, "Anjanath Set", anjanath, :mail],
    [5, "Anjanath Mail 5", 82, "Anjanath Set", anjanath, :mail],
    [6, "Anjanath Mail 6", 100, "Anjanath Set", anjanath, :mail],
    [7, "Anjanath Mail 7", 119, "Anjanath Set", anjanath, :mail],
    [8, "Anjanath Mail 8", 139, "Anjanath Set", anjanath, :mail],
    [9, "Anjanath Mail 9", 160, "Anjanath Set", anjanath, :mail],
    [10, "Anjanath Mail 10", 182, "Anjanath Set", anjanath, :mail],

    [1, "Anjanath Vambraces 1", 20, "Anjanath Set", anjanath, :gloves],
    [2, "Anjanath Vambraces 2", 34, "Anjanath Set", anjanath, :gloves],
    [3, "Anjanath Vambraces 3", 49, "Anjanath Set", anjanath, :gloves],
    [4, "Anjanath Vambraces 4", 65, "Anjanath Set", anjanath, :gloves],
    [5, "Anjanath Vambraces 5", 82, "Anjanath Set", anjanath, :gloves],
    [6, "Anjanath Vambraces 6", 100, "Anjanath Set", anjanath, :gloves],
    [7, "Anjanath Vambraces 7", 119, "Anjanath Set", anjanath, :gloves],
    [8, "Anjanath Vambraces 8", 139, "Anjanath Set", anjanath, :gloves],
    [9, "Anjanath Vambraces 9", 160, "Anjanath Set", anjanath, :gloves],
    [10, "Anjanath Vambraces 10", 182, "Anjanath Set", anjanath, :gloves],

    [1, "Anjanath Coil 1", 20, "Anjanath Set", anjanath, :belt],
    [2, "Anjanath Coil 2", 34, "Anjanath Set", anjanath, :belt],
    [3, "Anjanath Coil 3", 49, "Anjanath Set", anjanath, :belt],
    [4, "Anjanath Coil 4", 65, "Anjanath Set", anjanath, :belt],
    [5, "Anjanath Coil 5", 82, "Anjanath Set", anjanath, :belt],
    [6, "Anjanath Coil 6", 100, "Anjanath Set", anjanath, :belt],
    [7, "Anjanath Coil 7", 119, "Anjanath Set", anjanath, :belt],
    [8, "Anjanath Coil 8", 139, "Anjanath Set", anjanath, :belt],
    [9, "Anjanath Coil 9", 160, "Anjanath Set", anjanath, :belt],
    [10, "Anjanath Coil 10", 182, "Anjanath Set", anjanath, :belt],

    [1, "Anjanath Greaves 1", 20, "Anjanath Set", anjanath, :greaves],
    [2, "Anjanath Greaves 2", 34, "Anjanath Set", anjanath, :greaves],
    [3, "Anjanath Greaves 3", 49, "Anjanath Set", anjanath, :greaves],
    [4, "Anjanath Greaves 4", 65, "Anjanath Set", anjanath, :greaves],
    [5, "Anjanath Greaves 5", 82, "Anjanath Set", anjanath, :greaves],
    [6, "Anjanath Greaves 6", 100, "Anjanath Set", anjanath, :greaves],
    [7, "Anjanath Greaves 7", 119, "Anjanath Set", anjanath, :greaves],
    [8, "Anjanath Greaves 8", 139, "Anjanath Set", anjanath, :greaves],
    [9, "Anjanath Greaves 9", 160, "Anjanath Set", anjanath, :greaves],
    [10, "Anjanath Greaves 10", 182, "Anjanath Set", anjanath, :greaves],


    [1, "Rathian Helm 1", 20, "Rathian Set", rathian, :helm],
    [2, "Rathian Helm 2", 34, "Rathian Set", rathian, :helm],
    [3, "Rathian Helm 3", 49, "Rathian Set", rathian, :helm],
    [4, "Rathian Helm 4", 65, "Rathian Set", rathian, :helm],
    [5, "Rathian Helm 5", 82, "Rathian Set", rathian, :helm],
    [6, "Rathian Helm 6", 100, "Rathian Set", rathian, :helm],
    [7, "Rathian Helm 7", 119, "Rathian Set", rathian, :helm],
    [8, "Rathian Helm 8", 139, "Rathian Set", rathian, :helm],
    [9, "Rathian Helm 9", 160, "Rathian Set", rathian, :helm],
    [10, "Rathian Helm 10", 182, "Rathian Set", rathian, :helm],

    [1, "Rathian Mail 1", 20, "Rathian Set", rathian, :mail],
    [2, "Rathian Mail 2", 34, "Rathian Set", rathian, :mail],
    [3, "Rathian Mail 3", 49, "Rathian Set", rathian, :mail],
    [4, "Rathian Mail 4", 65, "Rathian Set", rathian, :mail],
    [5, "Rathian Mail 5", 82, "Rathian Set", rathian, :mail],
    [6, "Rathian Mail 6", 100, "Rathian Set", rathian, :mail],
    [7, "Rathian Mail 7", 119, "Rathian Set", rathian, :mail],
    [8, "Rathian Mail 8", 139, "Rathian Set", rathian, :mail],
    [9, "Rathian Mail 9", 160, "Rathian Set", rathian, :mail],
    [10, "Rathian Mail 10", 182, "Rathian Set", rathian, :mail],

    [1, "Rathian Vambraces 1", 20, "Rathian Set", rathian, :gloves],
    [2, "Rathian Vambraces 2", 34, "Rathian Set", rathian, :gloves],
    [3, "Rathian Vambraces 3", 49, "Rathian Set", rathian, :gloves],
    [4, "Rathian Vambraces 4", 65, "Rathian Set", rathian, :gloves],
    [5, "Rathian Vambraces 5", 82, "Rathian Set", rathian, :gloves],
    [6, "Rathian Vambraces 6", 100, "Rathian Set", rathian, :gloves],
    [7, "Rathian Vambraces 7", 119, "Rathian Set", rathian, :gloves],
    [8, "Rathian Vambraces 8", 139, "Rathian Set", rathian, :gloves],
    [9, "Rathian Vambraces 9", 160, "Rathian Set", rathian, :gloves],
    [10, "Rathian Vambraces 10", 182, "Rathian Set", rathian, :gloves],

    [1, "Rathian Coil 1", 20, "Rathian Set", rathian, :belt],
    [2, "Rathian Coil 2", 34, "Rathian Set", rathian, :belt],
    [3, "Rathian Coil 3", 49, "Rathian Set", rathian, :belt],
    [4, "Rathian Coil 4", 65, "Rathian Set", rathian, :belt],
    [5, "Rathian Coil 5", 82, "Rathian Set", rathian, :belt],
    [6, "Rathian Coil 6", 100, "Rathian Set", rathian, :belt],
    [7, "Rathian Coil 7", 119, "Rathian Set", rathian, :belt],
    [8, "Rathian Coil 8", 139, "Rathian Set", rathian, :belt],
    [9, "Rathian Coil 9", 160, "Rathian Set", rathian, :belt],
    [10, "Rathian Coil 10", 182, "Rathian Set", rathian, :belt],

    [1, "Rathian Greaves 1", 20, "Rathian Set", rathian, :greaves],
    [2, "Rathian Greaves 2", 34, "Rathian Set", rathian, :greaves],
    [3, "Rathian Greaves 3", 49, "Rathian Set", rathian, :greaves],
    [4, "Rathian Greaves 4", 65, "Rathian Set", rathian, :greaves],
    [5, "Rathian Greaves 5", 82, "Rathian Set", rathian, :greaves],
    [6, "Rathian Greaves 6", 100, "Rathian Set", rathian, :greaves],
    [7, "Rathian Greaves 7", 119, "Rathian Set", rathian, :greaves],
    [8, "Rathian Greaves 8", 139, "Rathian Set", rathian, :greaves],
    [9, "Rathian Greaves 9", 160, "Rathian Set", rathian, :greaves],
    [10, "Rathian Greaves 10", 182, "Rathian Set", rathian, :greaves],


    [1, "Pink Rathian Helm 1", 20, "Pink Rathian Set", pink_rathian, :helm],
    [2, "Pink Rathian Helm 2", 34, "Pink Rathian Set", pink_rathian, :helm],
    [3, "Pink Rathian Helm 3", 49, "Pink Rathian Set", pink_rathian, :helm],
    [4, "Pink Rathian Helm 4", 65, "Pink Rathian Set", pink_rathian, :helm],
    [5, "Pink Rathian Helm 5", 82, "Pink Rathian Set", pink_rathian, :helm],
    [6, "Pink Rathian Helm 6", 100, "Pink Rathian Set", pink_rathian, :helm],
    [7, "Pink Rathian Helm 7", 119, "Pink Rathian Set", pink_rathian, :helm],
    [8, "Pink Rathian Helm 8", 139, "Pink Rathian Set", pink_rathian, :helm],
    [9, "Pink Rathian Helm 9", 160, "Pink Rathian Set", pink_rathian, :helm],
    [10, "Pink Rathian Helm 10", 182, "Pink Rathian Set", pink_rathian, :helm],

    [1, "Pink Rathian Mail 1", 20, "Pink Rathian Set", pink_rathian, :mail],
    [2, "Pink Rathian Mail 2", 34, "Pink Rathian Set", pink_rathian, :mail],
    [3, "Pink Rathian Mail 3", 49, "Pink Rathian Set", pink_rathian, :mail],
    [4, "Pink Rathian Mail 4", 65, "Pink Rathian Set", pink_rathian, :mail],
    [5, "Pink Rathian Mail 5", 82, "Pink Rathian Set", pink_rathian, :mail],
    [6, "Pink Rathian Mail 6", 100, "Pink Rathian Set", pink_rathian, :mail],
    [7, "Pink Rathian Mail 7", 119, "Pink Rathian Set", pink_rathian, :mail],
    [8, "Pink Rathian Mail 8", 139, "Pink Rathian Set", pink_rathian, :mail],
    [9, "Pink Rathian Mail 9", 160, "Pink Rathian Set", pink_rathian, :mail],
    [10, "Pink Rathian Mail 10", 182, "Pink Rathian Set", pink_rathian, :mail],

    [1, "Pink Rathian Vambraces 1", 20, "Pink Rathian Set", pink_rathian, :gloves],
    [2, "Pink Rathian Vambraces 2", 34, "Pink Rathian Set", pink_rathian, :gloves],
    [3, "Pink Rathian Vambraces 3", 49, "Pink Rathian Set", pink_rathian, :gloves],
    [4, "Pink Rathian Vambraces 4", 65, "Pink Rathian Set", pink_rathian, :gloves],
    [5, "Pink Rathian Vambraces 5", 82, "Pink Rathian Set", pink_rathian, :gloves],
    [6, "Pink Rathian Vambraces 6", 100, "Pink Rathian Set", pink_rathian, :gloves],
    [7, "Pink Rathian Vambraces 7", 119, "Pink Rathian Set", pink_rathian, :gloves],
    [8, "Pink Rathian Vambraces 8", 139, "Pink Rathian Set", pink_rathian, :gloves],
    [9, "Pink Rathian Vambraces 9", 160, "Pink Rathian Set", pink_rathian, :gloves],
    [10, "Pink Rathian Vambraces 10", 182, "Pink Rathian Set", pink_rathian, :gloves],

    [1, "Pink Rathian Coil 1", 20, "Pink Rathian Set", pink_rathian, :belt],
    [2, "Pink Rathian Coil 2", 34, "Pink Rathian Set", pink_rathian, :belt],
    [3, "Pink Rathian Coil 3", 49, "Pink Rathian Set", pink_rathian, :belt],
    [4, "Pink Rathian Coil 4", 65, "Pink Rathian Set", pink_rathian, :belt],
    [5, "Pink Rathian Coil 5", 82, "Pink Rathian Set", pink_rathian, :belt],
    [6, "Pink Rathian Coil 6", 100, "Pink Rathian Set", pink_rathian, :belt],
    [7, "Pink Rathian Coil 7", 119, "Pink Rathian Set", pink_rathian, :belt],
    [8, "Pink Rathian Coil 8", 139, "Pink Rathian Set", pink_rathian, :belt],
    [9, "Pink Rathian Coil 9", 160, "Pink Rathian Set", pink_rathian, :belt],
    [10, "Pink Rathian Coil 10", 182, "Pink Rathian Set", pink_rathian, :belt],

    [1, "Pink Rathian Greaves 1", 20, "Pink Rathian Set", pink_rathian, :greaves],
    [2, "Pink Rathian Greaves 2", 34, "Pink Rathian Set", pink_rathian, :greaves],
    [3, "Pink Rathian Greaves 3", 49, "Pink Rathian Set", pink_rathian, :greaves],
    [4, "Pink Rathian Greaves 4", 65, "Pink Rathian Set", pink_rathian, :greaves],
    [5, "Pink Rathian Greaves 5", 82, "Pink Rathian Set", pink_rathian, :greaves],
    [6, "Pink Rathian Greaves 6", 100, "Pink Rathian Set", pink_rathian, :greaves],
    [7, "Pink Rathian Greaves 7", 119, "Pink Rathian Set", pink_rathian, :greaves],
    [8, "Pink Rathian Greaves 8", 139, "Pink Rathian Set", pink_rathian, :greaves],
    [9, "Pink Rathian Greaves 9", 160, "Pink Rathian Set", pink_rathian, :greaves],
    [10, "Pink Rathian Greaves 10", 182, "Pink Rathian Set", pink_rathian, :greaves],


    [1, "Legiana Helm 1", 20, "Legiana Set", legiana, :helm],
    [2, "Legiana Helm 2", 34, "Legiana Set", legiana, :helm],
    [3, "Legiana Helm 3", 49, "Legiana Set", legiana, :helm],
    [4, "Legiana Helm 4", 65, "Legiana Set", legiana, :helm],
    [5, "Legiana Helm 5", 82, "Legiana Set", legiana, :helm],
    [6, "Legiana Helm 6", 100, "Legiana Set", legiana, :helm],
    [7, "Legiana Helm 7", 119, "Legiana Set", legiana, :helm],
    [8, "Legiana Helm 8", 139, "Legiana Set", legiana, :helm],
    [9, "Legiana Helm 9", 160, "Legiana Set", legiana, :helm],
    [10, "Legiana Helm 10", 182, "Legiana Set", legiana, :helm],

    [1, "Legiana Mail 1", 20, "Legiana Set", legiana, :mail],
    [2, "Legiana Mail 2", 34, "Legiana Set", legiana, :mail],
    [3, "Legiana Mail 3", 49, "Legiana Set", legiana, :mail],
    [4, "Legiana Mail 4", 65, "Legiana Set", legiana, :mail],
    [5, "Legiana Mail 5", 82, "Legiana Set", legiana, :mail],
    [6, "Legiana Mail 6", 100, "Legiana Set", legiana, :mail],
    [7, "Legiana Mail 7", 119, "Legiana Set", legiana, :mail],
    [8, "Legiana Mail 8", 139, "Legiana Set", legiana, :mail],
    [9, "Legiana Mail 9", 160, "Legiana Set", legiana, :mail],
    [10, "Legiana Mail 10", 182, "Legiana Set", legiana, :mail],

    [1, "Legiana Vambraces 1", 20, "Legiana Set", legiana, :gloves],
    [2, "Legiana Vambraces 2", 34, "Legiana Set", legiana, :gloves],
    [3, "Legiana Vambraces 3", 49, "Legiana Set", legiana, :gloves],
    [4, "Legiana Vambraces 4", 65, "Legiana Set", legiana, :gloves],
    [5, "Legiana Vambraces 5", 82, "Legiana Set", legiana, :gloves],
    [6, "Legiana Vambraces 6", 100, "Legiana Set", legiana, :gloves],
    [7, "Legiana Vambraces 7", 119, "Legiana Set", legiana, :gloves],
    [8, "Legiana Vambraces 8", 139, "Legiana Set", legiana, :gloves],
    [9, "Legiana Vambraces 9", 160, "Legiana Set", legiana, :gloves],
    [10, "Legiana Vambraces 10", 182, "Legiana Set", legiana, :gloves],

    [1, "Legiana Coil 1", 20, "Legiana Set", legiana, :belt],
    [2, "Legiana Coil 2", 34, "Legiana Set", legiana, :belt],
    [3, "Legiana Coil 3", 49, "Legiana Set", legiana, :belt],
    [4, "Legiana Coil 4", 65, "Legiana Set", legiana, :belt],
    [5, "Legiana Coil 5", 82, "Legiana Set", legiana, :belt],
    [6, "Legiana Coil 6", 100, "Legiana Set", legiana, :belt],
    [7, "Legiana Coil 7", 119, "Legiana Set", legiana, :belt],
    [8, "Legiana Coil 8", 139, "Legiana Set", legiana, :belt],
    [9, "Legiana Coil 9", 160, "Legiana Set", legiana, :belt],
    [10, "Legiana Coil 10", 182, "Legiana Set", legiana, :belt],

    [1, "Legiana Greaves 1", 20, "Legiana Set", legiana, :greaves],
    [2, "Legiana Greaves 2", 34, "Legiana Set", legiana, :greaves],
    [3, "Legiana Greaves 3", 49, "Legiana Set", legiana, :greaves],
    [4, "Legiana Greaves 4", 65, "Legiana Set", legiana, :greaves],
    [5, "Legiana Greaves 5", 82, "Legiana Set", legiana, :greaves],
    [6, "Legiana Greaves 6", 100, "Legiana Set", legiana, :greaves],
    [7, "Legiana Greaves 7", 119, "Legiana Set", legiana, :greaves],
    [8, "Legiana Greaves 8", 139, "Legiana Set", legiana, :greaves],
    [9, "Legiana Greaves 9", 160, "Legiana Set", legiana, :greaves],
    [10, "Legiana Greaves 10", 182, "Legiana Set", legiana, :greaves],


    [1, "Diablos Helm 1", 20, "Diablos Set", diablos, :helm],
    [2, "Diablos Helm 2", 34, "Diablos Set", diablos, :helm],
    [3, "Diablos Helm 3", 49, "Diablos Set", diablos, :helm],
    [4, "Diablos Helm 4", 65, "Diablos Set", diablos, :helm],
    [5, "Diablos Helm 5", 82, "Diablos Set", diablos, :helm],
    [6, "Diablos Helm 6", 100, "Diablos Set", diablos, :helm],
    [7, "Diablos Helm 7", 119, "Diablos Set", diablos, :helm],
    [8, "Diablos Helm 8", 139, "Diablos Set", diablos, :helm],
    [9, "Diablos Helm 9", 160, "Diablos Set", diablos, :helm],
    [10, "Diablos Helm 10", 182, "Diablos Set", diablos, :helm],

    [1, "Diablos Mail 1", 20, "Diablos Set", diablos, :mail],
    [2, "Diablos Mail 2", 34, "Diablos Set", diablos, :mail],
    [3, "Diablos Mail 3", 49, "Diablos Set", diablos, :mail],
    [4, "Diablos Mail 4", 65, "Diablos Set", diablos, :mail],
    [5, "Diablos Mail 5", 82, "Diablos Set", diablos, :mail],
    [6, "Diablos Mail 6", 100, "Diablos Set", diablos, :mail],
    [7, "Diablos Mail 7", 119, "Diablos Set", diablos, :mail],
    [8, "Diablos Mail 8", 139, "Diablos Set", diablos, :mail],
    [9, "Diablos Mail 9", 160, "Diablos Set", diablos, :mail],
    [10, "Diablos Mail 10", 182, "Diablos Set", diablos, :mail],

    [1, "Diablos Vambraces 1", 20, "Diablos Set", diablos, :gloves],
    [2, "Diablos Vambraces 2", 34, "Diablos Set", diablos, :gloves],
    [3, "Diablos Vambraces 3", 49, "Diablos Set", diablos, :gloves],
    [4, "Diablos Vambraces 4", 65, "Diablos Set", diablos, :gloves],
    [5, "Diablos Vambraces 5", 82, "Diablos Set", diablos, :gloves],
    [6, "Diablos Vambraces 6", 100, "Diablos Set", diablos, :gloves],
    [7, "Diablos Vambraces 7", 119, "Diablos Set", diablos, :gloves],
    [8, "Diablos Vambraces 8", 139, "Diablos Set", diablos, :gloves],
    [9, "Diablos Vambraces 9", 160, "Diablos Set", diablos, :gloves],
    [10, "Diablos Vambraces 10", 182, "Diablos Set", diablos, :gloves],

    [1, "Diablos Coil 1", 20, "Diablos Set", diablos, :belt],
    [2, "Diablos Coil 2", 34, "Diablos Set", diablos, :belt],
    [3, "Diablos Coil 3", 49, "Diablos Set", diablos, :belt],
    [4, "Diablos Coil 4", 65, "Diablos Set", diablos, :belt],
    [5, "Diablos Coil 5", 82, "Diablos Set", diablos, :belt],
    [6, "Diablos Coil 6", 100, "Diablos Set", diablos, :belt],
    [7, "Diablos Coil 7", 119, "Diablos Set", diablos, :belt],
    [8, "Diablos Coil 8", 139, "Diablos Set", diablos, :belt],
    [9, "Diablos Coil 9", 160, "Diablos Set", diablos, :belt],
    [10, "Diablos Coil 10", 182, "Diablos Set", diablos, :belt],

    [1, "Diablos Greaves 1", 20, "Diablos Set", diablos, :greaves],
    [2, "Diablos Greaves 2", 34, "Diablos Set", diablos, :greaves],
    [3, "Diablos Greaves 3", 49, "Diablos Set", diablos, :greaves],
    [4, "Diablos Greaves 4", 65, "Diablos Set", diablos, :greaves],
    [5, "Diablos Greaves 5", 82, "Diablos Set", diablos, :greaves],
    [6, "Diablos Greaves 6", 100, "Diablos Set", diablos, :greaves],
    [7, "Diablos Greaves 7", 119, "Diablos Set", diablos, :greaves],
    [8, "Diablos Greaves 8", 139, "Diablos Set", diablos, :greaves],
    [9, "Diablos Greaves 9", 160, "Diablos Set", diablos, :greaves],
    [10, "Diablos Greaves 10", 182, "Diablos Set", diablos, :greaves],


    [1, "Black Diablos Helm 1", 20, "Black Diablos Set", diablos, :helm],
    [2, "Black Diablos Helm 2", 34, "Black Diablos Set", diablos, :helm],
    [3, "Black Diablos Helm 3", 49, "Black Diablos Set", diablos, :helm],
    [4, "Black Diablos Helm 4", 65, "Black Diablos Set", diablos, :helm],
    [5, "Black Diablos Helm 5", 82, "Black Diablos Set", diablos, :helm],
    [6, "Black Diablos Helm 6", 100, "Black Diablos Set", diablos, :helm],
    [7, "Black Diablos Helm 7", 119, "Black Diablos Set", diablos, :helm],
    [8, "Black Diablos Helm 8", 139, "Black Diablos Set", diablos, :helm],
    [9, "Black Diablos Helm 9", 160, "Black Diablos Set", diablos, :helm],
    [10, "Black Diablos Helm 10", 182, "Black Diablos Set", diablos, :helm],

    [1, "Black Diablos Mail 1", 20, "Black Diablos Set", diablos, :mail],
    [2, "Black Diablos Mail 2", 34, "Black Diablos Set", diablos, :mail],
    [3, "Black Diablos Mail 3", 49, "Black Diablos Set", diablos, :mail],
    [4, "Black Diablos Mail 4", 65, "Black Diablos Set", diablos, :mail],
    [5, "Black Diablos Mail 5", 82, "Black Diablos Set", diablos, :mail],
    [6, "Black Diablos Mail 6", 100, "Black Diablos Set", diablos, :mail],
    [7, "Black Diablos Mail 7", 119, "Black Diablos Set", diablos, :mail],
    [8, "Black Diablos Mail 8", 139, "Black Diablos Set", diablos, :mail],
    [9, "Black Diablos Mail 9", 160, "Black Diablos Set", diablos, :mail],
    [10, "Black Diablos Mail 10", 182, "Black Diablos Set", diablos, :mail],

    [1, "Black Diablos Vambraces 1", 20, "Black Diablos Set", diablos, :gloves],
    [2, "Black Diablos Vambraces 2", 34, "Black Diablos Set", diablos, :gloves],
    [3, "Black Diablos Vambraces 3", 49, "Black Diablos Set", diablos, :gloves],
    [4, "Black Diablos Vambraces 4", 65, "Black Diablos Set", diablos, :gloves],
    [5, "Black Diablos Vambraces 5", 82, "Black Diablos Set", diablos, :gloves],
    [6, "Black Diablos Vambraces 6", 100, "Black Diablos Set", diablos, :gloves],
    [7, "Black Diablos Vambraces 7", 119, "Black Diablos Set", diablos, :gloves],
    [8, "Black Diablos Vambraces 8", 139, "Black Diablos Set", diablos, :gloves],
    [9, "Black Diablos Vambraces 9", 160, "Black Diablos Set", diablos, :gloves],
    [10, "Black Diablos Vambraces 10", 182, "Black Diablos Set", diablos, :gloves],

    [1, "Black Diablos Coil 1", 20, "Black Diablos Set", diablos, :belt],
    [2, "Black Diablos Coil 2", 34, "Black Diablos Set", diablos, :belt],
    [3, "Black Diablos Coil 3", 49, "Black Diablos Set", diablos, :belt],
    [4, "Black Diablos Coil 4", 65, "Black Diablos Set", diablos, :belt],
    [5, "Black Diablos Coil 5", 82, "Black Diablos Set", diablos, :belt],
    [6, "Black Diablos Coil 6", 100, "Black Diablos Set", diablos, :belt],
    [7, "Black Diablos Coil 7", 119, "Black Diablos Set", diablos, :belt],
    [8, "Black Diablos Coil 8", 139, "Black Diablos Set", diablos, :belt],
    [9, "Black Diablos Coil 9", 160, "Black Diablos Set", diablos, :belt],
    [10, "Black Diablos Coil 10", 182, "Black Diablos Set", diablos, :belt],

    [1, "Black Diablos Greaves 1", 20, "Black Diablos Set", diablos, :greaves],
    [2, "Black Diablos Greaves 2", 34, "Black Diablos Set", diablos, :greaves],
    [3, "Black Diablos Greaves 3", 49, "Black Diablos Set", diablos, :greaves],
    [4, "Black Diablos Greaves 4", 65, "Black Diablos Set", diablos, :greaves],
    [5, "Black Diablos Greaves 5", 82, "Black Diablos Set", diablos, :greaves],
    [6, "Black Diablos Greaves 6", 100, "Black Diablos Set", diablos, :greaves],
    [7, "Black Diablos Greaves 7", 119, "Black Diablos Set", diablos, :greaves],
    [8, "Black Diablos Greaves 8", 139, "Black Diablos Set", diablos, :greaves],
    [9, "Black Diablos Greaves 9", 160, "Black Diablos Set", diablos, :greaves],
    [10, "Black Diablos Greaves 10", 182, "Black Diablos Set", diablos, :greaves],


    [1, "Rathalos Helm 1", 20, "Rathalos Set", rathalos, :helm],
    [2, "Rathalos Helm 2", 34, "Rathalos Set", rathalos, :helm],
    [3, "Rathalos Helm 3", 49, "Rathalos Set", rathalos, :helm],
    [4, "Rathalos Helm 4", 65, "Rathalos Set", rathalos, :helm],
    [5, "Rathalos Helm 5", 82, "Rathalos Set", rathalos, :helm],
    [6, "Rathalos Helm 6", 100, "Rathalos Set", rathalos, :helm],
    [7, "Rathalos Helm 7", 119, "Rathalos Set", rathalos, :helm],
    [8, "Rathalos Helm 8", 139, "Rathalos Set", rathalos, :helm],
    [9, "Rathalos Helm 9", 160, "Rathalos Set", rathalos, :helm],
    [10, "Rathalos Helm 10", 182, "Rathalos Set", rathalos, :helm],

    [1, "Rathalos Mail 1", 20, "Rathalos Set", rathalos, :mail],
    [2, "Rathalos Mail 2", 34, "Rathalos Set", rathalos, :mail],
    [3, "Rathalos Mail 3", 49, "Rathalos Set", rathalos, :mail],
    [4, "Rathalos Mail 4", 65, "Rathalos Set", rathalos, :mail],
    [5, "Rathalos Mail 5", 82, "Rathalos Set", rathalos, :mail],
    [6, "Rathalos Mail 6", 100, "Rathalos Set", rathalos, :mail],
    [7, "Rathalos Mail 7", 119, "Rathalos Set", rathalos, :mail],
    [8, "Rathalos Mail 8", 139, "Rathalos Set", rathalos, :mail],
    [9, "Rathalos Mail 9", 160, "Rathalos Set", rathalos, :mail],
    [10, "Rathalos Mail 10", 182, "Rathalos Set", rathalos, :mail],

    [1, "Rathalos Vambraces 1", 20, "Rathalos Set", rathalos, :gloves],
    [2, "Rathalos Vambraces 2", 34, "Rathalos Set", rathalos, :gloves],
    [3, "Rathalos Vambraces 3", 49, "Rathalos Set", rathalos, :gloves],
    [4, "Rathalos Vambraces 4", 65, "Rathalos Set", rathalos, :gloves],
    [5, "Rathalos Vambraces 5", 82, "Rathalos Set", rathalos, :gloves],
    [6, "Rathalos Vambraces 6", 100, "Rathalos Set", rathalos, :gloves],
    [7, "Rathalos Vambraces 7", 119, "Rathalos Set", rathalos, :gloves],
    [8, "Rathalos Vambraces 8", 139, "Rathalos Set", rathalos, :gloves],
    [9, "Rathalos Vambraces 9", 160, "Rathalos Set", rathalos, :gloves],
    [10, "Rathalos Vambraces 10", 182, "Rathalos Set", rathalos, :gloves],

    [1, "Rathalos Coil 1", 20, "Rathalos Set", rathalos, :belt],
    [2, "Rathalos Coil 2", 34, "Rathalos Set", rathalos, :belt],
    [3, "Rathalos Coil 3", 49, "Rathalos Set", rathalos, :belt],
    [4, "Rathalos Coil 4", 65, "Rathalos Set", rathalos, :belt],
    [5, "Rathalos Coil 5", 82, "Rathalos Set", rathalos, :belt],
    [6, "Rathalos Coil 6", 100, "Rathalos Set", rathalos, :belt],
    [7, "Rathalos Coil 7", 119, "Rathalos Set", rathalos, :belt],
    [8, "Rathalos Coil 8", 139, "Rathalos Set", rathalos, :belt],
    [9, "Rathalos Coil 9", 160, "Rathalos Set", rathalos, :belt],
    [10, "Rathalos Coil 10", 182, "Rathalos Set", rathalos, :belt],

    [1, "Rathalos Greaves 1", 20, "Rathalos Set", rathalos, :greaves],
    [2, "Rathalos Greaves 2", 34, "Rathalos Set", rathalos, :greaves],
    [3, "Rathalos Greaves 3", 49, "Rathalos Set", rathalos, :greaves],
    [4, "Rathalos Greaves 4", 65, "Rathalos Set", rathalos, :greaves],
    [5, "Rathalos Greaves 5", 82, "Rathalos Set", rathalos, :greaves],
    [6, "Rathalos Greaves 6", 100, "Rathalos Set", rathalos, :greaves],
    [7, "Rathalos Greaves 7", 119, "Rathalos Set", rathalos, :greaves],
    [8, "Rathalos Greaves 8", 139, "Rathalos Set", rathalos, :greaves],
    [9, "Rathalos Greaves 9", 160, "Rathalos Set", rathalos, :greaves],
    [10, "Rathalos Greaves 10", 182, "Rathalos Set", rathalos, :greaves],


    [1, "Azure Rathalos Helm 1", 20, "Azure Rathalos Set", rathalos, :helm],
    [2, "Azure Rathalos Helm 2", 34, "Azure Rathalos Set", rathalos, :helm],
    [3, "Azure Rathalos Helm 3", 49, "Azure Rathalos Set", rathalos, :helm],
    [4, "Azure Rathalos Helm 4", 65, "Azure Rathalos Set", rathalos, :helm],
    [5, "Azure Rathalos Helm 5", 82, "Azure Rathalos Set", rathalos, :helm],
    [6, "Azure Rathalos Helm 6", 100, "Azure Rathalos Set", rathalos, :helm],
    [7, "Azure Rathalos Helm 7", 119, "Azure Rathalos Set", rathalos, :helm],
    [8, "Azure Rathalos Helm 8", 139, "Azure Rathalos Set", rathalos, :helm],
    [9, "Azure Rathalos Helm 9", 160, "Azure Rathalos Set", rathalos, :helm],
    [10, "Azure Rathalos Helm 10", 182, "Azure Rathalos Set", rathalos, :helm],

    [1, "Azure Rathalos Mail 1", 20, "Azure Rathalos Set", rathalos, :mail],
    [2, "Azure Rathalos Mail 2", 34, "Azure Rathalos Set", rathalos, :mail],
    [3, "Azure Rathalos Mail 3", 49, "Azure Rathalos Set", rathalos, :mail],
    [4, "Azure Rathalos Mail 4", 65, "Azure Rathalos Set", rathalos, :mail],
    [5, "Azure Rathalos Mail 5", 82, "Azure Rathalos Set", rathalos, :mail],
    [6, "Azure Rathalos Mail 6", 100, "Azure Rathalos Set", rathalos, :mail],
    [7, "Azure Rathalos Mail 7", 119, "Azure Rathalos Set", rathalos, :mail],
    [8, "Azure Rathalos Mail 8", 139, "Azure Rathalos Set", rathalos, :mail],
    [9, "Azure Rathalos Mail 9", 160, "Azure Rathalos Set", rathalos, :mail],
    [10, "Azure Rathalos Mail 10", 182, "Azure Rathalos Set", rathalos, :mail],

    [1, "Azure Rathalos Vambraces 1", 20, "Azure Rathalos Set", rathalos, :gloves],
    [2, "Azure Rathalos Vambraces 2", 34, "Azure Rathalos Set", rathalos, :gloves],
    [3, "Azure Rathalos Vambraces 3", 49, "Azure Rathalos Set", rathalos, :gloves],
    [4, "Azure Rathalos Vambraces 4", 65, "Azure Rathalos Set", rathalos, :gloves],
    [5, "Azure Rathalos Vambraces 5", 82, "Azure Rathalos Set", rathalos, :gloves],
    [6, "Azure Rathalos Vambraces 6", 100, "Azure Rathalos Set", rathalos, :gloves],
    [7, "Azure Rathalos Vambraces 7", 119, "Azure Rathalos Set", rathalos, :gloves],
    [8, "Azure Rathalos Vambraces 8", 139, "Azure Rathalos Set", rathalos, :gloves],
    [9, "Azure Rathalos Vambraces 9", 160, "Azure Rathalos Set", rathalos, :gloves],
    [10, "Azure Rathalos Vambraces 10", 182, "Azure Rathalos Set", rathalos, :gloves],

    [1, "Azure Rathalos Coil 1", 20, "Azure Rathalos Set", rathalos, :belt],
    [2, "Azure Rathalos Coil 2", 34, "Azure Rathalos Set", rathalos, :belt],
    [3, "Azure Rathalos Coil 3", 49, "Azure Rathalos Set", rathalos, :belt],
    [4, "Azure Rathalos Coil 4", 65, "Azure Rathalos Set", rathalos, :belt],
    [5, "Azure Rathalos Coil 5", 82, "Azure Rathalos Set", rathalos, :belt],
    [6, "Azure Rathalos Coil 6", 100, "Azure Rathalos Set", rathalos, :belt],
    [7, "Azure Rathalos Coil 7", 119, "Azure Rathalos Set", rathalos, :belt],
    [8, "Azure Rathalos Coil 8", 139, "Azure Rathalos Set", rathalos, :belt],
    [9, "Azure Rathalos Coil 9", 160, "Azure Rathalos Set", rathalos, :belt],
    [10, "Azure Rathalos Coil 10", 182, "Azure Rathalos Set", rathalos, :belt],

    [1, "Azure Rathalos Greaves 1", 20, "Azure Rathalos Set", rathalos, :greaves],
    [2, "Azure Rathalos Greaves 2", 34, "Azure Rathalos Set", rathalos, :greaves],
    [3, "Azure Rathalos Greaves 3", 49, "Azure Rathalos Set", rathalos, :greaves],
    [4, "Azure Rathalos Greaves 4", 65, "Azure Rathalos Set", rathalos, :greaves],
    [5, "Azure Rathalos Greaves 5", 82, "Azure Rathalos Set", rathalos, :greaves],
    [6, "Azure Rathalos Greaves 6", 100, "Azure Rathalos Set", rathalos, :greaves],
    [7, "Azure Rathalos Greaves 7", 119, "Azure Rathalos Set", rathalos, :greaves],
    [8, "Azure Rathalos Greaves 8", 139, "Azure Rathalos Set", rathalos, :greaves],
    [9, "Azure Rathalos Greaves 9", 160, "Azure Rathalos Set", rathalos, :greaves],
    [10, "Azure Rathalos Greaves 10", 182, "Azure Rathalos Set", rathalos, :greaves],


    [1, "Radobaan Helm 1", 20, "Radobaan Set", radobaan, :helm],
    [2, "Radobaan Helm 2", 34, "Radobaan Set", radobaan, :helm],
    [3, "Radobaan Helm 3", 49, "Radobaan Set", radobaan, :helm],
    [4, "Radobaan Helm 4", 65, "Radobaan Set", radobaan, :helm],
    [5, "Radobaan Helm 5", 82, "Radobaan Set", radobaan, :helm],
    [6, "Radobaan Helm 6", 100, "Radobaan Set", radobaan, :helm],
    [7, "Radobaan Helm 7", 119, "Radobaan Set", radobaan, :helm],
    [8, "Radobaan Helm 8", 139, "Radobaan Set", radobaan, :helm],
    [9, "Radobaan Helm 9", 160, "Radobaan Set", radobaan, :helm],
    [10, "Radobaan Helm 10", 182, "Radobaan Set", radobaan, :helm],

    [1, "Radobaan Mail 1", 20, "Radobaan Set", radobaan, :mail],
    [2, "Radobaan Mail 2", 34, "Radobaan Set", radobaan, :mail],
    [3, "Radobaan Mail 3", 49, "Radobaan Set", radobaan, :mail],
    [4, "Radobaan Mail 4", 65, "Radobaan Set", radobaan, :mail],
    [5, "Radobaan Mail 5", 82, "Radobaan Set", radobaan, :mail],
    [6, "Radobaan Mail 6", 100, "Radobaan Set", radobaan, :mail],
    [7, "Radobaan Mail 7", 119, "Radobaan Set", radobaan, :mail],
    [8, "Radobaan Mail 8", 139, "Radobaan Set", radobaan, :mail],
    [9, "Radobaan Mail 9", 160, "Radobaan Set", radobaan, :mail],
    [10, "Radobaan Mail 10", 182, "Radobaan Set", radobaan, :mail],

    [1, "Radobaan Vambraces 1", 20, "Radobaan Set", radobaan, :gloves],
    [2, "Radobaan Vambraces 2", 34, "Radobaan Set", radobaan, :gloves],
    [3, "Radobaan Vambraces 3", 49, "Radobaan Set", radobaan, :gloves],
    [4, "Radobaan Vambraces 4", 65, "Radobaan Set", radobaan, :gloves],
    [5, "Radobaan Vambraces 5", 82, "Radobaan Set", radobaan, :gloves],
    [6, "Radobaan Vambraces 6", 100, "Radobaan Set", radobaan, :gloves],
    [7, "Radobaan Vambraces 7", 119, "Radobaan Set", radobaan, :gloves],
    [8, "Radobaan Vambraces 8", 139, "Radobaan Set", radobaan, :gloves],
    [9, "Radobaan Vambraces 9", 160, "Radobaan Set", radobaan, :gloves],
    [10, "Radobaan Vambraces 10", 182, "Radobaan Set", radobaan, :gloves],

    [1, "Radobaan Coil 1", 20, "Radobaan Set", radobaan, :belt],
    [2, "Radobaan Coil 2", 34, "Radobaan Set", radobaan, :belt],
    [3, "Radobaan Coil 3", 49, "Radobaan Set", radobaan, :belt],
    [4, "Radobaan Coil 4", 65, "Radobaan Set", radobaan, :belt],
    [5, "Radobaan Coil 5", 82, "Radobaan Set", radobaan, :belt],
    [6, "Radobaan Coil 6", 100, "Radobaan Set", radobaan, :belt],
    [7, "Radobaan Coil 7", 119, "Radobaan Set", radobaan, :belt],
    [8, "Radobaan Coil 8", 139, "Radobaan Set", radobaan, :belt],
    [9, "Radobaan Coil 9", 160, "Radobaan Set", radobaan, :belt],
    [10, "Radobaan Coil 10", 182, "Radobaan Set", radobaan, :belt],

    [1, "Radobaan Greaves 1", 20, "Radobaan Set", radobaan, :greaves],
    [2, "Radobaan Greaves 2", 34, "Radobaan Set", radobaan, :greaves],
    [3, "Radobaan Greaves 3", 49, "Radobaan Set", radobaan, :greaves],
    [4, "Radobaan Greaves 4", 65, "Radobaan Set", radobaan, :greaves],
    [5, "Radobaan Greaves 5", 82, "Radobaan Set", radobaan, :greaves],
    [6, "Radobaan Greaves 6", 100, "Radobaan Set", radobaan, :greaves],
    [7, "Radobaan Greaves 7", 119, "Radobaan Set", radobaan, :greaves],
    [8, "Radobaan Greaves 8", 139, "Radobaan Set", radobaan, :greaves],
    [9, "Radobaan Greaves 9", 160, "Radobaan Set", radobaan, :greaves],
    [10, "Radobaan Greaves 10", 182, "Radobaan Set", radobaan, :greaves],


    [1, "Banbaro Helm 1", 20, "Banbaro Set", banbaro, :helm],
    [2, "Banbaro Helm 2", 34, "Banbaro Set", banbaro, :helm],
    [3, "Banbaro Helm 3", 49, "Banbaro Set", banbaro, :helm],
    [4, "Banbaro Helm 4", 65, "Banbaro Set", banbaro, :helm],
    [5, "Banbaro Helm 5", 82, "Banbaro Set", banbaro, :helm],
    [6, "Banbaro Helm 6", 100, "Banbaro Set", banbaro, :helm],
    [7, "Banbaro Helm 7", 119, "Banbaro Set", banbaro, :helm],
    [8, "Banbaro Helm 8", 139, "Banbaro Set", banbaro, :helm],
    [9, "Banbaro Helm 9", 160, "Banbaro Set", banbaro, :helm],
    [10, "Banbaro Helm 10", 182, "Banbaro Set", banbaro, :helm],

    [1, "Banbaro Mail 1", 20, "Banbaro Set", banbaro, :mail],
    [2, "Banbaro Mail 2", 34, "Banbaro Set", banbaro, :mail],
    [3, "Banbaro Mail 3", 49, "Banbaro Set", banbaro, :mail],
    [4, "Banbaro Mail 4", 65, "Banbaro Set", banbaro, :mail],
    [5, "Banbaro Mail 5", 82, "Banbaro Set", banbaro, :mail],
    [6, "Banbaro Mail 6", 100, "Banbaro Set", banbaro, :mail],
    [7, "Banbaro Mail 7", 119, "Banbaro Set", banbaro, :mail],
    [8, "Banbaro Mail 8", 139, "Banbaro Set", banbaro, :mail],
    [9, "Banbaro Mail 9", 160, "Banbaro Set", banbaro, :mail],
    [10, "Banbaro Mail 10", 182, "Banbaro Set", banbaro, :mail],

    [1, "Banbaro Vambraces 1", 20, "Banbaro Set", banbaro, :gloves],
    [2, "Banbaro Vambraces 2", 34, "Banbaro Set", banbaro, :gloves],
    [3, "Banbaro Vambraces 3", 49, "Banbaro Set", banbaro, :gloves],
    [4, "Banbaro Vambraces 4", 65, "Banbaro Set", banbaro, :gloves],
    [5, "Banbaro Vambraces 5", 82, "Banbaro Set", banbaro, :gloves],
    [6, "Banbaro Vambraces 6", 100, "Banbaro Set", banbaro, :gloves],
    [7, "Banbaro Vambraces 7", 119, "Banbaro Set", banbaro, :gloves],
    [8, "Banbaro Vambraces 8", 139, "Banbaro Set", banbaro, :gloves],
    [9, "Banbaro Vambraces 9", 160, "Banbaro Set", banbaro, :gloves],
    [10, "Banbaro Vambraces 10", 182, "Banbaro Set", banbaro, :gloves],

    [1, "Banbaro Coil 1", 20, "Banbaro Set", banbaro, :belt],
    [2, "Banbaro Coil 2", 34, "Banbaro Set", banbaro, :belt],
    [3, "Banbaro Coil 3", 49, "Banbaro Set", banbaro, :belt],
    [4, "Banbaro Coil 4", 65, "Banbaro Set", banbaro, :belt],
    [5, "Banbaro Coil 5", 82, "Banbaro Set", banbaro, :belt],
    [6, "Banbaro Coil 6", 100, "Banbaro Set", banbaro, :belt],
    [7, "Banbaro Coil 7", 119, "Banbaro Set", banbaro, :belt],
    [8, "Banbaro Coil 8", 139, "Banbaro Set", banbaro, :belt],
    [9, "Banbaro Coil 9", 160, "Banbaro Set", banbaro, :belt],
    [10, "Banbaro Coil 10", 182, "Banbaro Set", banbaro, :belt],

    [1, "Banbaro Greaves 1", 20, "Banbaro Set", banbaro, :greaves],
    [2, "Banbaro Greaves 2", 34, "Banbaro Set", banbaro, :greaves],
    [3, "Banbaro Greaves 3", 49, "Banbaro Set", banbaro, :greaves],
    [4, "Banbaro Greaves 4", 65, "Banbaro Set", banbaro, :greaves],
    [5, "Banbaro Greaves 5", 82, "Banbaro Set", banbaro, :greaves],
    [6, "Banbaro Greaves 6", 100, "Banbaro Set", banbaro, :greaves],
    [7, "Banbaro Greaves 7", 119, "Banbaro Set", banbaro, :greaves],
    [8, "Banbaro Greaves 8", 139, "Banbaro Set", banbaro, :greaves],
    [9, "Banbaro Greaves 9", 160, "Banbaro Set", banbaro, :greaves],
    [10, "Banbaro Greaves 10", 182, "Banbaro Set", banbaro, :greaves],


    [1, "Barioth Helm 1", 20, "Barioth Set", barioth, :helm],
    [2, "Barioth Helm 2", 34, "Barioth Set", barioth, :helm],
    [3, "Barioth Helm 3", 49, "Barioth Set", barioth, :helm],
    [4, "Barioth Helm 4", 65, "Barioth Set", barioth, :helm],
    [5, "Barioth Helm 5", 82, "Barioth Set", barioth, :helm],
    [6, "Barioth Helm 6", 100, "Barioth Set", barioth, :helm],
    [7, "Barioth Helm 7", 119, "Barioth Set", barioth, :helm],
    [8, "Barioth Helm 8", 139, "Barioth Set", barioth, :helm],
    [9, "Barioth Helm 9", 160, "Barioth Set", barioth, :helm],
    [10, "Barioth Helm 10", 182, "Barioth Set", barioth, :helm],

    [1, "Barioth Mail 1", 20, "Barioth Set", barioth, :mail],
    [2, "Barioth Mail 2", 34, "Barioth Set", barioth, :mail],
    [3, "Barioth Mail 3", 49, "Barioth Set", barioth, :mail],
    [4, "Barioth Mail 4", 65, "Barioth Set", barioth, :mail],
    [5, "Barioth Mail 5", 82, "Barioth Set", barioth, :mail],
    [6, "Barioth Mail 6", 100, "Barioth Set", barioth, :mail],
    [7, "Barioth Mail 7", 119, "Barioth Set", barioth, :mail],
    [8, "Barioth Mail 8", 139, "Barioth Set", barioth, :mail],
    [9, "Barioth Mail 9", 160, "Barioth Set", barioth, :mail],
    [10, "Barioth Mail 10", 182, "Barioth Set", barioth, :mail],

    [1, "Barioth Vambraces 1", 20, "Barioth Set", barioth, :gloves],
    [2, "Barioth Vambraces 2", 34, "Barioth Set", barioth, :gloves],
    [3, "Barioth Vambraces 3", 49, "Barioth Set", barioth, :gloves],
    [4, "Barioth Vambraces 4", 65, "Barioth Set", barioth, :gloves],
    [5, "Barioth Vambraces 5", 82, "Barioth Set", barioth, :gloves],
    [6, "Barioth Vambraces 6", 100, "Barioth Set", barioth, :gloves],
    [7, "Barioth Vambraces 7", 119, "Barioth Set", barioth, :gloves],
    [8, "Barioth Vambraces 8", 139, "Barioth Set", barioth, :gloves],
    [9, "Barioth Vambraces 9", 160, "Barioth Set", barioth, :gloves],
    [10, "Barioth Vambraces 10", 182, "Barioth Set", barioth, :gloves],

    [1, "Barioth Coil 1", 20, "Barioth Set", barioth, :belt],
    [2, "Barioth Coil 2", 34, "Barioth Set", barioth, :belt],
    [3, "Barioth Coil 3", 49, "Barioth Set", barioth, :belt],
    [4, "Barioth Coil 4", 65, "Barioth Set", barioth, :belt],
    [5, "Barioth Coil 5", 82, "Barioth Set", barioth, :belt],
    [6, "Barioth Coil 6", 100, "Barioth Set", barioth, :belt],
    [7, "Barioth Coil 7", 119, "Barioth Set", barioth, :belt],
    [8, "Barioth Coil 8", 139, "Barioth Set", barioth, :belt],
    [9, "Barioth Coil 9", 160, "Barioth Set", barioth, :belt],
    [10, "Barioth Coil 10", 182, "Barioth Set", barioth, :belt],

    [1, "Barioth Greaves 1", 20, "Barioth Set", barioth, :greaves],
    [2, "Barioth Greaves 2", 34, "Barioth Set", barioth, :greaves],
    [3, "Barioth Greaves 3", 49, "Barioth Set", barioth, :greaves],
    [4, "Barioth Greaves 4", 65, "Barioth Set", barioth, :greaves],
    [5, "Barioth Greaves 5", 82, "Barioth Set", barioth, :greaves],
    [6, "Barioth Greaves 6", 100, "Barioth Set", barioth, :greaves],
    [7, "Barioth Greaves 7", 119, "Barioth Set", barioth, :greaves],
    [8, "Barioth Greaves 8", 139, "Barioth Set", barioth, :greaves],
    [9, "Barioth Greaves 9", 160, "Barioth Set", barioth, :greaves],
    [10, "Barioth Greaves 10", 182, "Barioth Set", barioth, :greaves],


    [1, "Zinogre Helm 1", 20, "Zinogre Set", zinogre, :helm],
    [2, "Zinogre Helm 2", 34, "Zinogre Set", zinogre, :helm],
    [3, "Zinogre Helm 3", 49, "Zinogre Set", zinogre, :helm],
    [4, "Zinogre Helm 4", 65, "Zinogre Set", zinogre, :helm],
    [5, "Zinogre Helm 5", 82, "Zinogre Set", zinogre, :helm],
    [6, "Zinogre Helm 6", 100, "Zinogre Set", zinogre, :helm],
    [7, "Zinogre Helm 7", 119, "Zinogre Set", zinogre, :helm],
    [8, "Zinogre Helm 8", 139, "Zinogre Set", zinogre, :helm],
    [9, "Zinogre Helm 9", 160, "Zinogre Set", zinogre, :helm],
    [10, "Zinogre Helm 10", 182, "Zinogre Set", zinogre, :helm],

    [1, "Zinogre Mail 1", 20, "Zinogre Set", zinogre, :mail],
    [2, "Zinogre Mail 2", 34, "Zinogre Set", zinogre, :mail],
    [3, "Zinogre Mail 3", 49, "Zinogre Set", zinogre, :mail],
    [4, "Zinogre Mail 4", 65, "Zinogre Set", zinogre, :mail],
    [5, "Zinogre Mail 5", 82, "Zinogre Set", zinogre, :mail],
    [6, "Zinogre Mail 6", 100, "Zinogre Set", zinogre, :mail],
    [7, "Zinogre Mail 7", 119, "Zinogre Set", zinogre, :mail],
    [8, "Zinogre Mail 8", 139, "Zinogre Set", zinogre, :mail],
    [9, "Zinogre Mail 9", 160, "Zinogre Set", zinogre, :mail],
    [10, "Zinogre Mail 10", 182, "Zinogre Set", zinogre, :mail],

    [1, "Zinogre Vambraces 1", 20, "Zinogre Set", zinogre, :gloves],
    [2, "Zinogre Vambraces 2", 34, "Zinogre Set", zinogre, :gloves],
    [3, "Zinogre Vambraces 3", 49, "Zinogre Set", zinogre, :gloves],
    [4, "Zinogre Vambraces 4", 65, "Zinogre Set", zinogre, :gloves],
    [5, "Zinogre Vambraces 5", 82, "Zinogre Set", zinogre, :gloves],
    [6, "Zinogre Vambraces 6", 100, "Zinogre Set", zinogre, :gloves],
    [7, "Zinogre Vambraces 7", 119, "Zinogre Set", zinogre, :gloves],
    [8, "Zinogre Vambraces 8", 139, "Zinogre Set", zinogre, :gloves],
    [9, "Zinogre Vambraces 9", 160, "Zinogre Set", zinogre, :gloves],
    [10, "Zinogre Vambraces 10", 182, "Zinogre Set", zinogre, :gloves],

    [1, "Zinogre Coil 1", 20, "Zinogre Set", zinogre, :belt],
    [2, "Zinogre Coil 2", 34, "Zinogre Set", zinogre, :belt],
    [3, "Zinogre Coil 3", 49, "Zinogre Set", zinogre, :belt],
    [4, "Zinogre Coil 4", 65, "Zinogre Set", zinogre, :belt],
    [5, "Zinogre Coil 5", 82, "Zinogre Set", zinogre, :belt],
    [6, "Zinogre Coil 6", 100, "Zinogre Set", zinogre, :belt],
    [7, "Zinogre Coil 7", 119, "Zinogre Set", zinogre, :belt],
    [8, "Zinogre Coil 8", 139, "Zinogre Set", zinogre, :belt],
    [9, "Zinogre Coil 9", 160, "Zinogre Set", zinogre, :belt],
    [10, "Zinogre Coil 10", 182, "Zinogre Set", zinogre, :belt],

    [1, "Zinogre Greaves 1", 20, "Zinogre Set", zinogre, :greaves],
    [2, "Zinogre Greaves 2", 34, "Zinogre Set", zinogre, :greaves],
    [3, "Zinogre Greaves 3", 49, "Zinogre Set", zinogre, :greaves],
    [4, "Zinogre Greaves 4", 65, "Zinogre Set", zinogre, :greaves],
    [5, "Zinogre Greaves 5", 82, "Zinogre Set", zinogre, :greaves],
    [6, "Zinogre Greaves 6", 100, "Zinogre Set", zinogre, :greaves],
    [7, "Zinogre Greaves 7", 119, "Zinogre Set", zinogre, :greaves],
    [8, "Zinogre Greaves 8", 139, "Zinogre Set", zinogre, :greaves],
    [9, "Zinogre Greaves 9", 160, "Zinogre Set", zinogre, :greaves],
    [10, "Zinogre Greaves 10", 182, "Zinogre Set", zinogre, :greaves],
  ]

  armor_items = armor.map do |grade, name, power, key, mon, subgroup|
    group = :armor

    mon_key = mon&.key&.to_sym
    info = mon_info.fetch(mon_key, {})

    unlock = info[:unlock]
    starter = info[:starter] == 1
    event_only = info[:eventOnly] == 1

    eq_key = [key, group, subgroup]
    equipables[eq_key] ||= Equipable.find_or_create_by(key: key, group: group, sub_group: subgroup) { |eq|
      eq.attributes = {
        name: name.sub(/\s+\d+$/, ''),
        set_name: key,
        group: group,
        sub_group: subgroup,
        unlock_grade: unlock,
        starter: starter,
        event_only: event_only,
        monster: mon,
      }
    }

    equipable = equipables[eq_key]
    mon_key = mon&.key&.to_sym
    next if mon_key.nil?

    table = translation_table(equipable, all)

    gr = grade
    all[:costType][gr].each do |subgr, items|
      flat_gr = (5 * (gr - 1)) + subgr
      defense = all[:armorVal]&.[](flat_gr)
      stat = EquipableStat.create(
        grade: gr,
        sub_grade: subgr, 
        def: defense,
        forge: !starter,
        equipable: equipable,
      )
      cost_set =
        if unlock == gr && subgr == 1
          equipable.armor? ? all[:forgeArmorCost][gr] : all[:forgeWeaponCost][gr]
        else
          equipable.armor? ? all[:armorCost][gr][subgr] : all[:weaponCost][gr][subgr]
        end
      cost_set = cost_set.each(&:to_i)
      items.each.with_index do |item_code, item_idx|
        item_name = table[item_code.to_sym]
        item = Item.find_by(name: item_name)
        next if item.nil?
        ItemStat.create(
          item: item,
          equipable_stat: stat,
          grade: gr,
          sub_grade: subgr, 
          qty: cost_set[item_idx],
          equipable: equipable,
          monster: mon
        )
      end
    end
  end



  # TODO: Bone Weapons

  special_monsters_and_weapons = [
    :bone,
    # :shield_sword
    # G3	Bone Kukri 1	207	0%	
    # None
    # G4	Bone Kukri 2	299	0%	
    # None
    # G5	Bone Kukri 3	430	0%	
    # None
    # G6	Chief Kukri 1	559	0%	
    # None
    # G7	Chief Kukri 2	727	0%	
    # None
    # G8	Chief Kukri 3	945	0%	
    # None
    # G9	Chief Kukri 4	1228	0%	
    # None
    # G10	Chief Kukri 5	1596	0%	
    # None
    #
    # :great_sword
    # G3	Bone Blade 1	207	0%	
    # None
    # G4	Bone Blade 2	299	0%	
    # None
    # G5	Bone Blade 3	430	0%	
    # None
    # G6	Bone Slasher 1	559	0%	
    # None
    # G7	Bone Slasher 2	727	0%	
    # None
    # G8	Bone Slasher 3	945	0%	
    # None
    # G9	Bone Slasher 4	1228	0%	
    # None
    # G10	Bone Slasher 5	1596	0%	
    # None
    #
    # :long_sword
    # G3	Bone Shotel 1	207	0%	
    # None
    # G4	Bone Shotel 2	299	0%	
    # None
    # G5	Bone Shotel 3	430	0%	
    # None
    # G6	Hard Bone Shotel 1	559	0%	
    # None
    # G7	Hard Bone Shotel 2	727	0%	
    # None
    # G8	Hard Bone Shotel 3	945	0%	
    # None
    # G9	Hard Bone Shotel 4	1228	0%	
    # None
    # G10	Hard Bone Shotel 5	1596	0%	
    # None
    #
    # :hammer
    # 
    # G3	Bone Bludgeon 1	207	0%	
    # None
    # G4	Bone Bludgeon 2	299	0%	
    # None
    # G5	Bone Bludgeon 3	430	0%	
    # None
    # G6	Fossil Bludgeon 1	559	0%	
    # None
    # G7	Fossil Bludgeon 2	727	0%	
    # None
    # G8	Fossil Bludgeon 3	945	0%	
    # None
    # G9	Fossil Bludgeon 4	1228	0%	
    # None
    # G10	Fossil Bludgeon 5	1596	0%	
    # None

    # :dual_blades
    # 
    # G3	Bone Hatchets 1	207	0%	
    # None
    # G4	Bone Hatchets 2	299	0%	
    # None
    # G5	Bone Hatchets 3	430	0%	
    # None
    # G6	Wild Hatchets 1	559	0%	
    # None
    # G7	Wild Hatchets 2	727	0%	
    # None
    # G8	Wild Hatchets 3	945	0%	
    # None
    # G9	Wild Hatchets 4	1228	0%	
    # None
    # G10	Wild Hatchets 5	1596	0%	
    # None

    # :lance
    # 
    # G3	Bone Lance 1	207	0%	
    # None
    # G4	Bone Lance 2	299	0%	
    # None
    # G5	Bone Lance 3	430	0%	
    # None
    # G6	Hard Bone Lance 1	559	0%	
    # None
    # G7	Hard Bone Lance 2	727	0%	
    # None
    # G8	Hard Bone Lance 3	945	0%	
    # None
    # G9	Hard Bone Lance 4	1228	0%	
    # None
    # G10	Hard Bone Lance 5	1596	0%	
    # None

    # :light_gun
    #
  ]





  #   .each do |key, info|
  #   name = monster_names[key]
  # 
  #   defaults = {
  #     size: :large,
  #     swamp: false,
  #     desert: false,
  #     forest: false,
  #     fire_weak: false,
  #     water_weak: false,
  #     thunder_weak: false,
  #     dragon_weak: false,
  #     ice_weak: false,
  #     poison: 1,
  #     paralysis: 1,
  #     stun: 1,
  #     sleep: 1,
  #   }
  # 
  #   flags = info[:biome].zip Array.new(info[:biome].length, true)
  #   weak_keys = info[:weakness].map { |w|
  #     [w, :weak].join(?_)
  #   }
  #   weaknesses = weak_keys.zip Array.new(info[:weakness].length, true)
  #   attrs = {
  #     name: name,
  #     **defaults,
  #     **flags.to_h.symbolize_keys,
  #     **weaknesses.to_h.symbolize_keys,
  #     poison: info[:poison],
  #     paralysis: info[:paralysis],
  #     stun: info[:stun],
  #     sleep: info[:sleep],
  #   }
  # 
  #   monster = Monster.create(attrs)
  #   monsters[key] = monster
  # end
  # 
  # skill_data = [
  #   'Fire Attack',
  #   'Water Attack',
  #   'Ice Attack',
  #   'Thunder Attack',
  #   'Dragon Attack',
  #   'Poison Attack',
  #   'Paralysis Attack',
  #   'Sleep Attack',
  #   'Lock On',
  #   'Critical Eye',
  #   'Weakness Exploit',
  #   'Critical Boost',
  #   'Attack Boost',
  #   'Burst',
  #   'Skyward Striker',
  #   'Focus',
  #   'Peak Performance',
  #   'Divine Blessing',
  #   'Health Boost',
  #   'Rising Tide',
  #   'Guard',
  #   'Offensive Guard',
  #   'Evade ExtenderUP',
  #   'Artful Dodger',
  #   'Reload Speed',
  #   'Recoil Down',
  #   'Concentration',
  #   'Special Boost',
  #   'Evasive Concentration',
  #   'Windproof',
  #   'Tremor Resistance',
  #   'Earplugs',
  #   'Sneak Attack',
  #   'Fortify',
  #   'Resentment',
  #   'Guts',
  #   'Heroics',
  #   'Slugger',
  #   'Partbreaker'
  # ]
  # 
  # skills = skill_data.map { |name|
  #   [name, Skill.create(name: name)]
  # }.to_h
  # 
  # forgables = {
  #     'alloy': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance' ],
  #     'bone': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance' ],
  #     'leather': [ 'armor' ],
  #     'g-jagr': [ 'shield-sword', 'great-sword', 'light-gun', 'armor' ],
  #     'kulu': [ 'hammer', 'long-sword', 'bow', 'dual-blades', 'lance', 'armor' ],
  #     'puke': [ 'shield-sword', 'great-sword', 'hammer', 'bow', 'lance', 'armor' ],
  #     'barr': [ 'shield-sword', 'great-sword', 'hammer', 'light-gun', 'lance', 'armor' ],
  #     'g-girr': [ 'shield-sword', 'great-sword', 'hammer', 'armor' ],
  #     'tobi': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance', 'armor' ],
  #     'paol': [ 'shield-sword', 'light-gun', 'armor' ],
  #     'jyur': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance', 'armor' ],
  #     'anja': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'armor' ],
  #     'rathi': [ 'shield-sword', 'long-sword', 'bow', 'armor' ],
  #     'legi': [ 'shield-sword', 'great-sword', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance', 'armor' ],
  #     'diab': [ 'hammer', 'bow', 'dual-blades', 'armor' ],
  #     'ratha': [ 'shield-sword', 'great-sword', 'long-sword', 'light-gun', 'bow', 'lance', 'armor' ],
  #     'b-diab': [ 'hammer', 'bow', 'dual-blades', 'armor' ],
  #     'p-rathi': [ 'shield-sword', 'long-sword', 'bow', 'armor' ],
  #     'a-ratha': [ 'shield-sword', 'great-sword', 'long-sword', 'light-gun', 'bow', 'lance', 'armor' ],
  #     'rado': [ 'shield-sword', 'great-sword', 'hammer', 'armor' ],
  #     'banb': [ 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'armor' ],
  #     'bari': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance', 'armor' ],
  #     'zino': [ 'shield-sword', 'great-sword', 'hammer', 'long-sword', 'light-gun', 'bow', 'dual-blades', 'lance', 'armor' ],
  #     'halloween': [ 'helm' ],
  #     'ny-24': [ 'helm' ]
  # }
  # equipment_skills = {
  #   'alloy': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Poison Resistance',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'bone': {
  #     'weapon': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Concentration',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'leather': {
  #     'noWeapon': 1,
  #     'helm': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Critical Eye',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Ice Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Attack Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Fire Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Defense Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Thunder Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Health Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Water Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Poison Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Paralysis Resistance',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'g-jagr': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Health Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Firm Foothold',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Rising Tide',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Firm Foothold',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Water Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Fortify',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Rising Tide',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Water Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'kulu': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Fortify',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Lock On',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Critical Eye',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Guts',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Last Stand',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Critical Eye',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Last Stand',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Critical Eye',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'puke': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Sneak Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Focus',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Health Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Poison Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Focus',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Poison Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Poison Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Poison Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Health Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Poison Resistance',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'barr': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Defense Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Defense Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Offensive Guard',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Offensive Guard',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Guard',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Defense Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Guard',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Recoil Down',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Defense Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'g-girr': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Sneak Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': [ 2, 4 ],
  #         'skill': 'Paralysis Resistance',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Paralysis Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Sneak Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Sneak Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Earplugs',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Paralysis Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Earplugs',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Paralysis Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'tobi': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Reload Speed',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Artful Dodger',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Thunder Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Evade ExtenderUP',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Artful Dodger',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Thunder Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Artful Dodger',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Thunder Resistance',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'paol': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Divine Blessing',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 3,
  #         'skill': 'Concentration',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Windproof',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Recoil Down',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Concentration',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Divine Blessing',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Divine Blessing',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Windproof',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'jyur': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Last Stand',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 3,
  #         'skill': 'Water Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Last Stand',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 3,
  #         'skill': 'Water Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Last Stand',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Water Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 3, 4 ],
  #         'skill': 'Water Resistance',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Focus',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Last Stand',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'anja': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Rising Tide',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Fire Attack',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Fire Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Special Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Fire Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Fire Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Special Boost',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Peak Performance',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'rathi': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Health Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Health Boost',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Poison Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Poison Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Lock On',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Burst',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Poison Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Burst',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Health Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ]
  #   },
  #   'legi': {
  #     'weapon': [
  #       {
  #         'unlock': [ 5, 8 ],
  #         'skill': 'Divine Blessing',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Divine Blessing',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Ice Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Divine Blessing',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Windproof',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Reload Speed',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Ice Attack',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Windproof',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Reload Speed',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Ice Resistance',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'diab': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Heroics',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Heroics',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Slugger',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Heroics',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Heroics',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Partbreaker',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Partbreaker',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Offensive Guard',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Slugger',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Partbreaker',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'ratha': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Earplugs',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Attack Boost',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Fire Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Weakness Exploit',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Fire Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Attack Boost',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Focus',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Fire Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Fire Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Weakness Exploit',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'b-diab': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Partbreaker',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Partbreaker',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Resentment',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Resentment',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Firm Foothold',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Resentment',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Focus',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Lock On',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Heroics',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Heroics',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Offensive Guard',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'p-rathi': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Special Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Windproof',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Dragon Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Focus',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Windproof',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Critical Eye',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Critical Eye',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Special Boost',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Dragon Attack',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'a-ratha': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Special Boost',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Focus',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Earplugs',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 5,
  #         'skill': 'Fire Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Critical Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Special Boost',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Critical Boost',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Reload Speed',
  #         'lv': 2
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Fire Attack',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'halloween': {
  #     'noWeapon': 1,
  #     'helm': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Solidarity (Pumpkin Hunt)',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'rado': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Defense Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Guard',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Sleep Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Defense Boost',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Slugger',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Sleep Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 2, 6 ],
  #         'skill': 'Sleep Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 2,
  #         'skill': 'Sleep Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Guard',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'banb': {
  #     'weapon': [
  #       {
  #         'unlock': [ 4, 8 ],
  #         'skill': 'Firm Foothold',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 3,
  #         'skill': 'Tremor Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Recoil Down',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 3,
  #         'skill': 'Concentration',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Partbreaker',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Offensive Guard',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Tremor Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': [ 3, 6 ],
  #         'skill': 'Attack Boost',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 4,
  #         'skill': 'Firm Foothold',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 3,
  #         'skill': 'Divine Blessing',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Concentration',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'bari': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Skyward Striker',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Ice Resistance',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Ice Attack',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 4, 6 ],
  #         'skill': 'Ice Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Skyward Striker',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Ice Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Sneak Attack',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Evade ExtenderUP',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'zino': {
  #     'weapon': [
  #       {
  #         'unlock': 8,
  #         'skill': 'Artful Dodger',
  #         'lv': 1
  #       }
  #     ],
  #     'helm': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Evasive Concentration',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Burst',
  #         'lv': 1
  #       }
  #     ],
  #     'mail': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Evasive Concentration',
  #         'lv': [ 1, 2 ]
  #       },
  #       {
  #         'unlock': 5,
  #         'skill': 'Thunder Resistance',
  #         'lv': 1
  #       }
  #     ],
  #     'gloves': [
  #       {
  #         'unlock': [ 5, 6 ],
  #         'skill': 'Thunder Attack',
  #         'lv': [ 1, 2 ]
  #       }
  #     ],
  #     'belt': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Artful Dodger',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Reload Speed',
  #         'lv': 1
  #       }
  #     ],
  #     'greaves': [
  #       {
  #         'unlock': 5,
  #         'skill': 'Burst',
  #         'lv': 1
  #       },
  #       {
  #         'unlock': 6,
  #         'skill': 'Thunder Attack',
  #         'lv': 1
  #       }
  #     ]
  #   },
  #   'ny-24': {
  #     'noWeapon': 1,
  #     'helm': [
  #       {
  #         'unlock': 4,
  #         'skill': 'Happy New Year (2024)',
  #         'lv': 1
  #       }
  #     ]
  #   }
  # }.each do |name, equips|
  #   monster = monsters[name]
  #   next if monster.nil?
  # 
  #   equipables = []
  #   equips.each do |k, data|
  #     if k == :weapon
  #       w = equips[:weapon]
  #       cforg = forgables[name] - ['armor']
  #       cforg2 = cforg.map do |forg|
  #         x = Equipable.create(
  #           monster: monster,
  #           group: :weapon,
  #           subgroup: forg.gsub(/-/, ?_).to_sym,
  #         )
  #         equipables << x
  #       end
  #     else
  #       x = Equipable.create(
  #         monster: monster,
  #         group: :armor,
  #         subgroup: k,
  #       )
  #       equipables << x
  #     end
  #   end
  # end
end

