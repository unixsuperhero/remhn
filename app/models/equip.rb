class Equip < ApplicationRecord
  enum equip_type: { weapon: 1, armor: 2 }
  enum equip_subtype: {
    "shield-sword"  => 1,
    "great-sword"   => 2,
    "hammer"        => 3,
    "long-sword"    => 4,
    "light-gun"     => 5,
    "bow"           => 6,
    "dual-blades"   => 7,
    "lance"         => 8,
    "helm"          => 9,
    "mail"          => 10,
    "gloves"        => 11,
    "belt"          => 12,
    "greaves"       => 13,
  }

  belongs_to :element, optional: true
  belongs_to :monster, optional: true
  belongs_to :alt_monster, optional: true, class_name: 'Monster', foreign_key: 'alt_monster_id'

  has_many :equip_grades
  has_many :equip_grade_items

  scope :weapons, -> { where(equip_type: :weapon) }
  scope :armors, -> { where(equip_type: :armor) }

  def display_title
    {
      "shield-sword"  => 'Sword & Shield',
      "great-sword"   => 'Great Sword',
      "hammer"        => 'Hammer',
      "long-sword"    => 'Long Sword',
      "light-gun"     => 'Light Bowgun',
      "bow"           => 'Bow',
      "dual-blades"   => 'Dual Blades',
      "lance"         => 'Lance',
      "helm"          => 'Helm',
      "mail"          => 'Mail',
      "gloves"        => 'Gloves',
      "belt"          => 'Belt',
      "greaves"       => 'Greaves',
    }[equip_subtype]
  end
end
