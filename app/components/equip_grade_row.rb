class EquipGradeRow < ViewComponent::Base
  haml_template <<~HAML
    .equip_grade_row
      .text
        Grade:
        = grade_num
      .grade_list
        - sub_grades.each do |sub_grade|
          = render EquipSubGradeRow.new(equip, sub_grade)
          %br/
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
