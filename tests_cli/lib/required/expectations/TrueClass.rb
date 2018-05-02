# encoding: UTF-8
class TrueClass
  def should_equal expected, mess_ok = nil
    err = "FAUX : #{mess_ok} (la valeur est `false`)"
    Tests::Messages.evaluate(self === expected, err, mess_ok, self, expected)
  end
  def should_not_equal expected, err, mess_ok = nil
    err = "FAUX : #{mess_ok} (la valeur ne devrait pas être `true`)"
    Tests::Messages.evaluate(self != expected, err, mess_ok, self, expected)
  end
  def should_be_false sujet
    err = "[#{sujet}] devrait être false, il est true."
    Tests::Messages.evaluate(false, err, nil, self, false)
  end
  def should_be_true sujet
    mess_ok = "[#{sujet}] est true."
    Tests::Messages.evaluate(true, nil, mess_ok, self, true)
  end
end#/String
