class Main inherits IO {
    sum (n : Int) : Int {
        if n = 0 then 0
        else n + sum(n-1)
        fi
    };

    main () : Object {
        let num : Int in {
            out_string("Input: ");
            num <- in_int();
            out_int(sum(num));
            out_string("\n");
        }
    };
};