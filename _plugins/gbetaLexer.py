# File: gbetaLexer.py
#
# gbeta Lexer for pygments
# 
# 
from pygments.lexer import RegexLexer, bygroups
from pygments.token import *

class GbetaLexer(RegexLexer):
    name      = 'gbeta'
    aliases   = ['gbeta']
    filenames = ['*.gb']
    mimetypes = ['text/plain']

    tokens    = {
        'root': [
            (r'\s+',Text),
            (r'-- \w+:\w+ --', Name.Namespace),
            (r'//.*?$', Comment.Single),
            (r'(ORIGIN|BODY|MBODY|INCLUDE|LIBFILE|LINKOPT|OBJFILE|MAKE|BUILD)(\s+)',
             bygroups(Keyword, Text)),
            (r'\'(\\\\|\\\'|[^\'])*\'', String),   # Strings are single quoted
            (r'<<SLOT +\w+: *\w+>>', Keyword.Type),
            (r'\b(do|for|while|case|if|else|then|leave|restart|suspend|inner|new)\b', Keyword),
            (r'\b(true|false|none)\b',Keyword.Constant),
            (r'\b(bool|int|char|string|float)\b',Keyword.Type),
            (r'\b(this|not|and|div|mod|or|xor)\b',Operator.Word),
            (r'([a-zA-Z_][a-zA-Z0-9_]*)(:(:?:|<)?|\s*\{)', 
             bygroups(Name.Other, Text)),
            (r'[a-zA-Z_\$][a-zA-Z0-9_]*', Name),
            (r'stdio\b', Name.Builtin),    # Register stdio as a builtin name
            (r'[0-9]+', Number.Integer),
            (r'\n', Text),
            (r'[^\S\n]+', Text),
            (r'[\(\)\{\};,.#%@]', Punctuation),
            (r'(\*\*|\*|\+|-|\/|<|>|<=|>=|=|<>|\||&)', Operator),
            ]
        }

from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import HtmlFormatter
import sys

if __name__ == '__main__':
    
    code = sys.argv[1]
    print highlight(code, GbetaLexer(), HtmlFormatter())
