// Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
'use strict';

var $$Map = require("bs-platform/lib/js/map.js");
var List = require("bs-platform/lib/js/list.js");
var $$Array = require("bs-platform/lib/js/array.js");
var Block = require("bs-platform/lib/js/block.js");
var Curry = require("bs-platform/lib/js/curry.js");
var Int$Jit = require("./int.bs.js");
var Caml_obj = require("bs-platform/lib/js/caml_obj.js");
var Smap$Jit = require("./smap.bs.js");
var Sset$Jit = require("./Sset.bs.js");
var Caml_array = require("bs-platform/lib/js/caml_array.js");
var Darray$Jit = require("./darray.bs.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");
var Caml_exceptions = require("bs-platform/lib/js/caml_exceptions.js");

function scope_of(param) {
  return param[0];
}

function unwrap_scope(param) {
  return param[1];
}

function $$return(a) {
  return {
          run_state: (function (s) {
              return /* tuple */[
                      a,
                      s
                    ];
            })
        };
}

function $great$great$eq(m, k) {
  return {
          run_state: (function (s) {
              var match = Curry._1(m.run_state, s);
              return Curry._1(Curry._1(k, match[0]).run_state, match[1]);
            })
        };
}

function $great$great(m1, m2) {
  return {
          run_state: (function (s) {
              var match = Curry._1(m1.run_state, s);
              return Curry._1(m2.run_state, match[1]);
            })
        };
}

var get = {
  run_state: (function (s) {
      return /* tuple */[
              s,
              s
            ];
    })
};

function gets(f) {
  return {
          run_state: (function (s) {
              return /* tuple */[
                      Curry._1(f, s),
                      s
                    ];
            })
        };
}

function modify(f) {
  return {
          run_state: (function (s) {
              return /* tuple */[
                      undefined,
                      Curry._1(f, s)
                    ];
            })
        };
}

function put(s) {
  return {
          run_state: (function (param) {
              return /* tuple */[
                      undefined,
                      s
                    ];
            })
        };
}

function forM_(ms, k) {
  return $great$great(List.fold_left((function (a, b) {
                    return $great$great(a, $great$great$eq(b, k));
                  }), {
                  run_state: (function (s) {
                      return /* tuple */[
                              undefined,
                              s
                            ];
                    })
                }, ms), {
              run_state: (function (s) {
                  return /* tuple */[
                          undefined,
                          s
                        ];
                })
            });
}

function forM(ms, k) {
  var f = function (a, b) {
    return $great$great$eq($great$great$eq(a, k), (function (a) {
                  return $great$great$eq(b, (function (b) {
                                var a$1 = /* :: */[
                                  a,
                                  b
                                ];
                                return {
                                        run_state: (function (s) {
                                            return /* tuple */[
                                                    a$1,
                                                    s
                                                  ];
                                          })
                                      };
                              }));
                }));
  };
  return List.fold_right(f, ms, {
              run_state: (function (s) {
                  return /* tuple */[
                          /* [] */0,
                          s
                        ];
                })
            });
}

var MState = {
  $$return: $$return,
  $great$great$eq: $great$great$eq,
  $great$great: $great$great,
  get: get,
  gets: gets,
  modify: modify,
  put: put,
  forM_: forM_,
  forM: forM
};

var compare = Caml_obj.caml_compare;

var M_state = $$Map.Make({
      compare: compare
    });

var M_int = $$Map.Make(Int$Jit);

function type_union(a, b) {
  var exit = 0;
  var exit$1 = 0;
  var exit$2 = 0;
  if (typeof a === "number") {
    if (a === /* BottomT */2) {
      if (typeof b === "number" && b >= 2) {
        return Pervasives.failwith("type_union cannot be used on 2 undefined items.");
      } else {
        return b;
      }
    }
    exit$2 = 4;
  } else if (a.tag === /* UnionT */6) {
    if (typeof b === "number") {
      if (b === /* BottomT */2) {
        exit$2 = 4;
      } else {
        exit$1 = 3;
      }
    } else {
      if (b.tag === /* UnionT */6) {
        return /* UnionT */Block.__(6, [List.sort_uniq(Caml_obj.caml_compare, Pervasives.$at(a[0], b[0]))]);
      }
      exit$1 = 3;
    }
  } else {
    exit$2 = 4;
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
        return /* NomT */Block.__(4, ["int"]);
    case /* BoolL */1 :
        return /* NomT */Block.__(4, ["bool"]);
    case /* FloatL */2 :
        return /* NomT */Block.__(4, ["float"]);
    case /* StrL */3 :
        return /* NomT */Block.__(4, ["string"]);
    case /* TupleL */4 :
        return /* TupleT */Block.__(1, [List.map(type_of_const, xs[0])]);
    case /* InstrinsicL */5 :
        return /* IntrinsicT */Block.__(8, [xs[0]]);
    
  }
}

var NonStaticTypeCheck = Caml_exceptions.create("Pe0-Jit.NonStaticTypeCheck");

function type_less(a, b) {
  if (typeof a === "number") {
    switch (a) {
      case /* TopT */1 :
          throw NonStaticTypeCheck;
      case /* BottomT */2 :
          return true;
      default:
        
    }
  } else if (a.tag === /* UnionT */6) {
    if (typeof b === "number") {
      if (b !== /* TopT */1) {
        return false;
      }
      
    } else {
      if (b.tag !== /* UnionT */6) {
        return false;
      }
      var ys = b[0];
      return List.for_all((function (x) {
                    return List.exists((function (param) {
                                  return type_less(x, param);
                                }), ys);
                  }), a[0]);
    }
  }
  if (typeof b === "number") {
    if (b === /* TopT */1) {
      return true;
    } else {
      return false;
    }
  } else if (b.tag === /* UnionT */6) {
    return List.exists((function (param) {
                  return type_less(a, param);
                }), b[0]);
  } else {
    return false;
  }
}

function flip(f, x, y) {
  return Curry._2(f, y, x);
}

function sequence(param) {
  if (!param) {
    return /* [] */0;
  }
  var gs = param[1];
  var g = param[0];
  if (!gs) {
    return List.map((function (x) {
                  return /* :: */[
                          x,
                          /* [] */0
                        ];
                }), g);
  }
  var tls = sequence(gs);
  return List.concat(List.map((function (tl) {
                    return List.map((function (param) {
                                  return List.cons(param, tl);
                                }), g);
                  }), tls));
}

function specialise_bb(blocks, cur_lbl) {
  var match = Smap$Jit.find(cur_lbl, blocks);
  var phi = match.phi;
  var suite = match.suite;
  return $great$great$eq(get, (function (st) {
                var bb_count = st.bb_count;
                var reached = st.reached;
                var slots = st.slots;
                var n2i = st.n2i;
                var slots$prime = $$Array.copy(slots);
                var instrs = Darray$Jit.empty(undefined);
                var iter_do = function (param) {
                  var from = param[1];
                  var reg = param[0];
                  Darray$Jit.append(instrs, /* Assign */Block.__(2, [
                          reg,
                          /* Var */Block.__(0, [from])
                        ]));
                  var i_reg = Smap$Jit.find(reg, n2i);
                  var i_from = Smap$Jit.find(from, n2i);
                  var v1 = Caml_array.caml_array_get(slots$prime, i_reg);
                  var v2 = Caml_array.caml_array_get(slots, i_from);
                  if (v2.typ === /* BottomT */2) {
                    return Pervasives.failwith("NameError detected");
                  } else if (v1.typ === /* BottomT */2) {
                    return Caml_array.caml_array_set(slots$prime, i_reg, v2);
                  } else {
                    return Caml_array.caml_array_set(slots$prime, i_reg, {
                                typ: type_union(v1.typ, v2.typ),
                                value: v2.value
                              });
                  }
                };
                List.iter(iter_do, Smap$Jit.find(cur_lbl, phi));
                var config = /* tuple */[
                  cur_lbl,
                  slots$prime
                ];
                var match = Curry._2(M_state.find_opt, config, reached);
                if (match !== undefined) {
                  var a = match[0];
                  return {
                          run_state: (function (s) {
                              return /* tuple */[
                                      a,
                                      s
                                    ];
                            })
                        };
                }
                bb_count.contents = bb_count.contents + 1 | 0;
                var gen_lbl_001 = String(bb_count.contents);
                var gen_lbl = /* tuple */[
                  0,
                  gen_lbl_001
                ];
                var reached$1 = Curry._3(M_state.add, config, /* tuple */[
                      gen_lbl,
                      instrs
                    ], reached);
                var s_n2i = st.n2i;
                var s_i2f = st.i2f;
                var s_bb_count = st.bb_count;
                var s = {
                  n2i: s_n2i,
                  i2f: s_i2f,
                  slots: slots$prime,
                  reached: reached$1,
                  bb_count: s_bb_count
                };
                return $great$great$eq({
                            run_state: (function (param) {
                                return /* tuple */[
                                        undefined,
                                        s
                                      ];
                              })
                          }, (function (param) {
                              specialise_instrs(blocks, suite);
                              return {
                                      run_state: (function (s) {
                                          return /* tuple */[
                                                  gen_lbl,
                                                  s
                                                ];
                                        })
                                    };
                            }));
              }));
}

function specialise_instrs(blocks, param) {
  if (!param) {
    return {
            run_state: (function (s) {
                return /* tuple */[
                        /* [] */0,
                        s
                      ];
              })
          };
  }
  var xs = param[1];
  var instr = param[0];
  var lbl;
  switch (instr.tag | 0) {
    case /* GotoIf */0 :
        var $$var = instr[0];
        if ($$var.tag) {
          var match = $$var[0];
          if (typeof match === "number") {
            return Pervasives.failwith("internal error");
          }
          if (match.tag !== /* BoolL */1) {
            return Pervasives.failwith("internal error");
          }
          if (!match[0]) {
            return $great$great$eq(specialise_bb(blocks, instr[2]), (function (lbl) {
                          var a_000 = /* Goto */Block.__(1, [lbl]);
                          var a = /* :: */[
                            a_000,
                            /* [] */0
                          ];
                          return {
                                  run_state: (function (s) {
                                      return /* tuple */[
                                              a,
                                              s
                                            ];
                                    })
                                };
                        }));
          }
          lbl = instr[1];
        } else {
          var l2 = instr[2];
          var l1 = instr[1];
          var $$var$1 = $$var[0];
          return $great$great$eq(get, (function (param) {
                        var i = Smap$Jit.find($$var$1, param.n2i);
                        var v1 = Caml_array.caml_array_get(param.slots, i);
                        var match = v1.value;
                        if (!match.tag) {
                          var match$1 = match[0];
                          if (typeof match$1 !== "number" && match$1.tag === /* BoolL */1) {
                            if (match$1[0]) {
                              return $great$great$eq(specialise_bb(blocks, l1), (function (lbl) {
                                            var a_000 = /* Goto */Block.__(1, [lbl]);
                                            var a = /* :: */[
                                              a_000,
                                              /* [] */0
                                            ];
                                            return {
                                                    run_state: (function (s) {
                                                        return /* tuple */[
                                                                a,
                                                                s
                                                              ];
                                                      })
                                                  };
                                          }));
                            } else {
                              return $great$great$eq(specialise_bb(blocks, l2), (function (lbl) {
                                            var a_000 = /* Goto */Block.__(1, [lbl]);
                                            var a = /* :: */[
                                              a_000,
                                              /* [] */0
                                            ];
                                            return {
                                                    run_state: (function (s) {
                                                        return /* tuple */[
                                                                a,
                                                                s
                                                              ];
                                                      })
                                                  };
                                          }));
                            }
                          }
                          
                        }
                        return $great$great$eq(specialise_bb(blocks, l1), (function (l1) {
                                      return $great$great$eq(specialise_bb(blocks, l2), (function (l2) {
                                                    return $great$great$eq(specialise_instrs(blocks, xs), (function (tl) {
                                                                  var a_000 = /* GotoIf */Block.__(0, [
                                                                      /* Var */Block.__(0, [$$var$1]),
                                                                      l1,
                                                                      l2
                                                                    ]);
                                                                  var a = /* :: */[
                                                                    a_000,
                                                                    tl
                                                                  ];
                                                                  return {
                                                                          run_state: (function (s) {
                                                                              return /* tuple */[
                                                                                      a,
                                                                                      s
                                                                                    ];
                                                                            })
                                                                        };
                                                                }));
                                                  }));
                                    }));
                      }));
        }
        break;
    case /* Goto */1 :
        lbl = instr[0];
        break;
    case /* Assign */2 :
        var $$const = instr[1];
        var $$var$2 = instr[0];
        if ($$const.tag) {
          var $$const$1 = $$const[0];
          return $great$great$eq(get, (function (pe_state) {
                        var slots = pe_state.slots;
                        var ty = type_of_const($$const$1);
                        var i1 = Smap$Jit.find($$var$2, pe_state.n2i);
                        var v1 = Caml_array.caml_array_get(slots, i1);
                        var v2_value = /* S */Block.__(0, [$$const$1]);
                        var v2 = {
                          typ: ty,
                          value: v2_value
                        };
                        if (Caml_obj.caml_equal(v1, v2)) {
                          return specialise_instrs(blocks, xs);
                        }
                        var slots$prime = $$Array.copy(slots);
                        if (v1.typ === /* BottomT */2) {
                          Caml_array.caml_array_set(slots$prime, i1, v2);
                        } else {
                          Caml_array.caml_array_set(slots$prime, i1, {
                                typ: type_union(v1.typ, ty),
                                value: v2_value
                              });
                        }
                        var s_n2i = pe_state.n2i;
                        var s_i2f = pe_state.i2f;
                        var s_reached = pe_state.reached;
                        var s_bb_count = pe_state.bb_count;
                        var s = {
                          n2i: s_n2i,
                          i2f: s_i2f,
                          slots: slots$prime,
                          reached: s_reached,
                          bb_count: s_bb_count
                        };
                        return $great$great$eq($great$great({
                                        run_state: (function (param) {
                                            return /* tuple */[
                                                    undefined,
                                                    s
                                                  ];
                                          })
                                      }, specialise_instrs(blocks, xs)), (function (tl) {
                                      var a = /* :: */[
                                        instr,
                                        tl
                                      ];
                                      return {
                                              run_state: (function (s) {
                                                  return /* tuple */[
                                                          a,
                                                          s
                                                        ];
                                                })
                                            };
                                    }));
                      }));
        }
        var from = $$const[0];
        return $great$great$eq(get, (function (pe_state) {
                      var slots = pe_state.slots;
                      var n2i = pe_state.n2i;
                      var i1 = Smap$Jit.find($$var$2, n2i);
                      var i2 = Smap$Jit.find(from, n2i);
                      var v1 = Caml_array.caml_array_get(slots, i1);
                      var v2 = Caml_array.caml_array_get(slots, i2);
                      if (Caml_obj.caml_equal(v1, v2)) {
                        return specialise_instrs(blocks, xs);
                      }
                      var slots$prime = $$Array.copy(slots);
                      Caml_array.caml_array_set(slots$prime, i1, v2);
                      var s_n2i = pe_state.n2i;
                      var s_i2f = pe_state.i2f;
                      var s_reached = pe_state.reached;
                      var s_bb_count = pe_state.bb_count;
                      var s = {
                        n2i: s_n2i,
                        i2f: s_i2f,
                        slots: slots$prime,
                        reached: s_reached,
                        bb_count: s_bb_count
                      };
                      return $great$great({
                                  run_state: (function (param) {
                                      return /* tuple */[
                                              undefined,
                                              s
                                            ];
                                    })
                                }, $great$great$eq(specialise_instrs(blocks, xs), (function (tl) {
                                        var a = /* :: */[
                                          instr,
                                          tl
                                        ];
                                        return {
                                                run_state: (function (s) {
                                                    return /* tuple */[
                                                            a,
                                                            s
                                                          ];
                                                  })
                                              };
                                      })));
                    }));
    case /* Return */3 :
        var a = /* :: */[
          instr,
          /* [] */0
        ];
        return {
                run_state: (function (s) {
                    return /* tuple */[
                            a,
                            s
                          ];
                  })
              };
    case /* Call */4 :
        var bound = instr[0];
        if (bound === undefined) {
          return Pervasives.failwith("TODO");
        }
        var match$1 = instr[1];
        if (!match$1.tag) {
          return Pervasives.failwith("TODO");
        }
        var match$2 = match$1[0];
        if (typeof match$2 === "number") {
          return Pervasives.failwith("TODO");
        }
        if (match$2.tag !== /* InstrinsicL */5) {
          return Pervasives.failwith("TODO");
        }
        if (match$2[0] < 3) {
          return Pervasives.failwith("TODO");
        }
        var $$var$3 = instr[2];
        if ($$var$3.tag) {
          return Pervasives.failwith("TODO");
        }
        var match$3 = instr[3];
        var $$var$4 = $$var$3[0];
        if (!match$3.tag) {
          return Pervasives.failwith("TODO");
        }
        var match$4 = match$3[0];
        if (typeof match$4 === "number" && match$4 !== 0) {
          return $great$great$eq(get, (function (pe_state) {
                        var slots = pe_state.slots;
                        var n2i = pe_state.n2i;
                        var bi = Smap$Jit.find(bound, n2i);
                        var vi = Smap$Jit.find($$var$4, n2i);
                        var vv = Caml_array.caml_array_get(slots, vi);
                        var ty = vv.typ;
                        if (typeof ty !== "number" && ty.tag === /* TypeT */2) {
                          try {
                            var test = /* S */Block.__(0, [/* BoolL */Block.__(1, [type_less(ty[0], vv.typ)])]);
                            var slots$prime = $$Array.copy(slots);
                            Caml_array.caml_array_set(slots$prime, bi, {
                                  typ: type_union(Caml_array.caml_array_get(slots, bi).typ, bool_t),
                                  value: test
                                });
                            var s_n2i = pe_state.n2i;
                            var s_i2f = pe_state.i2f;
                            var s_reached = pe_state.reached;
                            var s_bb_count = pe_state.bb_count;
                            var s = {
                              n2i: s_n2i,
                              i2f: s_i2f,
                              slots: slots$prime,
                              reached: s_reached,
                              bb_count: s_bb_count
                            };
                            return $great$great({
                                        run_state: (function (param) {
                                            return /* tuple */[
                                                    undefined,
                                                    s
                                                  ];
                                          })
                                      }, specialise_instrs(blocks, xs));
                          }
                          catch (exn){
                            if (exn === NonStaticTypeCheck) {
                              return $great$great$eq(specialise_instrs(blocks, xs), (function (tl) {
                                            var a = /* :: */[
                                              instr,
                                              tl
                                            ];
                                            return {
                                                    run_state: (function (s) {
                                                        return /* tuple */[
                                                                a,
                                                                s
                                                              ];
                                                      })
                                                  };
                                          }));
                            }
                            throw exn;
                          }
                        }
                        return $great$great$eq(specialise_instrs(blocks, xs), (function (tl) {
                                      var a = /* :: */[
                                        instr,
                                        tl
                                      ];
                                      return {
                                              run_state: (function (s) {
                                                  return /* tuple */[
                                                          a,
                                                          s
                                                        ];
                                                })
                                            };
                                    }));
                      }));
        } else {
          return Pervasives.failwith("TODO");
        }
    
  }
  return $great$great$eq(specialise_bb(blocks, lbl), (function (lbl) {
                var a_000 = /* Goto */Block.__(1, [lbl]);
                var a = /* :: */[
                  a_000,
                  /* [] */0
                ];
                return {
                        run_state: (function (s) {
                            return /* tuple */[
                                    a,
                                    s
                                  ];
                          })
                      };
              }));
}

function specialise(param, f_defs) {
  var match = param.func_entry;
  var mk = function (param) {
    return List.map((function (param) {
                  return {
                          typ: param[1],
                          value: /* D */Block.__(1, [param[0]])
                        };
                }), param);
  };
  var ns = Pervasives.$at(match.args, Pervasives.$at(match.kwargs, Pervasives.$at(match.closure, match.other_bounds)));
  var n2i = List.mapi((function (i, param) {
          return /* tuple */[
                  param[0],
                  i
                ];
        }), ns);
  var states = $$Array.of_list(mk(ns));
  var init_state_reached = M_state.empty;
  var init_state_bb_count = {
    contents: 0
  };
  var init_state = {
    n2i: n2i,
    i2f: f_defs,
    slots: states,
    reached: init_state_reached,
    bb_count: init_state_bb_count
  };
  var m = specialise_bb(param.body, /* tuple */[
        0,
        "entry"
      ]);
  var match$1 = Curry._1(m.run_state, init_state);
  return List.map((function (param) {
                var match = param[1];
                return /* tuple */[
                        match[0],
                        Darray$Jit.to_list(match[1])
                      ];
              }), Curry._1(M_state.bindings, match$1[1].reached));
}

exports.scope_of = scope_of;
exports.unwrap_scope = unwrap_scope;
exports.MState = MState;
exports.M_state = M_state;
exports.M_int = M_int;
exports.type_union = type_union;
exports.bool_t = bool_t;
exports.type_of_const = type_of_const;
exports.NonStaticTypeCheck = NonStaticTypeCheck;
exports.type_less = type_less;
exports.flip = flip;
exports.sequence = sequence;
exports.specialise_bb = specialise_bb;
exports.specialise_instrs = specialise_instrs;
exports.specialise = specialise;
/* M_state Not a pure module */
