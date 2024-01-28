mysqlExport =
function(sql, asText = !file.exists(sql))
{
    if(!asText)
        sql = readLines(sql)

    s = grep("^CREATE (PROCEDURE|FUNCTION)", sql)
    e = grep("^ *END\\$\\$", sql)

    procFuns = mkProcFuns(sql, s, e)
    sql = sql[ - unlist(mapply(seq, s, e)) ]

    sql = removeComments(sql)
    d4 = strsplit(gsub("\\n\\n+", "\n\n", paste(sql, collapse = "\n")), "\\n")[[1]]
    g = split(d4, cumsum(d4 == ""))
    g = lapply(g, function(x) if(x[1] == "") x[-1] else x)
    names(g)
    names(g) = gsub(" .*", "", sapply(g, `[`, 1))

    g2 = split(g, names(g))
    g2 = lapply(g2, setNames)
        
    g2$procFuns = procFuns

    g2
}

setNames =
function(x)
{
    names(x) = gsub("[^`]*`([^`]+)`.*", "\\1", sapply(x, `[`, 1))
    x
}


mkProcFuns =
function(x, s, e)
{
    procFuns = mapply(function(s, e) x[seq(s, e)], s, e)
    names(procFuns) = gsub("[^`]*`([^`]+)`.*", "\\1", sapply(procFuns, `[`, 1))
    procFuns
}


removeComments =
function(x)
    x[!isCommentLine(x)]


isCommentLine =
function(x)
    grepl("^--", x) |  grepl("^ */\\*.*\\*/;?$", x)


