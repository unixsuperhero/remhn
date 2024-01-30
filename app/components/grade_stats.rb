class GradeStats < ViewComponent::Base
  haml_template <<~HAML
    %span.grade_stats
      - if sub_grade.atk_power
        %span.stat
          %strong ATK:
          = sub_grade.atk_power
      - if sub_grade.crit_power
        %span.stat
          %strong CRIT:
          = [sub_grade.crit_power, '%'].join
      - if sub_grade.elem_power
        %span.stat
          %strong ELEM:
          = sub_grade.elem_power
      - if sub_grade.def_power
        %span.stat
          %strong DEF:
          = sub_grade.def_power
  HAML

  attr_reader :sub_grade

  def initialize(sub_grade)
    @sub_grade = sub_grade
  end
end
