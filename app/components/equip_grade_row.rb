class EquipGradeRow < ViewComponent::Base
  haml_template <<~HAML
    .equip_grade_row.collapsed{ 'data-controller': 'equip-grade-row' }
      .text{ 'data-action': 'click->equip-grade-row#toggleRow' }
        %i.fa-solid.fa-caret-right{ 'data-equip-grade-row-target': 'collapsedIcon' }
        Grade:
        = grade_num
      .grade_list{ 'data-equip-grade-row-target': 'gradeList' }
        - sub_grades.each do |sub_grade|
          = render EquipSubGradeRow.new(equip, sub_grade)
  HAML

  attr_reader :equip, :grade_num

  def initialize(equip, grade_num)
    @equip = equip
    @grade_num = grade_num
  end

  def sub_grades
    EquipGrade.where(equip: equip, grade: grade_num).order(:sub_grade)
  end
end
