require 'csv'
item_data = [294,179,76,8,255,274,75,69,34,5,273,257,102,67,30,3,263,295,57,47,31,6,216,219,70,48,20,3,72,235,3,50,12,2,299,97,36,30,13,6,248,245,57,53,21,nil,40,118,13,24,8,nil,194,14,2,32,8,2,88,11,16,22,21,2,88,11,4,11,5,1,40,51,9,7,7,nil,40,70,9,8,9,nil,6,2,nil,nil,2,nil,14,12,4,nil,1,nil,19,7,3,2,2,nil,188,161,25,30,18,nil,74,187,20,20,10,1,128,73,14,14,9,nil,2,2,nil,1,2,nil,nil,nil,nil,26,2,9,210,194,225,215,135,275,243,189,314,208,91,244,234,37,20,nil,131380]

equip_data = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"4_4",nil,"5_4",nil,nil,nil,nil,nil,nil,"3_4",nil,nil,nil,nil,nil,nil,nil,nil,"2_3",nil,nil,"7_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"2_4","3_5","3_4",nil,nil,nil,nil,nil,nil,nil,nil,"4_4",nil,"4_4",nil,"2_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"5_2","5_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"6_2",nil,nil,nil,nil,nil,nil,nil,nil,nil,"5_2",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"5_2",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"4_4",nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,"3_4"]

File.open('output.log', 'a') do |log|
  can_do = []
  Equip.weapons.each do |weap|
    log.puts
    temp_items = item_data.dup
    possible = false
    last = nil
    fst = weap.equip_grades.order(:grade, :sub_grade).first
    grade = fst.grade
    subgrade = fst.sub_grade
    if equip_data[weap.id - 1]
      log.puts(before: [grade, subgrade], current_lvl: equip_data[weap.id - 1])
      ngr, nsgr = equip_data[weap.id - 1].split(?_)
      if nsgr == '5'
        grade = ngr.to_i + 1
        subgrade = 1
        log.puts(ngr: ngr, nsgr: nsgr, nsgr_is_5: [grade, subgrade])
      else
        grade = ngr.to_i
        subgrade = nsgr.to_i + 1
        log.puts(ngr: ngr, nsgr: nsgr, nsgr_is_not_5: [grade, subgrade])
      end
    end
    weap.equip_grades.where("grade >= ? AND sub_grade >= ?", grade, subgrade).order(:grade, :sub_grade).each do |gr|
      egis = gr.equip_grade_items
      log.puts egis.map{|egi| [egi.item.name, egi.qty] }
      can = egis.all? {|egi|
        t_qty = temp_items[egi.item_id - 1] || 0
        n_qty = egi.qty
        log.puts item: egi.item.name, t_qty: t_qty, n_qty: n_qty
        t_qty >= n_qty
      }

      if can
        possible = true
        last = [gr.grade, gr.sub_grade]
        log.puts CAN: gr.equip_id, last: last
        egis.each do |egi|
          temp_items[egi.item_id - 1] -= egi.qty
        end
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
