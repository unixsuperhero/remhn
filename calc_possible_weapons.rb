require 'csv'

item_data = [294,179,76,8,255,274,75,69,34,5,273,257,102,67,30,3,263,295,57,47,31,6,216,219,70,48,20,3,72,235,3,50,12,2,299,97,36,30,13,6,248,245,57,53,21,nil,40,118,13,24,8,nil,194,14,2,32,8,2,88,11,16,22,21,2,88,11,4,11,5,1,40,51,9,7,7,nil,40,70,9,8,9,nil,6,2,nil,nil,2,nil,14,12,4,nil,1,nil,19,7,3,2,2,nil,188,161,25,30,18,nil,74,187,20,20,10,1,128,73,14,14,9,nil,2,2,nil,1,2,nil,nil,nil,nil,26,2,9,210,194,225,215,135,275,243,189,314,208,91,244,234,37,20,nil,131380]

equip_data = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"4_4",nil,"5_4",nil,nil,nil,nil,nil,nil,"3_4",nil,nil,nil,nil,nil,nil,nil,nil,"2_3",nil,nil,"7_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"2_4","3_5","3_4",nil,nil,nil,nil,nil,nil,nil,nil,"4_4",nil,"4_4",nil,"2_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"5_2","5_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"6_2",nil,nil,nil,nil,nil,nil,nil,nil,nil,"5_2",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"5_2",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"4_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"3_4"]

class NextGrade
  attr_reader :current_grade, :lowest_grade
  def initialize(current_grade, lowest_grade)
    @current_grade = current_grade
    @lowest_grade = lowest_grade
  end

  def next_grade
    if current_grade.nil? || current_grade.strip.length == 0
      return [lowest_grade.grade, lowest_grade.sub_grade]
    end

    x, y = current_grade.split('_').map(&:to_i)

    if y == 5
      x += 1
      y = 1
    else
      y += 1
    end

    [x, y]
  end
end

class ItemTracker
  attr_reader :items
  attr_reader :last_grade
  attr_reader :possible
  attr_reader :done

  def initialize(items)
    @items = items
    @possible = false
    @done = false
  end

  def apply_grade(grade)
    grade_items = grade.equip_grade_items

    if have_all_items?(grade_items)
      use_all_items(grade_items)
      @possible = true
      @last_grade = grade
    else
      @done = true
    end
  end

  def have_all_items?(grade_items)
    grade_items.all? { |grade_item|
      qty_remaining = items[grade_item.item_id - 1] || 0
      qty_remaining >= grade_item.qty
    }
  end

  def use_all_items(grade_items)
    grade_items.each { |grade_item|
      items[grade_item.item_id - 1] -= grade_item.qty
    }
  end
end

class Weapon
  attr_reader :weapon, :equip_data

  def initialize(weapon, equip_data)
    @weapon = weapon
    @equip_data = equip_data
  end

  def current_grade
    equip_data[weapon.id - 1]
  end

  def first_grade
    @first_grade ||= grades.first
  end

  def highest_grade(tracker)
    g, s = NextGrade.new(current_grade, first_grade).next_grade

    grades.where('grade >= ? AND sub_grade >= ?', g, s).each do |grade|
      tracker.apply_grade(grade)

      next unless tracker.done

      if tracker.possible
        return tracker.last_grade
      end

      break
    end
  end

  def grades
    @grades ||= weapon.equip_grades.order(:grade, :sub_grade)
  end
end

can_do = []
Equip.weapons.each do |weap|
  tracker = ItemTracker.new(item_data.dup)
  weapon = Weapon.new(weap, equip_data)

  if highest_grade = weapon.highest_grade(tracker)
    can_do << [weap, highest_grade]
  end
end

File.open('can_do.csv', 'w+') do |csv|
  headers = [
    'monster_name',
    'sub_type',
    'grade',
    'sub_grade',
    'atk',
    'crit',
    'elem',
  ]
  csv.puts CSV.generate_line(headers).strip

  can_do.sort_by{|_, grade|
    [grade.grade, grade.sub_grade].join
  }.reverse.each do |weap, mgr|
    line = [
      weap.monster&.name,
      weap.equip_subtype,
      mgr.grade,
      mgr.sub_grade,
      mgr.atk_power,
      mgr.crit_power,
      mgr.elem_power,
    ]
    csv.puts CSV.generate_line(line).strip
  end
end
