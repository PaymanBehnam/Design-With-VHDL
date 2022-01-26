#include <iostream>
#include <fstream>
#include<string>
#include<sstream>

using namespace std;

class wire {
	char value;
	int delay;
	int power;

public:
	wire () {delay = 0; power = 0; value = 'X';}
	void put (char a, int d, int p) {value = a; delay = d; power = p;}
	void get (char& a, int& d, int& p) {a = value; d = delay; p = power;}
};
class and2Input {
	wire i1, i2, o1;
	int gateDelay;
	char value;

public:
	and2Input() {gateDelay = 2; value = 'X';}
	~and2Input(){};
	void AND (wire, wire, wire&);
};

class and3Input {
	wire i1, i2, i3, o1;
	int gateDelay;
	char value;

public:
	and3Input() {gateDelay = 3; value = 'X';}
	~and3Input(){};
	void AND (wire, wire, wire, wire&);
};

class or2Input {
	wire i1, i2, o1;
	int gateDelay;
	char value;

public:
	or2Input() {gateDelay = 2; value = 'X';}
	~or2Input(){};
	void OR (wire, wire, wire&);
};

class or3Input {
	wire i1, i2, i3, o1;
	int gateDelay;
	char value;

public:
	or3Input() {gateDelay = 3; value = 'X';}
	~or3Input(){};
	void OR (wire, wire, wire, wire&);
};

class not {
	wire i1, o1;
	int gateDelay;
	char value;

public:
	not () {gateDelay=1; value = 'X';}
	~not(){};
	void NOT (wire, wire&);
};

class dff_ar {
	wire D, clk, R, Q;
	int clkQDelay;
	char value;

public:
	dff_ar () {clkQDelay = 1; value = 'X';}
	~dff_ar(){};
	void DFF (wire D, wire C, wire R, wire& Q);
};

template <class T>
class wireTemp {
	char value;
	T delay;
	int power;

public:
	wireTemp();
	void put (char a, T d, int p) {value = a; delay = d; power = p;}
	void get (char& a, T& d, int& p) {a = value; d = delay; p = power;}
};

template <class T>
class and2InputTemp {
	int i1, i2, o1;
	T gateDelay;
	char value;

public:
	and2InputTemp();
	~and2InputTemp(){};
	void AND (wire, wire, wire&);
};

template <class T>
class and3InputTemp {
	wire i1, i2, i3, o1;
	T gateDelay;
	char value;

public:
	and3InputTemp();
	~and3InputTemp(){};
	void AND (wire, wire, wire, wire&);
};

template <class T>
class or2InputTemp {
	wire i1, i2, o1;
	T gateDelay;
	char value;

public:
	or2InputTemp() ;
	~or2InputTemp(){};
	void OR (wire, wire, wire&);
};

template <class T>
class or3InputTemp {
	wire i1, i2, i3, o1;
	T gateDelay;
	char value;

public:
	or3InputTemp();
	~or3InputTemp(){};
	void OR (wire, wire, wire, wire&);
};


template <class T>
class notTemp {
	wire i1, o1;
	T gateDelay;
	char value;

public:
	notTemp ();
	~notTemp(){};
	void NOT (wire, wire&);
};
