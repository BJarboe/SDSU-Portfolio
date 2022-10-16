/*  
*   @file romanToInt
*   @brief Converts a string to an integer based of the conventions of Roman Numerals
*          Runtime: 68 ms    Memory Usage: 6 mb
*   @author Bryce Jarboe
*/

class Solution {
public:
    int romanToInt(string s) {
        
        int ascii;
        int value = 0; 
        string::iterator i;
        
        for (i = s.begin(); i < s.end(); i++){
            bool nextExists = (i + 1 < s.end());
            ascii = (int)*i;
            cout << *i << ": " << value << "\n";
            switch(ascii){
                
                case (int)'M':
                    value += 1000;
                    break;
                
                case (int)'D':
                    value += 500;
                    break;
                
                case (int)'C':
                    if (nextExists){
                        if (*(i+1) == 'M'){
                            value += 900;
                            i++;
                        }
                        else if (*(i+1) == 'D'){
                            value += 400;
                            i++;
                        }
                        else{
                            value += 100;
                        }
                    }
                    else{
                        value += 100;
                    }
                    break;
                    
                case (int)'L':
                    value += 50;
                    break;
                    
                case (int)'X':
                    if (nextExists){
                        if (*(i+1) == 'C'){
                            value += 90;
                            i++;
                        }
                        else if (*(i+1) == 'L'){
                            value += 40;
                            i++;
                        }
                        else{
                            value += 10;
                        }
                    }
                    else{
                        value += 10;
                    }
                    break;
                    
                case (int)'V':
                    value += 5;
                    break;
                    
                case (int)'I':
                    if (nextExists){
                        if (*(i+1) == 'V'){
                            value += 4;
                            i++;
                        }
                        else if (*(i+1) == 'X'){
                            value += 9;
                            i++;
                        }
                        else{
                            value++;
                        }
                    }
                    else{
                        value++;
                    }
                    break;
                
                
            }
            
        }
        return value;
    }
};
