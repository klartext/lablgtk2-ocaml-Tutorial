(* $Id: statusbar.ml,v 1.1 2004/07/29 04:57:31 shoh Exp $ *)
(* file: statusbar.ml *)

let count = ref 0

let push_item context () =
  incr count;
  context#push (Printf.sprintf "item %d" !count);
  ()

let pop_item context () =
  context#pop ();
  ()

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Statusbar" () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  let vbox = GPack.vbox ~packing:window#add () in

  let statusbar = GMisc.statusbar ~packing:vbox#add () in
  let context = statusbar#new_context ~name:"Statusbar example" in

  let button = GButton.button ~label:"push item" ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback:(push_item context));

  let button = GButton.button ~label:"pop last item" ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback:(pop_item context));

  (* always display the window as the last step so it all splashes on
   * the screen at once. *)
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
