class Main {
    i : IO <- new IO;
    main () : Object { i.out_string("Hello World!\n") };
    (* main 메소드의 return 값이 object임. object는 루트 타입이라 가능함. *)
};