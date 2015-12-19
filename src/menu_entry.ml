(* $Id: menu_entry.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: menu_entry.ml *)

let print msg () =
  print_endline msg;
  flush stdout

let print_toggle selected =
  if selected
  then print_endline "On"
  else print_endline "Off";
  flush stdout

let print_selected n selected =
  if selected then (
    print_endline (string_of_int n);
    flush stdout
  )

let file_entries = [
  `I ("New", print "New");
  `I ("Open", print "Open");
  `I ("Save", print "Save");
  `I ("Save As", print "Save As");
  `S;
  `I ("Quit", GMain.Main.quit)
]

let option_entries = [
  `C ("Check", false, print_toggle);
  `S;
  `R [("Rad1", true, print_selected 1);
      ("Rad2", false, print_selected 2);
      ("Rad3", false, print_selected 3)]
]

let help_entries = [
  `I ("About", print "About");
]

let entries = [
  `M ("File", file_entries);
  `M ("Options", option_entries);
  `M ("Help", help_entries)
]

let create_menu label menubar =
  let item = GMenu.menu_item ~label ~packing:menubar#append () in
  GMenu.menu ~packing:item#set_submenu ()

let main () =
  (* Make a window *)
  let window = GWindow.window ~title:"Menu Entry" ~border_width:10 () in
  ignore (window#connect#destroy ~callback:GMain.Main.quit);
  
  let main_vbox = GPack.vbox ~packing:window#add () in

  let menubar = GMenu.menu_bar ~packing:main_vbox#add () in

  let menu = create_menu "File" menubar in
  GToolbox.build_menu menu ~entries:file_entries;

  let menu = create_menu "Options" menubar in
  GToolbox.build_menu menu ~entries:option_entries;

  let menu = create_menu "Help" menubar in
  GToolbox.build_menu menu ~entries:help_entries;

  (* Popup menu *)
  let button = GButton.button ~label:"Popup" ~packing:main_vbox#add () in
  ignore (button#connect#clicked ~callback:(fun () ->
    GToolbox.popup_menu ~entries ~button:0
	  ~time:(GtkMain.Main.get_current_event_time ())
    ));

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
