(* $Id: filesel.ml,v 1.1 2004/07/29 02:10:28 shoh Exp $ *)
(* file: filesel.ml *)

(* Get the selected filename and print it to the console *)
let file_ok_sel filew () =
  print_endline filew#filename;
  flush stdout

let main () =
  (* Create a new file selection widget; set default filename *)
  let filew = GWindow.file_selection ~title:"File selection" ~border_width:10
    ~filename:"penguin.png" () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  ignore (filew#connect#destroy ~callback:GMain.Main.quit);

  (* Connect the ok_button to file_ok_sel function *)
  ignore (filew#ok_button#connect#clicked ~callback:(file_ok_sel filew));

  (* Connect the cancel_button to destroy the widget *)
  ignore (filew#cancel_button#connect#clicked ~callback:filew#destroy);

  filew#show ();
  (* Rest in main and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = Printexc.print main ()
