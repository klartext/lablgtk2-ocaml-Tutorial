(* $Id: ruler.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: ruler.ml *)

let xsize = 600
let ysize = 400

let main () =
  let window = GWindow.window ~title:"Ruler" ~border_width:10 () in
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create a table for placing the ruler and the drawing area *)
  let table = GPack.table ~rows:3 ~columns:2 ~packing:window#add () in

  let area = GMisc.drawing_area ~width:xsize ~height:ysize
    ~packing:(table#attach ~left:1 ~top:1) () in
  area#event#add [`POINTER_MOTION; `POINTER_MOTION_HINT];

  (* The horizontal ruler goes on the top. As the mouse moves across
   * the drawing area, a motion_notify_event is passed to the
   * approprite event handler for the ruler. *)
  let hruler = GRange.ruler `HORIZONTAL ~metric:`PIXELS
    ~lower:7.0 ~upper:13.0 ~position:0.0 ~max_size:20.0
    ~packing:(table#attach ~left:1 ~top:0) () in
  ignore (area#event#connect#motion_notify
    ~callback:(fun ev -> hruler#event#send (ev :> GdkEvent.any)));

  (* The vertical ruler goes on the left. As the mouse moves across
   * the drawing area, a motion_notify_event is passed to the
   * approprite event handler for the ruler. *)
  let vruler = GRange.ruler `VERTICAL ~metric:`PIXELS
    ~lower:0.0 ~upper:(float ysize) ~position:0.0 ~max_size:(float ysize)
    ~packing:(table#attach ~left:0 ~top:1) () in
  ignore (area#event#connect#motion_notify
    ~callback:(fun ev -> vruler#event#send (ev :> GdkEvent.any)));

  window#show ();
  GMain.Main.main ()

let _ = main ()
