(* $Id: base.ml,v 1.1 2004/08/02 02:36:22 shoh Exp shoh $ *)
(* file:base.ml *)

let main () =
  let window = GWindow.window () in
  window#show ();
  GMain.Main.main ()

let _ = main ()
