class Main {
    i : IO <- new IO;
    main () : Int { { i.out_string("Hello World!\n"); 1; } };
    (* main 메소드의 return 값이 Int이기 때문에 1;이 필수로 있어야 함.
       out_string만 있으면 안됌. *)
};