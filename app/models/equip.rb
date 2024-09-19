class Equip < ApplicationRecord
  enum equip_type: { weapon: 1, armor: 2 }
  enum equip_subtype: {
    "shield-sword"  => 1,
    "dual-blades"   => 2,
    "great-sword"   => 3,
    "long-sword"    => 4,
    "hammer"        => 5,
    "lance"         => 6,
    "light-gun"     => 7,
    "heavy-gun"     => 8,
    "charge-blade"  => 9,
    "gunlance"      => 10,
    "bow"           => 11,
    "helm"          => 12,
    "mail"          => 13,
    "gloves"        => 14,
    "belt"          => 15,
    "greaves"       => 16,
  }

  belongs_to :element, optional: true
  belongs_to :monster, optional: true
  belongs_to :alt_monster, optional: true, class_name: 'Monster', foreign_key: 'alt_monster_id'

  has_many :equip_grades
  has_many :equip_grade_items, through: :equip_grades
  has_many :items, through: :equip_grade_items
  has_many :grades, class_name: 'EquipGrade'

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
