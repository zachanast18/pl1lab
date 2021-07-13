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
    val n = readInt inStream
    val k = readInt inStream
    val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
    fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	((n, k), readInts k [])
    end



fun round filename =
  let

    val ((n, k), carsList) = parse filename

    val cars = Array.fromList carsList (*turn cars list into an array*)

    fun count_cars [] res = res
    |count_cars (h::t) res =
      (Array.update(res, h, ((Array.sub(res, h))+1));
      count_cars t res)

    val cities = count_cars carsList (Array.array(n, 0)) (*array of cities with corresponding #cars*)

    fun non_empty cities ind =
      if ind = n then []
      else if Array.sub(cities, ind) > 0 then ind::(non_empty cities (ind+1))
      else non_empty cities (ind+1)

    val full = non_empty cities 0 (*list of cities with at least one car*)

    fun distance cities ind acc =
      if ind = n then acc
      else
        let val dist = (n-ind)*(Array.sub(cities, ind))
        in distance cities (ind+1) (acc+dist)
        end

    val init = distance cities 1 0 (*total distance from city0*)
    val first = List.nth(full, 0) (*first non empty city*)

    fun solve ind first cities [] prev (bd, bc) =
      if ind = n then (bd, bc)
      else
        let
          val dist = prev+k-n*Array.sub(cities, ind)
          val max = ind-first
          val check = dist-max+1
        in
          if max > check then solve (ind+1) first cities [] dist (bd, bc)
          else if dist >= bd then solve (ind+1) first cities [] dist (bd, bc)
          else solve (ind+1) first cities [] dist (dist, ind)
        end
    |solve ind first cities (next::t) prev (bd, bc) =
      if ind = n then (bd, bc)
      else if ind = next then solve ind first cities t prev (bd, bc)
      else if next = 0 then solve ind first cities t prev (bd, bc)
      else
        let
          val dist = prev+k-n*Array.sub(cities, ind)
          val max = n-abs(next-ind)
          val check = dist-max+1
        in
          if max > check then solve (ind+1) first cities (next::t) dist (bd, bc)
          else if dist >= bd then solve (ind+1) first cities (next::t) dist (bd, bc)
          else solve (ind+1) first cities (next::t) dist (dist, ind)
        end

    val res = solve 1 first cities full init (init, 0)

  in
    print(Int.toString(#1(res))^" "^Int.toString(#2(res))^"\n")
  end
