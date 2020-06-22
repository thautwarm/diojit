
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
  | MenhirState99
  | MenhirState94
  | MenhirState86
  | MenhirState82
  | MenhirState80
  | MenhirState73
  | MenhirState70
  | MenhirState68
  | MenhirState67
  | MenhirState60
  | MenhirState45
  | MenhirState40
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

# 97 "src/parser.ml"

let rec _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_repr__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState70 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv393 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 108 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv389 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 118 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv387 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 125 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let ((((_menhir_stack, _menhir_s, (_1 : (
# 30 "src/parser.mly"
       (Core.var)
# 130 "src/parser.ml"
            ))), _), _, (func : 'tv_repr)), _, (xs : 'tv_loption_separated_nonempty_list_COMMA_repr__)) = _menhir_stack in
            let _7 = () in
            let _5 = () in
            let _3 = () in
            let _2 = () in
            let _v : 'tv_instr = let args = 
# 232 "<standard.mly>"
    ( xs )
# 139 "src/parser.ml"
             in
            
# 104 "src/parser.mly"
        ( Call(Some _1, func, args, []) )
# 144 "src/parser.ml"
             in
            _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv388)) : 'freshtv390)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv391 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 154 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr)) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_repr__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv392)) : 'freshtv394)
    | MenhirState82 ->
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
# 177 "src/parser.ml"
             in
            
# 101 "src/parser.mly"
        ( Call(None, func, args, []))
# 182 "src/parser.ml"
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

and _menhir_goto_separated_nonempty_list_COMMA_repr_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_repr_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState82 | MenhirState70 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv381) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv379) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_repr_) : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_repr__ = 
# 144 "<standard.mly>"
    ( x )
# 210 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv380)) : 'freshtv382)
    | MenhirState73 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv385 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv383 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_repr_) : 'tv_separated_nonempty_list_COMMA_repr_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_repr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_repr_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 227 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_repr_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv384)) : 'freshtv386)
    | _ ->
        _menhir_fail ()

and _menhir_reduce22 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_loption_separated_nonempty_list_COMMA_repr__ = 
# 142 "<standard.mly>"
    ( [] )
# 238 "src/parser.ml"
     in
    _menhir_goto_loption_separated_nonempty_list_COMMA_repr__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_separated_nonempty_list_XOR_typ_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_XOR_typ_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv373 * _menhir_state * 'tv_typ)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv371 * _menhir_state * 'tv_typ)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_XOR_typ_) : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_typ)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_XOR_typ_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 259 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_typ_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv372)) : 'freshtv374)
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv377) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv375) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_XOR_typ_) : 'tv_separated_nonempty_list_XOR_typ_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_typ__ = 
# 144 "<standard.mly>"
    ( x )
# 274 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_typ__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv376)) : 'freshtv378)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_XOR_typ__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_XOR_typ__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv369 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv365 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv363 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (xs : 'tv_loption_separated_nonempty_list_XOR_typ__)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_typ = let ts = 
# 232 "<standard.mly>"
    ( xs )
# 300 "src/parser.ml"
         in
        
# 59 "src/parser.mly"
                                         ( UnionT ts )
# 305 "src/parser.ml"
         in
        _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv364)) : 'freshtv366)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv367 * _menhir_state) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_typ__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv368)) : 'freshtv370)

and _menhir_goto_repr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_repr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv317 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv315 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (v : 'tv_repr)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_instr = 
# 105 "src/parser.mly"
                      (Return v)
# 330 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv316)) : 'freshtv318)
    | MenhirState60 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv337 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | GOTO ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv333 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv329 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
                let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 351 "src/parser.ml"
                )) = _v in
                ((let _menhir_stack = (_menhir_stack, _v) in
                let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | GOTO ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv325 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 362 "src/parser.ml"
                    )) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv321 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 372 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 377 "src/parser.ml"
                        )) = _v in
                        ((let _menhir_env = _menhir_discard _menhir_env in
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv319 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 384 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        let ((f : (
# 30 "src/parser.mly"
       (Core.var)
# 389 "src/parser.ml"
                        )) : (
# 30 "src/parser.mly"
       (Core.var)
# 393 "src/parser.ml"
                        )) = _v in
                        ((let (((_menhir_stack, _menhir_s), _, (cond : 'tv_repr)), (t : (
# 30 "src/parser.mly"
       (Core.var)
# 398 "src/parser.ml"
                        ))) = _menhir_stack in
                        let _5 = () in
                        let _3 = () in
                        let _1 = () in
                        let _v : 'tv_instr = 
# 106 "src/parser.mly"
                                         ( GotoIf(cond, t, f) )
# 406 "src/parser.ml"
                         in
                        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv320)) : 'freshtv322)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : (((('freshtv323 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 416 "src/parser.ml"
                        ))) = Obj.magic _menhir_stack in
                        ((let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv324)) : 'freshtv326)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv327 * _menhir_state) * _menhir_state * 'tv_repr)) * (
# 30 "src/parser.mly"
       (Core.var)
# 427 "src/parser.ml"
                    )) = Obj.magic _menhir_stack in
                    ((let ((_menhir_stack, _menhir_s, _), _) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv328)) : 'freshtv330)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv331 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv332)) : 'freshtv334)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv335 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv336)) : 'freshtv338)
    | MenhirState68 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv343 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 450 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv339 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 460 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState70
            | FALSE ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState70
            | FLOAT _v ->
                _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState70 _v
            | ID _v ->
                _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState70 _v
            | INT _v ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState70 _v
            | LP ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState70
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState70 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState70
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState70
            | RP ->
                _menhir_reduce22 _menhir_env (Obj.magic _menhir_stack) MenhirState70
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState70) : 'freshtv340)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv341 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 496 "src/parser.ml"
            ))) * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv342)) : 'freshtv344)
    | MenhirState82 | MenhirState73 | MenhirState70 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv351 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COMMA ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv345 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState73
            | FALSE ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState73
            | FLOAT _v ->
                _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
            | ID _v ->
                _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
            | INT _v ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
            | LP ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState73
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState73 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState73
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState73
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState73) : 'freshtv346)
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv347 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_repr)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_COMMA_repr_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 541 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_COMMA_repr_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv348)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv349 * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv350)) : 'freshtv352)
    | MenhirState67 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv355 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 556 "src/parser.ml"
        ))) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv353 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 562 "src/parser.ml"
        ))) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (_1 : (
# 30 "src/parser.mly"
       (Core.var)
# 567 "src/parser.ml"
        ))), _, (from : 'tv_repr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_instr = 
# 102 "src/parser.mly"
                            ( Assign(_1, from) )
# 573 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv354)) : 'freshtv356)
    | MenhirState80 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv361 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv357 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState82
            | FALSE ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState82
            | FLOAT _v ->
                _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState82 _v
            | ID _v ->
                _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState82 _v
            | INT _v ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState82 _v
            | LP ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState82
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState82 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState82
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState82
            | RP ->
                _menhir_reduce22 _menhir_env (Obj.magic _menhir_stack) MenhirState82
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState82) : 'freshtv358)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv359 * _menhir_state) * _menhir_state * 'tv_repr) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv360)) : 'freshtv362)
    | _ ->
        _menhir_fail ()

and _menhir_goto_typ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_typ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState45 | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv301 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv295 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState45
            | LP ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState45
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState45
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState45) : 'freshtv296)
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv297 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (x : 'tv_typ)) = _menhir_stack in
            let _v : 'tv_separated_nonempty_list_XOR_typ_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 655 "src/parser.ml"
             in
            _menhir_goto_separated_nonempty_list_XOR_typ_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv298)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv299 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv300)) : 'freshtv302)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv309 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RB ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv305 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv303 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, (t : 'tv_typ)) = _menhir_stack in
            let _4 = () in
            let _2 = () in
            let _1 = () in
            let _v : 'tv_typ = 
# 58 "src/parser.mly"
                        ( TypeT t )
# 684 "src/parser.ml"
             in
            _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv304)) : 'freshtv306)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv307 * _menhir_state)) * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv308)) : 'freshtv310)
    | MenhirState82 | MenhirState80 | MenhirState67 | MenhirState73 | MenhirState70 | MenhirState68 | MenhirState60 | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv313 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv311 * _menhir_state * 'tv_typ) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (t : 'tv_typ)) = _menhir_stack in
        let _v : 'tv_repr = 
# 97 "src/parser.mly"
              ( S (TypeL t) )
# 703 "src/parser.ml"
         in
        _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv312)) : 'freshtv314)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_stmt_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_stmt_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState86 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv279 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_stmt_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv277 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_stmt_) : 'tv_list_stmt_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_stmt)) = _menhir_stack in
        let _v : 'tv_list_stmt_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 725 "src/parser.ml"
         in
        _menhir_goto_list_stmt_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv278)) : 'freshtv280)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv293) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_stmt_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv291) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_stmt_) : 'tv_list_stmt_) = _v in
        ((let _v : 'tv_suite = 
# 113 "src/parser.mly"
                        ( xs )
# 740 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv289) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suite) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv287 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 750 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_suite) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv285 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 758 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((suite : 'tv_suite) : 'tv_suite) = _v in
        ((let (((_menhir_stack, _menhir_s), (lbl : (
# 30 "src/parser.mly"
       (Core.var)
# 765 "src/parser.ml"
        ))), (phi : 'tv_phi)) = _menhir_stack in
        let _3 = () in
        let _1 = () in
        let _v : 'tv_basic_block = 
# 79 "src/parser.mly"
                                                    ( (lbl, {suite; phi}) )
# 772 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv283) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_basic_block) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv281 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | LABEL ->
            _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState94
        | FED ->
            _menhir_reduce12 _menhir_env (Obj.magic _menhir_stack) MenhirState94
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState94) : 'freshtv282)) : 'freshtv284)) : 'freshtv286)) : 'freshtv288)) : 'freshtv290)) : 'freshtv292)) : 'freshtv294)
    | _ ->
        _menhir_fail ()

and _menhir_goto_instr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_instr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv275 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | SEMICOLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv271 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv269 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (_1 : 'tv_instr)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_stmt = 
# 110 "src/parser.mly"
                       ( _1 )
# 814 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv267) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_stmt) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv265 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CALL ->
            _menhir_run80 _menhir_env (Obj.magic _menhir_stack) MenhirState86
        | GOTO ->
            _menhir_run78 _menhir_env (Obj.magic _menhir_stack) MenhirState86
        | ID _v ->
            _menhir_run66 _menhir_env (Obj.magic _menhir_stack) MenhirState86 _v
        | IF ->
            _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState86
        | RETURN ->
            _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState86
        | FED | LABEL ->
            _menhir_reduce16 _menhir_env (Obj.magic _menhir_stack) MenhirState86
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState86) : 'freshtv266)) : 'freshtv268)) : 'freshtv270)) : 'freshtv272)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv273 * _menhir_state * 'tv_instr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv274)) : 'freshtv276)

and _menhir_run38 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | LB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv261 * _menhir_state) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AT ->
            _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | LP ->
            _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | TYPE ->
            _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState39
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState39) : 'freshtv262)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv263 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv264)

and _menhir_run52 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv259) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 95 "src/parser.mly"
            ( S (BoolL true) )
# 890 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv260)

and _menhir_run53 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 29 "src/parser.mly"
       (string)
# 897 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv257) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((s : (
# 29 "src/parser.mly"
       (string)
# 907 "src/parser.ml"
    )) : (
# 29 "src/parser.mly"
       (string)
# 911 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 94 "src/parser.mly"
                ( S (StrL s) )
# 916 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv258)

and _menhir_run40 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | LP ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | TYPE ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState40
    | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv255) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState40 in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_typ__ = 
# 142 "<standard.mly>"
    ( [] )
# 939 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_typ__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv256)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState40

and _menhir_run54 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 27 "src/parser.mly"
       (int)
# 950 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv253) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((i : (
# 27 "src/parser.mly"
       (int)
# 960 "src/parser.ml"
    )) : (
# 27 "src/parser.mly"
       (int)
# 964 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 92 "src/parser.mly"
             ( S (IntL i) )
# 969 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv254)

and _menhir_run55 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 976 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv251) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((n : (
# 30 "src/parser.mly"
       (Core.var)
# 986 "src/parser.ml"
    )) : (
# 30 "src/parser.mly"
       (Core.var)
# 990 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 91 "src/parser.mly"
            ( D n )
# 995 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv252)

and _menhir_run56 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 28 "src/parser.mly"
       (float)
# 1002 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv249) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((f : (
# 28 "src/parser.mly"
       (float)
# 1012 "src/parser.ml"
    )) : (
# 28 "src/parser.mly"
       (float)
# 1016 "src/parser.ml"
    )) = _v in
    ((let _v : 'tv_repr = 
# 93 "src/parser.mly"
               ( S (FloatL f) )
# 1021 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv250)

and _menhir_run57 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv247) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_repr = 
# 96 "src/parser.mly"
             ( S (BoolL false) )
# 1035 "src/parser.ml"
     in
    _menhir_goto_repr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv248)

and _menhir_run41 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv239 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1051 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv237 * _menhir_state) = Obj.magic _menhir_stack in
        let ((n : (
# 30 "src/parser.mly"
       (Core.var)
# 1059 "src/parser.ml"
        )) : (
# 30 "src/parser.mly"
       (Core.var)
# 1063 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_typ = 
# 57 "src/parser.mly"
               ( NomT (snd n) )
# 1070 "src/parser.ml"
         in
        _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv238)) : 'freshtv240)
    | STRING _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv243 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 29 "src/parser.mly"
       (string)
# 1079 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv241 * _menhir_state) = Obj.magic _menhir_stack in
        let ((n : (
# 29 "src/parser.mly"
       (string)
# 1087 "src/parser.ml"
        )) : (
# 29 "src/parser.mly"
       (string)
# 1091 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_typ = 
# 56 "src/parser.mly"
                  ( NomT n )
# 1098 "src/parser.ml"
         in
        _menhir_goto_typ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv242)) : 'freshtv244)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv245 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv246)

and _menhir_goto_separated_nonempty_list_XOR_branch_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_XOR_branch_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState19 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv231) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv229) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_XOR_branch_) : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_XOR_branch__ = 
# 144 "<standard.mly>"
    ( x )
# 1124 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_XOR_branch__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv230)) : 'freshtv232)
    | MenhirState34 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv235 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv233 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_XOR_branch_) : 'tv_separated_nonempty_list_XOR_branch_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_branch)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_XOR_branch_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1141 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_branch_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv234)) : 'freshtv236)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_COMMA_move_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_move_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv223) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv221) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_move_) : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_move__ = 
# 144 "<standard.mly>"
    ( x )
# 1162 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_move__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv222)) : 'freshtv224)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv227 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv225 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_move_) : 'tv_separated_nonempty_list_COMMA_move_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_move)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_move_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 1179 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_move_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv226)) : 'freshtv228)
    | _ ->
        _menhir_fail ()

and _menhir_reduce16 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_stmt_ = 
# 211 "<standard.mly>"
    ( [] )
# 1190 "src/parser.ml"
     in
    _menhir_goto_list_stmt_ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run37 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | FALSE ->
        _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState37
    | FLOAT _v ->
        _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | ID _v ->
        _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | INT _v ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState37 _v
    | LP ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState37
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

and _menhir_run60 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState60
    | FALSE ->
        _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState60
    | FLOAT _v ->
        _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState60 _v
    | ID _v ->
        _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState60 _v
    | INT _v ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState60 _v
    | LP ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState60
    | STRING _v ->
        _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState60 _v
    | TRUE ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState60
    | TYPE ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState60
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState60

and _menhir_run66 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 1255 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ASSIGN ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv217 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1267 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AT ->
            _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState67
        | CALL ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv215 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1279 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState67 in
            ((let _menhir_stack = (_menhir_stack, _menhir_s) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | AT ->
                _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState68
            | FALSE ->
                _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState68
            | FLOAT _v ->
                _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState68 _v
            | ID _v ->
                _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState68 _v
            | INT _v ->
                _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState68 _v
            | LP ->
                _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState68
            | STRING _v ->
                _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState68 _v
            | TRUE ->
                _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState68
            | TYPE ->
                _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState68
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState68) : 'freshtv216)
        | FALSE ->
            _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState67
        | FLOAT _v ->
            _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
        | ID _v ->
            _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
        | INT _v ->
            _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
        | LP ->
            _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState67
        | STRING _v ->
            _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState67 _v
        | TRUE ->
            _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState67
        | TYPE ->
            _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState67
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState67) : 'freshtv218)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv219 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1335 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv220)

and _menhir_run78 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv211 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1352 "src/parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv209 * _menhir_state) = Obj.magic _menhir_stack in
        let ((l : (
# 30 "src/parser.mly"
       (Core.var)
# 1360 "src/parser.ml"
        )) : (
# 30 "src/parser.mly"
       (Core.var)
# 1364 "src/parser.ml"
        )) = _v in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_instr = 
# 107 "src/parser.mly"
                  ( Goto l )
# 1371 "src/parser.ml"
         in
        _menhir_goto_instr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv210)) : 'freshtv212)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv213 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv214)

and _menhir_run80 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | AT ->
        _menhir_run41 _menhir_env (Obj.magic _menhir_stack) MenhirState80
    | FALSE ->
        _menhir_run57 _menhir_env (Obj.magic _menhir_stack) MenhirState80
    | FLOAT _v ->
        _menhir_run56 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
    | ID _v ->
        _menhir_run55 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
    | INT _v ->
        _menhir_run54 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
    | LP ->
        _menhir_run40 _menhir_env (Obj.magic _menhir_stack) MenhirState80
    | STRING _v ->
        _menhir_run53 _menhir_env (Obj.magic _menhir_stack) MenhirState80 _v
    | TRUE ->
        _menhir_run52 _menhir_env (Obj.magic _menhir_stack) MenhirState80
    | TYPE ->
        _menhir_run38 _menhir_env (Obj.magic _menhir_stack) MenhirState80
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState80

and _menhir_goto_loption_separated_nonempty_list_COMMA_move__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_COMMA_move__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv207 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1417 "src/parser.ml"
    ))) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_loption_separated_nonempty_list_COMMA_move__) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : ('freshtv205 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1425 "src/parser.ml"
    ))) = Obj.magic _menhir_stack in
    let (_ : _menhir_state) = _menhir_s in
    let ((xs : 'tv_loption_separated_nonempty_list_COMMA_move__) : 'tv_loption_separated_nonempty_list_COMMA_move__) = _v in
    ((let (_menhir_stack, _menhir_s, (lbl : (
# 30 "src/parser.mly"
       (Core.var)
# 1432 "src/parser.ml"
    ))) = _menhir_stack in
    let _2 = () in
    let _v : 'tv_branch = let moves = 
# 232 "<standard.mly>"
    ( xs )
# 1438 "src/parser.ml"
     in
    
# 85 "src/parser.mly"
                                                        ((lbl, moves))
# 1443 "src/parser.ml"
     in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv203) = _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : 'tv_branch) = _v in
    ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv201 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | XOR ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv195 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState34 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState34) : 'freshtv196)
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv197 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_branch)) = _menhir_stack in
        let _v : 'tv_separated_nonempty_list_XOR_branch_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1474 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_XOR_branch_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv198)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv199 * _menhir_state * 'tv_branch) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv200)) : 'freshtv202)) : 'freshtv204)) : 'freshtv206)) : 'freshtv208)

and _menhir_run22 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 1488 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | MOVE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv191 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1500 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv187 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1510 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1515 "src/parser.ml"
            )) = _v in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv185 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1522 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            let ((from : (
# 30 "src/parser.mly"
       (Core.var)
# 1527 "src/parser.ml"
            )) : (
# 30 "src/parser.mly"
       (Core.var)
# 1531 "src/parser.ml"
            )) = _v in
            ((let (_menhir_stack, _menhir_s, (target : (
# 30 "src/parser.mly"
       (Core.var)
# 1536 "src/parser.ml"
            ))) = _menhir_stack in
            let _2 = () in
            let _v : 'tv_move = 
# 82 "src/parser.mly"
                               ( (target, from) )
# 1542 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv183) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : 'tv_move) = _v in
            ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv181 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | COMMA ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv175 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | ID _v ->
                    _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState27 _v
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState27) : 'freshtv176)
            | RB | XOR ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv177 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, (x : 'tv_move)) = _menhir_stack in
                let _v : 'tv_separated_nonempty_list_COMMA_move_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 1573 "src/parser.ml"
                 in
                _menhir_goto_separated_nonempty_list_COMMA_move_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv178)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv179 * _menhir_state * 'tv_move) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv180)) : 'freshtv182)) : 'freshtv184)) : 'freshtv186)) : 'freshtv188)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv189 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1590 "src/parser.ml"
            ))) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv190)) : 'freshtv192)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv193 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1601 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv194)

and _menhir_goto_list_basic_block_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_basic_block_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState14 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv169) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_basic_block_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv167) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((stmts : 'tv_list_basic_block_) : 'tv_list_basic_block_) = _v in
        ((let _v : 'tv_bbs = 
# 76 "src/parser.mly"
                             (stmts)
# 1621 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv165) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_bbs) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv163 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1632 "src/parser.ml"
        )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | FED ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv159 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1642 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv157 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1649 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let ((((_menhir_stack, _menhir_s), (n : (
# 30 "src/parser.mly"
       (Core.var)
# 1654 "src/parser.ml"
            ))), (entry : 'tv_func_entry)), _, (body : 'tv_bbs)) = _menhir_stack in
            let _5 = () in
            let _1 = () in
            let _v : 'tv_func_def = 
# 73 "src/parser.mly"
                                                  ( (n, {entry; body}) )
# 1661 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv155) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : 'tv_func_def) = _v in
            ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv153 * _menhir_state * 'tv_func_def) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | DEF ->
                _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState99
            | EOF ->
                _menhir_reduce14 _menhir_env (Obj.magic _menhir_stack) MenhirState99
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState99) : 'freshtv154)) : 'freshtv156)) : 'freshtv158)) : 'freshtv160)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv161 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1688 "src/parser.ml"
            )) * 'tv_func_entry) * _menhir_state * 'tv_bbs) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv162)) : 'freshtv164)) : 'freshtv166)) : 'freshtv168)) : 'freshtv170)
    | MenhirState94 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv173 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_list_basic_block_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv171 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_list_basic_block_) : 'tv_list_basic_block_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : 'tv_basic_block)) = _menhir_stack in
        let _v : 'tv_list_basic_block_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 1705 "src/parser.ml"
         in
        _menhir_goto_list_basic_block_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv172)) : 'freshtv174)
    | _ ->
        _menhir_fail ()

and _menhir_goto_loption_separated_nonempty_list_XOR_branch__ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_loption_separated_nonempty_list_XOR_branch__ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : (('freshtv151)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | RB ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv147)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv145)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _, (xs : 'tv_loption_separated_nonempty_list_XOR_branch__)) = _menhir_stack in
        let _4 = () in
        let _2 = () in
        let _1 = () in
        let _v : 'tv_phi = let brs = 
# 232 "<standard.mly>"
    ( xs )
# 1732 "src/parser.ml"
         in
        
# 88 "src/parser.mly"
                                                (brs)
# 1737 "src/parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv143) = _menhir_stack in
        let (_v : 'tv_phi) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv141 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1747 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | CALL ->
            _menhir_run80 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | GOTO ->
            _menhir_run78 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | ID _v ->
            _menhir_run66 _menhir_env (Obj.magic _menhir_stack) MenhirState36 _v
        | IF ->
            _menhir_run60 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | RETURN ->
            _menhir_run37 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | FED | LABEL ->
            _menhir_reduce16 _menhir_env (Obj.magic _menhir_stack) MenhirState36
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState36) : 'freshtv142)) : 'freshtv144)) : 'freshtv146)) : 'freshtv148)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv149)) * _menhir_state * 'tv_loption_separated_nonempty_list_XOR_branch__) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv150)) : 'freshtv152)

and _menhir_run20 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 1779 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COLON ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv137 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1791 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run22 _menhir_env (Obj.magic _menhir_stack) MenhirState21 _v
        | RB | XOR ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv135) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState21 in
            ((let _v : 'tv_loption_separated_nonempty_list_COMMA_move__ = 
# 142 "<standard.mly>"
    ( [] )
# 1805 "src/parser.ml"
             in
            _menhir_goto_loption_separated_nonempty_list_COMMA_move__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv136)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState21) : 'freshtv138)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv139 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 1819 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv140)

and _menhir_reduce12 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_basic_block_ = 
# 211 "<standard.mly>"
    ( [] )
# 1829 "src/parser.ml"
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
        let (_menhir_stack : 'freshtv131 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 30 "src/parser.mly"
       (Core.var)
# 1845 "src/parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | COLON ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv127 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1856 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | PHI ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : 'freshtv123) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | LB ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv119) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        _menhir_run20 _menhir_env (Obj.magic _menhir_stack) MenhirState19 _v
                    | RB ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : 'freshtv117) = Obj.magic _menhir_stack in
                        let (_menhir_s : _menhir_state) = MenhirState19 in
                        ((let _v : 'tv_loption_separated_nonempty_list_XOR_branch__ = 
# 142 "<standard.mly>"
    ( [] )
# 1882 "src/parser.ml"
                         in
                        _menhir_goto_loption_separated_nonempty_list_XOR_branch__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv118)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState19) : 'freshtv120)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : 'freshtv121) = Obj.magic _menhir_stack in
                    (raise _eRR : 'freshtv122)) : 'freshtv124)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv125 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1902 "src/parser.ml"
                ))) = Obj.magic _menhir_stack in
                ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv126)) : 'freshtv128)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv129 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 1913 "src/parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv130)) : 'freshtv132)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv133 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv134)

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
        let (_menhir_stack : ('freshtv103) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RP ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv99) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | BOUND ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv95) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | LB ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv91) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__))) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | ID _v ->
                        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
                    | RB ->
                        _menhir_reduce18 _menhir_env (Obj.magic _menhir_stack) MenhirState11
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState11) : 'freshtv92)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : ((('freshtv93) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__))) = Obj.magic _menhir_stack in
                    ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                    _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv94)) : 'freshtv96)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : (('freshtv97) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv98)) : 'freshtv100)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv101) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv102)) : 'freshtv104)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((((('freshtv115) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | RB ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv111) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv109) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
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
# 2010 "src/parser.ml"
              
            in
            let args = 
# 232 "<standard.mly>"
    ( xs )
# 2016 "src/parser.ml"
             in
            
# 65 "src/parser.mly"
        ( { args=args
          ; kwargs=[]
          ; fn_bounds=fn_bounds
          ; globals=[]
          }
        )
# 2026 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv107) = _menhir_stack in
            let (_v : 'tv_func_entry) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv105 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2036 "src/parser.ml"
            )) * 'tv_func_entry) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | LABEL ->
                _menhir_run15 _menhir_env (Obj.magic _menhir_stack) MenhirState14
            | FED ->
                _menhir_reduce12 _menhir_env (Obj.magic _menhir_stack) MenhirState14
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState14) : 'freshtv106)) : 'freshtv108)) : 'freshtv110)) : 'freshtv112)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((((('freshtv113) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv114)) : 'freshtv116)
    | _ ->
        _menhir_fail ()

and _menhir_goto_separated_nonempty_list_COMMA_ID_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_separated_nonempty_list_COMMA_ID_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv85 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2067 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv83 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2075 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((xs : 'tv_separated_nonempty_list_COMMA_ID_) : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_stack, _menhir_s, (x : (
# 30 "src/parser.mly"
       (Core.var)
# 2082 "src/parser.ml"
        ))) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_separated_nonempty_list_COMMA_ID_ = 
# 243 "<standard.mly>"
    ( x :: xs )
# 2088 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv84)) : 'freshtv86)
    | MenhirState11 | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv89) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv87) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((x : 'tv_separated_nonempty_list_COMMA_ID_) : 'tv_separated_nonempty_list_COMMA_ID_) = _v in
        ((let _v : 'tv_loption_separated_nonempty_list_COMMA_ID__ = 
# 144 "<standard.mly>"
    ( x )
# 2103 "src/parser.ml"
         in
        _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv88)) : 'freshtv90)
    | _ ->
        _menhir_fail ()

and _menhir_goto_list_func_def_ : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_list_func_def_ -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv77 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv73 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv71 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (xs : 'tv_list_func_def_)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 34 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2129 "src/parser.ml"
            ) = 
# 39 "src/parser.mly"
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
# 2147 "src/parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv69) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 34 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2155 "src/parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv67) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 34 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2163 "src/parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv65) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let ((_1 : (
# 34 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2171 "src/parser.ml"
            )) : (
# 34 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2175 "src/parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv66)) : 'freshtv68)) : 'freshtv70)) : 'freshtv72)) : 'freshtv74)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv75 * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv76)) : 'freshtv78)
    | MenhirState99 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv81 * _menhir_state * 'tv_func_def) * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv79 * _menhir_state * 'tv_func_def) * _menhir_state * 'tv_list_func_def_) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (x : 'tv_func_def)), _, (xs : 'tv_list_func_def_)) = _menhir_stack in
        let _v : 'tv_list_func_def_ = 
# 213 "<standard.mly>"
    ( x :: xs )
# 2194 "src/parser.ml"
         in
        _menhir_goto_list_func_def_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv80)) : 'freshtv82)
    | _ ->
        _menhir_fail ()

and _menhir_reduce18 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_loption_separated_nonempty_list_COMMA_ID__ = 
# 142 "<standard.mly>"
    ( [] )
# 2205 "src/parser.ml"
     in
    _menhir_goto_loption_separated_nonempty_list_COMMA_ID__ _menhir_env _menhir_stack _menhir_s _v

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 30 "src/parser.mly"
       (Core.var)
# 2212 "src/parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | COMMA ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv59 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2224 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState5 _v
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState5) : 'freshtv60)
    | RB | RP ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv61 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2240 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (x : (
# 30 "src/parser.mly"
       (Core.var)
# 2245 "src/parser.ml"
        ))) = _menhir_stack in
        let _v : 'tv_separated_nonempty_list_COMMA_ID_ = 
# 241 "<standard.mly>"
    ( [ x ] )
# 2250 "src/parser.ml"
         in
        _menhir_goto_separated_nonempty_list_COMMA_ID_ _menhir_env _menhir_stack _menhir_s _v) : 'freshtv62)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv63 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2260 "src/parser.ml"
        )) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv64)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState99 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11 * _menhir_state * 'tv_func_def) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv12)
    | MenhirState94 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13 * _menhir_state * 'tv_basic_block) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv14)
    | MenhirState86 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15 * _menhir_state * 'tv_stmt) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)
    | MenhirState82 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv17 * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv18)
    | MenhirState80 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv19 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv20)
    | MenhirState73 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv21 * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv22)
    | MenhirState70 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv23 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2303 "src/parser.ml"
        ))) * _menhir_state) * _menhir_state * 'tv_repr)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv24)
    | MenhirState68 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv25 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2312 "src/parser.ml"
        ))) * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv26)
    | MenhirState67 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv27 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2321 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv28)
    | MenhirState60 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv29 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)
    | MenhirState45 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv31 * _menhir_state * 'tv_typ)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv32)
    | MenhirState40 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv33 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv34)
    | MenhirState39 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv35 * _menhir_state)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv36)
    | MenhirState37 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv37 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv38)
    | MenhirState36 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv39 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2355 "src/parser.ml"
        ))) * 'tv_phi) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)
    | MenhirState34 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv41 * _menhir_state * 'tv_branch)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv42)
    | MenhirState27 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv43 * _menhir_state * 'tv_move)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv44)
    | MenhirState21 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv45 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2374 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv46)
    | MenhirState19 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv47)) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv48)
    | MenhirState14 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv49 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2387 "src/parser.ml"
        )) * 'tv_func_entry) = Obj.magic _menhir_stack in
        ((let (((_menhir_stack, _menhir_s), _), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv50)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (((('freshtv51) * _menhir_state * 'tv_loption_separated_nonempty_list_COMMA_ID__)))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv52)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv53 * _menhir_state * (
# 30 "src/parser.mly"
       (Core.var)
# 2401 "src/parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv54)
    | MenhirState3 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv55) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv56)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv57) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv58)

and _menhir_reduce14 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_list_func_def_ = 
# 211 "<standard.mly>"
    ( [] )
# 2419 "src/parser.ml"
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
# 30 "src/parser.mly"
       (Core.var)
# 2435 "src/parser.ml"
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
                _menhir_reduce18 _menhir_env (Obj.magic _menhir_stack) MenhirState3
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState3) : 'freshtv4)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv5 * _menhir_state) * (
# 30 "src/parser.mly"
       (Core.var)
# 2462 "src/parser.ml"
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
# 34 "src/parser.mly"
       (Core.fn_def option * (Core.fn_def Core.M_int.t))
# 2489 "src/parser.ml"
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
        _menhir_reduce14 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv2))

# 269 "<standard.mly>"
  

# 2520 "src/parser.ml"
