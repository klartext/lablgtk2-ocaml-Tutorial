(* $Id: paned.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: paned.ml *)

let cols = new GTree.column_list
let str_col = cols#add Gobject.Data.string

(* Create the list of "messages" *)
let create_list () =
  (* Create a new scrolled window, with scrollbars only if needed *)
  let scrolled_window = GBin.scrolled_window
    ~hpolicy:`AUTOMATIC ~vpolicy:`AUTOMATIC () in

  let model = GTree.list_store cols in
  let treeview = GTree.view ~model ~packing:(scrolled_window#add_with_viewport) () in

  for i = 0 to 10 do
    let iter = model#append () in
	model#set ~row:iter ~column:str_col (Printf.sprintf "Message #%d" i)
  done;
  let renderer = GTree.cell_renderer_text [] in
  let column = GTree.view_column ~title:"Messages"
    ~renderer:(renderer, ["text", str_col]) () in
  ignore (treeview#append_column column);
  scrolled_window#coerce

(* Add some text to our text widget - this is a callback that is invoked
 * when our window is realized. We could also force our window to be
 * realized with #misc#realize, but it would have to be part of
 * a hierarchy first *)
let insert_text (buffer: GText.buffer) =
  let iter = buffer#get_iter `START in
  buffer#insert ~iter (
    "From: pathfinder@nasa.gov\n" ^
    "To: mom@nasa.gov\n" ^
    "Subject: Made it!\n" ^
    "\n" ^
    "We just got in this morning. The weather has been\n" ^
    "great - clear but cold, and there are lots of fun sights.\n" ^
    "Sojourner says hi. See you soon.\n" ^
    " -Path\n")

(* Create a scrolled text area that displays a "message" *)
let create_text () =
  let scrolled_window = GBin.scrolled_window
    ~hpolicy:`AUTOMATIC ~vpolicy:`AUTOMATIC () in
  let view = GText.view ~packing:scrolled_window#add () in
  let buffer = view#buffer in
  insert_text buffer;
  scrolled_window#coerce

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Paned Windows" ~border_width:10
    ~width:450 ~height:400 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* create a vpaned widget and add it to our toplevel window *)
  let vpaned = GPack.paned `VERTICAL ~packing:window#add () in

  (* Now create the contents of the two halves of the window *)
  let list = create_list () in
  vpaned#add1 list;

  let text = create_text () in
  vpaned#add2 text;

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
