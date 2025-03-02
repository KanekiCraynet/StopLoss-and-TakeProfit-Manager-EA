//+------------------------------------------------------------------+
//|                               Copyright © 2014, Хлыстов Владимир |
//|                                                cmillion@narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, Khlystov Vladimir"
#property link      "cmillion@narod.ru"
#property description "Советник выставляет всем ордерам стоплосс тейкпрофит и переводит их в безубыток"
//--------------------------------------------------------------------*/
extern int     Stoploss             = 100,           //стоплосс
               Takeprofit           = 50,            //тейкпрофит
               NoLoss               = 10,            //перевод в безубыток, если 0, то нет перевода в безубыток
               MinProfitNoLoss      = 1;             //минимальная прибыль при переводе вбезубыток
//-------------------------------------------------------------------- 
int OnInit()
{ 
   DrawLABEL("Stoploss",StringConcatenate("Stoploss ",Stoploss),5,15,Gray);
   DrawLABEL("Takeprofit",StringConcatenate("Takeprofit ",Takeprofit),5,35,Gray);
   DrawLABEL("NoLoss",StringConcatenate("NoLoss ",NoLoss," + ",MinProfitNoLoss),5,55,Gray);
   return(INIT_SUCCEEDED);
}
//-------------------------------------------------------------------
void OnDeinit(const int reason)
{
   ObjectDelete("Stoploss");
   ObjectDelete("Takeprofit");
   ObjectDelete("NoLoss");
}
//--------------------------------------------------------------------
void OnTick()
{
   if (!IsTradeAllowed()) return;
   int STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double OSL,OTP,OOP,StLo,SL,TP;
   int tip;
   for (int i=0; i<OrdersTotal(); i++)
   {    
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      { 
         if (OrderSymbol()==Symbol())
         { 
            tip = OrderType(); 
            OSL = NormalizeDouble(OrderStopLoss(),Digits);
            OTP = NormalizeDouble(OrderTakeProfit(),Digits);
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);
            SL=OSL;TP=OTP;
            if (tip==OP_BUY)             
            {  
               if (OSL==0 && Stoploss>=STOPLEVEL && Stoploss!=0)
               {
                  SL = NormalizeDouble(OOP - Stoploss   * Point,Digits);
               } 
               if (OTP==0 && Takeprofit>=STOPLEVEL && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP + Takeprofit * Point,Digits);
               } 
               if (OSL<OOP && NoLoss!=0 && NoLoss>=STOPLEVEL)
               {
                  StLo = NormalizeDouble(OOP+MinProfitNoLoss*Point,Digits); 
                  if (StLo > OSL && StLo <= NormalizeDouble(Bid - NoLoss * Point,Digits)) SL = StLo;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,White)) Print("Error OrderModify ",GetLastError());
               }
            }                                         
            if (tip==OP_SELL)        
            {
               if (OSL==0 && Stoploss>=STOPLEVEL && Stoploss!=0)
               {
                  SL = NormalizeDouble(OOP + Stoploss   * Point,Digits);
               }
               if (OTP==0 && Takeprofit>=STOPLEVEL && Takeprofit!=0)
               {
                  TP = NormalizeDouble(OOP - Takeprofit * Point,Digits);
               }
               if ((OSL>OOP || OSL==0) && NoLoss!=0 && NoLoss>=STOPLEVEL)
               {
                  StLo = NormalizeDouble(OOP-MinProfitNoLoss*Point,Digits); 
                  if ((StLo < OSL || OSL==0) && StLo >= NormalizeDouble(Ask + NoLoss * Point,Digits)) SL = StLo;
               }
               if (SL != OSL || TP != OTP)
               {  
                  if (!OrderModify(OrderTicket(),OOP,SL,TP,0,White)) Print("Error OrderModify ",GetLastError());
               }
            } 
         }
      }
   } 
}
//--------------------------------------------------------------------
void DrawLABEL(string name, string Name, int X, int Y, color clr)
{
   if (ObjectFind(name)==-1)
   {
      ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
      ObjectSet(name, OBJPROP_CORNER, 1);
      ObjectSet(name, OBJPROP_XDISTANCE, X);
      ObjectSet(name, OBJPROP_YDISTANCE, Y);
   }
   ObjectSetText(name,Name,12,"Arial",clr);
}
//--------------------------------------------------------------------
