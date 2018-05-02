# encoding: UTF-8

class Fixnum

  # @usage :  x.should_equal(expected, <message d'erreur>)
  def should_equal expected, mess_ok
    err = "(FAUX) #{mess_ok}\nAttendu:#{RETTT}#{expected.inspect}\nObtenu:#{RETTT}#{self.inspect}"
    Tests::Messages.evaluate(self === expected, err, mess_ok, self, expected)
  end
  def should_not_equal expected, mess_ok
    err = "FAUX : #{mess_ok} (les deux valeurs sont égales)"
    Tests::Messages.evaluate(self != expected, err, mess_ok, self, expected)
  end

  def should_be_greater_than expected, mess_ok
    ok = self > expected
    err = ok ? '' : "(FAUX) #{mess_ok}\n#{self} n’est pas plus grand que #{expected}."
    Tests::Messages.evaluate(ok, err, mess_ok, self, expected)
  end

  def should_be_less_than expected, mess_ok
    ok = self < expected
    err = ok ? '' : "(FAUX) #{mess_ok}\n#{self} est plus grand que #{expected}."
    Tests::Messages.evaluate(ok, err, mess_ok, self, expected)
  end


end #/Fixnum
