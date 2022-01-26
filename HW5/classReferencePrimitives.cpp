#include "classReferencePrimitives.h"

void and2Input::AND(wire i1, wire i2, wire& o) {
	char av, bv, wv;
	int ad, bd, wd;
	int ap, bp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	o.get(wv, wd, wp);

	if ((av == '0')||(bv == '0')) {
		wv = '0';
		if (av=='0') wd = ad + this->gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else if ((av=='1')&&(bv=='1')) {
		wv = '1';
		if (ad > bd) wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	};
	if (value != wv) wp = ap + bp;
	value = wv;
	o.put(wv, wd, wp);
}

void and3Input::AND(wire i1, wire i2, wire i3, wire& o) {
	char av, bv, cv, wv;
	int ad, bd, cd, wd;
	int ap, bp, cp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	i3.get(cv, cd, cp);
	o.get(wv, wd, wp);

	if ((av=='0')||(bv=='0')||(cv=='0')) {
		wv = '0';
		if (av=='0') wd = ad + this->gateDelay;
		else if(bv=='0') wd = bd + this->gateDelay;
		else wd = cd + this->gateDelay;
	}
	else if ((av=='1')&&(bv=='1')&&(cv=='1')) {
		wv = '1';
		if ((ad >= bd)&&(ad >= cd)) wd = ad + this-> gateDelay;
		else if ((bd >= ad)&&(bd >= cd))wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else if (bv != '1') wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	};
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void or2Input::OR(wire i1, wire i2, wire& o) {
	char av, bv, wv;
	int ad, bd, wd;
	int ap, bp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	o.get(wv, wd, wp);

	if ((av=='1')||(bv=='1')) {
		wv = '1';
		if (av=='1') wd = ad + this->gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else if ((av=='0')&&(bv=='0')) {
		wv = '0';
		if (ad > bd) wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	};
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void or3Input::OR(wire i1, wire i2, wire i3, wire& o) {
	char av, bv, cv, wv;
	int ad, bd, cd, wd;
	int ap, bp, cp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	i3.get(cv, cd, cp);
	o.get(wv, wd, wp);

	if ((av=='1')||(bv=='1')||(cv=='1')) {
		wv = '1';
		if (av=='1') wd = ad + this->gateDelay;
		else if(bv=='1') wd = bd + this->gateDelay;
		else wd = cd + this->gateDelay;
	}
	else if ((av=='0')&&(bv=='0')&&(cv=='0')) {
		wv = '0';
		if ((ad >= bd)&&(ad >= cd)) wd = ad + this-> gateDelay;
		else if ((bd >= ad)&&(bd >= cd))wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else if (bv != '1') wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	};
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void not::NOT (wire i1, wire& o) {
	char av, wv;
	int ad, wd;
	int ap, wp;

	i1.get(av, ad, ap);
	o.get(wv, wd, wp);

	if (av=='1') wv = '0';
	else if (av=='0') wv = '1';
	else wv = 'X';
	wd = ad + this->gateDelay;
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void dff_ar::DFF (wire D, wire C, wire R, wire& Q) {
	char Dv, Cv, Rv, Qv;
	int Dd, Cd, Rd, Qd;
	int	Dp, Cp, Rp, Qp;

	D.get(Dv, Dd, Dp);
	C.get(Cv, Cd, Cp);
	R.get(Rv, Rd, Rp);
	Q.get(Qv, Qd, Qp);

	if (Rv=='1') {
		Qv='0';
		Qd= Rd + this->clkQDelay;
	}
	else if (Cv == 'P') {
		//Qv = Dv;
		if (Dd <= Cd) Qv = Dv;
		else Qv = value;
		Qd = Cd + this->clkQDelay;
	}
	if (value != Qv) Qp = Dp + 1;
	value = Qv;
	Q.put(Qv, Qd, Qp);
}

wireTemp<int>::wireTemp(){
	delay = 0;
	power = 0; 
	value = 'X';

}

and2InputTemp<int>::and2InputTemp(){
	gateDelay = 2;
	value = 'X';
}

and3InputTemp<int>::and3InputTemp(){
	gateDelay = 3;
	value = 'X';
}

or2InputTemp<int>::or2InputTemp(){
	gateDelay = 2;
	value = 'X';
}

or3InputTemp<int>::or3InputTemp(){
	gateDelay = 3;
	value = 'X';
}

notTemp<int>::notTemp(){
	gateDelay = 1;
	value = 'X';
}

void and2InputTemp<int>::AND(wire i1, wire i2, wire& o) {
	char av, bv, wv;
	int ad, bd, wd;
	int ap, bp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	o.get(wv, wd, wp);

	if ((av == '0')||(bv == '0')) {
		wv = '0';
		if (av=='0') wd = ad + this->gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else if ((av=='1')&&(bv=='1')) {
		wv = '1';
		if (ad > bd) wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	};
	if (value != wv) wp = ap + bp;
	value = wv;
	o.put(wv, wd, wp);
}

void and3InputTemp<int>::AND(wire i1, wire i2, wire i3, wire& o) {
	char av, bv, cv, wv;
	int ad, bd, cd, wd;
	int ap, bp, cp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	i3.get(cv, cd, cp);
	o.get(wv, wd, wp);

	if ((av=='0')||(bv=='0')||(cv=='0')) {
		wv = '0';
		if (av=='0') wd = ad + this->gateDelay;
		else if(bv=='0') wd = bd + this->gateDelay;
		else wd = cd + this->gateDelay;
	}
	else if ((av=='1')&&(bv=='1')&&(cv=='1')) {
		wv = '1';
		if ((ad >= bd)&&(ad >= cd)) wd = ad + this-> gateDelay;
		else if ((bd >= ad)&&(bd >= cd))wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else if (bv != '1') wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	};
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void or2InputTemp<int>::OR(wire i1, wire i2, wire& o) {
	char av, bv, wv;
	int ad, bd, wd;
	int ap, bp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	o.get(wv, wd, wp);

	if ((av=='1')||(bv=='1')) {
		wv = '1';
		if (av=='1') wd = ad + this->gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else if ((av=='0')&&(bv=='0')) {
		wv = '0';
		if (ad > bd) wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else wd = bd + this-> gateDelay;
	};
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void or3InputTemp<int>::OR(wire i1, wire i2, wire i3, wire& o) {
	char av, bv, cv, wv;
	int ad, bd, cd, wd;
	int ap, bp, cp, wp;
	
	i1.get(av, ad, ap);
	i2.get(bv, bd, bp);
	i3.get(cv, cd, cp);
	o.get(wv, wd, wp);

	if ((av=='1')||(bv=='1')||(cv=='1')) {
		wv = '1';
		if (av=='1') wd = ad + this->gateDelay;
		else if(bv=='1') wd = bd + this->gateDelay;
		else wd = cd + this->gateDelay;
	}
	else if ((av=='0')&&(bv=='0')&&(cv=='0')) {
		wv = '0';
		if ((ad >= bd)&&(ad >= cd)) wd = ad + this-> gateDelay;
		else if ((bd >= ad)&&(bd >= cd))wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	}
	else {
		wv = 'X';
		if (av != '1') wd = ad + this-> gateDelay;
		else if (bv != '1') wd = bd + this-> gateDelay;
		else wd = cd + this->gateDelay;
	};
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}

void notTemp<int>::NOT (wire i1, wire& o) {
	char av, wv;
	int ad, wd;
	int ap, wp;

	i1.get(av, ad, ap);
	o.get(wv, wd, wp);

	if (av=='1') wv = '0';
	else if (av=='0') wv = '1';
	else wv = 'X';
	wd = ad + this->gateDelay;
	if (value != wv) wp += 1;
	value = wv;
	o.put(wv, wd, wp);
}
