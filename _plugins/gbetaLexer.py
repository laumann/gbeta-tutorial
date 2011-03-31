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
            (r'[a-zA-Z_][a-zA-Z0-9_]*:(:?:|<)?', Keyword.Declaration),
            (r'[a-zA-Z_\$][a-zA-Z0-9_]*', Name),
            (r'[0-9]+', Number.Integer),
            (r'\n', Text),
            (r'[^\S\n]+', Text),
            (r'[\(\)\{\};,.#%@]', Punctuation),
            (r'(\*\*|\*|\+|-|\/|<|>|<=|>=|=|<>|\||&)', Operator),
            ]
        }

# from pygments import highlight
# from pygments.lexers import PythonLexer
# from pygments.formatters import HtmlFormatter
# # main method
# if __name__ == '__main__':
#     code = 'ORIGIN \'gbetaenv\'\n\
# -- program:merge --\n\
# // gbeta version of \'99 Bottles of Beer on the Wall\'\n\
# // Erik Ernst, eernst@cs.au.dk\n\
# {\n\
#   line: int %{\n\
#     a:< string; b:< string; end:< bool;\n\
#     plural: %(|if value=1 then \'\' else \'s\');\n\
#     punct: %(|if end then \'.\' else \',\');\n\
#   #\n\
#     if value=0 do { \'no more\'|puttext } else { value|putint };\n\
#     \' bottle\'+plural+\' of beer\'+a+punct+b|putline\n\
#   };\n\
#   long: line{ a:: { \' on the wall\'|value }};\n\
#   period: line{ end:: { true|value }};\n\
#   take: period{ b:: { \'\\nTake one down, pass it around,\'|value }}\n\
# #\n\
#   for i:99 do { (99-i|long|take)-1|long&period; newline }\n\
# }'

#     print highlight(code, GbetaLexer(), HtmlFormatter())
