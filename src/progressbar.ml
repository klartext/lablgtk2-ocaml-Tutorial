(* $Id: progressbar.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: progressbar.ml *)

let pulse_mode = ref false

(* Update the value of the progress bar so that we get
 * some movement *)
let progress_timeout pbar () =
  if !pulse_mode
  then pbar#pulse ()
  else (
    (* Calculate the value of the progress bar using the
    * value range set in the adjustment object *)
    let new_val =
      let v = pbar#fraction +. 0.01 in
      if v > 1.0 then 0.0 else v
    in
	pbar#set_fraction new_val
  );

  (* As this is a timeout function, return true so that it
   * continues to get called *)
  true

(* Callback that toggles the text display with the progress bar trough *)
let toggle_show_text pbar () =
  let text = pbar#text in
  if text = ""
  then pbar#set_text "some text"
  else pbar#set_text ""

(* Callback that toggles the activity mode of the progress bar *)
let toggle_activity_mode pbar () =
  pulse_mode := not !pulse_mode;
  if !pulse_mode
  then pbar#pulse ()
  else pbar#set_fraction 0.0

(* Callback that toggles the orientation of the progress bar *)
let toggle_orientation pbar () =
  match pbar#orientation with
  | `LEFT_TO_RIGHT -> pbar#set_orientation `RIGHT_TO_LEFT
  | `RIGHT_TO_LEFT -> pbar#set_orientation `LEFT_TO_RIGHT
  | _ -> ()

(* Remove timer and quit *)
let destroy_progress timer () =
  GMain.Timeout.remove timer;
  GMain.Main.quit ()

let main () =
  let window = GWindow.window ~title:"ProgressBar" () in

  let vbox = GPack.vbox ~border_width:10 ~packing:window#add () in

  (* Create a centering alignment object *)
  let align = GBin.alignment ~xalign:0.5 ~yalign:0.5
    ~xscale:0.0 ~yscale:0.0 ~packing:vbox#add ()
  in

  (* Create the progressbar *)
  let pbar = GRange.progress_bar ~packing:align#add () in

  (* Add a timer callback to update the value of the progress bar *)
  let timer = GMain.Timeout.add ~ms:100 ~callback:(progress_timeout pbar) in
  ignore (GMisc.separator `HORIZONTAL ~packing:vbox#add ());

  let table = GPack.table ~rows:3 ~columns:1 ~homogeneous:false
    ~packing:vbox#add ()
  in

  (* Add a check button to select displaying of trough text *)
  let check = GButton.check_button ~label:"Show text"
    ~packing:(table#attach ~left:0 ~top:0) ()
  in
  ignore (check#connect#clicked ~callback:(toggle_show_text pbar));
  
  (* Add a check button to toggle activity mode *)
  let check = GButton.check_button ~label:"Activity mode"
    ~packing:(table#attach ~left:0 ~top:1) ()
  in
  ignore (check#connect#clicked ~callback:(toggle_activity_mode pbar));

  (* Add a check button to toggle orientation *)
  let check = GButton.check_button ~label:"Right to Left"
    ~packing:(table#attach ~left:0 ~top:2) ()
  in
  ignore (check#connect#clicked ~callback:(toggle_orientation pbar));

  (* Add a buton to exit the program *)
  let button = GButton.button ~label:"Close" ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback:(destroy_progress timer));

  ignore (window#connect#destroy ~callback:(destroy_progress timer));
  window#show ();
  GMain.Main.main ()

let _ = main ()
