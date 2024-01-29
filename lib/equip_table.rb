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
      a: ItemSet.find_by(set_key: set_key, set_subkey: a_key)&.item,
      b: ItemSet.find_by(set_key: set_key, set_subkey: :b)&.item,
      c: ItemSet.find_by(set_key: set_key, set_subkey: :c)&.item,
      d: ItemSet.find_by(set_key: set_key, set_subkey: :d)&.item,
      e: ItemSet.find_by(set_key: set_key, set_subkey: :e)&.item,
      f: ItemSet.find_by(set_key: :f, set_subkey: equip.f_code)&.item,
      g: ItemSet.find_by(set_key: :g, set_subkey: equip.g_code)&.item,
      ha: ItemSet.find_by(set_key: h_key, set_subkey: :a)&.item,
      hb: ItemSet.find_by(set_key: h_key, set_subkey: :b)&.item,
      hc: ItemSet.find_by(set_key: h_key, set_subkey: :c)&.item,
      **i_set,
      j: ItemSet.find_by(set_key: j_key)&.item,
      k: ItemSet.find_by(set_key: k_key)&.item,
      l: ItemSet.find_by(set_key: :l)&.item,
      z: ItemSet.find_by(set_key: :z)&.item,
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
      item = ItemSet.find_by(
        set_key: alt_mon_key,
        set_subkey: subkey,
      )&.item

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
