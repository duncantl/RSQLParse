library(RSQLParse)
p = parseSQL("SELECT * FROM TABLE")
class(p)

p = parseSQL("SELECT * FROM TABLE WHERE ")
class(p)



