# encoding: UTF-8
class Fixnum

  # @usage :  x.should_equal(expected, <message d'erreur>)
  def should_equal expected, mess_expected
    err = "(FAUX) #{mess_expected}\nAttendu:\n#{expected}\nObtenu:\n#{self}"
    Tests::Messages.evaluate(self === expected, err, mess_expected, self, expected)
  end
  def should_not_equal expected, mess_expected
    err = "FAUX : #{mess_expected} (les deux valeurs sont égales)"
    Tests::Messages.evaluate(self != expected, err, mess_expected, self, expected)
  end


end #/Fixnum
