(* $Id: radiobutton.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: radiobutton.ml *)

open GMain

let main () =
  let window = GWindow.window ~title:"radio buttons" ~border_width:0 () in
  ignore (window#connect#destroy ~callback:Main.quit);

  let box1 = GPack.vbox ~packing:window#add () in

  let box2 = GPack.vbox ~spacing:10 ~border_width:10 ~packing: box1#add () in

  let button1 = GButton.radio_button ~label:"button1" ~packing: box2#add () in

  let button2 = GButton.radio_button ~group:button1#group ~label:"button2"
      ~active:true ~packing:box2#add () in

  let button3 = GButton.radio_button
      ~group:button1#group ~label:"button3" ~packing: box2#add () in

  let separator = GMisc.separator `HORIZONTAL ~packing: box1#pack () in

  let box3 = GPack.vbox ~spacing:10 ~border_width:10 ~packing:box1#pack () in

  let button = GButton.button ~label:"close" ~packing:box3#add () in
  ignore (button#connect#clicked ~callback:Main.quit);
  button#grab_default ();

  window#show ();
  Main.main ()

let _ = main ()
