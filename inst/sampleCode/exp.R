ll = readLines("~/GitWorkingArea/RSQLParse/inst/sampleCode/select1.sql"); ll = ll[ll != ""]
p = lapply(ll, parseSQL)
names(p) = ll

# Check if any have class SQLParseErrorInfo.
table(sapply(p, class))

err = sapply(p, class) == "SQLParseErrorInfo"
table(err)
which(err)

