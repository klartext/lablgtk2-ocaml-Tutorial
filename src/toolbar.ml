(* $Id: toolbar.ml,v 1.1 2004/07/31 03:56:12 shoh Exp $ *)
(* file: toolbar.ml *)

(* that's easy... when one of the buttons is toggled,
 * set the style of the toolbar accordingly *)
let radio_event toolbar style () =
  toolbar#set_style style

(* just check given toggle button and enable/disable
 * tooltips *)
let toggle_event toolbar button () =
  toolbar#set_tooltips button#active

let main () =
  (* Create a new window with a given title, and nice size *)
  let dialog = GWindow.dialog ~title:"Toolbar Tutorial" () in

  (* typically we quit if someone tries to close us *)
  ignore (dialog#connect#destroy ~callback:GMain.Main.quit);

  (* we neecd to realize the window because we use pixmaps for
   * items on the toolbar in the context of it *)
  dialog#misc#realize ();

  (* to make it nice we'll put the toolbar into the handle box,
   * so that it can be detached from the main window *)
  let handlebox = GBin.handle_box ~packing:dialog#vbox#add () in

  (* toolbar will be horizontal, with both icons and text, and
   * with 5pxl spaces between items and finally,
   * we'll also put it into our handlebox *)
  let toolbar = GButton.toolbar
    ~orientation:`HORIZONTAL
    ~style:`BOTH
    ~border_width:5 (* ~space_size:5 *)
    ~packing:handlebox#add () in

  (* we need icon for toolbar buttons *)
  let icon () =
    let info = GDraw.pixmap_from_xpm ~file:"gtk.xpm" () in
    (GMisc.pixmap info ())#coerce
  in

  (* our first item is "close" button *)
  let button = toolbar#insert_button
    ~text:"Close"
    ~tooltip:"Close this app"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:GMain.Main.quit () in
  toolbar#insert_space (); (* space after item *)

  (* now, lets make our radio buttons group... *)
  let icon_button = toolbar#insert_radio_button
    ~text:"Icon"
    ~tooltip:"Only icons in toolbar"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:(radio_event toolbar `ICONS) () in
  toolbar#insert_space ();

  (* following radio buttons refer to previous ones *)
  let text_button = toolbar#insert_radio_button
    ~text:"Text"
    ~tooltip:"Only texts in toolbar"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:(radio_event toolbar `TEXT) () in
  text_button#set_group icon_button#group;
  toolbar#insert_space ();

  let both_button = toolbar#insert_radio_button
    ~text:"Both"
    ~tooltip:"Icons and text in toolbar"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:(radio_event toolbar `BOTH) () in
  both_button#set_group text_button#group;
  both_button#set_active true;
  toolbar#insert_space ();

  (* here we have just a simple toggle button *)
  let tooltip_button = toolbar#insert_toggle_button
    ~text:"Tooltips"
    ~tooltip:"Toolbar with or without tips"
    ~tooltip_private:"Private"
    ~icon:(icon ()) () in
  ignore (tooltip_button#connect#clicked ~callback:(toggle_event toolbar tooltip_button));
  tooltip_button#set_active true;
  toolbar#insert_space ();

  (* to pack a widget into toolbar, we only have to
   * create it and append it with appropriate tooltip *)
  let entry = GEdit.entry () in
  toolbar#insert_widget 
    ~tooltip:"This is just an entry"
    ~tooltip_private:"Private"
    entry#coerce;

  (* that's it! let's show everything *)
  dialog#show ();
  (* rest in GMain.Main.main () and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = Printexc.print main ()
