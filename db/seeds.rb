
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

  rarity_subkey_map = {
    0 => %w[z],
    1 => %w[a a1 a2 j1 j2],
    2 => %w[b],
    3 => %w[c k1 k2],
    4 => %w[d],
    5 => %w[e],
    6 => %w[f l],
  }

  items_by_name = {}
  items = db['en']['item'].map do |set_key, set_info|
    if set_info.is_a?(String)
      set_info = { set_key => set_info }
    end

    set_info.map do |set_subkey, name|
      (rarity, _) = rarity_subkey_map.find{ |k,v|
        v.include?(set_subkey)
      }

      if set_key == 'f'
        rarity = 3
      elsif set_key == 'g'
        rarity = 1
      end

      items_by_name[name] ||= Item.create(
        name: name,
        rarity: rarity,
      )

      i = items_by_name[name]

      ItemSet.create(item: i, set_key: set_key, set_subkey: set_subkey)
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
