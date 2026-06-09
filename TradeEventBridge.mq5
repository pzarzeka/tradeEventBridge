//+------------------------------------------------------------------+
//|                                             TradeEventBridge.mq5 |
//|                                                         pzarzeka |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "pzarzeka"
#property link      ""
#property version   "1.00"
#property strict

input string webhook_url = "http://127.0.0.1/projects/trader/index.php";
input string api_key     = "CHANGE_ME";

int OnInit()
{
   Print("TradeEventBridge initialized");

   SendInitEvent();

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   Print("TradeEventBridge stopped");
}

void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
{
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD)
      return;

   ulong deal_ticket = trans.deal;

   if(!HistoryDealSelect(deal_ticket))
      return;

   long entry_type = HistoryDealGetInteger(deal_ticket, DEAL_ENTRY);

   string event_type = "unknown";

   switch(entry_type)
   {
      case DEAL_ENTRY_IN:
         event_type = "open";
         break;

      case DEAL_ENTRY_OUT:
         event_type = "close";
         break;

      case DEAL_ENTRY_INOUT:
         event_type = "reverse";
         break;

      case DEAL_ENTRY_OUT_BY:
         event_type = "partial_close";
         break;
   }

   string symbol       = HistoryDealGetString(deal_ticket, DEAL_SYMBOL);
   double volume       = HistoryDealGetDouble(deal_ticket, DEAL_VOLUME);
   double price        = HistoryDealGetDouble(deal_ticket, DEAL_PRICE);
   double profit       = HistoryDealGetDouble(deal_ticket, DEAL_PROFIT);

   long magic          = HistoryDealGetInteger(deal_ticket, DEAL_MAGIC);
   long position_id    = HistoryDealGetInteger(deal_ticket, DEAL_POSITION_ID);
   long deal_type      = HistoryDealGetInteger(deal_ticket, DEAL_TYPE);
   long time           = HistoryDealGetInteger(deal_ticket, DEAL_TIME);

   string side = "unknown";

   if(deal_type == DEAL_TYPE_BUY)
      side = "buy";

   if(deal_type == DEAL_TYPE_SELL)
      side = "sell";

   string json = StringFormat(
      "{"
      "\"event\":\"%s\","
      "\"deal_ticket\":%I64u,"
      "\"position_id\":%I64d,"
      "\"symbol\":\"%s\","
      "\"side\":\"%s\","
      "\"volume\":%f,"
      "\"price\":%f,"
      "\"profit\":%f,"
      "\"magic\":%I64d,"
      "\"timestamp\":%I64d"
      "}",
      event_type,
      deal_ticket,
      position_id,
      symbol,
      side,
      volume,
      price,
      profit,
      magic,
      time
   );

   SendWebhook(json);
}

void SendInitEvent()
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity  = AccountInfoDouble(ACCOUNT_EQUITY);
   double margin  = AccountInfoDouble(ACCOUNT_MARGIN);

   long login     = AccountInfoInteger(ACCOUNT_LOGIN);

   string currency = AccountInfoString(ACCOUNT_CURRENCY);

   string json = StringFormat(
      "{"
      "\"event\":\"init\","
      "\"account\":%I64d,"
      "\"balance\":%f,"
      "\"equity\":%f,"
      "\"margin\":%f,"
      "\"currency\":\"%s\""
      "}",
      login,
      balance,
      equity,
      margin,
      currency
   );

   SendWebhook(json);
}

void SendWebhook(string json)
{
   char data[];
   char result[];
   string response_headers;

   StringToCharArray(json, data);

   string headers =
      "Content-Type: application/json\r\n"
      "X-API-KEY: " + api_key + "\r\n";

   ResetLastError();

   int response = WebRequest(
      "POST",
      webhook_url,
      headers,
      2000,
      data,
      result,
      response_headers
   );

   if(response == -1)
   {
      Print("Webhook error: ", GetLastError());
      return;
   }

   Print("Webhook sent: ", json);
}