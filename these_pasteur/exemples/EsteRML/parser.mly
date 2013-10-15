%{
open Ast;;
%}


%token LPAREN RPAREN QMARK LBRACKET RBRACKET
%token COMBINE WITH PLUS TIMES AND OR COLONEQUAL
%token NOTHING PAUSE EMIT PRESENT IF THEN ELSE
%token SUSPEND WHEN LOOP TRAP IN EXIT SIGNAL VAR
%token MODULE COLON END PARALLEL SEMICOLON DOT
%token TRUE FALSE MINUS EQUAL UNEQUAL NOT COPYMODULE
%token LOWER GREATER LOWEROREQUAL GREATEROREQUAL
%token COMMA TYPE CONSTANT FUNCTION HANDLE ABORT
%token CASE WEAK DO HALT IMMEDIATE DIV MOD CALL
%token INPUT INPUTOUTPUT OUTPUT SENSOR PRE PROCEDURE
%token SUSTAIN REPEAT AWAIT EACH RUN TIMES POSITIVE
%token EVERY WATCHING TIMEOUT UPTO RELATION DASH IMPLY
%token GOTO PRINT REC

%right PARALLEL
%right SEMICOLON
%right COMMA
%left OR
%left AND
%nonassoc NOT
%left EQUAL UNEQUAL LOWER LOWEROREQUAL GREATER GREATEROREQUAL
%left PLUS MINUS
%left TIMES DIV MOD
%nonassoc UMINUS
%nonassoc QMARK

%token <string> IDENT
%token <int> INT
%token <string> STRING

%type <Ast.pexp> main

%start main

%%

main:
| statement DOT                         { $1 }
| DOT statement DOT                     { $2 }

statement:
  NOTHING                               { Pnothing }
| PAUSE                                 { Ppause }
| PRINT STRING                          { Pprint $2 }
| PRINT INT                             { Pprint (string_of_int $2) }
| SIGNAL IDENT IN statement END         { Psignal ($2, $4) }
| EMIT IDENT                            { Pemit $2 }
| PRESENT IDENT present END             { Ppresent ($2, fst $3, snd $3) }
| LBRACKET statement RBRACKET           { $2 }
| statement SEMICOLON statement         { Pseq ($1, $3) }
| statement PARALLEL statement          { Ppar ($1, $3) }
| statement SEMICOLON                   { $1 }
| LOOP statement END                    { Ploop $2 }
| TRAP IDENT IN statement END           { Ptrap ($2, $4) }
| EXIT IDENT                            { Pexit $2 }
| REC IDENT EQUAL statement END         { Prec ($2, $4) }
| RUN IDENT                             { Prun $2 }
;

present:
  THEN statement ELSE statement         { $2, $4 }
| THEN statement                        { $2, Pnothing }
| ELSE statement                        { Pnothing, $2 }
|                                       { Pnothing, Pnothing }
;
