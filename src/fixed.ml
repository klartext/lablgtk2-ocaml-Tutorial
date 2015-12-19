(* $Id: fixed.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* filename: fixed.ml *)

(* Global variables to store the position of the widget
 * within the fixed container *)
let rx = ref 50
let ry = ref 50

(* This callback function moves the button to a new position
 * in the Fixed container. *)
let move_button but fixed () =
  rx := (!rx + 30) mod 300;
  ry := (!ry + 50) mod 300;
  fixed#move but#coerce ~x:!rx ~y:!ry

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Fixed Container" ~border_width:10 () in

  (* Here we connect the "destroy" event to a signal handler *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create a Fixed Container *)
  let fixed = GPack.fixed ~packing:window#add () in

  for i = 1 to 3 do
    (* Creates a new button with the label "Press me"
     * and packs the button into the fixed containers window. *)
    let button = GButton.button ~label:"Press me"
	  ~packing:(fixed#put ~x:(i*50) ~y:(i*50)) ()
    in

    (* When the button receives the "clicked" signal, it will call the
     * function move_button passing it the Fixed Container as its
     * argument. *)
    ignore (button#connect#clicked ~callback:(move_button button fixed))
  done;

  (* Display the window and enter the event loop *)
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
