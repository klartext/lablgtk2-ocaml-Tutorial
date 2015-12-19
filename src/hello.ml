(* $Id: hello.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file:hello.ml *)

(* This is a callback function. *)
let hello () =
  print_endline "Hello World";
  flush stdout

(* Another callback function.
 * If you return [false] in the "delete_event" signal handler,
 * GTK will emit the "destroy" signal. Returning [true] means
 * you don't want the window to be destroyed.
 * This is useful for popping up 'are you sure you want to quit?'
 * type dialogs. *)
let delete_event ev =
  print_endline "Delete event occurred";
  flush stdout;

  (* Change [true] to [false] and the main window will be destroyed with
   * a "delete event" *)
  true

let main () =
  (* Create a new window and sets the border width of the window. *)
  let window = GWindow.window ~border_width:10 () in

  (* When the window is given the "delete_event" signal (this is given
   * by the window manager, usually by the "close" option, or on the
   * titlebar), we ask it to call the delete_event () function
   * as defined above. *)
  ignore (window#event#connect#delete ~callback:delete_event);

  (* Here we connect the "destroy" event to a signal handler.  
   * This event occurs when we call window#destroy method
   * or if we return [false] in the "delete_event" callback. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Creates a new button with the label "Hello World".
   * and packs the button into the window (a gtk container). *)
  let button = GButton.button ~label:"Hello World" ~packing:window#add () in

  (* When the button receives the "clicked" signal, it will call the
   * function hello().  The hello() function is defined above. *)
  ignore (button#connect#clicked ~callback:hello);

  (* This will cause the window to be destroyed by calling
   * window#destroy () when "clicked".  Again, the destroy
   * signal could come from here, or the window manager. *)
  ignore (button#connect#clicked ~callback:window#destroy);

  (* The final step is to display the window. *)
  window#show ();

  (* All GTK applications must have a GMain.Main.main (). Control ends here
   * and waits for an event to occur (like a key press or
   * mouse event). *)
  GMain.Main.main ()

let _ = main ()

