%{
open Core
%}

%token CALL
%token ASSIGN
%token LABEL
%token GOTO
%token IF
%token LP
%token DEF
%token FED
%token BOUND
%token TYPE
%token AT
%token RP
%token LB
%token RB
%token XOR
%token COMMA
%token COLON
%token TRUE
%token FALSE
%token MOVE
%token PHI
%token RETURN
%token <int>INT
%token <float>FLOAT
%token <string>STRING
%token <Core.var>ID
%token SEMICOLON
%token EOF

%start <Core.fn_def option * (Core.fn_def Core.M_int.t)> prog

%%

prog : xs=list(func_def) EOF
    { 
      let main = ref None in
      let globals = List.mapi (fun i (n, _) -> (n, FPtrT i)) xs in
      let fdefs = List.mapi
        (fun i (n, f) ->
          let f = 
            {f with entry = {f.entry with globals = globals; fn_bounds = f.entry.fn_bounds}}
          in
          (if n = (0, "main") then
            main := Some f);
          i, f)
        xs
      in
      !main, List.fold_left (fun a (i, f) -> M_int.add i f a) M_int.empty fdefs
    }
;

typ : AT n=STRING { NomT n }
     | AT n=ID { NomT (snd n) }
     | TYPE LB t=typ RB { TypeT t }
     | LP ts=separated_list(XOR, typ) RP { UnionT ts }
     ;


func_entry : LP args=separated_list(COMMA, ID) RP
       BOUND LB fn_bounds=separated_list(COMMA, ID) RB
        { { args=args
          ; kwargs=[]
          ; fn_bounds=fn_bounds
          ; globals=[]
          }
        }
;

func_def : DEF n=ID entry=func_entry body=bbs FED { (n, {entry; body}) }
;

bbs: stmts=list(basic_block) {stmts}
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
     | TRUE { S (BoolL true) }
     | FALSE { S (BoolL false) }
     | t=typ  { S (TypeL t) }
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

stmt : instr SEMICOLON { $1 }
;

suite :  xs=list(stmt)  { xs }
;

