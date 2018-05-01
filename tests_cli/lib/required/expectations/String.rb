# encoding: UTF-8
class String
  def should_equal expected, err, mess_ok = nil
    Tests::Messages.evaluate(self === expected, err, mess_ok, self, expected)
  end
  def should_not_equal expected, err, mess_ok = nil
    Tests::Messages.evaluate(self != expected, err, mess_ok, self, expected)
  end
end#/String
