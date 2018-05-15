# encoding: UTF-8
class String
  def should_equal expected, mess_ok = nil
    # ok = self.strip === expected.strip
    ok = self == expected
    mess_ok = (mess_ok || '««« %s »»» et ««« %s »»» sont égaux') % [self, expected]
    err = ok ? '' : "(FAUX) #{mess_ok}\nAttendu:\n'''\n#{expected}\n'''\nObtenu:\n'''\n#{self}\n'''"
    Tests::Messages.evaluate(ok, err, mess_ok, self, expected)
  end
  def should_contain expected, mess_ok = nil
    ok = self.include?(expected)
    mess_ok = (mess_ok || 'Le texte ««« %s »»» contient ««« %s »»»') % [self, expected]
    err = ok ? '' : "(FAUX) #{mess_ok}\nLe texte :\n'''\n#{self}\n'''\n\n… devrait contenir :\n'''\n#{expected}\n'''"
    Tests::Messages.evaluate(ok, err, mess_ok, self, expected)
  end
  def should_not_equal expected, mess_ok = nil
    err = "(FAUX) #{mess_ok}"
    Tests::Messages.evaluate(self.strip != expected.strip, err, mess_ok, self, expected)
  end
  def should_not_contain expected, mess_ok = nil
    ok = !self.include?(expected)
    err = ok ? '' : "(FAUX) #{mess_ok}\nLe texte :\n'''\n#{self}\n'''\n\n… NE devrait PAS contenir :\n'''\n#{expected}\n'''"
    Tests::Messages.evaluate(ok, err, mess_ok, self, expected)
  end
end#/String
