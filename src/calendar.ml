(* $Id: calendar.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: calendar.ml *)

type signals =
  { mutable last_sig: GMisc.label;
    mutable prev_sig: GMisc.label;
    mutable prev2_sig: GMisc.label
  }

let signals =
  let label = GMisc.label () in
  { last_sig = label;
    prev_sig = label;
    prev2_sig = label }

let set_signal_strings string =
  signals.prev2_sig#set_text signals.prev_sig#text;
  signals.prev_sig#set_text signals.last_sig#text;
  signals.last_sig#set_text string

let show_signal calendar msg () =
  let (y, m, d) = calendar#date in
  let str = Printf.sprintf "%s: %d/%d/%d" msg y m d in
  set_signal_strings str

let toggle_flags calendar but_flags () =
  let rec loop bflags =
    match bflags with
    | [] -> []
    | (but, flag)::rest ->
      if but#active
      then flag :: loop rest
      else loop rest
  in
  let flags = loop but_flags in
  calendar#display_options flags

let font_selection_ok font_window calendar () =
  let font_name = font_window#selection#font_name in
  let font_desc = GPango.font_description font_name in
  calendar#misc#modify_font font_desc

let select_font calendar () =
  let fwin = GWindow.font_selection_dialog ~title:"Font Selection Dialog" ~modal:true ~position:`MOUSE () in
  ignore (fwin#connect#destroy ~callback:fwin#destroy);
  ignore (fwin#ok_button#connect#clicked ~callback:(font_selection_ok fwin calendar));
  ignore (fwin#cancel_button#connect#clicked ~callback:fwin#destroy);
  fwin#show ()

let flags = [("Show Heading", true, `SHOW_HEADING);
    ("Show Day Names", true, `SHOW_DAY_NAMES);
    ("No Month Change", false, `NO_MONTH_CHANGE);
    ("Show Week Numbers", false, `SHOW_WEEK_NUMBERS);
    ("Week Start Monday", false, `WEEK_START_MONDAY)]

let create_calendar () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Calendar Example" ~resizable:false ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  let vbox = GPack.vbox ~border_width:10 ~packing:window#add () in

  (* The top part of the window, Calendar, flags and fontsel. *)
  let hbox = GPack.hbox ~packing:vbox#add () in
  let hbbox = GPack.button_box `HORIZONTAL ~layout:`SPREAD ~spacing:5 ~packing:hbox#add () in

  (* Calendar widget *)
  let frame = GBin.frame ~packing:hbbox#add () in
  let calendar = GMisc.calendar ~packing:frame#add () in
  calendar#mark_day 19;
  ignore (calendar#connect#month_changed ~callback:(show_signal calendar "month_changed"));
  ignore (calendar#connect#day_selected ~callback:(show_signal calendar "day_selected"));
  ignore (calendar#connect#day_selected_double_click ~callback:(show_signal calendar "day_selected_double_click"));
  ignore (calendar#connect#prev_month ~callback:(show_signal calendar "prev_month"));
  ignore (calendar#connect#next_month ~callback:(show_signal calendar "next_month"));
  ignore (calendar#connect#prev_year ~callback:(show_signal calendar "prev_year"));
  ignore (calendar#connect#next_year ~callback:(show_signal calendar "next_year"));

  let separator = GMisc.separator `VERTICAL ~packing:hbox#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in

  (* Build the Right frame with the flags in *)
  let frame = GBin.frame ~label:"Flags" ~packing:vbox2#add () in
  let vbox3 = GPack.vbox ~packing:frame#add () in
  let toggle_button (label, active, flag) =
    (GButton.check_button ~label ~active ~packing:vbox3#add (), flag) in
  let flag_buttons = List.map toggle_button flags in
  let set_flag_cb (but, _) =
    but#connect#toggled ~callback:(toggle_flags calendar flag_buttons);
    ()
  in
  List.iter set_flag_cb flag_buttons;

  (* Build the right font-button *)
  let button = GButton.button ~label:"Font..." ~packing:vbox2#add () in
  ignore (button#connect#clicked ~callback:(select_font calendar));

  (* Build the Signal-event part. *)
  let frame = GBin.frame ~label:"Signal events" ~packing:vbox#add () in
  let vbox2 = GPack.vbox ~packing:frame#add () in

  let hbox = GPack.hbox ~packing:vbox2#add () in
  let label = GMisc.label ~text:"Signal: " ~packing:hbox#add () in
  signals.last_sig <- GMisc.label ~packing:hbox#add ();

  let hbox = GPack.hbox ~packing:vbox2#add () in
  let label = GMisc.label ~text:"Previous signal: " ~packing:hbox#add () in
  signals.prev_sig <- GMisc.label ~packing:hbox#add ();

  let hbox = GPack.hbox ~packing:vbox2#add () in
  let label = GMisc.label ~text:"Second previous signal: " ~packing:hbox#add () in
  signals.prev2_sig <- GMisc.label ~packing:hbox#add ();

  let bbox = GPack.button_box `HORIZONTAL ~layout:`END ~packing:vbox#add () in
  let button = GButton.button ~label:"Close" ~packing:bbox#add () in
  ignore (button#connect#clicked ~callback:GMain.Main.quit);

  button#misc#set_can_default true;
  button#misc#grab_default ();

  window#show ()

let main () =
  create_calendar ();

  (* Enter the event loop *)
  GMain.Main.main ()

let _ = Printexc.print main ()
