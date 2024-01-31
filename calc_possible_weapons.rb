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

  def initialize(items)
    @items = items
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

File.open('output.log', 'a') do |log|
  can_do = []
  Equip.weapons.each do |weap|
    log.puts
    tracker = ItemTracker.new(item_data.dup)
    possible = false
    last = nil
    fst = weap.equip_grades.order(:grade, :sub_grade).first
    grade, subgrade = NextGrade.new(equip_data[weap.id - 1], fst).next_grade
    weap.equip_grades.where("grade >= ? AND sub_grade >= ?", grade, subgrade).order(:grade, :sub_grade).each do |gr|
      grade_items = gr.equip_grade_items
      if tracker.have_all_items?(grade_items)
        possible = true
        last = [gr.grade, gr.sub_grade]
        tracker.use_all_items(grade_items)
      else
        if possible
          can_do << [gr.equip_id, last]
        end
        break
      end
    end
  end

  File.open('can_do.csv', 'w+') do |csv|
    csv.puts CSV.generate_line(['monster_name', 'sub_type', 'grade', 'sub_grade', 'atk', 'crit', 'elem']).strip
    equip_ids = can_do.map(&:first)
    equips = Equip.where(id: equip_ids).includes(:monster).to_a
    can_do.each do |x, (y, z)|
      eq = equips.find{|equ| equ.id == x }
      log.puts monster: eq.monster&.name, eq_subtype: eq.equip_subtype, up_to: [y, z].join(?/)
      mgr = eq.equip_grades.find_by(grade: y, sub_grade: z)
      csv.puts CSV.generate_line([eq.monster&.name, eq.equip_subtype, mgr.grade, mgr.sub_grade, mgr.atk_power, mgr.crit_power, mgr.elem_power]).strip
    end
  end
end
