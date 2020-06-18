%{
open Core
%}

%token CALL
%token ASSIGN
%token LABEL
%token GOTO
%token IF
%token LP
%token RP
%token LB
%token RB
%token XOR
%token COMMA
%token COLON
%token MOVE
%token PHI
%token RETURN
%token <int>INT
%token <float>FLOAT
%token <string>STRING
%token <Core.var>ID
%token SEMICOLON
%token EOF

%start <Core.basic_blocks> prog

%%

prog: stmts=list(basic_block) EOF {stmts}
;

basic_block: LABEL lbl=ID COLON phi=phi suite=suite { (lbl, {suite; phi}) }
;

move :  target=ID MOVE from=ID { (target, from) }
;

branch : lbl=ID COLON moves=separated_list(COMMA, move) {(lbl, moves)}
;

phi : PHI LB brs=separated_list(XOR, branch) RB {brs}
;

repr : n=ID { D n }
     | i=INT { S (IntL i) }
     | f=FLOAT { S (FloatL f) }
     | s=STRING { S (StrL s) }
     ;

instr : CALL func=repr LP args=separated_list(COMMA, repr) RP
        { Call(None, func, args, [])}
      | ID ASSIGN from=repr { Assign($1, from) }
      | ID ASSIGN CALL func=repr LP args=separated_list(COMMA, repr) RP
        { Call(Some $1, func, args, []) }
      | RETURN v=repr {Return v}
      | IF cond=repr GOTO t=ID GOTO f=ID { GotoIf(cond, t, f) }
      | GOTO l=ID { Goto l }
      ;

suite :  xs=separated_list(SEMICOLON, instr)  { xs }
;

