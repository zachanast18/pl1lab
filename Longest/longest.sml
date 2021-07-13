(*algorithm inspired by: //algorithm inspired by: https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/?fbclid=IwAR1Prq2UCG54AYjv8w-P6kHwulyoQO3E4kgbCCwq8Ipq3NY7GZAPKbIRlw0*)


(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
fun parse file =
    let
    (* A function to read an integer from specified input. *)
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
    val m = readInt inStream
    val n = readInt inStream
    val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
    fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	((m, n), readInts m [])
    end
    


fun longest fileName =
    let			
        val ((m, n), l)  = parse fileName
        
        
        val l1 = List.map (fn x => ((~1 * x)-n))  l
        
        fun partial_sums sum [] i = []
            |partial_sums sum (h::t) i =
                let
                    val temp = h + sum
                in
                    ((i-1), temp)::(partial_sums temp t (i+1))
                end
        
                    
        val l2 = partial_sums 0 l1 1 
        
        
        
        val sorted_l = ListMergeSort.sort (fn ((a,b), (c,d)) => (if (b = d) then a>c else b>d)) l2
        
        fun min_index min [] = []
            |min_index min ((a,b)::t) =
            let
                val result = if (a < min) then a else min
            in 
                [result]@ (min_index result t)
            end
            
        
        val minind = min_index (valOf Int.maxInt) sorted_l
        
        val minind_arr = Array.fromList(minind)
        val arr = Array.fromList(sorted_l)
        
        fun binary sum begin ending =
            (*if (begin = ending) then (print(Int.toString(begin)^"\n"); begin)*)
            
                let
                    val mid_ind = begin + floor(real(ending-begin)/real(2))
                    val mid = #2(Array.sub(arr, mid_ind))
                in
                    if (mid = sum) then mid_ind
                    else if (mid > sum) then binary sum begin mid_ind
                    else binary sum mid_ind ending
                end
        
        
        fun traverse nil best current_ind = best
            |traverse ((a,b)::t) best current_ind =
                let
                    val sum = b
                    val i = binary sum 0 (Array.length arr)
 					val j = Array.sub(minind_arr, i)
                    val index = if (j = 0) then (current_ind+1) else (current_ind - j)
                    
                in
                    if index > best then traverse t index (current_ind+1)
                    else traverse t best (current_ind+1)
                end
            
    in
        print(Int.toString(traverse l2 ~1 0)^"\n")
    end
