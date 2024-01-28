class EquipTable
  attr_reader :equip

  def self.for(equip)
    new(equip).table
  end

  def initialize(equip)
    @equip = equip
  end

  def set_key
    equip.set_key
  end

  def table
    {
      a: Item.find_by(set_key: set_key, set_subkey: a_key),
      b: Item.find_by(set_key: set_key, set_subkey: :b),
      c: Item.find_by(set_key: set_key, set_subkey: :c),
      d: Item.find_by(set_key: set_key, set_subkey: :d),
      e: Item.find_by(set_key: set_key, set_subkey: :e),
      f: Item.find_by(set_key: :f, set_subkey: equip.f_code),
      g: Item.find_by(set_key: :g, set_subkey: equip.g_code),
      ha: Item.find_by(set_key: h_key, set_subkey: :a),
      hb: Item.find_by(set_key: h_key, set_subkey: :b),
      hc: Item.find_by(set_key: h_key, set_subkey: :c),
      **i_set,
      j: Item.find_by(set_key: j_key),
      k: Item.find_by(set_key: k_key),
      l: Item.find_by(set_key: :l),
      z: Item.find_by(set_key: :z),
    }.stringify_keys
  end

  def a_key
    equip.armor? ? :a1 : :a2
  end

  def h_key
    equip.h_code == '1' ? 'h1' : 'h2'
  end

  def i_set
    return {} unless equip.alt_monster

    alt_mon_key = equip.alt_monster.key

    [*'b'..'e'].inject({}) do |h, subkey|
      k = ['i', subkey].join
      item = Item.find_by(
        set_key: alt_mon_key,
        set_subkey: subkey,
      )

      h.merge(k => item)
    end
  end

  def j_key
    equip.armor? ? :j1 : :j2
  end

  def k_key
    equip.armor? ? :k1 : :k2
  end
end
