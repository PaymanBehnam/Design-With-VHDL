#include "classReferencePrimitives.h"

class shiftregister8Bit {
	dff_ar reg[8];
	wire q[8];
	wire D[8];
public:
	shiftregister8Bit(){};
	~shiftregister8Bit(){};
	void SELECT(wire i0, wire i1, wire i2, wire i3, wire m0, wire m1, wire& o1);
	void tempSELECT(wire i0, wire i1, wire i2, wire i3, wire m0, wire m1, wire& o1);
	void DOSHIFT(wire clock, wire reset, wire m0, wire m1, wire sri, wire sli, wire din[]);
	void PRINT(ofstream & fout);
	void update(wire clock, wire reset);
};

/*shiftregister8Bit::shiftregister8Bit(){
	int od, op = 0;
	char x = 'X';
	for (int i = 0; i < 8; i++)
		q[i].put(x, od, op);
}*/

void shiftregister8Bit::SELECT(wire i0, wire i1, wire i2, wire i3, wire m0, wire m1, wire& o1){
	wire m0Bar, m1Bar, sel0, sel1, sel2, sel3, or0Out;
	
	not *not0 = new not();
	not *not1 = new not();
	and3Input *and0 = new and3Input();
	and3Input *and1 = new and3Input();
	and3Input *and2 = new and3Input();
	and3Input *and3 = new and3Input();
	or3Input *or0 = new or3Input();
	or2Input *or1 = new or2Input();

	not0->NOT(m0, m0Bar);
	not1->NOT(m1, m1Bar);

	and0->AND(m0Bar, m1Bar, i0, sel0);
	and1->AND(m0, m1Bar, i1, sel1);
	and2->AND(m0Bar, m1, i2, sel2);
	and3->AND(m0, m1, i3, sel3);

	or0->OR(sel0, sel1, sel2, or0Out);
	or1->OR(or0Out, sel3, o1);
}

void shiftregister8Bit::tempSELECT(wire i0, wire i1, wire i2, wire i3, wire m0, wire m1, wire& o1) {
	char ov;
	int od, op, m0d, m1d;
	wire m0Bar, m1Bar, sel0, sel1, sel2, sel3, or0Out;
	
	notTemp<int> *not0 = new notTemp<int>();
	notTemp<int> *not1 = new notTemp<int>();
	and3InputTemp<int> *and0 = new and3InputTemp<int>();
	and3InputTemp<int> *and1 = new and3InputTemp<int>();
	and3InputTemp<int> *and2 = new and3InputTemp<int>();
	and3InputTemp<int> *and3 = new and3InputTemp<int>();
	or3InputTemp<int> *or0 = new or3InputTemp<int>();
	or2InputTemp<int> *or1 = new or2InputTemp<int>();

	not0->NOT(m0, m0Bar);
	not1->NOT(m1, m1Bar);

	and0->AND(m0Bar, m1Bar, i0, sel0);
	and1->AND(m0, m1Bar, i1, sel1);
	and2->AND(m0Bar, m1, i2, sel2);
	and3->AND(m0, m1, i3, sel3);

	or0->OR(sel0, sel1, sel2, or0Out);
	or1->OR(or0Out, sel3, o1);
	m0.get(ov, m0d, op);
	m1.get(ov, m1d, op);
	if (m0d > m1d)
		m1d = m0d;
	m1d += 9;
	o1.get(ov, od, op);
	o1.put(ov, m1d , op);
}

void shiftregister8Bit::DOSHIFT(wire clock, wire reset, wire m0, wire m1, wire sri, wire sli, wire din[]){
	char m1v, m0v;
	int md, mp;
	m0.get(m0v, md, mp);
	m1.get(m1v, md, mp);
	
		SELECT(q[7], sri, q[6], din[7], m0, m1, D[7]);
		SELECT(q[6], q[7], q[5], din[6], m0, m1, D[6]);
		SELECT(q[5], q[6], q[4], din[5], m0, m1, D[5]);
		SELECT(q[4], q[5], q[3], din[4], m0, m1, D[4]);
		SELECT(q[3], q[4], q[2], din[3], m0, m1, D[3]);
		SELECT(q[2], q[3], q[1], din[2], m0, m1, D[2]);
		SELECT(q[1], q[2], q[0], din[1], m0, m1, D[1]);
		SELECT(q[0], q[1], sli, din[0], m0, m1, D[0]);
	
	/*tempSELECT(q[7], sri, q[6], din[7], m0, m1, D[7]);
	tempSELECT(q[6], q[7], q[5], din[6], m0, m1, D[6]);
	tempSELECT(q[5], q[6], q[4], din[5], m0, m1, D[5]);
	tempSELECT(q[4], q[5], q[3], din[4], m0, m1, D[4]);
	tempSELECT(q[3], q[4], q[2], din[3], m0, m1, D[3]);
	tempSELECT(q[2], q[3], q[1], din[2], m0, m1, D[2]);
	tempSELECT(q[1], q[2], q[0], din[1], m0, m1, D[1]);
	tempSELECT(q[0], q[1], sli, din[0], m0, m1, D[0]);*/

	for (int i = 0; i < 8; i++)
		reg[i].DFF(D[i], clock, reset, q[i]);
	

}

void shiftregister8Bit::update(wire clock, wire reset){
	for (int i = 0; i < 8; i++)
		reg[i].DFF(D[i], clock, reset, q[i]);
}

void shiftregister8Bit::PRINT(ofstream &fout){
	string *o = new string("00000000");
	int od, op;
	for (int k = 0; k < 8; k++)
		this->q[k].get((*o)[k], od, op);
	fout<<"time:"<< od << " output value: "<< *o << " Power : "<< op * 8 <<endl;
}

int main() {
	char ov[9] = "XXXXXXXX";
	int time = 0;
	int oldTime = 0;
	int od = 0; 
	int op = 0;
	
	ifstream fin("in1.txt");
	ofstream fout("out.txt");
	string line, signals, d, output;

	wire din[8];
	wire clock, reset, m0, m1, sri, sli;
	wire qout[8];

	shiftregister8Bit *shtreg = new shiftregister8Bit();
	
//Start of Reading inputs	
	while (getline(fin, line)){
		istringstream tokenizer(line);
		string token;

		getline(tokenizer, token, ' ');
		istringstream is_time(token);
		is_time >> time;
		
		getline(tokenizer, signals, ' ');
		getline(tokenizer, d, ' ');

		clock.put(signals[0], time, 0);
		reset.put(signals[1], time, 0);
		
		shtreg->update(clock, reset);
		//shtreg->PRINT(fout);
		
		m0.put(signals[2], time, 0);
		m1.put(signals[3], time, 0);
		sri.put(signals[4], time, 0);
		sli.put(signals[5], time, 0);

		for (int i = 0; i < 8; i++)
			din[i].put(d[i], time, 0);

		shtreg->DOSHIFT(clock, reset, m0, m1, sri, sli, din);
		shtreg->PRINT(fout);
	}

	
	return 0;

}