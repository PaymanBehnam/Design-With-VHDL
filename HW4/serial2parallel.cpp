//============================================================================
// Name        : payman2.cpp
// Author      : payman
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include <fstream>
#include<string>

using namespace std;
//////////////////////////////////////////////////////////////
char XOR (char a, char b)
{
	if ((a=='X')||(b=='X')||(a=='Z')||(b=='Z')) return 'X';
	else if (a==b) return '0';
	else return '1';
}
//////////////////////////////////////////////////////////////
char NOT(char in){
	if(in == '1')
		return '0';
	else
		return '1';
}
/////////////////////////////////////////////////////////////
void cu_unit(char clock_in,char start,char *ready,char *done,char *load,char reset){
	static unsigned int counter;
	static char state = 's';
	//cout<<"state:"<<state;
	if(clock_in == 'p'){
		//cout<< "count"<<counter<<endl;
		if(reset == '1'){
			cout<<"state reset:"<<counter<<endl;
			*done = '0';
			*load = '0';
			counter = 0;
			*ready = '0';
			state = 'r';
		}
		if(state == 'r'){
			
				if (reset == '0'){
					*done = '0';
					*load = '0';
					counter = 0;
					*ready = '1';
					state = 's';
					state = 's';
				}
				else
					state = 'r';
			}
		if(state == 's'){//state start
			cout<<"state readystart"<<counter<<endl;
			if(start == '0'){
				*done = '0';
				*load = '0';
				counter = 0;
				*ready = '1';
				state = 's';
				
			}else if(start == '1'){
				state = 'c';
				counter = 0;
			}	
			
		}
		

		if(state == 'c'){//state calc
			cout<<"state count:"<<counter<<endl;
			//printf("count:%d",counter);
			if(counter < 9){
				*ready = '0';
				*load = '1';
				*done = '0';
				counter++;
				state = 'c';
			}if(counter == 8){
				state = 'f';
			}
		}
		if(state  == 'f'){
			//	printf("%d",counter);
			cout<<"state final"<<counter<<endl;
			*done = '1';
			*ready = '0';
			*load = '1';
			state ='s';
			}
			
		//counter = 0;
	}
	//printf("\n");
	return;
}
///////////////////////////////////////////////////
void dp_unit(char clock,char serin,char load,char reset,char *parout){
	static char reg[10];
	static int inc;
	unsigned int index =0;
	int i=0;
	static char parity = '0';
	
	if(clock =='p'){
		
		if(reset == '1'){
				index = 0;
				inc=0;
				load='0';
		//		ready = '0';
				for(i=0;i<9;i++){
					reg[i]=0;
				}
		}
		
		if(load == '1'){
				//printf("index:%d",index);
				//reg[0]=serin;
				reg[inc]=serin;
				inc++;
				cout<<serin;
				//cout << "reg:"<<reg;
				//for( index=8 ; index>0;index--){
					//reg[index]=reg[index-1];

				//}
		}
	}
		if(inc == 8){
			//reg[8] = 0;
			//cout<< "reg"<<reg<<endl;
					parity = XOR(reg[0],reg[1]);
					//cout<<parity;
					for(i =2;i<8;i++){
						//cout<<reg[i]<<parity;
						parity = XOR(reg[i],parity);
						//cout<<parity<<endl;
					}
					reg[8] = NOT(parity);//NOT(parity);
					reg[9] = '\0';
					for(i=0;i<=9;i++)
						parout[i] =(char) reg[i];
					for(i=0;i<9;i++){
						reg[i]=0;
						inc=0;
						index=0;
						load=0;
					}
					//ready = '1';
					//printf("%c",reg[i]);
					
				}
				
		//if(ready == '1'){
			//for(i=0;i<9;i++)
				//parout[i] =(char) reg[i];
			//printf("parout:%s",parout);
		
	
	

	return;
}
/////////////////////////////////////////////////serial2parall(clock,reset,parout,start,&done,&ready)
void serial2parall(char clock,char reset,char serin,char *parout,char start,char *done,char *ready){
	//char reset;
	char load;
	cu_unit(clock,start,ready,done,&load,reset);
	//printf("count:%d,clock:%c,serin:%c,load:%c,reset:%c,done:%c\n",count,clock_in,serin,load,reset,*done);
	
	dp_unit(clock,serin,load,reset,parout);
	
	
	return;
}
////////////////////////////////////////////////////
int main() {
	char input[5];
	char done='0',ready='0';
	char parout[] = "000000000";
	char clock,start,reset;
	char in='a';
	//
	ifstream fin("in1.txt");
	ofstream fout("out.txt");
	while(in !='b'){
		fin >> input;
		in = input[0];
		clock = input[1];
		start = input[2];
		reset = input[3];
		//fout<< "out:"<<serin<<endl;
		serial2parall(clock,reset,in,parout,start,&done,&ready);
		//(char clock,char reset,char load,char serin,char *parout,char start,char *done,char *ready)
		if(done == '1'){
			fout<<"parout:"<<parout<<endl;
		}
		//cin>>in;
	}
	//cout<<parout;
	cin >> in;
	return 0;
}
