(* $Id: aspectframe.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: aspectframe.ml *)

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Aspect Frame" ~border_width:10 () in

  (* Here we connect the "destroy" event to a signal handler *)
  ignore (window#connect#destroy ~callback:GMain.Main.quit);

  (* Create a Frame
   * Set the frame's label
   * Align the label at the right of the frame
   * Set the style of the frame *)
  let aspect_frame = GBin.aspect_frame ~label:"2x1"
    ~xalign:0.5 (* center x *)
    ~yalign:0.5 (* center y *)
    ~ratio:2.0	(* xsize/ysize = 2.0 *)
    ~obey_child:false (* ignore child's aspect *)
    ~packing:window#add () in

  (* Now add a child widget to the aspect frame *)
  (* Ask for a 200x200 widnow, but the AspectFrame will give us a 200x100
   * window since we are forcing a 2x1 aspect ratio *)
  let drawing_area = GMisc.drawing_area ~width:200 ~height:200 ~packing:aspect_frame#add () in

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
