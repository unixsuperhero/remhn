class EquipSubGradeRow < ViewComponent::Base
  haml_template <<~HAML
    .equip_sub_grade_row
      .text
        %span
          %span.small_text Lv.
          %span.large_text= sub_grade.sub_grade
          %span.small_text /5
          = render GradeStats.new(sub_grade)
      .item_lists
        - sub_grade.grade_items.each do |grade_item|
          = render ItemIcon.new(equip, grade_item: grade_item)

  HAML

  attr_reader :equip, :sub_grade

  def initialize(equip, sub_grade)
    @equip = equip
    @sub_grade = sub_grade
  end

  def item_icon(grade_item)
    path = EquipItemIcon.path_for(equip, grade_item.item)
    image_url(path)
  end

  def item_title(grade_item)
    grade_item.item.name
  end
  
  def item_qty(grade_item)
    sprintf('(%d)', grade_item.qty)
  end
end
