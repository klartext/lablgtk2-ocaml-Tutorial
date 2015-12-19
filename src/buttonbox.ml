(* $Id: buttonbox.ml,v 1.1 2004/07/30 07:47:54 shoh Exp $ *)
(* file: buttonbox.ml *)

(* Create a Buttn Box with the specified parameters *)
let create_bbox direction title spacing child_width child_height layout =
  let frame = GBin.frame ~label:title () in
  let bbox = GPack.button_box direction ~border_width:5 ~layout
    ~child_height ~child_width ~spacing ~packing:frame#add () in
  ignore (GButton.button ~stock:`OK ~packing:bbox#add ());
  ignore (GButton.button ~stock:`CANCEL ~packing:bbox#add ());
  ignore (GButton.button ~stock:`HELP ~packing:bbox#add ());
  frame#coerce

let main () =
  let window = GWindow.window ~title:"Button Boxes" ~border_width:10 () in
  ignore (window #connect#destroy ~callback:GMain.Main.quit);

  let main_vbox = GPack.vbox ~packing:window#add () in

  let frame_horz = GBin.frame ~label:"Horizontal Button Boxes"
    ~packing:(main_vbox#pack ~expand:true ~fill:true ~padding:10) () in
  
  let vbox = GPack.vbox ~border_width:10 ~packing:frame_horz#add () in
  
  vbox#add (create_bbox `HORIZONTAL "Spread (spacing 40)" 40 85 20 `SPREAD);
  vbox#pack (create_bbox `HORIZONTAL "Edge (spacing 30)" 30 85 20 `EDGE) 
    ~expand:true ~fill:true ~padding:5;
  vbox#pack (create_bbox `HORIZONTAL "Start (spacing 20)" 20 85 20 `START)
    ~expand:true ~fill:true ~padding:5;
  vbox#pack (create_bbox `HORIZONTAL "End (spacing 10)" 10 85 20 `END)
    ~expand:true ~fill:true ~padding:5;

  let frame_vert = GBin.frame ~label:"Vertical Button Boxes"
    ~packing:(main_vbox#pack ~expand:true ~fill:true ~padding:10) () in
  
  let hbox = GPack.hbox ~border_width:10 ~packing:frame_vert#add () in
  hbox#add (create_bbox `VERTICAL "Spread (spacing 5)" 5 85 20 `SPREAD);
  hbox#pack (create_bbox `VERTICAL "Edge (spacing 30)" 30 85 20 `EDGE)
    ~expand:true ~fill:true ~padding:5;
  hbox#pack (create_bbox `VERTICAL "Start (spacing 20)" 20 85 20 `START)
    ~expand:true ~fill:true ~padding:5;
  hbox#pack (create_bbox `VERTICAL "End (spacing 20)" 20 85 20 `END)
    ~expand:true ~fill:true ~padding:5;
  window#show ();

  (* Enter the event loop *)
  GMain.Main.main ()

let _ = Printexc.print main ()
