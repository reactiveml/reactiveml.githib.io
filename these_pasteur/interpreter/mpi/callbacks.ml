
open Runtime_options

module type S = sig
  type tag
  type msg
  type msg_queue
  type dispatcher

  type callback = msg -> unit
  type callback_kind = Once | Forever

  val mk_queue : unit -> msg_queue
  val dispatch_all : msg_queue -> dispatcher -> tag -> msg option
  val recv_given_msg : msg_queue -> tag -> msg
  val recv_n_given_msg : msg_queue -> tag -> int -> unit
  val dispatch_given_msg : msg_queue -> dispatcher -> tag -> unit
  val await_new_msg : msg_queue -> unit

  val add_callback : ?kind:callback_kind -> tag -> callback -> dispatcher -> unit
  val remove_callback : tag -> dispatcher -> unit

  val mk_dispatcher : unit -> dispatcher
  val start_receiving : msg_queue -> unit
  val stop_receiving : msg_queue -> unit
end

module Make (C : Communication.S) = struct
  module MyMap = Map.Make(struct
    type t = C.gid C.tag
    let compare = compare
  end)

  type tag = C.gid C.tag
  type msg = C.msg
  type msg_queue = {
    mutable q_alive : bool;
    q_mutex : Mutex.t;
    q_queue_filled : Condition.t;
    mutable q_queue : (tag * msg) list;
    mutable q_thread : Thread.t option;
  }

  type callback = C.msg -> unit
  type callback_kind = Once | Forever
  type dispatcher = {
    mutable d_handlers : (callback * callback_kind) MyMap.t;
    d_mutex : Mutex.t;
  }

  let mk_dispatcher () = {
    d_handlers = MyMap.empty;
    d_mutex = Mutex.create ();
  }

  let add_callback ?(kind=Forever) tag f d =
    d.d_handlers <- MyMap.add tag (f, kind) d.d_handlers

  let remove_callback tag d =
    d.d_handlers <- MyMap.remove tag d.d_handlers

  let call_callback d tag s =
    try
      let f, kind = MyMap.find tag d.d_handlers in
        if kind = Once then
          d.d_handlers <- MyMap.remove tag d.d_handlers;
        IFDEF RML_DEBUG THEN
          print_debug "Calling callback for tag: %a@." C.print_tag tag
        ELSE () END;
        f s
    with
      | Not_found ->
          IFDEF RML_DEBUG THEN
            print_debug "%a: Received unexpected tag: %a@." C.print_here () C.print_tag tag
          ELSE () END

  let mk_queue () =
  { q_alive = true;
    q_mutex = Mutex.create ();
    q_queue = [];
    q_queue_filled = Condition.create ();
    q_thread = None }

  let is_empty q =
    Mutex.lock q.q_mutex;
    let b = q.q_queue = [] in
    Mutex.unlock q.q_mutex;
    b

  let await_new_msg q =
    Mutex.lock q.q_mutex;
    if q.q_queue = [] then
      Condition.wait q.q_queue_filled q.q_mutex;
    Mutex.unlock q.q_mutex

  let print_queue ff q =
    List.iter (fun (tag, _) -> Format.fprintf ff "   %a" C.print_tag tag) q.q_queue;
    Format.fprintf ff "@."

  let dispatch_all q d stop_tag =
    let rec process_msgs l = match l with
      | [] -> None
      | (tag, msg)::l when tag = stop_tag ->
        Mutex.lock q.q_mutex;
        q.q_queue <- q.q_queue @ (List.rev l);
        Mutex.unlock q.q_mutex;
        Some msg
      | (tag, msg)::l -> call_callback d tag msg; process_msgs l
    in
    Mutex.lock q.q_mutex;
    let l = List.rev q.q_queue in
    q.q_queue <- [];
    Mutex.unlock q.q_mutex;
    process_msgs l

  let recv_given_msg q tag =
    let rec aux () =
      if q.q_queue = [] then
        Condition.wait q.q_queue_filled q.q_mutex;
      IFDEF RML_DEBUG THEN
        print_debug "Looking for requested tag '%a' @." C.print_tag tag
      ELSE () END;
      let found, others = List.partition (fun (t,_) -> t = tag) q.q_queue in
      match found with
        | [] ->
            IFDEF RML_DEBUG THEN print_debug "Message not there yet@." ELSE () END;
            (* wait for a new msg *)
            Condition.wait q.q_queue_filled q.q_mutex;
            aux ()
        | (_, msg)::_ -> (* found the awaited message *)
            q.q_queue <- others;
            msg
    in
    Mutex.lock q.q_mutex;
    let msg = aux () in
    Mutex.unlock q.q_mutex;
    IFDEF RML_DEBUG THEN
      print_debug "Received the awaited message with tag '%a'@." C.print_tag tag
    ELSE () END;
    msg

  let recv_n_given_msg q tag n =
    let counter = ref n in
    let rec aux () =
      if q.q_queue = [] then
        Condition.wait q.q_queue_filled q.q_mutex;
      IFDEF RML_DEBUG THEN
        print_debug "Looking for requested tag '%a' @." C.print_tag tag
      ELSE () END;
      let found, others = List.partition (fun (t,_) -> t = tag) q.q_queue in
      q.q_queue <- others;
      counter := !counter - (List.length found);
      if !counter <> 0 then (
        Condition.wait q.q_queue_filled q.q_mutex;
        aux ()
      )
    in
    Mutex.lock q.q_mutex;
    aux ();
    Mutex.unlock q.q_mutex;
    IFDEF RML_DEBUG THEN
      print_debug "Received the n awaited messages with tag '%a'@." C.print_tag tag
    ELSE () END

  let dispatch_given_msg q d tag =
    let rec aux () =
      if q.q_queue = [] then
        Condition.wait q.q_queue_filled q.q_mutex;
      IFDEF RML_DEBUG THEN
        print_debug "Looking for requested tag '%a' @." C.print_tag tag
      ELSE () END;
      let found, others = List.partition (fun (t,_) -> t = tag) q.q_queue in
      match found with
        | [] ->
            IFDEF RML_DEBUG THEN print_debug "Message not there yet@." ELSE () END;
            (* wait for a new msg *)
            Condition.wait q.q_queue_filled q.q_mutex;
            aux ()
        | _ -> (* found the awaited message *)
            q.q_queue <- others;
            found
    in
    Mutex.lock q.q_mutex;
    let found = aux () in
    Mutex.unlock q.q_mutex;
    List.iter (fun (tag, msg) -> call_callback d tag msg) found;
    IFDEF RML_DEBUG THEN
      print_debug "Received %d matching messages wit tag '%a'@." (List.length found)  C.print_tag tag
    ELSE () END

  let receive q =
    while q.q_alive do
      let tag, msg = C.receive () in
      Mutex.lock q.q_mutex;
     (* let was_empty = q.q_queue = [] in*)
      q.q_queue <- (tag, msg) :: q.q_queue;
      Mutex.unlock q.q_mutex;
(*      if was_empty then *)
      Condition.signal q.q_queue_filled
    done

  let start_receiving q =
    let t = Thread.create receive q in
    q.q_thread <- Some t

  let stop_receiving q =
    q.q_alive <- false;
    (* send dummy messsage to stop the receiving thread *)
    C.send (C.local_site ()) C.dummy_tag ();
    match q.q_thread with
      | None -> assert false
      | Some t -> Thread.join t
end


module MakeC (C : Communication.S) = struct
  module MyMap = Map.Make(struct
    type t = C.gid C.tag
    let compare = compare
  end)

  type tag = C.gid C.tag
  type msg = C.msg
  type msg_queue = {
    q_mpi_queue : Mpi_queue.msg_queue;
    mutable q_queue : (tag * msg) list;
  }

  type callback = C.msg -> unit
  type callback_kind = Once | Forever
  type dispatcher = {
    mutable d_handlers : (callback * callback_kind) MyMap.t;
    d_mutex : Mutex.t;
  }

  let mk_dispatcher () = {
    d_handlers = MyMap.empty;
    d_mutex = Mutex.create ();
  }

  let add_callback ?(kind=Forever) tag f d =
    d.d_handlers <- MyMap.add tag (f, kind) d.d_handlers

  let remove_callback tag d =
    d.d_handlers <- MyMap.remove tag d.d_handlers

  let call_callback d tag s =
    try
      let f, kind = MyMap.find tag d.d_handlers in
        if kind = Once then
          d.d_handlers <- MyMap.remove tag d.d_handlers;
        IFDEF RML_DEBUG THEN
          print_debug "Calling callback for tag: %a@." C.print_tag tag
        ELSE () END;
        f s
    with
      | Not_found ->
          IFDEF RML_DEBUG THEN
            print_debug "%a: Received unexpected tag: %a@." C.print_here () C.print_tag tag
          ELSE () END

  let mk_queue () =
    { q_mpi_queue = Mpi_queue.mk_queue ();
      q_queue = [] }

  let fetch_new_msgs q =
    let l = Mpi_queue.get q.q_mpi_queue in
    q.q_queue <- l @ q.q_queue;
    IFDEF RML_DEBUG THEN
      print_debug "Received %d new meesages, total length is %d@." (List.length l) (List.length q.q_queue)
    ELSE () END

  let await_new_msg q =
    if q.q_queue = [] then
      fetch_new_msgs q

  let print_queue ff q =
    List.iter (fun (tag, _) -> Format.fprintf ff "   %a" C.print_tag tag) q.q_queue;
    Format.fprintf ff "@."

  let dispatch_all q d stop_tag =
    let rec process_msgs l = match l with
      | [] -> None
      | (tag, msg)::l when tag = stop_tag ->
        Format.eprintf "Found messages with stop_tag and %d msgs remaining@." (List.length l); q.q_queue <- List.rev l; Some msg
      | (tag, msg)::l -> call_callback d tag msg; process_msgs l
    in
    Format.eprintf "Found messages@.";
    let l = List.rev q.q_queue in
    q.q_queue <- [];
    process_msgs l

  let recv_given_msg q tag =
    let rec aux () =
      await_new_msg q;
      IFDEF RML_DEBUG THEN
        print_debug "Looking for requested tag '%a' @." C.print_tag tag
      ELSE () END;
      let found, others = List.partition (fun (t,_) -> t = tag) q.q_queue in
      match found with
        | [] ->
            IFDEF RML_DEBUG THEN print_debug "Message not there yet@." ELSE () END;
            (* wait for a new msg *)
            fetch_new_msgs q;
            aux ()
        | (_, msg)::_ -> (* found the awaited message *)
            q.q_queue <- others;
            msg
    in
    let msg = aux () in
    IFDEF RML_DEBUG THEN
      print_debug "Received the awaited message with tag '%a', %d msgs in the queue@."
        C.print_tag tag (List.length q.q_queue)
    ELSE () END;
    msg

  let recv_n_given_msg q tag n =
    let counter = ref n in
    let rec aux () =
      await_new_msg q;
      IFDEF RML_DEBUG THEN
        print_debug "Looking for requested tag '%a' @." C.print_tag tag
      ELSE () END;
      let found, others = List.partition (fun (t,_) -> t = tag) q.q_queue in
      q.q_queue <- others;
      counter := !counter - (List.length found);
      if !counter <> 0 then (
        fetch_new_msgs q;
        aux ()
      )
    in
    aux ();
    IFDEF RML_DEBUG THEN
      print_debug "Received the n awaited messages with tag '%a'@." C.print_tag tag
    ELSE () END

  let dispatch_given_msg q d tag =
    let rec aux () =
      if q.q_queue = [] then
        await_new_msg q;
      IFDEF RML_DEBUG THEN
        print_debug "Looking for requested tag '%a' @." C.print_tag tag
      ELSE () END;
      let found, others = List.partition (fun (t,_) -> t = tag) q.q_queue in
      match found with
        | [] ->
            IFDEF RML_DEBUG THEN print_debug "Message not there yet@." ELSE () END;
            (* wait for a new msg *)
            fetch_new_msgs q;
            aux ()
        | _ -> (* found the awaited message *)
            q.q_queue <- others;
            found
    in
    let found = aux () in
    List.iter (fun (tag, msg) -> call_callback d tag msg) found;
    IFDEF RML_DEBUG THEN
      print_debug "Received %d matching messages wit tag '%a'@." (List.length found)  C.print_tag tag
    ELSE () END

  let start_receiving q =
    Mpi_queue.start_receiving q.q_mpi_queue Mpi_communication.msg_tag

  let stop_receiving q =
    Mpi_queue.stop_receiving q.q_mpi_queue
end
