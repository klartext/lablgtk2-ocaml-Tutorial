(* $Id: button.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file:button.ml *)

open GMain

(* Create a new hbox with an image and a label packed into it
 * and return the box *)
let xpm_label_box ~file ~text ~packing () =
  if not (Sys.file_exists file) then failwith (file ^ " does not exist");

  (* Create box for image and label and pack *)
  let box = GPack.hbox ~border_width:2 ~packing () in

  (* Now on to the image stuff and pack into box *)
  let pixmap = GDraw.pixmap_from_xpm ~file () in
  ignore (GMisc.pixmap pixmap ~packing:(box#pack ~padding:3) ());

  (* Create a label for the button and pack into box *)
  GMisc.label ~text ~packing:(box#pack ~padding:3) ()

let main () =
  (* Create a new window; set title and border_width *)
  let window = GWindow.window ~title:"Pixmap'd Buttons!" ~border_width:10 () in

  (* It's a good idea to do this for all windows. *)
  ignore (window#connect#destroy ~callback:Main.quit);
  ignore (window#event#connect#delete ~callback:(fun _ -> Main.quit (); true));

  (* Create a new button and pack *)
  let button = GButton.button ~packing:window#add () in

  (* Connect the "clicked" signal of the button to callback *)
  ignore (button#connect#clicked ~callback:
    (fun () -> print_endline "Hello again - cool button was pressed"));

  (* Create box with xpm and label *)
  ignore (xpm_label_box ~file:"info.xpm" ~text:"cool button" ~packing:button#add ());

  (* Show the window and wait for the fun to begin! *)
  window#show ();
  Main.main ()

let _ = main ()
