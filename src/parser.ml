
module MenhirBasics = struct
  
  exception Error
  
  type token = 
    | XOR
    | TYPE
    | TRUE
    | STRING of (
# 29 "src/parser.mly"
       (string)
# 14 "src/parser.ml"
  )
    | SEMICOLON
    | RP
    | RETURN
    | RB
    | PHI
    | MOVE
    | LP
    | LB
    | LABEL
    | INT of (
# 27 "src/parser.mly"
       (int)
# 28 "src/parser.ml"
  )
    | IF
    | ID of (
# 30 "src/parser.mly"
       (Core.var)
# 34 "src/parser.ml"
  )
    | GOTO
    | FLOAT of (
# 28 "src/parser.mly"
       (float)
# 40 "src/parser.ml"
  )
    | FED
    | FALSE
    | EOF
    | DEF
    | COMMA
    | COLON
    | CALL
    | BOUND
    | AT
    | ASSIGN
  
end

include MenhirBasics

let _eRR =
  MenhirBasics.Error

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState106
  | MenhirState101
  | MenhirState93
  | MenhirState89
  | MenhirState87
  | MenhirState80
  | MenhirState77
  | MenhirState75
  | MenhirState74
  | MenhirState67
  | MenhirState58
  | MenhirState57
  | MenhirState55
  | MenhirState48
  | MenhirState42
  | MenhirState40
  | MenhirState35
  | MenhirState33
  | MenhirState27
  | MenhirState25
  | MenhirState13
  | MenhirState8
  | MenhirState7
  | MenhirState5
  | MenhirState3
  | MenhirState0

# 1 "src/parser.mly"
  
open Core

# 99 "src/parser.ml"

let rec _menhir_goto_list_stmt_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_stmt_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState93 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv421 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_stmt_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv419 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_stmt_) : 'tv_list_stmt_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_stmt)) = _menhir_stack in
        let _v : 'tv_list_stmt_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 117 "src/parser.ml"
         in
        _menhir_goto_list_stmt_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv420)) : 'freshtv422)
    | MenhirState57 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv435) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_stmt_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv433) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_stmt_) : 'tv_list_stmt_) = _v in
        ((let _v : 'tv_suite = 
# 107 "src/parser.mly"
                        ( xs )
# 132 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv431) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suite) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv429 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 142 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suite) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv427 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 150 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((suite : 'tv_suite) : 'tv_suite) = _v in
        ((let (((_menhir_stack, _menhir_s), (lbl : (
# 30 "src/parser.mly"
       (Core.var)
# 157 "src/parser.ml"
        ))), (phi : 'tv_phi)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_basic_block = 
# 73 "src/parser.mly"
                                                    ( (lbl, {suite; phi}) )
# 164 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv425) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_basic_block) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv423 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LABEL ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState101
        | FED ->
            _menhir_reduce13 _menhir_env (Obj.magic _menhir_stack) MenhirState101
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState101) : 'freshtv424)) : 'freshtv426)) : 'freshtv428)) : 'freshtv430)) : 'freshtv432)) : 'freshtv434)) : 'freshtv436)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_XOR_branch_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_XOR_branch_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv413) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv411) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_XOR_branch_) : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_branch__ = 
# 144 "<standard.mly>"
    ( x )
# 202 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_branch__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv412)) : 'freshtv414)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv417 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv415 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_XOR_branch_) : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_branch)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_XOR_branch_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 219 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_branch_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv416)) : 'freshtv418)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_COMMA_move_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_move_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState42 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv405) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv403) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_move_) : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_move__ = 
# 144 "<standard.mly>"
    ( x )
# 240 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_move__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv404)) : 'freshtv406)
    | MenhirState48 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv409 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv407 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_move_) : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_move)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_move_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 257 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_move_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv408)) : 'freshtv410)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_repr__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState77 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv393 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 272 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv389 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 282 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv387 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 289 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let ((((_menhir_stack, _menhir_s, (_1 : (
# 30 "src/parser.mly"
       (Core.var)
# 294 "src/parser.ml"
            ))), _), _, (func : 'tv_repr)), _, (xs : 'tv_loption_separated_nonempty_list_COMMA_repr__)) = _menhir_stack in
            let _7 = () in
            let _5 = () in
            let _3 = () in
            let _2 = () in
            let _v : 'tv_instr = let args = 
# 232 "<standard.mly>"
    ( xs )
# 303 "src/parser.ml"
             in
            
# 98 "src/parser.mly"
        ( Call(Some _1, func, args, []) )
# 308 "src/parser.ml"
             in
            _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv388)) : 'freshtv390)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv391 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 318 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv392)) : 'freshtv394)
    | MenhirState89 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv401 * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv397 * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv395 * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (((_menhir_stack, _menhir_s), _, (func : 'tv_repr)), _, (xs : 'tv_loption_separated_nonempty_list_COMMA_repr__)) = _menhir_stack in
            let _5 = () in
            let _3 = () in
            let _1 = () in
            let _v : 'tv_instr = let args = 
# 232 "<standard.mly>"
    ( xs )
# 341 "src/parser.ml"
             in
            
# 95 "src/parser.mly"
        ( Call(None, func, args, []))
# 346 "src/parser.ml"
             in
            _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv396)) : 'freshtv398)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv399 * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv400)) : 'freshtv402)
    | _ ->
        _menhir_fail ()

and _menhir_reduce17 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_stmt_ = 
# 211 "<standard.mly>"
    ( [] )
# 364 "src/parser.ml"
     in
    _menhir_goto_list_stmt_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run58 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | FALSE ->
        _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | FLOAT _v ->
        _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | ID _v ->
        _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | INT _v ->
        _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | LP ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | STRING _v ->
        _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState58 _v
    | TRUE ->
        _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | TYPE ->
        _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState58
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState58

and _menhir_run67 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState67
    | FALSE ->
        _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState67
    | FLOAT _v ->
        _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
    | ID _v ->
        _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
    | INT _v ->
        _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
    | LP ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState67
    | STRING _v ->
        _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
    | TRUE ->
        _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState67
    | TYPE ->
        _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState67
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState67

and _menhir_run73 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 429 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ASSIGN ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv383 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 441 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AT ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState74
        | CALL ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv381 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 453 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState74 in
            ((let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState75
            | FALSE ->
                _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState75
            | FLOAT _v ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState75 _v
            | ID _v ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState75 _v
            | INT _v ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState75 _v
            | LP ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState75
            | STRING _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState75 _v
            | TRUE ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState75
            | TYPE ->
                _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState75
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState75) : 'freshtv382)
        | FALSE ->
            _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState74
        | FLOAT _v ->
            _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
        | ID _v ->
            _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
        | INT _v ->
            _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
        | LP ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState74
        | STRING _v ->
            _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
        | TRUE ->
            _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState74
        | TYPE ->
            _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState74
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState74) : 'freshtv384)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv385 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 509 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv386)

and _menhir_run85 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv377 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 526 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv375 * _menhir_state) = Obj.magic _menhir_stack in
        let ((l : (
# 30 "src/parser.mly"
       (Core.var)
# 534 "src/parser.ml"
        )) : (
# 30 "src/parser.mly"
       (Core.var)
# 538 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_instr = 
# 101 "src/parser.mly"
                  ( Goto l )
# 545 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv376)) : 'freshtv378)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv379 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv380)

and _menhir_run87 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState87
    | FALSE ->
        _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState87
    | FLOAT _v ->
        _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState87 _v
    | ID _v ->
        _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState87 _v
    | INT _v ->
        _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState87 _v
    | LP ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState87
    | STRING _v ->
        _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState87 _v
    | TRUE ->
        _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState87
    | TYPE ->
        _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState87
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState87

and _menhir_goto_loption_separated_nonempty_list_COMMA_move__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_move__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv373 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 591 "src/parser.ml"
    ))) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_loption_separated_nonempty_list_COMMA_move__) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv371 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 599 "src/parser.ml"
    ))) = Obj.magic _menhir_stack in
    let (_ : _menhir_state) = _menhir_s in
    let ((xs : 'tv_loption_separated_nonempty_list_COMMA_move__) : 'tv_loption_separated_nonempty_list_COMMA_move__) = _v in
    ((let (_menhir_stack, _menhir_s, (lbl : (
# 30 "src/parser.mly"
       (Core.var)
# 606 "src/parser.ml"
    ))) = _menhir_stack in
    let _2 = () in
    let _v : 'tv_branch = let moves = 
# 232 "<standard.mly>"
    ( xs )
# 612 "src/parser.ml"
     in
    
# 79 "src/parser.mly"
                                                        ((lbl, moves))
# 617 "src/parser.ml"
     in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv369) = _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_branch) = _v in
    ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv367 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | XOR ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv361 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState55 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState55) : 'freshtv362)
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv363 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_branch)) = _menhir_stack in
        let _v : 'tv_separated_nonempty_list_XOR_branch_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 648 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_branch_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv364)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv365 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv366)) : 'freshtv368)) : 'freshtv370)) : 'freshtv372)) : 'freshtv374)

and _menhir_run43 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 662 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | MOVE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv357 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 674 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv353 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 684 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 689 "src/parser.ml"
            )) = _v in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv351 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 696 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let ((from : (
# 30 "src/parser.mly"
       (Core.var)
# 701 "src/parser.ml"
            )) : (
# 30 "src/parser.mly"
       (Core.var)
# 705 "src/parser.ml"
            )) = _v in
            ((let (_menhir_stack, _menhir_s, (target : (
# 30 "src/parser.mly"
       (Core.var)
# 710 "src/parser.ml"
            ))) = _menhir_stack in
            let _2 = () in
            let _v : 'tv_move = 
# 76 "src/parser.mly"
                               ( (target, from) )
# 716 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv349) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : 'tv_move) = _v in
            ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv347 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | COMMA ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv341 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | ID _v ->
                    _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState48 _v
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState48) : 'freshtv342)
            | RB | XOR ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv343 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, (x : 'tv_move)) = _menhir_stack in
                let _v : 'tv_separated_nonempty_list_COMMA_move_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 747 "src/parser.ml"
                 in
                _menhir_goto_separated_nonempty_list_COMMA_move_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv344)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv345 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv346)) : 'freshtv348)) : 'freshtv350)) : 'freshtv352)) : 'freshtv354)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv355 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 764 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv356)) : 'freshtv358)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv359 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 775 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv360)

and _menhir_goto_separated_nonempty_list_COMMA_repr_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_repr_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState89 | MenhirState77 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv335) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv333) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_repr_) : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_repr__ = 
# 144 "<standard.mly>"
    ( x )
# 795 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv334)) : 'freshtv336)
    | MenhirState80 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv339 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv337 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_repr_) : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_repr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_repr_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 812 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_repr_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv338)) : 'freshtv340)
    | _ ->
        _menhir_fail ()

and _menhir_reduce25 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_loption_separated_nonempty_list_COMMA_repr__ = 
# 142 "<standard.mly>"
    ( [] )
# 823 "src/parser.ml"
     in
    _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run59 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv331) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 89 "src/parser.mly"
            ( S (BoolL true) )
# 837 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv332)

and _menhir_run60 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 29 "src/parser.mly"
       (string)
# 844 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv329) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((s : (
# 29 "src/parser.mly"
       (string)
# 854 "src/parser.ml"
    )) : (
# 29 "src/parser.mly"
       (string)
# 858 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 88 "src/parser.mly"
                ( S (StrL s) )
# 863 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv330)

and _menhir_run61 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 27 "src/parser.mly"
       (int)
# 870 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv327) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((i : (
# 27 "src/parser.mly"
       (int)
# 880 "src/parser.ml"
    )) : (
# 27 "src/parser.mly"
       (int)
# 884 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 86 "src/parser.mly"
             ( S (IntL i) )
# 889 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv328)

and _menhir_run62 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 896 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv325) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((n : (
# 30 "src/parser.mly"
       (Core.var)
# 906 "src/parser.ml"
    )) : (
# 30 "src/parser.mly"
       (Core.var)
# 910 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 85 "src/parser.mly"
            ( D n )
# 915 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv326)

and _menhir_run63 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 28 "src/parser.mly"
       (float)
# 922 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv323) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((f : (
# 28 "src/parser.mly"
       (float)
# 932 "src/parser.ml"
    )) : (
# 28 "src/parser.mly"
       (float)
# 936 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 87 "src/parser.mly"
               ( S (FloatL f) )
# 941 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv324)

and _menhir_run64 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv321) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 90 "src/parser.mly"
             ( S (BoolL false) )
# 955 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv322)

and _menhir_goto_instr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_instr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv319 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | SEMICOLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv315 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv313 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (_1 : 'tv_instr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_stmt = 
# 104 "src/parser.mly"
                       ( _1 )
# 978 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv311) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_stmt) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv309 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CALL ->
            _menhir_run87 _menhir_env (Obj.magic _menhir_stack) MenhirState93
        | GOTO ->
            _menhir_run85 _menhir_env (Obj.magic _menhir_stack) MenhirState93
        | ID _v ->
            _menhir_run73 _menhir_env (Obj.magic _menhir_stack) MenhirState93 _v
        | IF ->
            _menhir_run67 _menhir_env (Obj.magic _menhir_stack) MenhirState93
        | RETURN ->
            _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState93
        | FED | LABEL ->
            _menhir_reduce17 _menhir_env (Obj.magic _menhir_stack) MenhirState93
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState93) : 'freshtv310)) : 'freshtv312)) : 'freshtv314)) : 'freshtv316)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv317 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv318)) : 'freshtv320)

and _menhir_goto_list_basic_block_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_basic_block_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv303) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_basic_block_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv301) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((stmts : 'tv_list_basic_block_) : 'tv_list_basic_block_) = _v in
        ((let _v : 'tv_bbs = 
# 70 "src/parser.mly"
                             (stmts)
# 1029 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv299) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_bbs) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv297 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1040 "src/parser.ml"
        )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | FED ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv293 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1050 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv291 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1057 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let ((((_menhir_stack, _menhir_s), (n : (
# 30 "src/parser.mly"
       (Core.var)
# 1062 "src/parser.ml"
            ))), (func_entry : 'tv_func_entry)), _, (body : 'tv_bbs)) = _menhir_stack in
            let _5 = () in
            let _1 = () in
            let _v : 'tv_func_def = 
# 67 "src/parser.mly"
                                                       ( (n, {func_entry; body}) )
# 1069 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv289) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : 'tv_func_def) = _v in
            ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv287 * _menhir_state * 'tv_func_def) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DEF ->
                _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState106
            | EOF ->
                _menhir_reduce15 _menhir_env (Obj.magic _menhir_stack) MenhirState106
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState106) : 'freshtv288)) : 'freshtv290)) : 'freshtv292)) : 'freshtv294)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv295 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1096 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv296)) : 'freshtv298)) : 'freshtv300)) : 'freshtv302)) : 'freshtv304)
    | MenhirState101 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv307 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_basic_block_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv305 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_basic_block_) : 'tv_list_basic_block_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_basic_block)) = _menhir_stack in
        let _v : 'tv_list_basic_block_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 1113 "src/parser.ml"
         in
        _menhir_goto_list_basic_block_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv306)) : 'freshtv308)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_XOR_branch__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_XOR_branch__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : (('freshtv285)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv281)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv279)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _, (xs : 'tv_loption_separated_nonempty_list_XOR_branch__)) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _1 = () in
        let _v : 'tv_phi = let brs = 
# 232 "<standard.mly>"
    ( xs )
# 1140 "src/parser.ml"
         in
        
# 82 "src/parser.mly"
                                                (brs)
# 1145 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv277) = _menhir_stack in
        let (_v : 'tv_phi) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv275 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1155 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CALL ->
            _menhir_run87 _menhir_env (Obj.magic _menhir_stack) MenhirState57
        | GOTO ->
            _menhir_run85 _menhir_env (Obj.magic _menhir_stack) MenhirState57
        | ID _v ->
            _menhir_run73 _menhir_env (Obj.magic _menhir_stack) MenhirState57 _v
        | IF ->
            _menhir_run67 _menhir_env (Obj.magic _menhir_stack) MenhirState57
        | RETURN ->
            _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState57
        | FED | LABEL ->
            _menhir_reduce17 _menhir_env (Obj.magic _menhir_stack) MenhirState57
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState57) : 'freshtv276)) : 'freshtv278)) : 'freshtv280)) : 'freshtv282)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv283)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv284)) : 'freshtv286)

and _menhir_run41 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 1187 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv271 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1199 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run43 _menhir_env (Obj.magic _menhir_stack) MenhirState42 _v
        | RB | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv269) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState42 in
            ((let _v : 'tv_loption_separated_nonempty_list_COMMA_move__ = 
# 142 "<standard.mly>"
    ( [] )
# 1213 "src/parser.ml"
             in
            _menhir_goto_loption_separated_nonempty_list_COMMA_move__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv270)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState42) : 'freshtv272)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv273 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1227 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv274)

and _menhir_goto_repr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_repr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv223 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv221 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (v : 'tv_repr)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_instr = 
# 99 "src/parser.mly"
                      (Return v)
# 1246 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv222)) : 'freshtv224)
    | MenhirState67 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv243 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | GOTO ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv239 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv235 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
                let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1267 "src/parser.ml"
                )) = _v in
                ((let _menhir_stack = (_menhir_stack, _v) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | GOTO ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv231 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 1278 "src/parser.ml"
                    )) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv227 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 1288 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1293 "src/parser.ml"
                        )) = _v in
                        ((let _menhir_env = _menhir_discard _menhir_env in
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv225 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 1300 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        let ((f : (
# 30 "src/parser.mly"
       (Core.var)
# 1305 "src/parser.ml"
                        )) : (
# 30 "src/parser.mly"
       (Core.var)
# 1309 "src/parser.ml"
                        )) = _v in
                        ((let (((_menhir_stack, _menhir_s), _, (cond : 'tv_repr)), (t : (
# 30 "src/parser.mly"
       (Core.var)
# 1314 "src/parser.ml"
                        ))) = _menhir_stack in
                        let _5 = () in
                        let _3 = () in
                        let _1 = () in
                        let _v : 'tv_instr = 
# 100 "src/parser.mly"
                                         ( GotoIf(cond, t, f) )
# 1322 "src/parser.ml"
                         in
                        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv226)) : 'freshtv228)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv229 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 1332 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        ((let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv230)) : 'freshtv232)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv233 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 1343 "src/parser.ml"
                    )) = Obj.magic _menhir_stack in
                    ((let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv234)) : 'freshtv236)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv237 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv238)) : 'freshtv240)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv241 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv242)) : 'freshtv244)
    | MenhirState75 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv249 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1366 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv245 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1376 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | FALSE ->
                _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | FLOAT _v ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | ID _v ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | INT _v ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | LP ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | STRING _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | TRUE ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | TYPE ->
                _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | RP ->
                _menhir_reduce25 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState77) : 'freshtv246)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv247 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1412 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv248)) : 'freshtv250)
    | MenhirState89 | MenhirState80 | MenhirState77 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv257 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COMMA ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv251 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState80
            | FALSE ->
                _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState80
            | FLOAT _v ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
            | ID _v ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
            | INT _v ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
            | LP ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState80
            | STRING _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
            | TRUE ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState80
            | TYPE ->
                _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState80
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState80) : 'freshtv252)
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv253 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_repr)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_COMMA_repr_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1457 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_COMMA_repr_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv254)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv255 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv256)) : 'freshtv258)
    | MenhirState74 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv261 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1472 "src/parser.ml"
        ))) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv259 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1478 "src/parser.ml"
        ))) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (_1 : (
# 30 "src/parser.mly"
       (Core.var)
# 1483 "src/parser.ml"
        ))), _, (from : 'tv_repr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_instr = 
# 96 "src/parser.mly"
                            ( Assign(_1, from) )
# 1489 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv260)) : 'freshtv262)
    | MenhirState87 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv267 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv263 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState89
            | FALSE ->
                _menhir_run64 _menhir_env (Obj.magic _menhir_stack) MenhirState89
            | FLOAT _v ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
            | ID _v ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
            | INT _v ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
            | LP ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState89
            | STRING _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
            | TRUE ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState89
            | TYPE ->
                _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState89
            | RP ->
                _menhir_reduce25 _menhir_env (Obj.magic _menhir_stack) MenhirState89
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState89) : 'freshtv264)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv265 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv266)) : 'freshtv268)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_COMMA_ann_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_ann_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv215) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ann_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv213) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_ann_) : 'tv_separated_nonempty_list_COMMA_ann_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_ann__ = 
# 144 "<standard.mly>"
    ( x )
# 1553 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_ann__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv214)) : 'freshtv216)
    | MenhirState33 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv219 * _menhir_state * 'tv_ann)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ann_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv217 * _menhir_state * 'tv_ann)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_ann_) : 'tv_separated_nonempty_list_COMMA_ann_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_ann)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_ann_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1570 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ann_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv218)) : 'freshtv220)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_XOR_typ_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_XOR_typ_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState13 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv207 * _menhir_state * 'tv_typ)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv205 * _menhir_state * 'tv_typ)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_XOR_typ_) : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_typ)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_XOR_typ_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1593 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_typ_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv206)) : 'freshtv208)
    | MenhirState8 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv211) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv209) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_XOR_typ_) : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_typ__ = 
# 144 "<standard.mly>"
    ( x )
# 1608 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_typ__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv210)) : 'freshtv212)
    | _ ->
        _menhir_fail ()

and _menhir_reduce13 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_basic_block_ = 
# 211 "<standard.mly>"
    ( [] )
# 1619 "src/parser.ml"
     in
    _menhir_goto_list_basic_block_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run36 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv201 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1635 "src/parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv197 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1646 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | PHI ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv193) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | LB ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv189) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState40 _v
                    | RB ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : 'freshtv187) = Obj.magic _menhir_stack in
                        let (_menhir_s : _menhir_state) = MenhirState40 in
                        ((let _v : 'tv_loption_separated_nonempty_list_XOR_branch__ = 
# 142 "<standard.mly>"
    ( [] )
# 1672 "src/parser.ml"
                         in
                        _menhir_goto_loption_separated_nonempty_list_XOR_branch__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv188)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState40) : 'freshtv190)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv191) = Obj.magic _menhir_stack in
                    (raise _eRR : 'freshtv192)) : 'freshtv194)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv195 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1692 "src/parser.ml"
                ))) = Obj.magic _menhir_stack in
                ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv196)) : 'freshtv198)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv199 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1703 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv200)) : 'freshtv202)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv203 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv204)

and _menhir_goto_separated_nonempty_list_COMMA_ID_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_ID_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv181 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1723 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv179 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1731 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_ID_) : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : (
# 30 "src/parser.mly"
       (Core.var)
# 1738 "src/parser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_ID_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1744 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv180)) : 'freshtv182)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv185) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv183) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_ID_) : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_ID__ = 
# 144 "<standard.mly>"
    ( x )
# 1759 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv184)) : 'freshtv186)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_XOR_typ__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_XOR_typ__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv177 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv173 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv171 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (xs : 'tv_loption_separated_nonempty_list_XOR_typ__)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_typ = let ts = 
# 232 "<standard.mly>"
    ( xs )
# 1785 "src/parser.ml"
         in
        
# 51 "src/parser.mly"
                                         ( UnionT ts )
# 1790 "src/parser.ml"
         in
        _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv172)) : 'freshtv174)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv175 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv176)) : 'freshtv178)

and _menhir_goto_typ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_typ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState13 | MenhirState8 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv143 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv137 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState13
            | LP ->
                _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState13
            | TYPE ->
                _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState13
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState13) : 'freshtv138)
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv139 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_typ)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_XOR_typ_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1834 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_XOR_typ_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv140)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv141 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv142)) : 'freshtv144)
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv151 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RB ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv147 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv145 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, (t : 'tv_typ)) = _menhir_stack in
            let _4 = () in
            let _2 = () in
            let _1 = () in
            let _v : 'tv_typ = 
# 50 "src/parser.mly"
                        ( TypeT t )
# 1863 "src/parser.ml"
             in
            _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv146)) : 'freshtv148)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv149 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv150)) : 'freshtv152)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv165 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1878 "src/parser.ml"
        ))) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv163 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1884 "src/parser.ml"
        ))) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (n : (
# 30 "src/parser.mly"
       (Core.var)
# 1889 "src/parser.ml"
        ))), _, (t : 'tv_typ)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_ann = 
# 54 "src/parser.mly"
                       ((n, t))
# 1895 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv161) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_ann) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv159 * _menhir_state * 'tv_ann) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COMMA ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv153 * _menhir_state * 'tv_ann) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState33 _v
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState33) : 'freshtv154)
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv155 * _menhir_state * 'tv_ann) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_ann)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_COMMA_ann_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1926 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_COMMA_ann_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv156)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv157 * _menhir_state * 'tv_ann) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv158)) : 'freshtv160)) : 'freshtv162)) : 'freshtv164)) : 'freshtv166)
    | MenhirState89 | MenhirState87 | MenhirState74 | MenhirState80 | MenhirState77 | MenhirState75 | MenhirState67 | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv169 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv167 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (t : 'tv_typ)) = _menhir_stack in
        let _v : 'tv_repr = 
# 91 "src/parser.mly"
              ( S (TypeL t) )
# 1945 "src/parser.ml"
         in
        _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv168)) : 'freshtv170)
    | _ ->
        _menhir_fail ()

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_ID__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ((((('freshtv135) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv131) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv129) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _, (xs : 'tv_loption_separated_nonempty_list_COMMA_ann__)), _, (xs_inlined1 : 'tv_loption_separated_nonempty_list_COMMA_ID__)) = _menhir_stack in
        let _7 = () in
        let _5 = () in
        let _4 = () in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_func_entry = let bounds =
          let xs = xs_inlined1 in
          
# 232 "<standard.mly>"
    ( xs )
# 1981 "src/parser.ml"
          
        in
        let args = 
# 232 "<standard.mly>"
    ( xs )
# 1987 "src/parser.ml"
         in
        
# 59 "src/parser.mly"
        ( { args=args
          ; kwargs=[]
          ; other_bounds=List.map (fun x -> x, BottomT) bounds
          ; globals=[]
          }
        )
# 1997 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv127) = _menhir_stack in
        let (_v : 'tv_func_entry) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv125 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2007 "src/parser.ml"
        )) * 'tv_func_entry) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LABEL ->
            _menhir_run36 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | FED ->
            _menhir_reduce13 _menhir_env (Obj.magic _menhir_stack) MenhirState35
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState35) : 'freshtv126)) : 'freshtv128)) : 'freshtv130)) : 'freshtv132)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv133) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv134)) : 'freshtv136)

and _menhir_run26 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 2031 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COMMA ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv119 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2043 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState27) : 'freshtv120)
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv121 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2059 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (x : (
# 30 "src/parser.mly"
       (Core.var)
# 2064 "src/parser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_separated_nonempty_list_COMMA_ID_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 2069 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv122)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv123 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2079 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv124)

and _menhir_run6 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | LB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv115 * _menhir_state) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AT ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState7
        | LP ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState7
        | TYPE ->
            _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState7
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState7) : 'freshtv116)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv117 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv118)

and _menhir_run8 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState8
    | LP ->
        _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState8
    | TYPE ->
        _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState8
    | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv113) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState8 in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_typ__ = 
# 142 "<standard.mly>"
    ( [] )
# 2133 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_typ__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv114)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState8

and _menhir_run9 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv105 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 2153 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv103 * _menhir_state) = Obj.magic _menhir_stack in
        let ((n : (
# 30 "src/parser.mly"
       (Core.var)
# 2161 "src/parser.ml"
        )) : (
# 30 "src/parser.mly"
       (Core.var)
# 2165 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_typ = 
# 49 "src/parser.mly"
               ( NomT (snd n) )
# 2172 "src/parser.ml"
         in
        _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv104)) : 'freshtv106)
    | STRING _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv109 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 29 "src/parser.mly"
       (string)
# 2181 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv107 * _menhir_state) = Obj.magic _menhir_stack in
        let ((n : (
# 29 "src/parser.mly"
       (string)
# 2189 "src/parser.ml"
        )) : (
# 29 "src/parser.mly"
       (string)
# 2193 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_typ = 
# 48 "src/parser.mly"
                  ( NomT n )
# 2200 "src/parser.ml"
         in
        _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv108)) : 'freshtv110)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv111 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv112)

and _menhir_goto_list_func_def_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_func_def_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv97 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv93 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv91 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (xs : 'tv_list_func_def_)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 34 "src/parser.mly"
       (Core.func_def Core.M_int.t)
# 2231 "src/parser.ml"
            ) = 
# 39 "src/parser.mly"
    ( let globals = List.mapi (fun i (n, f) -> (n, FPtrT i)) xs in
      let fdefs = List.mapi
        (fun i (n, f) -> i, {f with func_entry = {f.func_entry with globals = globals}})
        xs
      in
      List.fold_left (fun a (i, f) -> M_int.add i f a) M_int.empty fdefs
    )
# 2241 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv89) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 34 "src/parser.mly"
       (Core.func_def Core.M_int.t)
# 2249 "src/parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv87) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 34 "src/parser.mly"
       (Core.func_def Core.M_int.t)
# 2257 "src/parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv85) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let ((_1 : (
# 34 "src/parser.mly"
       (Core.func_def Core.M_int.t)
# 2265 "src/parser.ml"
            )) : (
# 34 "src/parser.mly"
       (Core.func_def Core.M_int.t)
# 2269 "src/parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv86)) : 'freshtv88)) : 'freshtv90)) : 'freshtv92)) : 'freshtv94)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv95 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv96)) : 'freshtv98)
    | MenhirState106 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv101 * _menhir_state * 'tv_func_def) * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv99 * _menhir_state * 'tv_func_def) * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (x : 'tv_func_def)), _, (xs : 'tv_list_func_def_)) = _menhir_stack in
        let _v : 'tv_list_func_def_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 2288 "src/parser.ml"
         in
        _menhir_goto_list_func_def_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv100)) : 'freshtv102)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_COMMA_ann__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_ann__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv83) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv79) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | BOUND ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv75) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | LB ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv71) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__))) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | ID _v ->
                    _menhir_run26 _menhir_env (Obj.magic _menhir_stack) MenhirState25 _v
                | RB ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv69) = Obj.magic _menhir_stack in
                    let (_menhir_s : _menhir_state) = MenhirState25 in
                    ((let _v : 'tv_loption_separated_nonempty_list_COMMA_ID__ = 
# 142 "<standard.mly>"
    ( [] )
# 2329 "src/parser.ml"
                     in
                    _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv70)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState25) : 'freshtv72)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ((('freshtv73) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__))) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv74)) : 'freshtv76)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv77) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv78)) : 'freshtv80)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv81) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv82)) : 'freshtv84)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 2361 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv65 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2373 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AT ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack) MenhirState5
        | LP ->
            _menhir_run8 _menhir_env (Obj.magic _menhir_stack) MenhirState5
        | TYPE ->
            _menhir_run6 _menhir_env (Obj.magic _menhir_stack) MenhirState5
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState5) : 'freshtv66)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv67 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2395 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv68)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState106 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13 * _menhir_state * 'tv_func_def) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv14)
    | MenhirState101 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)
    | MenhirState93 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv18)
    | MenhirState89 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv19 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv20)
    | MenhirState87 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv21 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv22)
    | MenhirState80 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv23 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv24)
    | MenhirState77 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv25 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2438 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv26)
    | MenhirState75 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv27 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2447 "src/parser.ml"
        ))) * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv28)
    | MenhirState74 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv29 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2456 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)
    | MenhirState67 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv31 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv32)
    | MenhirState58 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv33 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv34)
    | MenhirState57 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv35 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2475 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv36)
    | MenhirState55 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv37 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState48 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv39 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState42 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv41 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2494 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv43)) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv44)
    | MenhirState35 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv45 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2507 "src/parser.ml"
        )) * 'tv_func_entry) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState33 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv47 * _menhir_state * 'tv_ann)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv49 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2521 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState25 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv51) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ann__)))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState13 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv53 * _menhir_state * 'tv_typ)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState8 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv56)
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv57 * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv58)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv59 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2550 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv60)
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv61) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv62)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv63) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv64)

and _menhir_reduce15 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_func_def_ = 
# 211 "<standard.mly>"
    ( [] )
# 2568 "src/parser.ml"
     in
    _menhir_goto_list_func_def_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 2584 "src/parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState3 _v
            | RP ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = MenhirState3 in
                ((let _v : 'tv_loption_separated_nonempty_list_COMMA_ann__ = 
# 142 "<standard.mly>"
    ( [] )
# 2605 "src/parser.ml"
                 in
                _menhir_goto_loption_separated_nonempty_list_COMMA_ann__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv4)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState3) : 'freshtv6)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv7 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2619 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv8)) : 'freshtv10)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv12)

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and prog : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 34 "src/parser.mly"
       (Core.func_def Core.M_int.t)
# 2646 "src/parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env =
      let (lexer : Lexing.lexbuf -> token) = lexer in
      let (lexbuf : Lexing.lexbuf) = lexbuf in
      ((let _tok = Obj.magic () in
      {
        _menhir_lexer = lexer;
        _menhir_lexbuf = lexbuf;
        _menhir_token = _tok;
        _menhir_error = false;
      }) : _menhir_env)
    in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv1) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    ((let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | DEF ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | EOF ->
        _menhir_reduce15 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv2))

# 269 "<standard.mly>"
  

# 2677 "src/parser.ml"
