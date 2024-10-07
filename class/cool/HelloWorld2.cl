class Main {
    i : IO <- new IO;
    main () : IO { i.out_string("Hello World!\n") };
    (* main 메소드의 return 값이 IO임. *)
};