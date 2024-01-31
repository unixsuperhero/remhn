class EquipForm < ViewComponent::Base
  haml_template <<~HAML
    .equip_form{ 'data-controller': 'equip-form' }
      - equips.each do |equip|
        .equip_row{style: 'display: flex; margin-bottom: 8px; line-height: 1;'}
          - if equip.monster
            = render MonsterIcon.new(equip.monster)
          = render EquipIcon.new(equip)
          %div{style: 'width: 200px; transform: translateY(8px);'}= equip.set_name
          %input{ type: :text, 'data-equip_id': equip.id, 'data-action': 'blur->equip-form#updateItem' }/
  HAML

  def equips
    @equips ||= Equip.order(:monster_id, :equip_subtype).all
  end

  def src(item)
    image_url(icon_path(item))
  end

  def title(item)
    item.name
  end

  def item_set(item)
    item.item_sets.first
  end

  def icon_path(item)
    temp_item_set = item_set(item)
    subdir =
      case temp_item_set.set_subkey
      when 'l', 'z', 'j1', 'j2', 'k1', 'k2'
        ''
      else
        [temp_item_set.set_key, '/'].join
      end

    ['item/', subdir, temp_item_set.set_subkey, '.png'].join
  end
end
