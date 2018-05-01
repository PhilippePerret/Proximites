# encoding: UTF-8
class FalseClass
  def should_equal expected, mess_ok = nil
    err = "FAUX : #{mess_ok} (la valeur est `true`)"
    Tests::Messages.evaluate(self === expected, err, mess_ok, self, expected)
  end
  def should_not_equal expected, err, mess_ok = nil
    err = "FAUX : #{mess_ok} (la valeur ne devrait pas être `false`)"
    Tests::Messages.evaluate(self != expected, err, mess_ok, self, expected)
  end
end#/String
