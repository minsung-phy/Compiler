(*
   The class A2I provides integer-to-string and string-to-integer
conversion routines.  To use these routines, either inherit them
in the class where needed, have a dummy variable bound to
something of type A2I, or simpl write (new A2I).method(argument).
*)


(*
   c2i   Converts a 1-character string to an integer.  Aborts
         if the string is not "0" through "9"
*)
class A2I {

     c2i(char : String) : Int {
        if char = "0" then 0 else
        if char = "1" then 1 else
        if char = "2" then 2 else
        if char = "3" then 3 else
        if char = "4" then 4 else
        if char = "5" then 5 else
        if char = "6" then 6 else
        if char = "7" then 7 else
        if char = "8" then 8 else
        if char = "9" then 9 else
        { abort(); 0; }  -- the 0 is needed to satisfy the typchecker
        fi fi fi fi fi fi fi fi fi fi
     };

(*
   i2c is the inverse of c2i.
*)
     i2c(i : Int) : String {
        if i = 0 then "0" else
        if i = 1 then "1" else
        if i = 2 then "2" else
        if i = 3 then "3" else
        if i = 4 then "4" else
        if i = 5 then "5" else
        if i = 6 then "6" else
        if i = 7 then "7" else
        if i = 8 then "8" else
        if i = 9 then "9" else
        { abort(); ""; }  -- the "" is needed to satisfy the typchecker
        fi fi fi fi fi fi fi fi fi fi
     };

(*
   a2i converts an ASCII string into an integer.  The empty string
is converted to 0.  Signed and unsigned strings are handled.  The
method aborts if the string does not represent an integer.  Very
long strings of digits produce strange answers because of arithmetic
overflow.

*)
     a2i(s : String) : Int {
        if s.length() = 0 then 0 else
        if s.substr(0,1) = "-" then ~a2i_aux(s.substr(1,s.length()-1)) else
        if s.substr(0,1) = "+" then a2i_aux(s.substr(1,s.length()-1)) else
           a2i_aux(s)
        fi fi fi
     };

(*
  a2i_aux converts the usigned portion of the string.  As a programming
example, this method is written iteratively.
*)
     a2i_aux(s : String) : Int {
        (let int : Int <- 0 in
           {
               (let j : Int <- s.length() in
                  (let i : Int <- 0 in
                    while i < j loop
                        {
                            int <- int * 10 + c2i(s.substr(i,1));
                            i <- i + 1;
                        }
                    pool
                  )
               );
              int;
            }
        )
     };

(*
    i2a converts an integer to a string.  Positive and negative
numbers are handled correctly.
*)
    i2a(i : Int) : String {
        if i = 0 then "0" else
        if 0 < i then i2a_aux(i) else
          "-".concat(i2a_aux(i * ~1))
        fi fi
    };

(*
    i2a_aux is an example using recursion.
*)
    i2a_aux(i : Int) : String {
        if i = 0 then "" else
            (let next : Int <- i / 10 in
                i2a_aux(next).concat(i2c(i - next * 10))
            )
        fi
    };

};

class List {
    item : String;
    next : List;

    -- 리스트를 초기화하는 메서드
    init (i : String, n : List) : List {
        {
            item <- i;
            next <- n;
            self;
        }
    };

    -- 리스트에 아이템을 추가하는 메서드
    cons (i : String) : List {
        (new List).init(i, self)
    };

    -- reverse 메서드를 누적 리스트와 함께 사용하여 역순으로 리스트를 구성
    reverse_helper(accum : List) : List {
        if (isvoid next) then 
            (new List).init(item, accum)  -- 누적 리스트에 마지막 요소 추가
        else 
            next.reverse_helper((new List).init(item, accum))  -- 현재 요소를 누적 리스트에 추가하면서 재귀 호출
        fi
    };

    reverse() : List {
        reverse_helper(new Nil)  -- 빈 리스트부터 시작해서 역순으로 누적
    };

    -- 리스트를 오름차순으로 정렬하는 메서드 (간단한 삽입 정렬)
    insert (i : String) : List {
        if (isvoid next) then
            (new List).init(i, new Nil)
        else
            if (item <= i) then 
                (new List).init(item, next.insert(i))
            else   
                (new List).init(i, self)
            fi
        fi
    };

    sort () : List {
        if (isvoid next) then   
            self
        else 
            next.sort().insert(item)
        fi
    };
    
    -- 리스트를 내림차순으로 정렬하는 메서드
    sort_descending() : List {
        sort().reverse() -- 오름차순으로 정렬한 후 뒤집음
    };

    -- 리스트를 flatten(문자열로 병합)하는 메서드
    flatten () : String {
        if (isvoid next) then 
            item
        else
            item.concat(" ").concat(next.flatten())
        fi
    }; 
};

class Nil inherits List {
    cons(i : String) : List {
        (new List).init(i, self)
    };

    reverse_helper(accum : List) : List {
        accum  -- 빈 리스트에 도달하면 누적된 리스트 반환
    };

    reverse() : List {
        self
    };

    insert(i : String) : List {
        (new List).init(i, self)
    };

    sort() : List {
        self
    };

    sort_descending() : List {
        self
    };

    flatten() : String {
        ""
    };
};

class Main inherits IO {
    main () : Object {
        let input : String, nil : List, l : List <- (new List).init("", nil), direction : String in {
            out_string("양수를 입력하세요. (그 외의 경우 입력 종료)\n");
            input <- in_string();
            while (0 < (new A2I).a2i(input)) loop {
                l <- l.cons(input);
                input <- in_string();
            } pool;

            out_string("y: 오름차순, n: 내림차순 : ");
            direction <- in_string();
            if direction = "y" then 
                out_string("정방향 : ".concat(l.sort().flatten()).concat("\n").concat("역방향 : ").concat(l.sort_descending().flatten()).concat("\n"))
            else 
                out_string("정방향 : ".concat(l.sort_descending().flatten()).concat("\n").concat("역방향 : ").concat(l.sort().flatten()).concat("\n"))
            fi;
        }
    };
};