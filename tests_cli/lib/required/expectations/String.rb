# encoding: UTF-8
class String
  def should_equal expected, mess_ok = nil
    ok = self.strip === expected.strip
    err = ok ? '' : "(FAUX) #{mess_ok}\nAttendu:\n'''\n#{expected}\n'''\nObtenu:\n'''\n#{self}\n'''"
    Tests::Messages.evaluate(ok, err, mess_ok, self.strip, expected.strip)
  end
  def should_not_equal expected, mess_ok = nil
    err = "(FAUX) #{mess_ok}"
    Tests::Messages.evaluate(self.strip != expected.strip, err, mess_ok, self, expected)
  end
end#/String
