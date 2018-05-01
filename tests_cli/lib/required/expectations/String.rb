# encoding: UTF-8
class String
  def should_equal expected, mess_ok = nil
    err = "(FAUX) #{mess_ok}\nAttendu:\n#{expected}\nObtenu:\n#{self}"
    Tests::Messages.evaluate(self === expected, err, mess_ok, self, expected)
  end
  def should_not_equal expected, mess_ok = nil
    err = "(FAUX) #{mess_ok}"
    Tests::Messages.evaluate(self != expected, err, mess_ok, self, expected)
  end
end#/String
