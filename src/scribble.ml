(* $Id: scribble.ml,v 1.1 2004/08/11 02:01:41 shoh Exp shoh $ *)
(* file: scribble.ml *)

(* Backing pixmap for drawing area *)
let backing = ref (GDraw.pixmap ~width:200 ~height:200 ())

(* Create a new backing pixmap of the appropriate size *)
let configure window backing ev =
  let width = GdkEvent.Configure.width ev in
  let height = GdkEvent.Configure.height ev in
  let pixmap = GDraw.pixmap ~width ~height ~window () in
  pixmap#set_foreground `WHITE;
  pixmap#rectangle ~x:0 ~y:0 ~width ~height ~filled:true ();
  backing := pixmap;
  true

(* Redraw the screen from the backing pixmap *)
let expose (drawing_area:GMisc.drawing_area) (backing:GDraw.pixmap ref) ev =
  let area = GdkEvent.Expose.area ev in
  let x = Gdk.Rectangle.x area in
  let y = Gdk.Rectangle.y area in
  let width = Gdk.Rectangle.width area in
  let height = Gdk.Rectangle.width area in
  let drawing =
    drawing_area#misc#realize ();
    new GDraw.drawable (drawing_area#misc#window)
  in
  drawing#put_pixmap ~x ~y ~xsrc:x ~ysrc:y ~width ~height !backing#pixmap;
  false

(* Draw a rectangle on the screen *)
let draw_brush (area:GMisc.drawing_area) (backing:GDraw.pixmap ref) x y =
  let x = x - 5 in
  let y = y - 5 in
  let width = 10 in
  let height = 10 in
  let update_rect = Gdk.Rectangle.create ~x ~y ~width ~height in
  !backing#set_foreground `BLACK;
  !backing#rectangle ~x ~y ~width ~height ~filled:true ();
  area#misc#draw (Some update_rect)

let button_pressed area backing ev =
  if GdkEvent.Button.button ev = 1 then (
    let x = int_of_float (GdkEvent.Button.x ev) in
    let y = int_of_float (GdkEvent.Button.y ev) in
    draw_brush area backing x y
  );
  true

let motion_notify area backing ev =
  let (x, y) =
    if GdkEvent.Motion.is_hint ev
	then area#misc#pointer
	else
      (int_of_float (GdkEvent.Motion.x ev), int_of_float (GdkEvent.Motion.y ev))
  in
  let state = GdkEvent.Motion.state ev in
  if Gdk.Convert.test_modifier `BUTTON1 state
  then draw_brush area backing x y;
  true

let main () =
  let width = 200 in
  let height = 200 in

  let window = GWindow.window ~title:"Scribble" () in
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  let vbox = GPack.vbox ~packing:window#add () in

  (* Create the drawing area *)
  let area = GMisc.drawing_area ~width ~height ~packing:vbox#add () in

  (* Signals used to handle backing pixmap *)
  ignore (area#event#connect#expose ~callback:(expose area backing));
  ignore (area#event#connect#configure ~callback:(configure window backing));

  (* Event signals *)
  ignore (area#event#connect#motion_notify ~callback:(motion_notify area backing));
  ignore (area#event#connect#button_press ~callback:(button_pressed area backing));

  area#event#add [`EXPOSURE; `LEAVE_NOTIFY; `BUTTON_PRESS; `POINTER_MOTION; `POINTER_MOTION_HINT];

  (* .. And a quit button *)
  let button = GButton.button ~label:"Quit" ~packing:vbox#add () in
  ignore (button#connect#clicked ~callback:window#destroy);

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
