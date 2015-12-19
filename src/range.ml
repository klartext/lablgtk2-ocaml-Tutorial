(* $Id: range.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: range.ml *)

let cb_pos_menu_select hscale vscale pos () =
  hscale#set_value_pos pos;
  vscale#set_value_pos pos
  
let cb_update_menu_select hscale vscale policy () =
  hscale#set_update_policy policy;
  vscale#set_update_policy policy
  
let cb_digits_scale hscale vscale adj () =
  hscale#set_digits (int_of_float adj#value);
  vscale#set_digits (int_of_float adj#value)

let clamp x low high =
  if x > high then high
  else if x < low then low
  else x

let cb_page_size get (set: GData.adjustment) () =
  (* Set the page size and page increment size of the sample
   * adjustment to the value specified by the "Page Size" scale *)
  let v = get#value in
  set#set_bounds ~page_incr:v ~page_size:v ();

  (* This sets the adjustment and makes it emit the "chagnged" signal to
   * reconfigure all the widgets that are attatched to this signal. *)
   set#set_value (clamp set#value set#lower (set#upper -. set#page_size))

let cb_draw_value button hscale vscale () =
  hscale#set_draw_value button#active;
  vscale#set_draw_value button#active

let make_menu_item ~label ~packing ~callback =
  let item = GMenu.menu_item ~label ~packing () in
  ignore (item#connect#activate ~callback)

let create_range_controls () =
  (* Standard window-creating stuff *)
  let window = GWindow.window ~title:"Range controls" ~border_width:20 () in
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  let box1 = GPack.vbox ~packing:window#add () in
  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in

  (* Note that the page_size value only makes a difference for
   * scrollbar widgets, and the highest value you'll get is actually
   * (upper - page_size). *)
  let adj1 = GData.adjustment ~value:0.0 ~lower:0.0 ~upper:101.0
    ~step_incr:0.1 ~page_incr:1.0 ~page_size:1.0 ()
  in
  let vscale = GRange.scale `VERTICAL ~adjustment:adj1 ~packing:box2#add () in

  let box3 = GPack.vbox ~packing:box2#add () in

  (* Reuse the same adjustment *)
  let hscale = GRange.scale `HORIZONTAL ~adjustment:adj1 ~packing:box3#add () in

  (* Reuse the same adjustment again.
   * Default update_policy is `CONTINUOUS.
   * Notice the scales always be updated continuously
   * when the scrollbar is moved *)
  let scrollbar = GRange.scrollbar `HORIZONTAL ~adjustment:adj1
    ~packing:box3#add ()
  in

  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in

  (* A checkbutton to control whether the value is displayed or not *)
  let button = GButton.check_button ~label:"Display value on scale widgets"
    ~active:true ~packing:box2#add ()
  in
  ignore (button#connect#toggled ~callback:(cb_draw_value button hscale vscale));

  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in
  let label = GMisc.label ~text:"Scale Value Position:" ~packing:box2#add () in

  let opt = GMenu.option_menu ~packing:box2#add () in
  let menu = GMenu.menu ~packing:opt#set_menu () in
  let f (label, pos) =
    make_menu_item ~label ~packing:menu#append
	  ~callback:(cb_pos_menu_select hscale vscale pos)
  in
  List.iter f [("Top", `TOP); ("Bottom", `BOTTOM); ("Left", `LEFT);
    ("Right", `RIGHT)];

  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in
  (* Yet another option menu, this time for the update policy of the
   * scale widgets *)
  let label = GMisc.label ~text:"Scale Update Policy:" ~packing:box2#add () in
  let opt = GMenu.option_menu ~packing:box2#add () in
  let menu = GMenu.menu ~packing:opt#set_menu () in
  let f (label, policy) =
    make_menu_item ~label ~packing:menu#append
	  ~callback:(cb_update_menu_select hscale vscale policy)
  in
  List.iter f [("Continuous", `CONTINUOUS); ("Discontinuous", `DISCONTINUOUS);
    ("Delayed", `DELAYED)];

  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in
  let label = GMisc.label ~text:"Scale Digits:" ~packing:box2#add () in

  let adj2 = GData.adjustment ~value:1.0 ~lower:0.0 ~upper:5.0
    ~step_incr:1.0 ~page_incr:1.0 ~page_size:0.0 ()
  in
  ignore (adj2#connect#value_changed ~callback:(cb_digits_scale hscale vscale adj2));

  let scale = GRange.scale `HORIZONTAL ~adjustment:adj2
    ~digits:0 ~packing:box2#add ()
  in

  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in
  (* And, one last Horizontal Scale widget for adjusting the page size of the
   * scrollbar *)
  let label = GMisc.label ~text:"Scrollbar Page Size:" ~packing:box2#add () in

  let adj2 = GData.adjustment ~value:1.0 ~lower:0.0 ~upper:101.0
    ~step_incr:1.0 ~page_incr:1.0 ~page_size:0.0 ()
  in
  ignore (adj2#connect#value_changed ~callback:(cb_page_size adj2 adj1));
  let scale = GRange.scale `HORIZONTAL ~adjustment:adj2
    ~digits:0 ~packing:box2#add ()
  in

  let separator = GMisc.separator `HORIZONTAL ~packing:box1#add () in

  let box2 = GPack.hbox ~border_width:10 ~packing:box1#add () in
  let button = GButton.button ~label:"Quit" ~packing:box2#add () in
  ignore (button#connect#clicked ~callback:GMain.quit);
  button#misc#set_can_default true;
  button#misc#grab_default ();
  window#show ()

let main () =
  create_range_controls ();
  GMain.Main.main ()

let _ = Printexc.print main ()
