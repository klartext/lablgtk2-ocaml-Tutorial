(* $Id: label.ml,v 1.2 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file: label.ml *)

let main () =
  let window = GWindow.window ~title:"Labels" ~border_width:5 () in
  ignore (window #connect#destroy ~callback:GMain.Main.quit);

  let hbox = GPack.hbox ~spacing:5 ~packing:window#add () in
  let vbox = GPack.vbox ~spacing:5 ~packing:hbox#add () in

  let frame = GBin.frame ~label:"Normal Label" ~packing:vbox#pack () in
  ignore (GMisc.label ~text:"This is a normal label" ~packing:frame#add ());

  let frame = GBin.frame ~label:"Multi_line Label" ~packing:vbox#pack () in
  ignore (GMisc.label
    ~text:"This is a multi-line label.\nSecond line\nThird line"
    ~packing:frame#add ());

  let frame = GBin.frame ~label:"Left Justified Label" ~packing:vbox#pack () in
  ignore (GMisc.label
    ~text:"This is a left justified\nmulti_line label\nThird      line"
    ~justify:`LEFT ~packing:frame#add ());

  let frame = GBin.frame ~label:"Right Justified Label" ~packing:vbox#pack () in
  ignore (GMisc.label
    ~text:"This is a Right-Justified\nMulti-line label.\nThird line, (j/k)"
    ~justify:`RIGHT ~packing:frame#add ());

  let vbox = GPack.vbox ~spacing:5 ~packing:hbox#add () in

  let frame = GBin.frame ~label:"Line wrapped Label" ~packing:vbox#pack () in
  ignore (GMisc.label
    ~text:"This is an example of a line-wrapped label.  It should not be taking up the entire             width allocated to it, but automatically wraps the words to fit.  The time has come, for all good men, to come to the aid of their party.  The sixth sheik's six sheep's sick.
     It supports multiple paragraphs correctly, and  correctly   adds many          extra  spaces. "
    ~packing:frame#add ~line_wrap:true ());

  let frame = GBin.frame ~label:"Filled, wrapped label" ~packing:vbox#pack () in
  ignore (GMisc.label
    ~text:"This is an example of a line-wrapped, filled label.  It should be taking up the entire              width allocated to it.  Here is a sentence to prove my point.  Here is another sentence.  Here comes the sun, do de do de do.
    This is a new paragraph.
    This is another newer, longer, better paragraph.  It is coming to an end, unfortunately."
    ~line_wrap:true ~justify:`FILL ~packing:frame#add ());

  let frame = GBin.frame ~label:"Underlined Label" ~packing:vbox#pack () in
  ignore (GMisc.label
    ~text:"This label is underlined!\nThis one is underlined in quite a funky fashion"
    ~pattern:"_________________________ _ _________ _ ______     __ _______ ___"
    ~justify:`LEFT ~packing:frame#add ());

  window #show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
