type cell = Dead | Alive

let grid_x = 100
let grid_y = 25
let initial_alives = 60
let temp_grid = Array.init grid_y (fun _ -> Array.make grid_x Dead)

let init_grid x y =
  Random.self_init ();
  let grid = Array.init grid_y (fun _ -> Array.make grid_x Dead) in
  for y = 0 to grid_y  - 1 do
    for x = 0 to initial_alives - 1 do
      grid.(y).(x) <- Alive
    done;
    Array.shuffle ~rand:Random.int grid.(y)
  done;
  grid

let print_grid grid =
  let current_pos = ref 0 in
  let buf = Bytes.create (grid_y * grid_x + grid_y) in
  let buf_add_cell cell_state =
    (match cell_state with
    | Dead -> Bytes.set buf !current_pos '.'
    | Alive -> Bytes.set buf !current_pos 'x');
    current_pos := !current_pos + 1 in
  let buf_add_newline () =
    Bytes.set buf !current_pos '\n';
    current_pos := !current_pos + 1 in
  for y = 0 to grid_y  - 1 do
    for x = 0 to grid_x - 1 do
      buf_add_cell grid.(y).(x)
    done;
    buf_add_newline ();
  done;
  output_bytes stdout buf;
  flush stdout

let count_neighbors grid x y =
  let count = ref 0 in
  for dy = -1 to 1 do
    for dx = -1 to 1 do
      if not(dx = 0  && dy = 0) then
        let nx = x + dx in
        let ny = y + dy in
        if nx >= 0 && nx < grid_x && ny >= 0 && ny < grid_y then
          if grid.(ny).(nx) = Alive then
            count := !count + 1;
    done;
  done;
  !count

let update_grid grid =
  for y = 0 to grid_y - 1 do
    for x = 0 to grid_x - 1 do
      let neighbors = count_neighbors grid x y in
      let current_state = grid.(y).(x) in
      if current_state = Alive then
        temp_grid.(y).(x) <- (if neighbors <= 1 || neighbors >= 4 then Dead else Alive)
      else
        temp_grid.(y).(x) <- (if neighbors = 3 then Alive else Dead)
    done;
  done;
  for y = 0 to grid_y - 1 do
    Array.blit temp_grid.(y) 0 grid.(y) 0 (grid_x)
  done

let () =
  let grid = init_grid grid_x grid_y in
  let delay = 1.0 /. 30.0 in
  let clear () = print_string "\x1b[2J\x1b[H" in
  let sleep () = ignore (Unix.sleepf delay) in
  while true do
    clear ();
    print_grid grid;
    update_grid grid;
    sleep ();
  done;;
