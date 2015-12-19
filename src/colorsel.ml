(* $Id: colorsel.ml,v 1.1 2004/07/31 02:34:45 shoh Exp $ *)
(* file: colorsel.ml *)

let dialog_ref = ref None
let color = ref (`RGB (0, 65535, 0))     (* GDraw.color ref type *)

(* "color_changed" event does not exist in lablgtk2!!! *)
(*
let color_changed_cb colorsel drawingarea () =
  let ncolor = colorsel#color in
  drawingarea#misc#modify_bg [(`NORMAL, `COLOR ncolor)]
*)

let response dlg drawingarea resp =
  let colorsel = dlg#colorsel in
  begin
  match resp with
  | `OK -> color := `COLOR colorsel#color
  | _ -> ()
  end;
  ignore (drawingarea#misc#modify_bg [(`NORMAL, !color)]);
  dlg#misc#hide ()

(* Drawingarea button_press event handler *)
let button_pressed drawingarea ev =
  (* Create color selection dialog *)
  let colordlg =
    match !dialog_ref with
    | None ->
      let dlg = GWindow.color_selection_dialog ~title:"Select background color" () in
      dialog_ref := Some dlg;
      dlg
    | Some dlg -> dlg
  in

  (* Get the ColorSelection widget *)
  let colorsel = colordlg#colorsel in

  (* set_prev_color does not exist in lablgtk2!!! *)
  (* colorsel#set_prev_color (GDraw.color !color); *)
  colorsel#set_color (GDraw.color !color); (* requires Gdk.color type *)
  colorsel#set_has_palette true;

  (* Connect to the "color_changed" signal *)
  (* This event does not exist in lablgtk2!!! *)
  (* Need confirm to lablgtk2 team. *)
  (* colorsel#connect#color_changed ~callback:(color_changed_cb colorsel drawingarea);
  *)

  ignore (colordlg#connect#response ~callback:(response colordlg drawingarea));

  (* Show the dialog *)
  ignore (colordlg#run ());
  true
    
let main () =
  (* Create toplevel window, set title and policies (allow_grow, allow_shrink) *)
  let window = GWindow.window ~title:"Color selection test" ~border_width:10
    ~allow_grow:true ~allow_shrink:true () in

  (* Attach "destroy" events so we can exit *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create drawingarea, set size and catch button events *)
  let drawingarea = GMisc.drawing_area ~width:200 ~height:200 ~packing:window#add () in
  drawingarea#misc#modify_bg [(`NORMAL, !color)];
  drawingarea#event#add [`BUTTON_PRESS];
  ignore (drawingarea#event#connect#button_press ~callback:(button_pressed drawingarea));

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
