(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun parse file =
    let
    (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
    val rows = readInt inStream
    val cols = readInt inStream
    val _ = TextIO.inputLine inStream
    
    (*function to read the chars. Inspired by https://stackoverflow.com/questions/37015891/read-file-character-by-character-in-smlnj*)
    fun read_chars i acc =
        let
            fun next_String input = (TextIO.inputAll input)
            val a = next_String inStream
        in
             explode(a)::[]
        end
        
    in
   	((rows, cols), read_chars (rows*cols) [])
    end



fun loop_rooms filename = 
    let
        val ((r, c), [l]) = parse filename (*reading the input file*)
        val rows = r
        val cols = c
        
        fun formatter rws cls lst =	(*formats the input in order to turn it into a 2d array*)
            if (length lst < cls) then 
                nil
            else
                let
                    val l1 = List.take(lst, cls)
                    val l2 = List.drop(lst , (cls+1))
                in 
                    [l1]@(formatter rws cls l2)
                end
        
        val temp = formatter rows cols l
        val maze = Array2.fromList temp (*the map of the maze*)
        val room_status = Array2.tabulate Array2.RowMajor (rows, cols, (fn (i,j) => 0)) (*0->first time we see it, 1->good room, 2->bad room*)
            
                
        fun navigate (row, col) l =
            if ((row > (rows-1)) orelse (col > (cols-1)) orelse (row < 0) orelse (col < 0)) 
                then 1 (*found an exit from the maze*)
            else if (Array2.sub(room_status, row, col) = 1) 
                then 1 (*already seen this room and it's good*)
            else if (Array2.sub(room_status, row, col) = 2) 
                then 2(*already seen this room and it's bad*)
            else if (List.exists (fn x => x = (row, col)) l)
                then 2
            else  (*never seen this room again, continue navigating*)
                let					
                    val next_row = 
                        if Array2.sub(maze, row, col) = #"U" then (row-1)
                        else if Array2.sub(maze, row, col) = #"D" then (row+1)
                        else row
                    val next_col = 
                        if Array2.sub(maze, row, col) = #"L" then (col-1)
                        else if Array2.sub(maze, row, col) = #"R" then (col+1)
                        else col
                        
                    val status = navigate (next_row, next_col) (l@[(row, col)])
                
                    fun dummy row col =
                        (Array2.update(room_status, row, col, status);
                         status
                         )
                in
                    dummy row col
                end 
        
            
        fun get_result i j result = 
            if (i = rows) then result
            else if (j = cols) then get_result (i+1) 0 result
            else if ((navigate (i, j) nil) = 2) then get_result i (j+1) (result+1)
            else get_result i (j+1) result 
        
            
    in
        (*
        ((Array2.modifyi Array2.RowMajor (fn (row,col,x) => navigate (row, col) nil) {base=room_status,row=0,col=0,nrows=NONE,ncols=NONE});
        print("result = " ^ Int.toString(result) ^ "\n"))
        *)
        print(Int.toString(get_result 0 0 0) ^ "\n")
    end
