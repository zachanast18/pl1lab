import java.io.*;
import java.util.*;

public class QSsort 
{
	private static boolean is_sorted(List<Integer> queue)
	{
		boolean flag = true;
		Iterator<Integer> itr = queue.iterator();
		int previous = itr.next();
		int current;
		while (itr.hasNext())
		{
			current = itr.next();
			if(current < previous)
			{
				flag = false;
				break;
			}
			previous = current;
		}
		return flag;
	}

	public static void main (String [] args) throws Exception
	{
		//Read File Inputs and fill queue
		File file = new File(args[0]);
		Scanner input = new Scanner(file);
		int n = Integer.parseInt(input.next());
		List<Integer> queue = new ArrayList<Integer>();
		for (int i = 0; i < n; i++) queue.add(Integer.parseInt(input.next()));
		input.close();

		//Define Stack, Result, visited, next_moves and some temp lists
		Queue<List<Integer>> next_moves = new ArrayDeque<List<Integer>>();
		List<Integer> stack = new ArrayList<Integer>();
		List<Integer> result = new ArrayList<Integer>();
		
		List<Integer> new_q = new ArrayList<Integer>();
		List<Integer> new_s = new ArrayList<Integer>();
		List<Integer> new_r = new ArrayList<Integer>();

		
		Set<List<List<Integer>>> visited = new HashSet<List<List<Integer>>>();
		
		//Check if the queue is already sorted
		if(is_sorted(queue))
		{
			System.out.println("empty");
			System.exit(0);
		}
		
		//Do the first move (Q)
		stack.add(queue.remove(0));
		result.add(1);
		
		next_moves.add(queue);
		next_moves.add(stack);
		next_moves.add(result);	

		while(true)
		{	
			//Get next moves
			queue = next_moves.remove();
			stack = next_moves.remove();
			result = next_moves.remove();
			
			
			List<List<Integer>> temp = new ArrayList<List<Integer>>();
			temp.add(queue);
			temp.add(stack);
			if(!visited.add(temp)) continue;

			//Q move (Q = 1)
			if (!queue.isEmpty())
			{
				new_q = new ArrayList<Integer>(queue);
				new_s = new ArrayList<Integer>(stack);
				new_r = new ArrayList<Integer>(result);
				
				new_s.add(new_q.remove(0));
				new_r.add(1);

				next_moves.add(new_q);
				next_moves.add(new_s);
				next_moves.add(new_r);	
				//S move (S = 0)	
				if (!stack.isEmpty())
				{
					if(queue.get(0) != stack.get(stack.size() - 1))
					{
						new_q = new ArrayList<Integer>(queue);
						new_s = new ArrayList<Integer>(stack);
						new_r = new ArrayList<Integer>(result);
						
						new_q.add(new_s.remove(new_s.size() - 1));
						new_r.add(0);

						next_moves.add(new_q);
						next_moves.add(new_s);
						next_moves.add(new_r);
					}
				}
				//Check if the queue is sorted
				else if(is_sorted(queue))
				{
					Iterator<Integer> res = result.iterator();
					while (res.hasNext())
					{
						if(res.next() == 1) System.out.print("Q");
						else System.out.print("S");
					}		
					System.out.println();
					System.exit(0);
				}
			}
		}	
	}
}
