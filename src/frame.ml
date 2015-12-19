(* $Id: frame.ml,v 1.1 2004/07/30 06:36:59 shoh Exp $ *)
(* file: frame.ml *)

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Frame Example" ~width:300 ~height:300 ~border_width:10 () in

  (* Here we connect the "destroy" event to a signal handler *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create a Frame
   * Set the frame's label
   * Align the label at the right of the frame
   * Set the style of the frame *)
  let frame = GBin.frame ~label:"Frame Widget" ~label_xalign:1.0 ~shadow_type:`ETCHED_OUT ~packing:window#add () in

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
