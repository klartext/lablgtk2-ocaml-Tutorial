(* $Id: scrolledwin.ml,v 1.1 2004/07/30 07:01:42 shoh Exp $ *)
(* file: scrolledwin.ml *)

let main () =
  (* Create a new dialog window for the scrolled window to be
   * packed into. *)
  let window = GWindow.dialog ~title:"ScrolledWindow example" ~width:300 ~height:300 ~border_width:0 () in
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create a new scrolled window *)
  let scrolled_window = GBin.scrolled_window ~border_width:10
    ~hpolicy:`AUTOMATIC ~vpolicy:`AUTOMATIC ~packing:window#vbox#add () in

  (* Create a table of 10 by 10 squares.
   * Set the spacing to 10 on x and 10 on y *)
  let table = GPack.table ~rows:10 ~columns:10 ~row_spacings:10 ~col_spacings:10
    ~packing:scrolled_window#add_with_viewport () in

  for i = 0 to 10 do
    for j=0 to 10 do
      ignore (GButton.toggle_button
        ~label:("button ("^ string_of_int i ^","^ string_of_int j ^")\n")
        ~packing:(table#attach ~left:i ~top:j ~expand:`BOTH) ())
    done
  done;

  (* Add a "close" button to the bottom of the dialog *)
  let button = GButton.button ~label:"close" ~packing:window#action_area#add () in
  ignore (button#connect#clicked ~callback:(window#destroy));

  (* This grabs this button to be the default button. Simply hitting
   * the "Enter" key will cause this button to activate. *)
  button#grab_default ();

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
