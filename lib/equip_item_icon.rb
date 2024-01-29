class EquipItemIcon
  attr_reader :equip, :item

  def self.path_for(equip, item)
    new(equip, item).path
  end

  def initialize(equip, item)
    @equip = equip
    @item = item
  end

  def key
    equip.set_key
  end

  def subkey
    item.set_subkey
  end

  def path
    subdir =
      if item.set_key == item.set_subkey
        ''
      else
        [item.set_key, '/'].join
      end

    ['item/', subdir, subkey, '.png'].join
  end
end
