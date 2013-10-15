
type 'a step = 'a -> unit

module type SEQ_DATA_STRUCT =
sig
  type next
  type current
  type waiting_list

  (* functions on the current data structure *)
  val mk_current : unit -> current
  val exec_all_current : current -> unit
  val add_current : unit step -> current -> unit
  val add_current_list : unit step list -> current -> unit
  (* Adds all elements of a waiting list or next to current and empty it. *)
  val add_current_waiting_list : waiting_list -> current -> unit
  val add_current_next : next -> current -> unit

  val current_length : current -> int
  val waiting_length : waiting_list -> int

  (*functions on waiting list*)
  val mk_waiting_list : unit -> waiting_list
  val add_waiting : unit step -> waiting_list -> unit
  val take_all : waiting_list -> unit step list

  (* functions on next lists *)
  val mk_next : unit -> next
  val add_next : unit step -> next -> unit
  val add_next_next : next -> next -> unit
  val clear_next : next -> unit
  val is_empty_next : next -> bool
end


type ('step, 'clock) control_type =
    | Clock_domain of 'clock
    | Kill of Rml_types.pause_kind * 'step
    | Kill_handler of Rml_types.pause_kind * (unit -> 'step)
    | Susp
    | When



module type CONTROL_TREE_R =
sig
  type control_tree
  and clock_domain
  and clock
  type region

  type ('a, 'b) event
  type event_cfg
  module Event :
    (sig
      val new_evt_global: Rml_types.signal_kind -> 'b -> ('a -> 'b -> 'b) -> ('a, 'b) event
      val new_evt : clock_domain -> clock -> region ->
        Rml_types.signal_kind -> 'b -> ('a -> 'b -> 'b) -> clock option ->
        (('a, 'b) event -> unit step) -> unit step

      val status: ?only_at_eoi:bool -> ('a, 'b) event -> bool
      val value: ('a, 'b) event -> 'b
      val one: ('a, 'a list) event -> 'a
      val pre_status: ('a, 'b) event -> bool
      val pre_value: ('a, 'b) event -> 'b
      val last: ('a, 'b) event -> 'b
      val default: ('a, 'b) event -> 'b
      val emit: ('a, 'b) event -> 'a -> unit

      val clock : ('a, 'b) event -> clock
      val region_of_clock : clock -> region

      val cfg_present : ('a, 'b) event -> event_cfg
      val cfg_or : event_cfg -> event_cfg -> event_cfg
      val cfg_and : event_cfg -> event_cfg -> event_cfg
      val cfg_status: ?only_at_eoi:bool -> event_cfg -> bool
     end)

  type join_point
  module Join :
    (sig
        val new_join_point : int -> join_point
        val incr : join_point -> int -> unit
        (* Returns whether the join point counter has reached zero *)
        val decr : join_point -> bool
     end)

  (* functions on the control tree *)
  (* let f = create_control kind (fun f_k new_ctrl -> body new_ctrl f_k) f_k ctrl s (fun v -> .) in]
     f ()

     OR for partial application:

     let f = create_control kind (fun f_k new_ctrl -> body new_ctrl f_k) f_k ctrl in
     fun () ->
       let s = e () in
       f s (fun v -> .) ()
  *)
  val create_control : (unit step, clock) control_type ->
    ('a step -> control_tree -> unit step) -> 'a step -> control_tree -> clock_domain ->
    ('b, 'c) event -> ('c -> bool) -> unit step

  val create_control_evt_conf : (unit step, clock) control_type ->
    ('a step -> control_tree -> unit step) -> 'a step -> control_tree -> clock_domain ->
    event_cfg -> unit step

  (* various functions on the clock domain *)
  val is_eoi : clock_domain -> bool
  val control_tree : clock_domain -> control_tree
  val clock : clock_domain -> clock
  val top_clock : unit -> clock
  val new_clock_domain : clock_domain -> control_tree ->
    (clock_domain -> control_tree -> 'a step -> unit step) ->
    (int -> int * int) option -> int option -> 'a step -> unit step

  (* step scheduling *)
  exception Wait_again

  (** [on_current_instant cd f] executes 'f ()' during the current step of [cd]. *)
  val on_current_instant : clock_domain -> unit step -> unit
  (** [on_current_instant_list cd fl] executes the list of step functions [fl]
      during the current step of [cd]. *)
  val on_current_instant_list : clock_domain -> unit step list -> unit
  (** [on_next_instant ctrl f] executes 'f ()' during the next activation of [ctrl]. *)
  val on_next_instant : ?kind:Rml_types.pause_kind -> control_tree -> unit step -> unit
  (** [on_eoi cd f v] executes 'f v' during the eoi of cd. *)
  val on_eoi : clock -> unit step -> unit

  (** [on_event evt ctrl f] executes 'f ()' if evt is emitted and
      ctrl is active in the same step.
      It waits for the next activation of w otherwise,
      or if the call raises Wait_again *)
  val on_event : ('a, 'b) event -> control_tree -> unit step -> unit
  (** [on_event_cfg evt_cfg ctrl f] executes 'f ()' if evt_cfg is true and
      ctrl is active in the same step.
      It waits for the next activation of evt_cfg otherwise,
      or if the call raises Wait_again *)
  val on_event_cfg : event_cfg -> control_tree -> unit step -> unit
  (** [on_event_or_next evt f_w cd ctrl f_next] executes 'f_w ()' if
      evt is emitted before the end of instant of cd.
      Otherwise, executes 'f_next ()' during the next instant. *)
  val on_event_or_next : ('a, 'b) event -> unit step ->
    clock_domain -> control_tree -> unit step -> unit
 (** [on_event_cfg_or_next evt_cfg f_w cd ctrl f_next] executes 'f_w ()' if
      evt_cfg is true before the end of instant of cd.
      Otherwise, executes 'f_next ()' during the next instant. *)
  val on_event_cfg_or_next : event_cfg -> unit step ->
    clock_domain -> control_tree -> unit step -> unit

  (* scheduling *)
  val init : unit -> unit
  val get_top_clock_domain : unit -> clock_domain
  val react : clock_domain -> unit
  val set_paused : clock_domain -> 'a -> unit
  (** [step_clock_domain ctrl new_ctrl cd new_cd] creates the step
      function of the new clock domain [new_cd]. *)
(*  val step_clock_domain :
    control_tree -> control_tree -> clock_domain -> clock_domain -> unit -> unit *)


  (* Only for distributed runtimes *)
  val start_slave : unit -> 'a option
  val finalize_top_clock_domain : clock_domain -> unit
  val is_master : unit -> bool
end
