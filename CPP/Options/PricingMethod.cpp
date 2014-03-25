// PricingMethod.cpp : Defines the exported functions for the DLL application.
//

#include <cmath>

#include "stdafx.h"
#include "PricingMethod.h"

using namespace std;

// This is an example of an exported variable
PRICINGMETHOD_API int nPricingMethod=0;
PRICINGMETHOD_API double STEP_FACTOR = 0.00001;
PRICINGMETHOD_API double MAX_PRICE_STEP = 0.001;
// This is an example of an exported function.
PRICINGMETHOD_API int fnPricingMethod(void)
{
	return 42;
}

// This is the constructor of a class that has been exported.
// see PricingMethod.h for the class definition
CPricingMethod::CPricingMethod()
{
	return;
}


/*
function [price,la]=futuresamerput(s,k,r,T,sigma,N)
%s is the current price of the underlying asset, k is the exercise price 
%of the option,r is the risk-free rate,q is the dividend,T is the maturity length, sigma 
%is the volatility of the asset price, and N is the interval number. 

deltaT=T/N;
u=exp(sigma*sqrt(deltaT));
d=exp(-sigma*sqrt(deltaT));
p=(1-d)/(u-d);
la=zeros(N+1);
for i=1:N+1
    la(i,i)=max(0,k-s*u^(N-i+1)*d^(i-1));
end;
for i=2:N+1
    for j=i-1:(-1):1
        la(i,j)=max(exp(-r*deltaT)*(p*la(i-1,j)+(1-p)*la(i,j+1)),k-s*u^(N-i+1)*d^(j-1));
    end;
end;
price=la(N+1,1);

*/

double BinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step){
	double dT = T/Step;
	double u,d;
	u = exp(Sigma*sqrt(dT));
	d = 1/u;
	double p = (1-d)/(u-d);
	vector<vector<double>> bTree(Step+1, vector<double>(Step+1, 0));
	for(size_t i = 0; i < bTree[Step].size(); i++){
		double value = K - S*pow(u, (int)(Step-i))*pow(d, (int)i);
		if(value < 0){
			value = 0;
		}
		bTree[Step][i] = value;
	}
	for(int i = Step-1; i >=0; i--){
		for(int j = 0; j <= i; j++){
			double value = exp(-R*dT)*(p*bTree[i+1][j]+(1-p)*bTree[i+1][j+1]);
			double btValue = K - S*pow(u, i-j)*pow(d, j);
			bTree[i][j] = value>btValue?value:btValue;
		}
	}
	return bTree[0][0];
}

double PricingCallOptionsByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step){
    double dT = T/Step;
    double u,d;
    u = exp(Sigma*sqrt(dT));
    d = 1/u;
    double p = (1-d)/(u-d);
    vector<vector<double>> bTree(Step+1, vector<double>(Step+1, 0));
    for(size_t i = 0; i < bTree[Step].size(); i++){
        double value = S*pow(u, (int)(Step-i))*pow(d, (int)i) - K;
        if(value < 0){
            value = 0;
        }
        bTree[Step][i] = value;
    }
    for(int i = Step-1; i >=0; i--){
        for(int j = 0; j <= i; j++){
            double value = exp(-R*dT)*(p*bTree[i+1][j]+(1-p)*bTree[i+1][j+1]);
            double btValue = S*pow(u, i-j)*pow(d, j) - K;
            bTree[i][j] = value>btValue?value:btValue;
        }
    }
    return bTree[0][0];
}

double PricingPutOptionsByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step){
    double dT = T/Step;
    double u,d;
    u = exp(Sigma*sqrt(dT));
    d = 1/u;
    double p = (1-d)/(u-d);
    vector<vector<double>> bTree(Step+1, vector<double>(Step+1, 0));
    for(size_t i = 0; i < bTree[Step].size(); i++){
        double value = K - S*pow(u, (int)(Step-i))*pow(d, (int)i);
        if(value < 0){
            value = 0;
        }
        bTree[Step][i] = value;
    }
    for(int i = Step-1; i >=0; i--){
        for(int j = 0; j <= i; j++){
            double value = exp(-R*dT)*(p*bTree[i+1][j]+(1-p)*bTree[i+1][j+1]);
            double btValue = K - S*pow(u, i-j)*pow(d, j);
            bTree[i][j] = value>btValue?value:btValue;
        }
    }
    return bTree[0][0];
}

double GetCallOptionsDeltaByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step){
    double dS = S * STEP_FACTOR;
	if(dS > MAX_PRICE_STEP){
		dS = MAX_PRICE_STEP;
	}
    double delta = (PricingCallOptionsByBinomialTree(Sigma, R, T, S+dS, K, Step)-PricingCallOptionsByBinomialTree(Sigma, R, T, S, K, Step))/dS;
    return  delta;
}

double GetPutOptionsDeltaByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step){
    double dS = S * STEP_FACTOR;
	if(dS > MAX_PRICE_STEP){
		dS = MAX_PRICE_STEP;
	}
    double delta = (PricingPutOptionsByBinomialTree(Sigma, R, T, S+dS, K, Step)-PricingPutOptionsByBinomialTree(Sigma, R, T, S, K, Step))/dS;
    return  delta;
}

double PHI(double x){
	return 0.5*(1.0 + erf(0.5*sqrt(2.0)*x));
}

double PricingCallOptionsByBlack76(double Sigma, double R, double T, double S, double K){
	double price = 0;
	double denominator = Sigma*sqrt(T);
	double d1 = (log(S / K) + 0.5*Sigma*Sigma*T) / denominator;
	double d2 = d1 - Sigma*sqrt(T);
	price = exp(-R*T)*(S*PHI(d1)-K*PHI(d2));
	return price;
}

double PricingPutOptionsByBlack76(double Sigma, double R, double T, double S, double K){
	double price = 0.0;
	double denominator = Sigma*sqrt(T);
	double d1 = (log(S / K) + 0.5*Sigma*Sigma*T) / denominator;
	double d2 = d1 - Sigma*sqrt(T);
	price = exp(-R*T)*(K*PHI(-d2) - S*PHI(-d1));
	return price;
}
double CPricingMethod::BinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step){
	double dT = T/Step;
	double u,d;
	u = exp(Sigma*sqrt(dT));
	d = 1/u;
	double p = (1-d)/(u-d);
	vector<vector<double>> bTree(Step+1, vector<double>(Step+1, 0));
	for(size_t i = 0; i < bTree[Step].size(); i++){
		double value = K - S*pow(u, (int)(Step-i))*pow(d, (int)i);
		if(value < 0){
			value = 0;
		}
		bTree[Step][i] = value;
	}
	for(int i = Step-1; i >=0; i--){
		for(int j = 0; j <= i; j++){
			double value = exp(-R*dT)*(p*bTree[i+1][j]+(1-p)*bTree[i+1][j+1]);
			double btValue = K - S*pow(u, i-j)*pow(d, j);
			bTree[i][j] = value>btValue?value:btValue;
		}
	}
	return bTree[0][0];
}


