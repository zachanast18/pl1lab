#include <iostream>
#include <string>
#include <fstream>
#include <stdio.h>
#include <vector>
#include <chrono>
#include<tuple>
#include <algorithm>
#include <climits>
#include <math.h>
using namespace std;

//algorithm inspired by: https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/?fbclid=IwAR1Prq2UCG54AYjv8w-P6kHwulyoQO3E4kgbCCwq8Ipq3NY7GZAPKbIRlw0

//auto start = std::chrono::high_resolution_clock::now(); //start the timer


bool my_compare(tuple<int, int> i, tuple<int, int> j){
    if (get<0>(i) == get<0>(j)) return get<1>(i) < get<1>(j);
    else return get<0>(i) < get<0>(j);	
}

std::vector<tuple<int, int>>::iterator my_bin_search(std::vector<tuple<int, int>>::iterator begin, std::vector<tuple<int, int>>::iterator end, int max){
    if ((begin == end) or (begin+1 == end)) return begin;
    auto mid = begin + (end-begin)/2;
    if(get<0>(*mid) == max) return mid;
    else if(get<0>(*mid) > max) return my_bin_search(begin, mid, max);
    else return my_bin_search(mid, end, max);
}


int main(int argc, char **argv){
    int *l = NULL;
    int M = 0; //number of days
    int N = 0; //number of hospitals
    int K = 0; //longest "good" period (in days) for the country's hospitals
    vector<tuple<int, int>> v;
    const char *h = argv[1]; //pointer to the text file given
    FILE *f;
    f = fopen(h, "r");
    
    //reading the file
    char buff[20];
    int p = 0;
    int i = 0;
    while(fscanf(f, "%s", buff) != EOF){
        if(p == 0){
            M = atoi(buff); //the first number in the file is the number of days
            l = new int[M];
            p++; 
        }
        else if (p == 1){
            N = atoi(buff); //the second number in the file is the number of hospitals
            p++;
        }
        else{
            int temp =  -atoi(buff) - N;
            //l.push_back(temp); //the remaining numbers are the differences of used hospital beds
            l[i++] = temp;
        } 
    }
    fclose(f);
    //finished reading
    
    //creating and sorting a vector of partial sums
    int sum = 0;
    for(int i = 0; i < M; ++i){
        //cout << l[i] << '\n';
        sum += l[i];
        v.push_back(make_tuple(sum, i));	
    }
    
    std::sort(v.begin(), v.end(), my_compare);
    
    
    //saving the smallest index in space [0..i] of sorted vector in minind[]
    int *minind = new int[M];

    int min = INT_MAX;
    int k = 0;
    for(std::vector<tuple<int, int>>::iterator it = v.begin(); it != v.end(); it++){
        if (get<1>(*it) < min)
            min = get<1>(*it);
        minind[k++] = min;
    }
    
    
    //traversing the array and finding the largest acceptable space
    sum = 0;
    for (int i = 0; i < M; ++i){
        sum += l[i];
        if (sum > 0){
            K = i+1;
            continue;
        }
        int max = sum;
        std::vector<tuple<int, int>>::iterator find = my_bin_search(v.begin(), v.end(), max);
        int j = find-v.begin();
        int index = minind[j];
        if (index > i) continue;
        int temp = i-index;
        if (temp > K) K = temp;
    }
    
    
    //cout << "the longest period of \"good days\" is : " + to_string(K) + '\n';
    cout << K << '\n';
    
    //auto stop = std::chrono::high_resolution_clock::now(); //stop the timer
    //auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start); //calculate elapsed time
    //std::cout << "duration = " << duration.count() << " milliseconds\n"; //print elapsed time
    
    return 0;
}
