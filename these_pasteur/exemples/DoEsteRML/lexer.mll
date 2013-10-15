{
open Parser;;

exception EOF;;

let line = ref 1;;
}

rule token = parse
(* spaces *)
  [' ' '\t']          { token lexbuf }
| ['\n']              { incr line; token lexbuf }

(* comments *)
| '%' [^'\n']* '\n'                { incr line; token lexbuf }
| "%{" ([^'}']|('}'[^'%']))* "}%"  { let count = function
                                         'n' -> incr line
                                       | _ -> () in
                                     String.iter count (Lexing.lexeme lexbuf);
                                     token lexbuf }

(* operators *)
| '('                 { LPAREN }
| ')'                 { RPAREN }
| '['                 { LBRACKET }
| ']'                 { RBRACKET }
| ','                 { COMMA }
| ';'                 { SEMICOLON }
| ':'                 { COLON }
| "."                 { DOT }
| "#"                 { DASH }
| "=>"                { IMPLY }
| "+"                 { PLUS }
| "-"                 { MINUS }
| "*"                 { TIMES }
| "/"                 { DIV }
| "="                 { EQUAL }
| '?'                 { QMARK }
| "<>"                { UNEQUAL }
| "<"                 { LOWER }
| "<="                { LOWEROREQUAL }
| ">"                 { GREATER }
| ">="                { GREATEROREQUAL }
| "||"                { PARALLEL }
| ":="                { COLONEQUAL }

(* keywords *)
| "abort"             { ABORT }
| "and"               { AND }
| "await"             { AWAIT }
| "by"                { BY }
| "call"              { CALL }
| "case"              { CASE }
| "combine"           { COMBINE }
| "copymodule"        { COPYMODULE }
| "constant"          { CONSTANT }
| "do"                { DO }
| "done"              { DONE }
| "domain"            { DOMAIN }
| "each"              { EACH }
| "else"              { ELSE }
| "emit"              { EMIT }
| "end"               { END }
| "every"             { EVERY }
| "exit"              { EXIT }
| "false"             { FALSE }
| "function"          { FUNCTION }
| "goto"              { GOTO }
| "halt"              { HALT }
| "handle"            { HANDLE }
| "if"                { IF }
| "immediate"         { IMMEDIATE }
| "in"                { IN }
| "input"             { INPUT }
| "inputoutput"       { INPUTOUTPUT }
| "loop"              { LOOP }
| "mod"               { MOD }
| "module"            { MODULE }
| "not"               { NOT }
| "nothing"           { NOTHING }
| "or"                { OR }
| "output"            { OUTPUT }
| "pause"             { PAUSE }
| "positive"          { POSITIVE }
| "pre"               { PRE }
| "present"           { PRESENT }
| "print"             { PRINT }
| "procedure"         { PROCEDURE }
| "relation"          { RELATION }
| "repeat"            { REPEAT }
| "run"               { RUN }
| "sensor"            { SENSOR }
| "signal"            { SIGNAL }
| "suspend"           { SUSPEND }
| "sustain"           { SUSTAIN }
| "then"              { THEN }
| "timeout"           { TIMEOUT }
| "times"             { TIMES }
| "trap"              { TRAP }
| "true"              { TRUE }
| "type"              { TYPE }
| "upto"              { UPTO }
| "var"               { VAR }
| "watching"          { WATCHING }
| "weak"              { WEAK }
| "when"              { WHEN }
| "with"              { WITH }

(* strings *)
| '"'[^'"']*'"'       (* '"' emacs mode fix *)
                      { let s = Lexing.lexeme lexbuf in
                        STRING (String.sub s 1 (String.length s - 2)) }

(* integers *)
| ['0'-'9']+          { INT (int_of_string (Lexing.lexeme lexbuf)) }

(* identifiers *)
| ['a'-'z''A'-'Z']['a'-'z''A'-'Z''0'-'9''_']*
                      { IDENT (Lexing.lexeme lexbuf) }

(* end of file *)
| eof                 { raise EOF}
