// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the PRICINGMETHOD_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// PRICINGMETHOD_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef PRICINGMETHOD_EXPORTS
#define PRICINGMETHOD_API __declspec(dllexport)
#else
#define PRICINGMETHOD_API __declspec(dllimport)
#endif

// This class is exported from the PricingMethod.dll
class PRICINGMETHOD_API CPricingMethod {
public:
	double price;
public:
	CPricingMethod(void);
	// TODO: add your methods here.
	double BinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step);

};

extern PRICINGMETHOD_API int nPricingMethod;
extern PRICINGMETHOD_API double STEP_FACTOR;
extern PRICINGMETHOD_API double MAX_PRICE_STEP;


extern "C" PRICINGMETHOD_API double BinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step);

extern "C" PRICINGMETHOD_API double PricingCallOptionsByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step);
extern "C" PRICINGMETHOD_API double PricingPutOptionsByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step);
extern "C" PRICINGMETHOD_API double GetCallOptionsDeltaByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step);
extern "C" PRICINGMETHOD_API double GetPutOptionsDeltaByBinomialTree(double Sigma, double R, double T, double S, double K, unsigned int Step);

extern "C" PRICINGMETHOD_API double PricingCallOptionsByBlack76(double Sigma, double R, double T, double S, double K);
extern "C" PRICINGMETHOD_API double PricingPutOptionsByBlack76(double Sigma, double R, double T, double S, double K);
