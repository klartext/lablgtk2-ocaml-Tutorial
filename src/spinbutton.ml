(* $Id: spinbutton.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: spinbutton.ml *)

let toggle checkbutton f () = f checkbutton#active

let get_value spinner label show_type () =
  let text =
    match show_type with
    | `INT -> Printf.sprintf "%d" spinner#value_as_int
    | _ -> Printf.sprintf "%0.*f" spinner#digits spinner#value
  in
  label#set_text text

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Spin Button" ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  let main_vbox = GPack.vbox ~border_width:10 ~packing:window#add () in

  let frame = GBin.frame ~label:"Not accelerated" ~packing:main_vbox#add () in
  let vbox = GPack.vbox ~border_width:5 ~packing:frame#add () in

  (* Day, month, year spinners *)
  let hbox = GPack.hbox ~packing:vbox#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Day :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:1.0 ~lower:1.0 ~upper:31.0 ~step_incr:1.0 ~page_incr:5.0 ~page_size:0.0 () in
  let spinner = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~wrap:true ~packing:vbox2#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Month :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:1.0 ~lower:1.0 ~upper:12.0 ~step_incr:1.0 ~page_incr:5.0 ~page_size:0.0 () in
  let spinner = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~wrap:true ~packing:vbox2#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Year :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:1998.0 ~lower:0.0 ~upper:2100.0 ~step_incr:1.0 ~page_incr:100.0 ~page_size:0.0 () in
  let spinner = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~wrap:false ~width:55 ~packing:vbox2#add () in

  let frame = GBin.frame ~label:"Accelerated" ~packing:main_vbox#add () in
  let vbox = GPack.vbox ~border_width:5 ~packing:frame#add () in

  let hbox = GPack.hbox ~packing:vbox#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Value :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:0.0 ~lower:(-10000.0) ~upper:10000.0 ~step_incr:0.5 ~page_incr:100.0 ~page_size:0.0 () in
  let spinner1 = GEdit.spin_button ~adjustment:adj ~rate:1.0 ~digits:2 ~width:100 ~packing:vbox2#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Digits :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:2.0 ~lower:1.0 ~upper:5.0 ~step_incr:1.0 ~page_incr:1.0 ~page_size:0.0 () in
  let spinner2 = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~packing:vbox2#add () in
  ignore (adj#connect#value_changed ~callback:(fun () -> spinner1#set_digits spinner2#value_as_int));

  let button = GButton.check_button ~label:"Snap to 0.5-ticks" ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback:(toggle button spinner1#set_snap_to_ticks));
  let button = GButton.check_button ~label:"Numeric only input mode" ~active:true ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback:(toggle button spinner1#set_numeric));

  let hbox = GPack.hbox ~packing:vbox#add () in
  let val_label = GMisc.label ~text:"0" ~packing:vbox#add () in

  let button = GButton.button ~label:"Value as Int" ~packing:hbox#add () in
  ignore (button#connect#clicked ~callback:(get_value spinner1 val_label `INT));
  let button = GButton.button ~label:"Value as Float" ~packing:hbox#add () in
  ignore (button#connect#clicked ~callback:(get_value spinner1 val_label `FLOAT));

  let hbox = GPack.hbox ~packing:main_vbox#add () in
  let button = GButton.button ~label:"Close" ~packing:hbox#add () in
  ignore (button#connect#clicked ~callback:window#destroy);

  window#show ();

  (* Enter the event loop *)
  GMain.Main.main ()

let _ = Printexc.print main ()
