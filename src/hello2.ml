(* $Id: hello2.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: hello2.ml *)

let clicked msg () =
  print_endline msg;
  flush stdout

let delete_event ev =
 GMain.Main.quit ();
 false

let main () =
  (* Create a new window and sets the border width and title of the window. *)
  let window = GWindow.window ~title:"Hello Buttons!" ~border_width:10 () in

  (* Here we just set a handler for delete_event that immediately
   * exits GTK. *)
  ignore (window#event#connect#delete ~callback:delete_event);

  (* We create a box to pack widgets into.  This is described in detail
   * in the "packing" section. The box is not really visible, it
   * is just used as a tool to arrange widgets.
   * And put the box into the main window. *)
  let box1 = GPack.hbox ~packing:window#add () in

  (* Creates a new button with the label "Button 1".
   * Instead of box1#add, we pack this button into the invisible
   * box, which has been packed into the window. *)
  let button = GButton.button ~label:"Button 1" ~packing:box1#pack () in
    
  (* Now when the button is clicked, we call the "clicked" function
   * with "button 1" as its argument *)
  ignore (button#connect#clicked ~callback:(clicked "button 1"));

  (* Do these same steps again to create a second button *)
  let button = GButton.button ~label:"Button 2" ~packing:box1#pack () in

  (* Call the same callback function with a different argument,
   * passing "button 2" instead. *)
  ignore (button#connect#clicked ~callback:(clicked "button 2"));

  (* Display the window. *)
  window#show ();

  (* Rest in GMain.Main.main and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = main ()

