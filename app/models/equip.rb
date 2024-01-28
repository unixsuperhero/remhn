class Equip < ApplicationRecord
  belongs_to :element, optional: true
  belongs_to :monster, optional: true
  belongs_to :alt_monster, optional: true, class_name: 'Monster', foreign_key: 'alt_monster_id'

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
end
