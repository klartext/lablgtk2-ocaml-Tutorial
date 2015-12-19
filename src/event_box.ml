(* $Id: event_box.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: event_box.ml *)

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Event Box" ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create an EventBox and add it to our toplevel window *)
  let event_box = GBin.event_box ~packing:window#add () in

  (* Create a long label *)
  let label = GMisc.label ~text:"Click here to quit, quit, quit, quit, quit"
    ~packing:event_box#add ()
  in

  (* Clip it short. *)
  label#misc#set_size_request ~width:110 ~height:20 () ;

  (* And bind an action to it *)
  event_box#event#add [`BUTTON_PRESS];
  ignore (event_box#event#connect#button_press ~callback:(fun ev -> exit 0; true));

  (* Yet one more thing you need an X window for ... *)
  event_box#misc#realize ();
  Gdk.Window.set_cursor event_box#misc#window (Gdk.Cursor.create `HAND1);

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
