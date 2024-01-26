#include <Rdefines.h>

#undef error

#include <pg_query.h>
#include <stdio.h>

SEXP mkPgQueryError(const PgQueryError * const err);

SEXP R_parseSQL(SEXP r_sql)
{
  PgQueryParseResult result;
  SEXP ans = R_NilValue;

  result = pg_query_parse(CHAR(STRING_ELT(r_sql, 0)));

  if(result.error) {
      PROTECT(ans = Rf_allocVector(VECSXP, 2));
      SET_VECTOR_ELT(ans, 0, mkPgQueryError(result.error));
      SET_VECTOR_ELT(ans, 1, ScalarString(mkChar(result.stderr_buffer ? result.stderr_buffer : "")));
      UNPROTECT(1);
  } else {
      ans = ScalarString( mkChar(result.parse_tree) );
  }
  
//  printf("%s\n", result.parse_tree);

  pg_query_free_parse_result(result);

  return(ans);
}


SEXP
mkPgQueryError(const PgQueryError *const err)
{
    SEXP ans;
    ans = Rf_allocVector(VECSXP, 5);
    PROTECT(ans);
    SET_VECTOR_ELT(ans, 0, ScalarString(mkChar(err->message)));
    SET_VECTOR_ELT(ans, 1, ScalarString(mkChar(err->funcname ? err->funcname : "")));
    SET_VECTOR_ELT(ans, 2, ScalarString(mkChar(err->filename ? err->filename : "")));
    SET_VECTOR_ELT(ans, 3, ScalarInteger(err->lineno));
    SET_VECTOR_ELT(ans, 4, ScalarInteger(err->cursorpos));    

    UNPROTECT(1);
    return(ans);
}
