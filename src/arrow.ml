(* $Id: arrow.ml,v 1.3 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: arrow.ml *)

(* Create an Arrow widget with the specified parameters
 * and pack in into a button *)
let create_arrow_button ~kind ~shadow ~packing () =
  let button = GButton.button ~packing () in
  let arrow = GMisc.arrow ~kind ~shadow ~packing:button#add () in
  button

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Arrow Buttons" ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create a box to hold the arrow/buttons *)
  let box = GPack.hbox ~border_width:2 ~packing:window#add () in

  let f (kind, shadow) =
    ignore (create_arrow_button ~kind ~shadow ~packing:box#add ())
  in
  List.iter f [(`UP, `IN); (`DOWN, `OUT); (`LEFT, `ETCHED_IN);
    (`RIGHT, `ETCHED_OUT) ];

  window#show ();
  (* Rest in main and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = Printexc.print main ()
