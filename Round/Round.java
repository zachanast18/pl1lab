import java.util.*;
import java.io.*;
import java.util.Scanner;
import java.lang.Math;

public class Round {
  public static void main(String[] args) throws Exception {

    String filename = args[0];
    int[] cars;

    //read input
    File file = new File(filename);
    Scanner input = new Scanner(file);
    int n = Integer.parseInt(input.next());
    int k = Integer.parseInt(input.next());
    cars = new int[k];
    int j = 0;
    while (input.hasNext()) {
      cars[j] = Integer.parseInt(input.next());
      j += 1;
    }

    //cities Array shows the #cars in each city
    int[] cities = new int[n];
    Arrays.fill(cities, 0);
    for (int i = 0; i < k; i++){
      cities[cars[i]] += 1;
    }

    //full is the list of cities that have at least one car
    Deque<Integer> full= new ArrayDeque<Integer>();
    for (int i = 0; i < n; i++){
      if(cities[i] != 0){
        full.add(i);
      }
    }

    //find solution
    solve(n, k, cities, full);
  }

  private static void solve(int n, int k, int[] cities, Deque<Integer> full){
    //find total distance from city 0
    int init = 0;
    for (int i = 1; i < n; i++){
      init += (n-i)*cities[i];
    }
    int dist = init;

    int first = full.getFirst(); // first non empty city

    if (full.peek() == 0){full.removeFirst();}
    int distance = init;
    int city = 0;

    //calculate the total distance for each city and keep the smallest one
    for (int i = 1; i < n; i++){
      dist = dist + k - n*cities[i];
      int max;
      if (full.isEmpty()){
        max = i - first; // max distance from the last city
      }
      else{
        if (full.peek() == i) {full.removeFirst();}
        if (full.isEmpty()){
          max = i - first; // max distance from the last city
        }
        else{
          int next = full.peek();
          max = n-Math.abs(next-i); // maximum distance from current city
        }
      }
      int check = dist-max+1;
      if (max > check || dist >= distance) {continue;}
      distance = dist;
      city = i;
    }
    System.out.print(distance);
    System.out.print(' ');
    System.out.println(city);
  }
}
