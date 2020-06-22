1. Function type representation: an integer
2. Split control flows at each callsite
3. Split control flows for each boolean         expression
        source:
            a = v istypeof t
            stmts
        generate:
            a = v istypeof t
            if a then
                assume v :: t
                stmts
            else
                stmts     
