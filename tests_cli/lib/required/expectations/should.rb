# encoding: UTF-8


# @usage :
#         should_equal(valeur1, valeur2, '<message en cas de succès>')
#
def should_equal actual, expected, mess_ok, strict = false
  ok = strict ? actual === expected : actual == expected
  err = ok ? '' : "(FAUX #{mess_ok}) [ #{actual.inspect} ] devrait être égal à [ #{expected.inspect} ]"
  Tests::Messages.evaluate(ok, err, mess_ok, actual, expected)
end
def should_not_equal actual, expected, mess_ok, strict = false
  ok = !(strict ? actual == expected : actual === expected)
  err = ok ? '' : "(FAUX #{mess_ok}) [ #{actual.inspect} ] NE devrait PAS être égal à [ #{expected.inspect} ]"
  Tests::Messages.evaluate(ok, err, mess_ok, actual, expected)
end
