//+------------------------------------------------------------------+
//|                                               Trade/FxSymbol.mqh |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2016, Li Ding"
#property link      "dingmaotu@hotmail.com"
#property strict

#include "../Lang/Mql.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NormalizeLots(double lots,double minLot)
  {
   double r=MathMod(lots,minLot);
   return Mql::isEqual(r,0.0) ? lots : (lots -r + minLot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FxSymbol
  {
private:
   const string      m_symbol;

public:
   //--- SymbolWatch
   static int        getTotal() {return SymbolsTotal(false);}
   static string     getName(int i) {return SymbolName(i,false);}

   static int        getTotalSelected() {return SymbolsTotal(true);}
   static string     getNameSelected(int i) {return SymbolName(i,true);}

   static bool       select(string symbol) {return SymbolSelect(symbol, true);}
   static bool       remove(string symbol) {return SymbolSelect(symbol, false);}

   static bool       isSelected(string symbol) {return SymbolInfoInteger(symbol,SYMBOL_SELECT)!=0;}
   static bool       isVisible(string symbol) {return SymbolInfoInteger(symbol,SYMBOL_VISIBLE)!=0;}

   //-- symbol info
   static string     getDescription(string symbol) {return SymbolInfoString(symbol,SYMBOL_DESCRIPTION);}
   static string     getPath(string symbol) {return SymbolInfoString(symbol,SYMBOL_PATH);}
   static string     getBaseCurrency(string symbol) {return SymbolInfoString(symbol,SYMBOL_CURRENCY_BASE);}
   static string     getProfitCurrency(string symbol) {return SymbolInfoString(symbol,SYMBOL_CURRENCY_PROFIT);}
   static string     getMarginCurrency(string symbol) {return SymbolInfoString(symbol,SYMBOL_CURRENCY_MARGIN);}

   //-- trade mode
   static ENUM_SYMBOL_TRADE_MODE getTradeMode(string symbol) {return(ENUM_SYMBOL_TRADE_MODE)SymbolInfoInteger(symbol,SYMBOL_TRADE_MODE);}
   static bool       isTradeDisabled(string symbol) {return getTradeMode(symbol)==SYMBOL_TRADE_MODE_DISABLED;}
   static bool       isTradeFully(string symbol) {return getTradeMode(symbol)==SYMBOL_TRADE_MODE_FULL;}
   static bool       isTradeShortOnly(string symbol) {return getTradeMode(symbol)==SYMBOL_TRADE_MODE_SHORTONLY;}
   static bool       isTradeLongOnly(string symbol) {return getTradeMode(symbol)==SYMBOL_TRADE_MODE_LONGONLY;}
   static bool       isTradeCloseOnly(string symbol) {return getTradeMode(symbol)==SYMBOL_TRADE_MODE_CLOSEONLY;}

   static double     getInitialMargin(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_MARGIN_INITIAL);}
   static double     getMaintenanceMargin(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_MARGIN_MAINTENANCE);}
   static double     getHedgedMargin(string symbol) {return MarketInfo(symbol,MODE_MARGINHEDGED);}
   static double     getRequiredMargin(string symbol) {return MarketInfo(symbol,MODE_MARGINREQUIRED);}
   static double     getLongSwap(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_SWAP_LONG);}
   static double     getShortSwap(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_SWAP_SHORT);}

   //-- latest market info
   static double     getBid(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_BID);}
   static double     getAsk(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_ASK);}
   static bool       getTick(string symbol,MqlTick &tick) {return SymbolInfoTick(symbol,tick);}

   static double     getTickSize(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);}
   static double     getTickValue(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);}

   static double     getContractSize(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE);}

   //-- basic trade info
   static double     getPoint(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_POINT);}
   static int        getDigits(string symbol) {return (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);}
   static int        getSpread(string symbol) {return (int)SymbolInfoInteger(symbol,SYMBOL_SPREAD);}
   static bool       isSpreadFloat(string symbol) {return SymbolInfoInteger(symbol,SYMBOL_SPREAD_FLOAT)!=0;};
   static int        getStopLevel(string symbol) {return(int)SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL);}
   static int        getFreezeLevel(string symbol) {return(int)SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL);}

   //-- lot info
   static double     getMinLot(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);}
   static double     getLotStep(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);}
   static double     getMaxLot(string symbol) {return SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);}

   //-- utility methods
   static double     normalizeLots(string symbol,double lots) {return NormalizeLots(lots,getMinLot(symbol));}
   static double     normalizePrice(string symbol,double price) {return NormalizeDouble(price,getDigits(symbol));}

   static double     addPoints(string symbol,double price,int points) {return NormalizeDouble(price+points*getPoint(symbol),getDigits(symbol));}
   static double     subPoints(string symbol,double price,int points) {return NormalizeDouble(price-points*getPoint(symbol),getDigits(symbol));}

   //--- op%2==0 means a buy operation: OP_BUY OP_BUYLIMIT OP_BUYSTOP
   // OP_BUY       0 Buy operation
   // OP_SELL      1 Sell operation
   // OP_BUYLIMIT  2 Buy limit pending order
   // OP_SELLLIMIT 3 Sell limit pending order
   // OP_BUYSTOP   4 Buy stop pending order
   // OP_SELLSTOP  5 Sell stop pending order
   static double     priceForOpen(string symbol,int op) {return op%2==0?getAsk(symbol):getBid(symbol);}
   static double     priceForClose(string symbol,int op) {return op%2==0?getBid(symbol):getAsk(symbol);}

   //-- Constructor
                     FxSymbol(string symbol=""):m_symbol(symbol==""?_Symbol:symbol){}

   //-- basic properties
   string            getName() const {return m_symbol;}

   //--- SymbolWatch
   bool              select() {return select(m_symbol);}
   bool              remove() {return remove(m_symbol);}

   bool              isSelected() {return isSelected(m_symbol);}
   bool              isVisible() {return isVisible(m_symbol);}

   //-- symbol info
   string            getDescription() const {return getDescription(m_symbol);}
   string            getPath() const {return getPath(m_symbol);}
   string            getBaseCurrency() const {return getBaseCurrency(m_symbol);}
   string            getProfitCurrency() const {return getProfitCurrency(m_symbol);}
   string            getMarginCurrency() const {return getMarginCurrency(m_symbol);}

   //-- trade mode
   ENUM_SYMBOL_TRADE_MODE getTradeMode() const {return getTradeMode(m_symbol);}
   bool              isTradeDisabled() const {return isTradeDisabled(m_symbol);}
   bool              isTradeFully() const {return isTradeFully(m_symbol);}
   bool              isTradeShortOnly() const {return isTradeShortOnly(m_symbol);}
   bool              isTradeLongOnly() const {return isTradeLongOnly(m_symbol);}
   bool              isTradeCloseOnly() const {return isTradeCloseOnly(m_symbol);}

   double            getInitialMargin() const {return getInitialMargin(m_symbol);}
   double            getMaintenanceMargin() const {return getMaintenanceMargin(m_symbol);}
   double            getHedgedMargin() {return getHedgedMargin(m_symbol);}
   double            getRequiredMargin() {return getRequiredMargin(m_symbol);}
   double            getLongSwap() const {return getLongSwap(m_symbol);}
   double            getShortSwap() const {return getShortSwap(m_symbol);}

   //-- latest market info
   double            getBid() const {return getBid(m_symbol);}
   double            getAsk() const {return getAsk(m_symbol);}
   bool              getTick(MqlTick &tick) const {return getTick(m_symbol,tick);}

   double            getTickSize() const {return getTickSize(m_symbol);}
   double            getTickValue() const {return getTickValue(m_symbol);}

   double            getContractSize() const {return getContractSize(m_symbol);}

   //-- basic trade info
   double            getPoint() const {return getPoint(m_symbol);}
   int               getDigits() const {return getDigits(m_symbol);}
   int               getSpread() const {return getSpread(m_symbol);}
   bool              isSpreadFloat() const {return isSpreadFloat(m_symbol);};
   int               getStopLevel() const {return getStopLevel(m_symbol);}
   int               getFreezeLevel() const {return getFreezeLevel(m_symbol);}

   //-- lot info
   double            getMinLot() const {return getMinLot(m_symbol);}
   double            getLotStep() const {return getLotStep(m_symbol);}
   double            getMaxLot() const {return getMaxLot(m_symbol);}

   //-- utility methods
   double            normalizeLots(double lots) const {return normalizeLots(m_symbol,lots);}
   double            normalizePrice(double price) const {return normalizePrice(m_symbol,price);}

   double            addPoints(double price,int points) const {return addPoints(m_symbol,price,points);}
   double            subPoints(double price,int points) const {return subPoints(m_symbol,price,points);}

   double            priceForOpen(int op) const {return priceForOpen(m_symbol,op);}
   double            priceForClose(int op) const {return priceForClose(m_symbol,op);}
  };
//+------------------------------------------------------------------+
