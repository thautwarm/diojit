
module MenhirBasics = struct
  
  exception Error
  
  type token = 
    | XOR
    | TYPE
    | TRUE
    | STRING of (
# 32 "src/parser.mly"
       (string)
# 14 "src/parser.ml"
  )
    | SEMICOLON
    | RP
    | RETURN
    | RB
    | PHI
    | NEG
    | MOVE
    | LP
    | LB
    | LABEL
    | ISA
    | INT of (
# 30 "src/parser.mly"
       (int)
# 30 "src/parser.ml"
  )
    | IF
    | ID of (
# 33 "src/parser.mly"
       (Core.var)
# 36 "src/parser.ml"
  )
    | GOTO
    | FLOAT of (
# 31 "src/parser.mly"
       (float)
# 42 "src/parser.ml"
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
    | ADD
  
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
  | MenhirState108
  | MenhirState103
  | MenhirState95
  | MenhirState91
  | MenhirState89
  | MenhirState83
  | MenhirState81
  | MenhirState77
  | MenhirState74
  | MenhirState73
  | MenhirState66
  | MenhirState50
  | MenhirState46
  | MenhirState39
  | MenhirState37
  | MenhirState36
  | MenhirState34
  | MenhirState27
  | MenhirState21
  | MenhirState19
  | MenhirState14
  | MenhirState11
  | MenhirState5
  | MenhirState3
  | MenhirState0

# 1 "src/parser.mly"
  
open Core

# 101 "src/parser.ml"

let rec _menhir_goto_separated_nonempty_list_XOR_atom_typ_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_XOR_atom_typ_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState46 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv429) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_atom_typ_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv427) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_XOR_atom_typ_) : 'tv_separated_nonempty_list_XOR_atom_typ_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_atom_typ__ = 
# 144 "<standard.mly>"
    ( x )
# 118 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_atom_typ__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv428)) : 'freshtv430)
    | MenhirState50 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv433 * _menhir_state * 'tv_atom_typ)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_atom_typ_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv431 * _menhir_state * 'tv_atom_typ)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_XOR_atom_typ_) : 'tv_separated_nonempty_list_XOR_atom_typ_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_atom_typ)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_XOR_atom_typ_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 135 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_atom_typ_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv432)) : 'freshtv434)
    | _ ->
        _menhir_fail ()

and _menhir_goto_typ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_typ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv421 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RB ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv417 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv415 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, (t : 'tv_typ)) = _menhir_stack in
            let _4 = () in
            let _2 = () in
            let _1 = () in
            let _v : 'tv_atom_typ = 
# 61 "src/parser.mly"
                            ( TypeT t )
# 164 "src/parser.ml"
             in
            _menhir_goto_atom_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv416)) : 'freshtv418)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv419 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv420)) : 'freshtv422)
    | MenhirState91 | MenhirState89 | MenhirState73 | MenhirState83 | MenhirState81 | MenhirState77 | MenhirState74 | MenhirState66 | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv425 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv423 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (t : 'tv_typ)) = _menhir_stack in
        let _v : 'tv_repr = 
# 102 "src/parser.mly"
              ( S (TypeL t) )
# 183 "src/parser.ml"
         in
        _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv424)) : 'freshtv426)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_XOR_atom_typ__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_XOR_atom_typ__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv413 * _menhir_state * 'tv_atom_typ)) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_loption_separated_nonempty_list_XOR_atom_typ__) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv411 * _menhir_state * 'tv_atom_typ)) = Obj.magic _menhir_stack in
    let (_ : _menhir_state) = _menhir_s in
    let ((xs : 'tv_loption_separated_nonempty_list_XOR_atom_typ__) : 'tv_loption_separated_nonempty_list_XOR_atom_typ__) = _v in
    ((let (_menhir_stack, _menhir_s, (_1 : 'tv_atom_typ)) = _menhir_stack in
    let _2 = () in
    let _v : 'tv_typ = let _3 = 
# 232 "<standard.mly>"
    ( xs )
# 204 "src/parser.ml"
     in
    
# 65 "src/parser.mly"
                                                 ( UnionT (_1 :: _3) )
# 209 "src/parser.ml"
     in
    _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv412)) : 'freshtv414)

and _menhir_goto_separated_nonempty_list_COMMA_repr_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_repr_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState91 | MenhirState83 | MenhirState74 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv405) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv403) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_repr_) : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_repr__ = 
# 144 "<standard.mly>"
    ( x )
# 228 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv404)) : 'freshtv406)
    | MenhirState77 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv409 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv407 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_repr_) : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_repr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_repr_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 245 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_repr_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv408)) : 'freshtv410)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_repr__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState74 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv385 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 260 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv381 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 270 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv379 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 277 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (((_menhir_stack, _menhir_s, (_1 : (
# 33 "src/parser.mly"
       (Core.var)
# 282 "src/parser.ml"
            ))), _), _, (xs : 'tv_loption_separated_nonempty_list_COMMA_repr__)) = _menhir_stack in
            let _5 = () in
            let _3 = () in
            let _2 = () in
            let _v : 'tv_instr = let elts = 
# 232 "<standard.mly>"
    ( xs )
# 290 "src/parser.ml"
             in
            
# 114 "src/parser.mly"
        ( Call(Some _1, S (IntrinsicL BuildTuple), elts, []) )
# 295 "src/parser.ml"
             in
            _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv380)) : 'freshtv382)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv383 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 305 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv384)) : 'freshtv386)
    | MenhirState83 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv393 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 314 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv389 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 324 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv387 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 331 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let ((((_menhir_stack, _menhir_s, (_1 : (
# 33 "src/parser.mly"
       (Core.var)
# 336 "src/parser.ml"
            ))), _), _, (func : 'tv_repr)), _, (xs : 'tv_loption_separated_nonempty_list_COMMA_repr__)) = _menhir_stack in
            let _7 = () in
            let _5 = () in
            let _3 = () in
            let _2 = () in
            let _v : 'tv_instr = let args = 
# 232 "<standard.mly>"
    ( xs )
# 345 "src/parser.ml"
             in
            
# 116 "src/parser.mly"
        ( Call(Some _1, func, args, []) )
# 350 "src/parser.ml"
             in
            _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv388)) : 'freshtv390)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv391 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 360 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv392)) : 'freshtv394)
    | MenhirState91 ->
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
# 383 "src/parser.ml"
             in
            
# 111 "src/parser.mly"
        ( Call(None, func, args, []))
# 388 "src/parser.ml"
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

and _menhir_goto_atom_typ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_atom_typ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState89 | MenhirState91 | MenhirState73 | MenhirState81 | MenhirState83 | MenhirState74 | MenhirState77 | MenhirState66 | MenhirState37 | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv369 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv363 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState46
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState46
            | COMMA | GOTO | LP | RB | RP | SEMICOLON ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv361) = Obj.magic _menhir_stack in
                let (_menhir_s : _menhir_state) = MenhirState46 in
                ((let _v : 'tv_loption_separated_nonempty_list_XOR_atom_typ__ = 
# 142 "<standard.mly>"
    ( [] )
# 428 "src/parser.ml"
                 in
                _menhir_goto_loption_separated_nonempty_list_XOR_atom_typ__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv362)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState46) : 'freshtv364)
        | COMMA | GOTO | LP | RB | RP | SEMICOLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv365 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (_1 : 'tv_atom_typ)) = _menhir_stack in
            let _v : 'tv_typ = 
# 64 "src/parser.mly"
                ( _1 )
# 442 "src/parser.ml"
             in
            _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv366)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv367 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv368)) : 'freshtv370)
    | MenhirState50 | MenhirState46 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv377 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv371 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState50
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState50
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState50) : 'freshtv372)
        | COMMA | GOTO | LP | RB | RP | SEMICOLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv373 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_atom_typ)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_XOR_atom_typ_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 479 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_XOR_atom_typ_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv374)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv375 * _menhir_state * 'tv_atom_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv376)) : 'freshtv378)
    | _ ->
        _menhir_fail ()

and _menhir_goto_repr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_repr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv315 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv313 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (v : 'tv_repr)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_instr = 
# 117 "src/parser.mly"
                      (Return v)
# 506 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv314)) : 'freshtv316)
    | MenhirState66 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv335 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | GOTO ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv331 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv327 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
                let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 527 "src/parser.ml"
                )) = _v in
                ((let _menhir_stack = (_menhir_stack, _v) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | GOTO ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv323 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 33 "src/parser.mly"
       (Core.var)
# 538 "src/parser.ml"
                    )) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv319 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 33 "src/parser.mly"
       (Core.var)
# 548 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 553 "src/parser.ml"
                        )) = _v in
                        ((let _menhir_env = _menhir_discard _menhir_env in
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv317 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 33 "src/parser.mly"
       (Core.var)
# 560 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        let ((f : (
# 33 "src/parser.mly"
       (Core.var)
# 565 "src/parser.ml"
                        )) : (
# 33 "src/parser.mly"
       (Core.var)
# 569 "src/parser.ml"
                        )) = _v in
                        ((let (((_menhir_stack, _menhir_s), _, (cond : 'tv_repr)), (t : (
# 33 "src/parser.mly"
       (Core.var)
# 574 "src/parser.ml"
                        ))) = _menhir_stack in
                        let _5 = () in
                        let _3 = () in
                        let _1 = () in
                        let _v : 'tv_instr = 
# 118 "src/parser.mly"
                                         ( GotoIf(cond, t, f) )
# 582 "src/parser.ml"
                         in
                        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv318)) : 'freshtv320)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv321 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 33 "src/parser.mly"
       (Core.var)
# 592 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        ((let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv322)) : 'freshtv324)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv325 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 33 "src/parser.mly"
       (Core.var)
# 603 "src/parser.ml"
                    )) = Obj.magic _menhir_stack in
                    ((let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv326)) : 'freshtv328)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv329 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv330)) : 'freshtv332)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv333 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv334)) : 'freshtv336)
    | MenhirState91 | MenhirState83 | MenhirState77 | MenhirState74 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv343 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COMMA ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv337 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ADD ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | ASSIGN ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | FALSE ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | FLOAT _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | ID _v ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | INT _v ->
                _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | ISA ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | NEG ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState77 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState77
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState77) : 'freshtv338)
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv339 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_repr)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_COMMA_repr_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 668 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_COMMA_repr_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv340)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv341 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv342)) : 'freshtv344)
    | MenhirState81 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv349 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 683 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv345 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 693 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ADD ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | ASSIGN ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | FALSE ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | FLOAT _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState83 _v
            | ID _v ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState83 _v
            | INT _v ->
                _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState83 _v
            | ISA ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | NEG ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState83 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | RP ->
                _menhir_reduce26 _menhir_env (Obj.magic _menhir_stack) MenhirState83
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState83) : 'freshtv346)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv347 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 735 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv348)) : 'freshtv350)
    | MenhirState73 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv353 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 744 "src/parser.ml"
        ))) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv351 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 750 "src/parser.ml"
        ))) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (_1 : (
# 33 "src/parser.mly"
       (Core.var)
# 755 "src/parser.ml"
        ))), _, (_3 : 'tv_repr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_instr = 
# 112 "src/parser.mly"
                       ( Assign(_1, _3) )
# 761 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv352)) : 'freshtv354)
    | MenhirState89 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv359 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv355 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ADD ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | ASSIGN ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | FALSE ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | FLOAT _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState91 _v
            | ID _v ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState91 _v
            | INT _v ->
                _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState91 _v
            | ISA ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | NEG ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState91 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | RP ->
                _menhir_reduce26 _menhir_env (Obj.magic _menhir_stack) MenhirState91
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState91) : 'freshtv356)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv357 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv358)) : 'freshtv360)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_stmt_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_stmt_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState95 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv297 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_stmt_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv295 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_stmt_) : 'tv_list_stmt_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_stmt)) = _menhir_stack in
        let _v : 'tv_list_stmt_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 832 "src/parser.ml"
         in
        _menhir_goto_list_stmt_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv296)) : 'freshtv298)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv311) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_stmt_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv309) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_stmt_) : 'tv_list_stmt_) = _v in
        ((let _v : 'tv_suite = 
# 125 "src/parser.mly"
                        ( xs )
# 847 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv307) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suite) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv305 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 857 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suite) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv303 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 865 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((suite : 'tv_suite) : 'tv_suite) = _v in
        ((let (((_menhir_stack, _menhir_s), (lbl : (
# 33 "src/parser.mly"
       (Core.var)
# 872 "src/parser.ml"
        ))), (phi : 'tv_phi)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_basic_block = 
# 84 "src/parser.mly"
                                                    ( (lbl, {suite; phi}) )
# 879 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv301) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_basic_block) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv299 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LABEL ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState103
        | FED ->
            _menhir_reduce16 _menhir_env (Obj.magic _menhir_stack) MenhirState103
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState103) : 'freshtv300)) : 'freshtv302)) : 'freshtv304)) : 'freshtv306)) : 'freshtv308)) : 'freshtv310)) : 'freshtv312)
    | _ ->
        _menhir_fail ()

and _menhir_reduce26 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_loption_separated_nonempty_list_COMMA_repr__ = 
# 142 "<standard.mly>"
    ( [] )
# 907 "src/parser.ml"
     in
    _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_instr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_instr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv293 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | SEMICOLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv289 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv287 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (_1 : 'tv_instr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_stmt = 
# 122 "src/parser.mly"
                       ( _1 )
# 930 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv285) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_stmt) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv283 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CALL ->
            _menhir_run89 _menhir_env (Obj.magic _menhir_stack) MenhirState95
        | GOTO ->
            _menhir_run87 _menhir_env (Obj.magic _menhir_stack) MenhirState95
        | ID _v ->
            _menhir_run72 _menhir_env (Obj.magic _menhir_stack) MenhirState95 _v
        | IF ->
            _menhir_run66 _menhir_env (Obj.magic _menhir_stack) MenhirState95
        | RETURN ->
            _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState95
        | FED | LABEL ->
            _menhir_reduce20 _menhir_env (Obj.magic _menhir_stack) MenhirState95
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState95) : 'freshtv284)) : 'freshtv286)) : 'freshtv288)) : 'freshtv290)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv291 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv292)) : 'freshtv294)

and _menhir_run38 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | LB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv279 * _menhir_state) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AT ->
            _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | TYPE ->
            _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39) : 'freshtv280)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv281 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv282)

and _menhir_run52 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv277) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 100 "src/parser.mly"
            ( S (BoolL true) )
# 1004 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv278)

and _menhir_run53 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 32 "src/parser.mly"
       (string)
# 1011 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv275) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((s : (
# 32 "src/parser.mly"
       (string)
# 1021 "src/parser.ml"
    )) : (
# 32 "src/parser.mly"
       (string)
# 1025 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 99 "src/parser.mly"
                ( S (StrL s) )
# 1030 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv276)

and _menhir_run54 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FLOAT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv267 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 31 "src/parser.mly"
       (float)
# 1046 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv265 * _menhir_state) = Obj.magic _menhir_stack in
        let ((f : (
# 31 "src/parser.mly"
       (float)
# 1054 "src/parser.ml"
        )) : (
# 31 "src/parser.mly"
       (float)
# 1058 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_repr = 
# 104 "src/parser.mly"
                   ( S (FloatL (-. f)) )
# 1065 "src/parser.ml"
         in
        _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv266)) : 'freshtv268)
    | INT _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv271 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (int)
# 1074 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv269 * _menhir_state) = Obj.magic _menhir_stack in
        let ((i : (
# 30 "src/parser.mly"
       (int)
# 1082 "src/parser.ml"
        )) : (
# 30 "src/parser.mly"
       (int)
# 1086 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_repr = 
# 103 "src/parser.mly"
                 ( S (IntL (-i)) )
# 1093 "src/parser.ml"
         in
        _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv270)) : 'freshtv272)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv273 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv274)

and _menhir_run57 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv263) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 105 "src/parser.mly"
           ( S (IntrinsicL IsInstanceOf) )
# 1114 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv264)

and _menhir_run58 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (int)
# 1121 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv261) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((i : (
# 30 "src/parser.mly"
       (int)
# 1131 "src/parser.ml"
    )) : (
# 30 "src/parser.mly"
       (int)
# 1135 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 97 "src/parser.mly"
             ( S (IntL i) )
# 1140 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv262)

and _menhir_run59 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 33 "src/parser.mly"
       (Core.var)
# 1147 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv259) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((n : (
# 33 "src/parser.mly"
       (Core.var)
# 1157 "src/parser.ml"
    )) : (
# 33 "src/parser.mly"
       (Core.var)
# 1161 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 96 "src/parser.mly"
            ( D n )
# 1166 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv260)

and _menhir_run60 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 31 "src/parser.mly"
       (float)
# 1173 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv257) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((f : (
# 31 "src/parser.mly"
       (float)
# 1183 "src/parser.ml"
    )) : (
# 31 "src/parser.mly"
       (float)
# 1187 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 98 "src/parser.mly"
               ( S (FloatL f) )
# 1192 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv258)

and _menhir_run61 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv255) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 101 "src/parser.mly"
             ( S (BoolL false) )
# 1206 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv256)

and _menhir_run40 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv247 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 1222 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv245 * _menhir_state) = Obj.magic _menhir_stack in
        let ((n : (
# 33 "src/parser.mly"
       (Core.var)
# 1230 "src/parser.ml"
        )) : (
# 33 "src/parser.mly"
       (Core.var)
# 1234 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_atom_typ = 
# 60 "src/parser.mly"
                   ( NomT (snd n) )
# 1241 "src/parser.ml"
         in
        _menhir_goto_atom_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv246)) : 'freshtv248)
    | STRING _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv251 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 32 "src/parser.mly"
       (string)
# 1250 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv249 * _menhir_state) = Obj.magic _menhir_stack in
        let ((n : (
# 32 "src/parser.mly"
       (string)
# 1258 "src/parser.ml"
        )) : (
# 32 "src/parser.mly"
       (string)
# 1262 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_atom_typ = 
# 59 "src/parser.mly"
                       ( NomT n )
# 1269 "src/parser.ml"
         in
        _menhir_goto_atom_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv250)) : 'freshtv252)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv253 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv254)

and _menhir_run62 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv243) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 107 "src/parser.mly"
              ( S (IntrinsicL PolyEq) )
# 1290 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv244)

and _menhir_run63 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv241) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 106 "src/parser.mly"
           ( S (IntrinsicL PolyAdd) )
# 1304 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv242)

and _menhir_goto_separated_nonempty_list_XOR_branch_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_XOR_branch_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState19 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv235) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv233) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_XOR_branch_) : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_branch__ = 
# 144 "<standard.mly>"
    ( x )
# 1323 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_branch__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv234)) : 'freshtv236)
    | MenhirState34 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv239 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv237 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_XOR_branch_) : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_branch)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_XOR_branch_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1340 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_branch_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv238)) : 'freshtv240)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_COMMA_move_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_move_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv227) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv225) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_move_) : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_move__ = 
# 144 "<standard.mly>"
    ( x )
# 1361 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_move__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv226)) : 'freshtv228)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv231 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv229 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_move_) : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_move)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_move_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1378 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_move_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv230)) : 'freshtv232)
    | _ ->
        _menhir_fail ()

and _menhir_reduce20 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_stmt_ = 
# 211 "<standard.mly>"
    ( [] )
# 1389 "src/parser.ml"
     in
    _menhir_goto_list_stmt_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run37 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ADD ->
        _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | ASSIGN ->
        _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | AT ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | FALSE ->
        _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | FLOAT _v ->
        _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | ID _v ->
        _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | INT _v ->
        _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | ISA ->
        _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | NEG ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | STRING _v ->
        _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | TRUE ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | TYPE ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState37

and _menhir_run66 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ADD ->
        _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | ASSIGN ->
        _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | AT ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | FALSE ->
        _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | FLOAT _v ->
        _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
    | ID _v ->
        _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
    | INT _v ->
        _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
    | ISA ->
        _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | NEG ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | STRING _v ->
        _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState66 _v
    | TRUE ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | TYPE ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState66
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState66

and _menhir_run72 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 33 "src/parser.mly"
       (Core.var)
# 1466 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ASSIGN ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv221 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1478 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ADD ->
            _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | ASSIGN ->
            _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | AT ->
            _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | CALL ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv217 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1494 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState73 in
            ((let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ADD ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | ASSIGN ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | FALSE ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | FLOAT _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState81 _v
            | ID _v ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState81 _v
            | INT _v ->
                _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState81 _v
            | ISA ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | NEG ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState81 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState81
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState81) : 'freshtv218)
        | FALSE ->
            _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | FLOAT _v ->
            _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
        | ID _v ->
            _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
        | INT _v ->
            _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
        | ISA ->
            _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv219 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1544 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState73 in
            ((let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ADD ->
                _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | ASSIGN ->
                _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | AT ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | FALSE ->
                _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | FLOAT _v ->
                _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
            | ID _v ->
                _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
            | INT _v ->
                _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
            | ISA ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | NEG ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState74 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | RP ->
                _menhir_reduce26 _menhir_env (Obj.magic _menhir_stack) MenhirState74
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState74) : 'freshtv220)
        | NEG ->
            _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | STRING _v ->
            _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
        | TRUE ->
            _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | TYPE ->
            _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState73
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState73) : 'freshtv222)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv223 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1600 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv224)

and _menhir_run87 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv213 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 1617 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv211 * _menhir_state) = Obj.magic _menhir_stack in
        let ((l : (
# 33 "src/parser.mly"
       (Core.var)
# 1625 "src/parser.ml"
        )) : (
# 33 "src/parser.mly"
       (Core.var)
# 1629 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_instr = 
# 119 "src/parser.mly"
                  ( Goto l )
# 1636 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv212)) : 'freshtv214)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv215 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv216)

and _menhir_run89 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ADD ->
        _menhir_run63 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | ASSIGN ->
        _menhir_run62 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | AT ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | FALSE ->
        _menhir_run61 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | FLOAT _v ->
        _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
    | ID _v ->
        _menhir_run59 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
    | INT _v ->
        _menhir_run58 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
    | ISA ->
        _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | NEG ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | STRING _v ->
        _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState89 _v
    | TRUE ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | TYPE ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState89
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState89

and _menhir_goto_loption_separated_nonempty_list_COMMA_move__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_move__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv209 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1688 "src/parser.ml"
    ))) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_loption_separated_nonempty_list_COMMA_move__) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv207 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1696 "src/parser.ml"
    ))) = Obj.magic _menhir_stack in
    let (_ : _menhir_state) = _menhir_s in
    let ((xs : 'tv_loption_separated_nonempty_list_COMMA_move__) : 'tv_loption_separated_nonempty_list_COMMA_move__) = _v in
    ((let (_menhir_stack, _menhir_s, (lbl : (
# 33 "src/parser.mly"
       (Core.var)
# 1703 "src/parser.ml"
    ))) = _menhir_stack in
    let _2 = () in
    let _v : 'tv_branch = let moves = 
# 232 "<standard.mly>"
    ( xs )
# 1709 "src/parser.ml"
     in
    
# 90 "src/parser.mly"
                                                        ((lbl, moves))
# 1714 "src/parser.ml"
     in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv205) = _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_branch) = _v in
    ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv203 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | XOR ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv197 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState34 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState34) : 'freshtv198)
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv199 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_branch)) = _menhir_stack in
        let _v : 'tv_separated_nonempty_list_XOR_branch_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1745 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_branch_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv200)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv201 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv202)) : 'freshtv204)) : 'freshtv206)) : 'freshtv208)) : 'freshtv210)

and _menhir_run22 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 33 "src/parser.mly"
       (Core.var)
# 1759 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | MOVE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv193 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1771 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv189 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1781 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 1786 "src/parser.ml"
            )) = _v in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv187 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1793 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let ((from : (
# 33 "src/parser.mly"
       (Core.var)
# 1798 "src/parser.ml"
            )) : (
# 33 "src/parser.mly"
       (Core.var)
# 1802 "src/parser.ml"
            )) = _v in
            ((let (_menhir_stack, _menhir_s, (target : (
# 33 "src/parser.mly"
       (Core.var)
# 1807 "src/parser.ml"
            ))) = _menhir_stack in
            let _2 = () in
            let _v : 'tv_move = 
# 87 "src/parser.mly"
                               ( (target, from) )
# 1813 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv185) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : 'tv_move) = _v in
            ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv183 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | COMMA ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv177 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | ID _v ->
                    _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState27) : 'freshtv178)
            | RB | XOR ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv179 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, (x : 'tv_move)) = _menhir_stack in
                let _v : 'tv_separated_nonempty_list_COMMA_move_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1844 "src/parser.ml"
                 in
                _menhir_goto_separated_nonempty_list_COMMA_move_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv180)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv181 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv182)) : 'freshtv184)) : 'freshtv186)) : 'freshtv188)) : 'freshtv190)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv191 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1861 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv192)) : 'freshtv194)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv195 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 1872 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv196)

and _menhir_goto_list_basic_block_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_basic_block_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState14 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv171) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_basic_block_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv169) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((stmts : 'tv_list_basic_block_) : 'tv_list_basic_block_) = _v in
        ((let _v : 'tv_bbs = 
# 81 "src/parser.mly"
                             (stmts)
# 1892 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv167) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_bbs) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv165 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 1903 "src/parser.ml"
        )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | FED ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv161 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 1913 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv159 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 1920 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let ((((_menhir_stack, _menhir_s), (n : (
# 33 "src/parser.mly"
       (Core.var)
# 1925 "src/parser.ml"
            ))), (entry : 'tv_func_entry)), _, (body : 'tv_bbs)) = _menhir_stack in
            let _5 = () in
            let _1 = () in
            let _v : 'tv_func_def = 
# 78 "src/parser.mly"
                                                  ( (n, {entry; body}) )
# 1932 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv157) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : 'tv_func_def) = _v in
            ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv155 * _menhir_state * 'tv_func_def) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DEF ->
                _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState108
            | EOF ->
                _menhir_reduce18 _menhir_env (Obj.magic _menhir_stack) MenhirState108
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState108) : 'freshtv156)) : 'freshtv158)) : 'freshtv160)) : 'freshtv162)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv163 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 1959 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv164)) : 'freshtv166)) : 'freshtv168)) : 'freshtv170)) : 'freshtv172)
    | MenhirState103 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv175 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_basic_block_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv173 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_basic_block_) : 'tv_list_basic_block_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_basic_block)) = _menhir_stack in
        let _v : 'tv_list_basic_block_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 1976 "src/parser.ml"
         in
        _menhir_goto_list_basic_block_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv174)) : 'freshtv176)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_XOR_branch__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_XOR_branch__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : (('freshtv153)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv149)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv147)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _, (xs : 'tv_loption_separated_nonempty_list_XOR_branch__)) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _1 = () in
        let _v : 'tv_phi = let brs = 
# 232 "<standard.mly>"
    ( xs )
# 2003 "src/parser.ml"
         in
        
# 93 "src/parser.mly"
                                                (brs)
# 2008 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv145) = _menhir_stack in
        let (_v : 'tv_phi) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv143 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2018 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CALL ->
            _menhir_run89 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | GOTO ->
            _menhir_run87 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | ID _v ->
            _menhir_run72 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | IF ->
            _menhir_run66 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | RETURN ->
            _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | FED | LABEL ->
            _menhir_reduce20 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState36) : 'freshtv144)) : 'freshtv146)) : 'freshtv148)) : 'freshtv150)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv151)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv152)) : 'freshtv154)

and _menhir_run20 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 33 "src/parser.mly"
       (Core.var)
# 2050 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv139 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2062 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
        | RB | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv137) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState21 in
            ((let _v : 'tv_loption_separated_nonempty_list_COMMA_move__ = 
# 142 "<standard.mly>"
    ( [] )
# 2076 "src/parser.ml"
             in
            _menhir_goto_loption_separated_nonempty_list_COMMA_move__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv138)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState21) : 'freshtv140)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv141 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2090 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv142)

and _menhir_reduce16 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_basic_block_ = 
# 211 "<standard.mly>"
    ( [] )
# 2100 "src/parser.ml"
     in
    _menhir_goto_list_basic_block_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run15 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv133 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 2116 "src/parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv129 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2127 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | PHI ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv125) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | LB ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv121) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState19 _v
                    | RB ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : 'freshtv119) = Obj.magic _menhir_stack in
                        let (_menhir_s : _menhir_state) = MenhirState19 in
                        ((let _v : 'tv_loption_separated_nonempty_list_XOR_branch__ = 
# 142 "<standard.mly>"
    ( [] )
# 2153 "src/parser.ml"
                         in
                        _menhir_goto_loption_separated_nonempty_list_XOR_branch__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv120)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState19) : 'freshtv122)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv123) = Obj.magic _menhir_stack in
                    (raise _eRR : 'freshtv124)) : 'freshtv126)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv127 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2173 "src/parser.ml"
                ))) = Obj.magic _menhir_stack in
                ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv128)) : 'freshtv130)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv131 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2184 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv132)) : 'freshtv134)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv135 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv136)

and _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_ID__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv105) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv101) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | BOUND ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv97) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | LB ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv93) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__))) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
                    | RB ->
                        _menhir_reduce22 _menhir_env (Obj.magic _menhir_stack) MenhirState11
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState11) : 'freshtv94)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv95) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__))) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv96)) : 'freshtv98)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv99) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv100)) : 'freshtv102)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv103) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv104)) : 'freshtv106)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv117) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RB ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv113) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv111) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _, (xs : 'tv_loption_separated_nonempty_list_COMMA_ID__)), _, (xs_inlined1 : 'tv_loption_separated_nonempty_list_COMMA_ID__)) = _menhir_stack in
            let _7 = () in
            let _5 = () in
            let _4 = () in
            let _3 = () in
            let _1 = () in
            let _v : 'tv_func_entry = let fn_bounds =
              let xs = xs_inlined1 in
              
# 232 "<standard.mly>"
    ( xs )
# 2281 "src/parser.ml"
              
            in
            let args = 
# 232 "<standard.mly>"
    ( xs )
# 2287 "src/parser.ml"
             in
            
# 70 "src/parser.mly"
        ( { args=args
          ; kwargs=[]
          ; fn_bounds=fn_bounds
          ; globals=[]
          }
        )
# 2297 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv109) = _menhir_stack in
            let (_v : 'tv_func_entry) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv107 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2307 "src/parser.ml"
            )) * 'tv_func_entry) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | LABEL ->
                _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState14
            | FED ->
                _menhir_reduce16 _menhir_env (Obj.magic _menhir_stack) MenhirState14
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState14) : 'freshtv108)) : 'freshtv110)) : 'freshtv112)) : 'freshtv114)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv115) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv116)) : 'freshtv118)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_COMMA_ID_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_ID_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv87 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2338 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv85 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2346 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_ID_) : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : (
# 33 "src/parser.mly"
       (Core.var)
# 2353 "src/parser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_ID_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 2359 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv86)) : 'freshtv88)
    | MenhirState11 | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv91) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv89) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_ID_) : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_ID__ = 
# 144 "<standard.mly>"
    ( x )
# 2374 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv90)) : 'freshtv92)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_func_def_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_func_def_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv79 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv75 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv73 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (xs : 'tv_list_func_def_)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 37 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2400 "src/parser.ml"
            ) = 
# 42 "src/parser.mly"
    ( 
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
    )
# 2418 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv71) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 37 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2426 "src/parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv69) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 37 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2434 "src/parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv67) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let ((_1 : (
# 37 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2442 "src/parser.ml"
            )) : (
# 37 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2446 "src/parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv68)) : 'freshtv70)) : 'freshtv72)) : 'freshtv74)) : 'freshtv76)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv77 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv78)) : 'freshtv80)
    | MenhirState108 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv83 * _menhir_state * 'tv_func_def) * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv81 * _menhir_state * 'tv_func_def) * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (x : 'tv_func_def)), _, (xs : 'tv_list_func_def_)) = _menhir_stack in
        let _v : 'tv_list_func_def_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 2465 "src/parser.ml"
         in
        _menhir_goto_list_func_def_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv82)) : 'freshtv84)
    | _ ->
        _menhir_fail ()

and _menhir_reduce22 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_loption_separated_nonempty_list_COMMA_ID__ = 
# 142 "<standard.mly>"
    ( [] )
# 2476 "src/parser.ml"
     in
    _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 33 "src/parser.mly"
       (Core.var)
# 2483 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COMMA ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv61 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2495 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState5 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState5) : 'freshtv62)
    | RB | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv63 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2511 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (x : (
# 33 "src/parser.mly"
       (Core.var)
# 2516 "src/parser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_separated_nonempty_list_COMMA_ID_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 2521 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv64)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv65 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2531 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv66)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState108 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11 * _menhir_state * 'tv_func_def) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv12)
    | MenhirState103 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv14)
    | MenhirState95 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)
    | MenhirState91 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv17 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv18)
    | MenhirState89 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv19 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv20)
    | MenhirState83 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv21 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2569 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv22)
    | MenhirState81 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv23 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2578 "src/parser.ml"
        ))) * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv24)
    | MenhirState77 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv25 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv26)
    | MenhirState74 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv27 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2592 "src/parser.ml"
        ))) * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv28)
    | MenhirState73 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv29 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2601 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)
    | MenhirState66 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv31 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv32)
    | MenhirState50 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv33 * _menhir_state * 'tv_atom_typ)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv34)
    | MenhirState46 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv35 * _menhir_state * 'tv_atom_typ)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv36)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv37 * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv39 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv41 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2635 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState34 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv43 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv45 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv47 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2654 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv48)
    | MenhirState19 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv49)) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv50)
    | MenhirState14 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv51 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2667 "src/parser.ml"
        )) * 'tv_func_entry) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv53) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv55 * _menhir_state * (
# 33 "src/parser.mly"
       (Core.var)
# 2681 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv56)
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv58)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv59) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv60)

and _menhir_reduce18 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_func_def_ = 
# 211 "<standard.mly>"
    ( [] )
# 2699 "src/parser.ml"
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
        let (_menhir_stack : 'freshtv7 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 33 "src/parser.mly"
       (Core.var)
# 2715 "src/parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState3 _v
            | RP ->
                _menhir_reduce22 _menhir_env (Obj.magic _menhir_stack) MenhirState3
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState3) : 'freshtv4)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv5 * _menhir_state) * (
# 33 "src/parser.mly"
       (Core.var)
# 2742 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv6)) : 'freshtv8)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv10)

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
# 37 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2769 "src/parser.ml"
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
        _menhir_reduce18 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv2))

# 269 "<standard.mly>"
  

# 2800 "src/parser.ml"
