open FFmpeg

let scan_cam () =
  if Array.length Sys.argv < 2 then Printf.(Av.Format.(
      printf "\ninput devices :\n";
      Avdevice.get_video_input_formats() |> List.iter
        (fun d -> printf"\t%s (%s)\n"(get_input_name d)(get_input_long_name d));
      printf "\noutput devices :\n";
      Avdevice.get_video_output_formats() |> List.iter
        (fun d -> printf"\t%s (%s)\n"(get_output_name d)(get_output_long_name d));
      exit 0));

  let src = Avdevice.open_video_input Sys.argv.(1) in

  let (_, ias, _) = Av.find_best_video_stream src in

  let dst = try
      if Array.length Sys.argv < 3 then Avdevice.open_default_video_output()
       else Avdevice.open_video_output Sys.argv.(2)
    with Avutil.Failure _ ->
      Av.open_output Sys.argv.(2)
      |> Av.new_video_stream ~codec_id:`H264 |> Av.get_output in

  let rec run n =
    if n > 0 then match Av.read_frame ias with
      | `Frame frame -> Av.write_video_frame dst frame; run(n - 1)
      | `End_of_file -> ()
  in
  run 500;

  Av.close src;
  Av.close dst;


open Opium.Std

let html_msg title msg =
 "<html>" ^
 "  <head>" ^
 "    <title>Message</title>" ^
 "  </head>" ^
 "  <body>" ^
 "    <h1>" ^ title ^ "  </h1>" ^
      msg ^
 "  </body>" ^
 "</html>"


 let hello = get "/" (fun _ ->
   `Html (html_msg "Salut à toi" "ô mon frère")
   |> respond')

let _ =
  App.empty
   |> hello
|> App.run_command
