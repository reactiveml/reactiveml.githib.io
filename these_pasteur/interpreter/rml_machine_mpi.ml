open Rml_machine
open Runtime_options
open Runtime

module type INTERPRETER =
  sig
    type 'a process
    type ('a, 'b) event

    module R : (sig
      type clock_domain
      type ('a, 'b) event

      val init : unit -> unit
      val get_top_clock_domain : unit -> clock_domain
      val finalize_top_clock_domain : clock_domain -> unit
      val react : clock_domain -> unit
      val on_current_instant : clock_domain -> unit step -> unit

      val is_master : unit -> bool
      val start_slave : unit -> 'a option
    end)

    val rml_make: R.clock_domain -> 'a option ref -> 'a process -> unit step
    val rml_make_n: R.clock_domain -> 'a option ref -> 'a process list -> unit step list
  end

module Machine (I : INTERPRETER) =
struct
  module T = Rmltest_mpi.Test(Mpi_communication.Test)

  module MyInterpreter = struct
    type 'a process = 'a I.process

    let finalize_master start_t () =
      let cd = I.R.get_top_clock_domain () in
      I.R.finalize_top_clock_domain cd;
      if !Runtime_options.bench_mode then
        let end_t = Unix.gettimeofday () in
        Format.printf "%f@." (end_t -. start_t)

    let relaunch_done = ref false
    let finalize_slave () =
      if not !relaunch_done then (
        relaunch_done := true;
        ignore (I.R.start_slave ())
      )

    let init () =
      I.R.init ();
      if I.R.is_master () then (
        let start_t = Unix.gettimeofday () in
        at_exit (finalize_master start_t)
      ) else
        at_exit finalize_slave

    let rml_make p =
      if I.R.is_master () then (
        let result = ref None in
        let cd = I.R.get_top_clock_domain () in
        let step = I.rml_make cd result p in
        I.R.on_current_instant cd step;
        let react () =
          (*(Gc.print_stat stdout; print_newline(); print_newline ());*)
          I.R.react cd;
          !result
        in react
      ) else
        let react () =
          IFDEF RML_DEBUG THEN print_debug "Launching slave@." ELSE () END;
          I.R.start_slave ()
        in react

    let rml_make_test test_list =
      if I.R.is_master () then (
        let result = ref None in
        let cd = I.R.get_top_clock_domain () in
        let mk_test (p, name, expected) =
          let act = T.new_test name expected in
          p act
        in
        let pl = List.map mk_test test_list in
        let steps = I.rml_make_n cd result pl in
        List.iter (fun step -> I.R.on_current_instant cd step) steps;
        let react () =
          IFDEF RML_DEBUG THEN
            print_debug "@.********************* Doing one step@."
          ELSE () END;
          I.R.react cd;
          T.next_step ();
          !result
        in
        at_exit T.end_test;
        react
      ) else
        (fun _ -> I.R.start_slave ())

  end

  include M(MyInterpreter)
end

(*
module Lco_ctrl_tree_mpi_interpreter = struct
  module Interpreter = Lco_ctrl_tree_n.Rml_interpreter(Distributed_runtime_old.MpiRuntime)
  module Machine = Machine(Interpreter)
end

module Lco_ctrl_tree_mpi_buffer_interpreter = struct
  module Interpreter = Lco_ctrl_tree_n.Rml_interpreter(Distributed_runtime_old.MpiBufferedRuntime)
  module Machine = Machine(Interpreter)
end

module Lco_ctrl_tree_mpi_c_interpreter = struct
  module Interpreter = Lco_ctrl_tree_n.Rml_interpreter(Distributed_runtime_old.MpiCRuntime)
  module Machine = Machine(Interpreter)
end
*)

module Lco_ctrl_tree_mpi_new_interpreter = struct
  module Interpreter = Lco_ctrl_tree_n.Rml_interpreter(Distributed_runtime.MpiCRuntime)
  module Machine = Machine(Interpreter)
end
