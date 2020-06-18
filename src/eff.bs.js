// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
'use strict';

var Block = require("bs-platform/lib/js/block.js");
var Curry = require("bs-platform/lib/js/curry.js");
var Caml_obj = require("bs-platform/lib/js/caml_obj.js");
var Core$Jit = require("./core.bs.js");
var Smap$Jit = require("./smap.bs.js");
var Sset$Jit = require("./sset.bs.js");
var Caml_array = require("bs-platform/lib/js/caml_array.js");
var Common$Jit = require("./common.bs.js");
var Darray$Jit = require("./darray.bs.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");

function type_union(a, b) {
  var exit = 0;
  var exit$1 = 0;
  var exit$2 = 0;
  var exit$3 = 0;
  var exit$4 = 0;
  if (typeof a === "number") {
    switch (a) {
      case /* TopT */1 :
          return /* TopT */1;
      case /* BottomT */2 :
          if (typeof b === "number") {
            switch (b) {
              case /* NoneT */0 :
                  exit$3 = 5;
                  break;
              case /* TopT */1 :
                  exit$4 = 6;
                  break;
              case /* BottomT */2 :
                  return Pervasives.failwith("type_union cannot be used on 2 undefined items.");
              
            }
          } else {
            exit$3 = 5;
          }
          break;
      default:
        exit$4 = 6;
    }
  } else if (a.tag === /* UnionT */6) {
    if (typeof b === "number") {
      switch (b) {
        case /* TopT */1 :
            exit$4 = 6;
            break;
        case /* BottomT */2 :
            exit$2 = 4;
            break;
        default:
          exit$1 = 3;
      }
    } else {
      if (b.tag === /* UnionT */6) {
        return /* UnionT */Block.__(6, [Curry._2(Common$Jit.List.sort_uniq, Caml_obj.caml_compare, Pervasives.$at(a[0], b[0]))]);
      }
      exit$1 = 3;
    }
  } else {
    exit$4 = 6;
  }
  if (exit$4 === 6) {
    if (typeof b === "number") {
      if (b === 1) {
        return /* TopT */1;
      }
      exit$3 = 5;
    } else {
      exit$3 = 5;
    }
  }
  if (exit$3 === 5) {
    if (typeof a === "number") {
      if (a >= 2) {
        return b;
      }
      exit$2 = 4;
    } else {
      exit$2 = 4;
    }
  }
  if (exit$2 === 4) {
    if (typeof b === "number") {
      if (b >= 2) {
        return a;
      }
      exit$1 = 3;
    } else {
      exit$1 = 3;
    }
  }
  if (exit$1 === 3) {
    if (typeof a === "number") {
      exit = 2;
    } else {
      if (a.tag === /* UnionT */6) {
        return /* UnionT */Block.__(6, [Sset$Jit.add(b, a[0])]);
      }
      exit = 2;
    }
  }
  if (exit === 2 && typeof b !== "number" && b.tag === /* UnionT */6) {
    return /* UnionT */Block.__(6, [Sset$Jit.add(a, b[0])]);
  }
  if (Caml_obj.caml_equal(a, b)) {
    return a;
  } else {
    return /* UnionT */Block.__(6, [/* :: */[
                a,
                /* :: */[
                  b,
                  /* [] */0
                ]
              ]]);
  }
}

var bool_t = /* NomT */Block.__(4, ["bool"]);

var int_t = /* NomT */Block.__(4, ["int"]);

var float_t = /* NomT */Block.__(4, ["float"]);

var string_t = /* NomT */Block.__(4, ["string"]);

function type_of_const(xs) {
  if (typeof xs === "number") {
    if (xs === /* NoneL */0) {
      return /* NoneT */0;
    } else {
      return /* BottomT */2;
    }
  }
  switch (xs.tag | 0) {
    case /* IntL */0 :
        return int_t;
    case /* BoolL */1 :
        return bool_t;
    case /* FloatL */2 :
        return float_t;
    case /* StrL */3 :
        return string_t;
    case /* TupleL */4 :
        return /* TupleT */Block.__(1, [Curry._2(Common$Jit.List.map, type_of_const, xs[0])]);
    case /* InstrinsicL */5 :
        return /* IntrinsicT */Block.__(8, [xs[0]]);
    case /* TypeL */6 :
        return /* TypeT */Block.__(2, [xs[0]]);
    
  }
}

function MkSt(X) {
  var it = X.x;
  var assign_vars = function (vs) {
    var slots$prime = Curry._1(Common$Jit.$$Array.copy, it.slots);
    return Common$Jit.flip(Common$Jit.List.iter, vs, (function (param) {
                  var v2 = param[1];
                  var v1 = param[0];
                  var i1 = Smap$Jit.find(v1, it.n2i);
                  var i2 = Smap$Jit.find(v2, it.n2i);
                  var s2 = Caml_array.caml_array_get(slots$prime, i2);
                  if (!s2.value.tag) {
                    return Caml_array.caml_array_set(it.slots, i1, s2);
                  }
                  Darray$Jit.append(it.cur_block, /* Assign */Block.__(2, [
                          v1,
                          /* D */Block.__(1, [v2])
                        ]));
                  return Caml_array.caml_array_set(it.slots, i1, {
                              typ: s2.typ,
                              value: /* D */Block.__(1, [v1])
                            });
                }));
  };
  var assign = function (target) {
    var i_target = Smap$Jit.find(target, it.n2i);
    var s_target = Caml_array.caml_array_get(it.slots, i_target);
    var match = s_target.typ;
    if (typeof match === "number" && match === 1) {
      return (function (repr) {
          return Darray$Jit.append(it.cur_block, /* Assign */Block.__(2, [
                        target,
                        repr
                      ]));
        });
    }
    return (function ($$var) {
        if (!$$var.tag) {
          return Caml_array.caml_array_set(it.slots, i_target, {
                      typ: type_of_const($$var[0]),
                      value: $$var
                    });
        }
        var $$var$1 = $$var[0];
        var i_var = Smap$Jit.find($$var$1, it.n2i);
        var s = Caml_array.caml_array_get(it.slots, i_var);
        var match = s.typ;
        if (typeof match === "number" && match >= 2) {
          return Pervasives.failwith("undefined variable " + $$var$1[1]);
        }
        if (!s.value.tag) {
          return Caml_array.caml_array_set(it.slots, i_target, s);
        }
        Darray$Jit.append(it.cur_block, /* Assign */Block.__(2, [
                target,
                /* D */Block.__(1, [$$var$1])
              ]));
        return Caml_array.caml_array_set(it.slots, i_target, {
                    typ: s.typ,
                    value: /* D */Block.__(1, [target])
                  });
      });
  };
  var mark_reached = function (lbl) {
    it.reached = Sset$Jit.add(lbl, it.reached);
    
  };
  var has_reached = function (lbl) {
    return Sset$Jit.mem(lbl, it.reached);
  };
  var with_local = function (do_it) {
    var slots$prime = Curry._1(Common$Jit.$$Array.copy, it.slots);
    var slots = it.slots;
    var reached = it.reached;
    var cur_lbl = it.cur_lbl;
    var cur_block = it.cur_block;
    it.slots = slots$prime;
    var ret = Curry._1(do_it, undefined);
    it.slots = slots;
    it.reached = reached;
    it.cur_block = cur_block;
    it.cur_lbl = cur_lbl;
    return ret;
  };
  var add_instr = function (instr) {
    return Darray$Jit.append(it.cur_block, instr);
  };
  var dynamicalize_all = function (param) {
    return Curry._2(Common$Jit.List.iter, (function (param) {
                  var i = param[1];
                  var v = Caml_array.caml_array_get(it.slots, i);
                  Caml_array.caml_array_set(it.slots, i, {
                        typ: /* TopT */1,
                        value: /* D */Block.__(1, [param[0]])
                      });
                  var typ = v.typ;
                  if (typeof typ === "number") {
                    switch (typ) {
                      case /* TopT */1 :
                          return ;
                      case /* BottomT */2 :
                          return Pervasives.failwith("TODO");
                      default:
                        
                    }
                  } else if (typ.tag === /* UnionT */6) {
                    return ;
                  }
                  return Darray$Jit.append(it.cur_block, /* Call */Block.__(4, [
                                undefined,
                                /* S */Block.__(0, [/* InstrinsicL */Block.__(5, [/* Upcast */6])]),
                                /* :: */[
                                  /* S */Block.__(0, [/* TypeL */Block.__(6, [typ])]),
                                  /* :: */[
                                    v.value,
                                    /* [] */0
                                  ]
                                ],
                                /* [] */0
                              ]));
                }), it.n2i);
  };
  var enter_block = function (label, block) {
    it.cur_block = block;
    it.cur_lbl = label;
    
  };
  var add_return_type = function (t) {
    it.ret = type_union(it.ret, t);
    
  };
  var genlbl = function (param) {
    var v = it.lbl_count;
    it.lbl_count = v + 1 | 0;
    return /* tuple */[
            it.scope_level,
            String(v)
          ];
  };
  var genvar = function (param) {
    var v = it.var_count;
    it.var_count = v + 1 | 0;
    return /* tuple */[
            it.scope_level,
            String(v)
          ];
  };
  var union_types = function (param) {
    var unions = Common$Jit.List.unwrap_seq(Curry._1(Common$Jit.$$Array.to_list, Curry._2(Common$Jit.$$Array.mapi, (function (i, param) {
                    var ts = param.typ;
                    if (typeof ts === "number" || ts.tag !== /* UnionT */6) {
                      return ;
                    } else {
                      return /* tuple */[
                              i,
                              ts[0]
                            ];
                    }
                  }), it.slots)));
    var match = Common$Jit.List.unzip(unions);
    var indices = match[0];
    var tss = Common$Jit.sequence(match[1]);
    return Curry._2(Common$Jit.List.map, (function (param) {
                  return Common$Jit.List.zip(indices, param);
                }), tss);
  };
  var create_block = function (lbl) {
    var config_001 = Curry._1(Common$Jit.$$Array.copy, it.slots);
    var config = /* tuple */[
      lbl,
      config_001
    ];
    var new_lbl = genlbl(undefined);
    var block = Darray$Jit.from_array([/* Label */Block.__(6, [new_lbl])]);
    it.out_bbs = Curry._3(Core$Jit.M_state.add, config, /* tuple */[
          new_lbl,
          block
        ], it.out_bbs);
    return block;
  };
  var narrow = function ($$var, t) {
    var i = Smap$Jit.find($$var, it.n2i);
    var a = Caml_array.caml_array_get(it.slots, i);
    if (Caml_obj.caml_equal(a.typ, t)) {
      return /* S */Block.__(0, [/* BoolL */Block.__(1, [true])]);
    }
    if (!a.value.tag) {
      return Pervasives.failwith("TODO");
    }
    Caml_array.caml_array_set(it.slots, i, {
          typ: t,
          value: a.value
        });
    var check_var = genvar(undefined);
    Darray$Jit.append(it.cur_block, /* Call */Block.__(4, [
            check_var,
            /* S */Block.__(0, [/* InstrinsicL */Block.__(5, [/* Downcast */7])]),
            /* :: */[
              /* S */Block.__(0, [/* TypeL */Block.__(6, [t])]),
              /* :: */[
                /* D */Block.__(1, [$$var]),
                /* [] */0
              ]
            ],
            /* [] */0
          ]));
    return /* D */Block.__(1, [check_var]);
  };
  var add_config = function (config, labelled_block) {
    it.out_bbs = Curry._3(Core$Jit.M_state.add, config, labelled_block, it.out_bbs);
    
  };
  var revmap = Curry._2(Common$Jit.List.map, (function (param) {
          return /* tuple */[
                  param[1],
                  param[0]
                ];
        }), it.n2i);
  var dynamic_values = Curry._2(Common$Jit.$$Array.init, it.slots.length, (function (i) {
          return {
                  typ: /* TopT */1,
                  value: /* D */Block.__(1, [Smap$Jit.find(i, revmap)])
                };
        }));
  var make_config = function (param) {
    return /* tuple */[
            it.cur_lbl,
            Curry._1(Common$Jit.$$Array.copy, it.slots)
          ];
  };
  var lookup_config = function (config) {
    return Curry._2(Core$Jit.M_state.find_opt, config, it.out_bbs);
  };
  return {
          X: X,
          it: it,
          assign_vars: assign_vars,
          assign: assign,
          mark_reached: mark_reached,
          has_reached: has_reached,
          with_local: with_local,
          dynamicalize_all: dynamicalize_all,
          narrow: narrow,
          enter_block: enter_block,
          add_instr: add_instr,
          add_return_type: add_return_type,
          genlbl: genlbl,
          genvar: genvar,
          union_types: union_types,
          create_block: create_block,
          add_config: add_config,
          dynamic_values: dynamic_values,
          make_config: make_config,
          lookup_config: lookup_config
        };
}

function CopySt(S) {
  var X = S.X;
  var it = X.x;
  var assign_vars = function (vs) {
    var slots$prime = Curry._1(Common$Jit.$$Array.copy, it.slots);
    return Common$Jit.flip(Common$Jit.List.iter, vs, (function (param) {
                  var v2 = param[1];
                  var v1 = param[0];
                  var i1 = Smap$Jit.find(v1, it.n2i);
                  var i2 = Smap$Jit.find(v2, it.n2i);
                  var s2 = Caml_array.caml_array_get(slots$prime, i2);
                  if (!s2.value.tag) {
                    return Caml_array.caml_array_set(it.slots, i1, s2);
                  }
                  Darray$Jit.append(it.cur_block, /* Assign */Block.__(2, [
                          v1,
                          /* D */Block.__(1, [v2])
                        ]));
                  return Caml_array.caml_array_set(it.slots, i1, {
                              typ: s2.typ,
                              value: /* D */Block.__(1, [v1])
                            });
                }));
  };
  var assign = function (target) {
    var i_target = Smap$Jit.find(target, it.n2i);
    var s_target = Caml_array.caml_array_get(it.slots, i_target);
    var match = s_target.typ;
    if (typeof match === "number" && match === 1) {
      return (function (repr) {
          return Darray$Jit.append(it.cur_block, /* Assign */Block.__(2, [
                        target,
                        repr
                      ]));
        });
    }
    return (function ($$var) {
        if (!$$var.tag) {
          return Caml_array.caml_array_set(it.slots, i_target, {
                      typ: type_of_const($$var[0]),
                      value: $$var
                    });
        }
        var $$var$1 = $$var[0];
        var i_var = Smap$Jit.find($$var$1, it.n2i);
        var s = Caml_array.caml_array_get(it.slots, i_var);
        var match = s.typ;
        if (typeof match === "number" && match >= 2) {
          return Pervasives.failwith("undefined variable " + $$var$1[1]);
        }
        if (!s.value.tag) {
          return Caml_array.caml_array_set(it.slots, i_target, s);
        }
        Darray$Jit.append(it.cur_block, /* Assign */Block.__(2, [
                target,
                /* D */Block.__(1, [$$var$1])
              ]));
        return Caml_array.caml_array_set(it.slots, i_target, {
                    typ: s.typ,
                    value: /* D */Block.__(1, [target])
                  });
      });
  };
  var mark_reached = function (lbl) {
    it.reached = Sset$Jit.add(lbl, it.reached);
    
  };
  var has_reached = function (lbl) {
    return Sset$Jit.mem(lbl, it.reached);
  };
  var with_local = function (do_it) {
    var slots$prime = Curry._1(Common$Jit.$$Array.copy, it.slots);
    var slots = it.slots;
    var reached = it.reached;
    var cur_lbl = it.cur_lbl;
    var cur_block = it.cur_block;
    it.slots = slots$prime;
    var ret = Curry._1(do_it, undefined);
    it.slots = slots;
    it.reached = reached;
    it.cur_block = cur_block;
    it.cur_lbl = cur_lbl;
    return ret;
  };
  var add_instr = function (instr) {
    return Darray$Jit.append(it.cur_block, instr);
  };
  var dynamicalize_all = function (param) {
    return Curry._2(Common$Jit.List.iter, (function (param) {
                  var i = param[1];
                  var v = Caml_array.caml_array_get(it.slots, i);
                  Caml_array.caml_array_set(it.slots, i, {
                        typ: /* TopT */1,
                        value: /* D */Block.__(1, [param[0]])
                      });
                  var typ = v.typ;
                  if (typeof typ === "number") {
                    switch (typ) {
                      case /* TopT */1 :
                          return ;
                      case /* BottomT */2 :
                          return Pervasives.failwith("TODO");
                      default:
                        
                    }
                  } else if (typ.tag === /* UnionT */6) {
                    return ;
                  }
                  return Darray$Jit.append(it.cur_block, /* Call */Block.__(4, [
                                undefined,
                                /* S */Block.__(0, [/* InstrinsicL */Block.__(5, [/* Upcast */6])]),
                                /* :: */[
                                  /* S */Block.__(0, [/* TypeL */Block.__(6, [typ])]),
                                  /* :: */[
                                    v.value,
                                    /* [] */0
                                  ]
                                ],
                                /* [] */0
                              ]));
                }), it.n2i);
  };
  var enter_block = function (label, block) {
    it.cur_block = block;
    it.cur_lbl = label;
    
  };
  var add_return_type = function (t) {
    it.ret = type_union(it.ret, t);
    
  };
  var genlbl = function (param) {
    var v = it.lbl_count;
    it.lbl_count = v + 1 | 0;
    return /* tuple */[
            it.scope_level,
            String(v)
          ];
  };
  var genvar = function (param) {
    var v = it.var_count;
    it.var_count = v + 1 | 0;
    return /* tuple */[
            it.scope_level,
            String(v)
          ];
  };
  var union_types = function (param) {
    var unions = Common$Jit.List.unwrap_seq(Curry._1(Common$Jit.$$Array.to_list, Curry._2(Common$Jit.$$Array.mapi, (function (i, param) {
                    var ts = param.typ;
                    if (typeof ts === "number" || ts.tag !== /* UnionT */6) {
                      return ;
                    } else {
                      return /* tuple */[
                              i,
                              ts[0]
                            ];
                    }
                  }), it.slots)));
    var match = Common$Jit.List.unzip(unions);
    var indices = match[0];
    var tss = Common$Jit.sequence(match[1]);
    return Curry._2(Common$Jit.List.map, (function (param) {
                  return Common$Jit.List.zip(indices, param);
                }), tss);
  };
  var create_block = function (lbl) {
    var config_001 = Curry._1(Common$Jit.$$Array.copy, it.slots);
    var config = /* tuple */[
      lbl,
      config_001
    ];
    var new_lbl = genlbl(undefined);
    var block = Darray$Jit.from_array([/* Label */Block.__(6, [new_lbl])]);
    it.out_bbs = Curry._3(Core$Jit.M_state.add, config, /* tuple */[
          new_lbl,
          block
        ], it.out_bbs);
    return block;
  };
  var narrow = function ($$var, t) {
    var i = Smap$Jit.find($$var, it.n2i);
    var a = Caml_array.caml_array_get(it.slots, i);
    if (Caml_obj.caml_equal(a.typ, t)) {
      return /* S */Block.__(0, [/* BoolL */Block.__(1, [true])]);
    }
    if (!a.value.tag) {
      return Pervasives.failwith("TODO");
    }
    Caml_array.caml_array_set(it.slots, i, {
          typ: t,
          value: a.value
        });
    var check_var = genvar(undefined);
    Darray$Jit.append(it.cur_block, /* Call */Block.__(4, [
            check_var,
            /* S */Block.__(0, [/* InstrinsicL */Block.__(5, [/* Downcast */7])]),
            /* :: */[
              /* S */Block.__(0, [/* TypeL */Block.__(6, [t])]),
              /* :: */[
                /* D */Block.__(1, [$$var]),
                /* [] */0
              ]
            ],
            /* [] */0
          ]));
    return /* D */Block.__(1, [check_var]);
  };
  var add_config = function (config, labelled_block) {
    it.out_bbs = Curry._3(Core$Jit.M_state.add, config, labelled_block, it.out_bbs);
    
  };
  var revmap = Curry._2(Common$Jit.List.map, (function (param) {
          return /* tuple */[
                  param[1],
                  param[0]
                ];
        }), it.n2i);
  var dynamic_values = Curry._2(Common$Jit.$$Array.init, it.slots.length, (function (i) {
          return {
                  typ: /* TopT */1,
                  value: /* D */Block.__(1, [Smap$Jit.find(i, revmap)])
                };
        }));
  var make_config = function (param) {
    return /* tuple */[
            it.cur_lbl,
            Curry._1(Common$Jit.$$Array.copy, it.slots)
          ];
  };
  var lookup_config = function (config) {
    return Curry._2(Core$Jit.M_state.find_opt, config, it.out_bbs);
  };
  return {
          X: X,
          it: it,
          assign_vars: assign_vars,
          assign: assign,
          mark_reached: mark_reached,
          has_reached: has_reached,
          with_local: with_local,
          dynamicalize_all: dynamicalize_all,
          narrow: narrow,
          enter_block: enter_block,
          add_instr: add_instr,
          add_return_type: add_return_type,
          genlbl: genlbl,
          genvar: genvar,
          union_types: union_types,
          create_block: create_block,
          add_config: add_config,
          dynamic_values: dynamic_values,
          make_config: make_config,
          lookup_config: lookup_config
        };
}

exports.type_union = type_union;
exports.bool_t = bool_t;
exports.int_t = int_t;
exports.float_t = float_t;
exports.string_t = string_t;
exports.type_of_const = type_of_const;
exports.MkSt = MkSt;
exports.CopySt = CopySt;
/* Core-Jit Not a pure module */
