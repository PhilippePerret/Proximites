# encoding: UTF-8
class Proximity

  def treated?  ; !!@is_treated end
  def treated_in_quick_mode? ; !!@is_treated_in_quick_mode end
  def deleted?  ; !!@is_deleted end

  def set_treated   ; @is_treated = true  end
  def set_deleted   ; @is_deleted = true  end
  def set_undeleted ; @is_deleted = nil   end
  def set_treated_in_quick_mode
    @is_treated_in_quick_mode == true
  end

end #/Proximity
