parseSQL = sqlParse =
function(query, asText = !file.exists(query))
{
    query = as.character(query)
    if(!asText)
        query = paste( readLines(query), collapse = "\n")
    
    ans = .Call("R_parseSQL", query)
    if(is.list(ans)) {
        # error
        names(ans[[1]]) = c("message", "funcname", "filename", "lineno", "cursorpos")
        names(ans) = c("errorInfo", "stderrBuffer")
        class(ans) = "SQLParseErrorInfo"
    } else {
        ans = fromJSON(ans)
    }
    

    ans
    
}
