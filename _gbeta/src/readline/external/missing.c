#include <stdlib.h>
#include <string.h>

extern char *readline(char const *prompt);

char *
raw_readline(char const *prompt)
{
   char *result=readline(prompt);
   if (result) return result;
   else return "\004";
}

#pragma unused
void _set_lines_and_columns(int ignore1, int ignore2) {}

/* **************************************************************** */
/*								    */
/*	 Functions for quoting strings to be re-read as input	    */
/*								    */
/* **************************************************************** */

/* Return a new string which is the single-quoted version of STRING.
   Used by alias and trap, among others. */
char *
_single_quote (char *string)
{
  register int c;
  char *result, *r, *s;

  result = (char *)malloc (3 + (4 * strlen (string)));
  r = result;
  *r++ = '\'';

  for (s = string; s && (c = *s); s++)
    {
      *r++ = c;

      if (c == '\'')
	{
	  *r++ = '\\';	/* insert escaped single quote */
	  *r++ = '\'';
	  *r++ = '\'';	/* start new quoted string */
	}
    }

  *r++ = '\'';
  *r = '\0';

  return (result);
}

/* Quote STRING using double quotes.  Return a new string. */
char *
double_quote (char *string)
{
  register int c;
  char *result, *r, *s;

  result = (char *)malloc (3 + (2 * strlen (string)));
  r = result;
  *r++ = '"';

  for (s = string; s && (c = *s); s++)
    {
      switch (c)
        {
	case '"':
	case '$':
	case '`':
	case '\\':
	  *r++ = '\\';
	default:
	  *r++ = c;
	  break;
        }
    }

  *r++ = '"';
  *r = '\0';

  return (result);
}

/* Quote special characters in STRING using backslashes.  Return a new
   string. */
char *
backslash_quote (char *string)
{
  int c;
  char *result, *r, *s;

  result = (char *)malloc (2 * strlen (string) + 1);

  for (r = result, s = string; s && (c = *s); s++)
    {
      switch (c)
	{
	case ' ': case '\t': case '\n':		/* IFS white space */
	case '\'': case '"': case '\\':		/* quoting chars */
	case '|': case '&': case ';':		/* shell metacharacters */
	case '(': case ')': case '<': case '>':
	case '!': case '{': case '}':		/* reserved words */
	case '*': case '[': case '?': case ']':	/* globbing chars */
	case '^':
	case '$': case '`':			/* expansion chars */
	  *r++ = '\\';
	  *r++ = c;
	  break;
	case '#':				/* comment char */
	  if (s == string)
	    *r++ = '\\';
	  /* FALLTHROUGH */
	default:
	  *r++ = c;
	  break;
	}
    }

  *r = '\0';
  return (result);
}

int
contains_shell_metas (char *string)
{
  char *s;

  for (s = string; s && *s; s++)
    {
      switch (*s)
	{
	case ' ': case '\t': case '\n':		/* IFS white space */
	case '\'': case '"': case '\\':		/* quoting chars */
	case '|': case '&': case ';':		/* shell metacharacters */
	case '(': case ')': case '<': case '>':
	case '!': case '{': case '}':		/* reserved words */
	case '*': case '[': case '?': case ']':	/* globbing chars */
	case '^':
	case '$': case '`':			/* expansion chars */
	  return (1);
	case '#':
	  if (s == string)			/* comment char */
	    return (1);
	  /* FALLTHROUGH */
	default:
	  break;
	}
    }

  return (0);
}

