(* $Id: packbox.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: packbox.ml *)

(* Make a new hbox filled with button-labels. Arguments of the
 * variables we're interested are passed in to this fuction.
 * We do not show the box, butdo show everything inside. *)
let make_box ~homogeneous ~spacing ~expand ~fill ~padding ?packing () =
  (* Create a new hbox with the appropriate homogeneous
   * and spacing settings *)
  let box = GPack.box `HORIZONTAL ~homogeneous ~spacing ?packing () in

  (* Create a series of buttons with the appropriate settings *)
  let button = GButton.button ~label:"box_pack"
    ~packing:(box#pack ~expand ~fill ~padding) () in

  let button = GButton.button ~label:"(box"
    ~packing:(box#pack ~expand ~fill ~padding) () in

  let button = GButton.button ~label:"button,"
    ~packing:(box#pack ~expand ~fill ~padding) () in

  (* Create a button with the label depending on the value of
   * expand. *)
  let button = GButton.button ~label:(if expand then "TRUE," else "FALSE,")
    ~packing:(box#pack ~expand ~fill ~padding) () in

  (* This is the same as the button creation for "expand". *)
  let button = GButton.button ~label:(if fill then "TRUE," else "FALSE,")
    ~packing:(box#pack ~expand ~fill ~padding) () in

  let button = GButton.button ~label:(Printf.sprintf "%d)" padding)
    ~packing:(box#pack ~expand ~fill ~padding) () in

  box

let main () =
  if Array.length Sys.argv < 2 then (
    prerr_endline "usage: packbox num, where num is 1, 2, or 3.";
    exit 1
  );
  let which = int_of_string Sys.argv.(1) in

  (* Create our window *)
  let window = GWindow.window ~title:"Packing" ~border_width:10 () in

  (* You should always rememeber to connect the destroy signal
   * to the main window. This is very important for proper intutive
   * behavior *)
  ignore (window #connect#destroy ~callback:GMain.Main.quit);

  let box1 = GPack.vbox ~packing:window#add () in

  (* which example to show. These correspond to the pictures above. *)
  begin
  match which with
  | 1 ->
      (* Create a new label. *)
      let label = GMisc.label ~text:"hbox_new (false, 0);" () in

      (* Align the label to the left side. We'll discuss this function and
       * others in the section on Widget Attributes. *)
      label#set_xalign 0.0;
      label#set_yalign 0.0;

      (* Pack the label into the vertical box (vobx box1). Remember that
       * widget added to a vbox will be packed one on top of the otehr in
       * order. *)
      box1#pack ~expand:false ~fill:false ~padding:0 label#coerce;

      (* Call our make box function *)
      let box2 = make_box ~homogeneous:false ~spacing:0
        ~expand:false ~fill:false ~padding:0 () in
      box1#pack ~expand:false ~fill:false ~padding:0 box2#coerce;

      (* Call our make box function *)
      let box2 = make_box ~homogeneous:false ~spacing:0
        ~expand:true ~fill:false ~padding:0 () in
      box1#pack ~expand:false ~fill:false ~padding:0 box2#coerce;

      (* Call our make box function *)
      let box2 = make_box ~homogeneous:false ~spacing:0
        ~expand:true ~fill:true ~padding:0 () in
      box1#pack ~expand:false ~fill:false ~padding:0 box2#coerce;

      (* Creates a separator, we'll learn more about these later,
       * but they are quite simple. *)
      let separator = GMisc.separator `HORIZONTAL () in
      box1#pack ~expand:false ~fill:true ~padding:0 separator#coerce;

      (* Create another new label, and show it. *)
      let label = GMisc.label ~text:"hbox_new (true, 0);" () in
      label#set_xalign 0.0;
      label#set_yalign 0.0;
      box1#pack ~expand:false ~fill:false ~padding:0 label#coerce;

      let box2 = make_box ~homogeneous:true ~spacing:0
        ~expand:true ~fill:false ~padding:0 () in
      box1#pack ~expand:false ~fill:false ~padding:0 box2#coerce;

      let box2 = make_box ~homogeneous:true ~spacing:0
        ~expand:true ~fill:true ~padding:0 () in
      box1#pack ~expand:false ~fill:false ~padding:0 box2#coerce;

      (* Another new separator. *)
      let separator = GMisc.separator `HORIZONTAL () in
      box1#pack ~expand:false ~fill:true ~padding:5 separator#coerce;

  | 2 ->
      (* Create a new label, remember box1 is a vbox as created
       * near the beginning of main().
       * You can give widget attributes on widget creation.
       * See: ~xalign, ~yalign, ~packing *)
      let label = GMisc.label ~text:"hbox_new (false, 10);"
        ~xalign:0.0 ~yalign:0.0
    	~packing:(box1#pack ~expand:false ~fill:false ~padding:0) () in

      (* Packing is done in make_box () *)
      ignore (make_box ~homogeneous:false ~spacing:10
        ~expand:true ~fill:false ~padding:0
        ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) ());

      (* Same: packing is done in make_box () *)
      ignore (make_box ~homogeneous:false ~spacing:10
        ~expand:true ~fill:true ~padding:0
        ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) ());

      (* Packing is done in GMisc.separator () *)
      ignore (GMisc.separator `HORIZONTAL
        ~packing:(box1#pack ~expand:false ~fill:true ~padding:5) ());

      (* Alignment and packing is done in GMisc.label () *)
      ignore (GMisc.label ~text:"hbox_new (false, 0);"
        ~xalign:0.0 ~yalign:0.0
        ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) ());

      ignore (make_box ~homogeneous:false ~spacing:0
        ~expand:true ~fill:false ~padding:10
        ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) ());

      ignore (make_box ~homogeneous:false ~spacing:0
        ~expand:true ~fill:true ~padding:10
        ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) ());

      ignore (GMisc.separator `HORIZONTAL
        ~packing:(box1#pack ~expand:false ~fill:true ~padding:5) ());

      ()

  | 3 ->
      (* This demonstrates the ability to use "pack ~from:`END" to
       * right justify widgets. First, we create a new box as before. *)
      let box2 = make_box ~homogeneous:false ~spacing:0
        ~expand:false ~fill:false ~padding:0 () in

      (* Create the label that will be put at the end.
       * and pack it using "pack ~from:`END", so it is put on the right
       * side of the hbox created in the make_box () call. *)
      let label = GMisc.label ~text:"end"
    	~packing:(box2#pack ~from:`END ~expand:false ~fill:false ~padding:0) () in
      (* Pack box2 into box1 (the vbox remember ? :) *)
      box1#pack ~expand:false ~fill:false ~padding:0 box2#coerce;

      (* A separator for the bottom.
       * And pack the separator into the vbox (box1) created near the start
       * of main () *)
      let separator = GMisc.separator `HORIZONTAL
        ~packing:(box1#pack ~expand:false ~fill:true ~padding:5) () in

      (* This explicitly set the separstor to 400 pixels wide by 5 pixels
       * high. This is so the hbox we created will also be 400 pixels wide,
       * and the "end" label will be separated from the other labels in the
       * hbox. Otherwise, all the widgets in the hbox would be packed as
       * close together as possible. *)
      separator#misc#set_size_request ~width:400 ~height:5 ()

  | _ -> ()
  end;

  (* Create another new hbox. remember we can use as many as we need! *)
  let quitbox = GPack.hbox ~homogeneous:false ~spacing:0
    ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) () in

  (* Our quit button. *)
  let button = GButton.button ~label:"Quit"
    ~packing:(box1#pack ~expand:false ~fill:false ~padding:0) () in
  ignore (button#connect#clicked ~callback:GMain.Main.quit);

  (* Showing the window last so everything pops up at once. *)
  window#show ();

  (* And of course, our main function. *)
  GMain.Main.main ()

let _ = Printexc.print main ()
