//+------------------------------------------------------------------+
//|                                                       common.mq4 |
//|                                              Copyright 2020, kc. |
//|                                            https://www.eyouc.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, kc."
#property link      "https://www.eyouc.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 文件操作                                            |
//+------------------------------------------------------------------+
void iFileOperation(string myFileName,int myFileType,int myFileMode,string myFileString) 
{ 
  int myHandle; //文件序列号 
  if (myFileMode==0 && myFileString=="") //新建文件 
  { 
    if (myFileType==0) 
      myHandle=FileOpen(myFileName,FILE_BIN|FILE_WRITE); 
    if (myFileType==1) 
      myHandle=FileOpen(myFileName,FILE_CSV|FILE_WRITE,";"); 
      
    FileClose(myHandle); 
  } 
  if (myFileMode==1 && myFileString!="") //创建写入字符串 
  { 
    if (myFileType==0) 
      myHandle=FileOpen(myFileName,FILE_BIN|FILE_WRITE); 
    if (myFileType==1) 
      myHandle=FileOpen(myFileName,FILE_CSV|FILE_WRITE,";"); 

    FileWrite(myHandle,myFileString); 
    FileClose(myHandle); 
  } 
  if (myFileMode==2 && myFileString!="") //追加写入字符串 
  { 
    if (myFileType==0) 
    { 
      myHandle=FileOpen(myFileName,FILE_BIN|FILE_READ|FILE_WRITE); 
      FileSeek(myHandle,0,SEEK_END); 
      FileWrite(myHandle,myFileString); 
      FileClose(myHandle); 
    } 
    if (myFileType==1) 
    { 
      myHandle=FileOpen(myFileName,FILE_CSV|FILE_READ|FILE_WRITE,";"); 
      FileSeek(myHandle,SEEK_SET,SEEK_END); 
      FileWrite(myHandle,myFileString); 
      FileClose(myHandle); 
    } 
  } 
  return(0); 
}


//+------------------------------------------------------------------+
//| 开单整形                                          |
//+------------------------------------------------------------------+
double iLotsFormat(double myLots) 
{ 
  myLots=MathRound(myLots/MarketInfo(Symbol(), MODE_MINLOT))*MarketInfo(Symbol(), MODE_MINLOT);//开仓量整形 
  return(myLots); 
}

//+------------------------------------------------------------------+
//| 持单净值总计                    |
//+------------------------------------------------------------------+
double iGroupEquity(int myOrderType,int myMagicNum) 
{ 
  double myReturn; 
  if (OrdersTotal()==0) 
    return(0); 
  for (int cnt=0;cnt<OrdersTotal();i++)
  { 
    if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==myMagicNum && OrderSymbol()==Symbol() && OrderType()==myOrderType) 
    { 
      myReturn=myReturn+OrderProfit(); 
    } 
  } 
  return(myReturn); 
}

//+------------------------------------------------------------------+
//| 持仓单开仓量总计                    |
//+------------------------------------------------------------------+
double iGroupLots(int myOrderType,int myMagicNum) 
{ 
  double myReturn; 
  if (OrdersTotal()==0) 
    return(0); 
  for (int cnt=0;cnt<OrdersTotal();i++)
  { 
    if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==myMagicNum && OrderSymbol()==Symbol() && OrderType()==myOrderType) 
    { 
      myReturn=myReturn+OrderLots(); 
    } 
  } 
  return(myReturn); 
}

//+------------------------------------------------------------------+
//| 持仓单数量统计                    |
//+------------------------------------------------------------------+
int iOrderStatistics(int myOrderType,int myMagicNum) 
{ 
  int myReturn; 
  if (OrdersTotal()==0) 
    return(0); 
  for (int cnt=0;cnt<OrdersTotal();i++) 
  { 
    if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==myMagicNum && OrderSymbol()==Symbol() && OrderType()==myOrderType) 
    { 
      myReturn=myReturn+1; 
    } 
  } 
  return(myReturn); 
}

//+------------------------------------------------------------------+
//| 计算特定条件的订单                    |
//+------------------------------------------------------------------+
int iOrdersSort(int myOrderType,int myOrderSort,int myMaxMin,int myMagicNum) 
{ 
  int myReturn,myArrayRange,cnt,i,j; 
  if (OrdersTotal()<=0) 
    return(myReturn); 
  myArrayRange=OrdersTotal(); //持仓订单基本信息:0订单号,1开仓时间,2订单利润,3订单类型,4开仓量,5开仓价, // 6止损价,7止赢价,8订单特征码,9订单佣金,10掉期,11挂单有效日期 
  double myOrdersArray[][12]; //定义订单数组,第1维:订单序号;第2维:订单信息 
  ArrayResize(myOrdersArray,myArrayRange); //重新界定订单数组 
  ArrayInitialize(myOrdersArray, 0.0); //初始化订单数组 
  //订单数组赋值 
  for (cnt=0; cnt<OrdersTotal();i++) 
  { 
    //选中当前货币对相关持仓订单 
    if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==myMagicNum) 
    { 
      myOrdersArray[cnt][0]=OrderTicket();//0订单号 
      myOrdersArray[cnt][1]=OrderOpenTime();//1开仓时间 
      myOrdersArray[cnt][2]=OrderProfit();//2订单利润 
      myOrdersArray[cnt][3]=OrderType();//3订单类型 
      myOrdersArray[cnt][4]=OrderLots();//4开仓量 
      myOrdersArray[cnt][5]=OrderOpenPrice();//5开仓价 
      myOrdersArray[cnt][6]=OrderStopLoss();//6止损价 
      myOrdersArray[cnt][7]=OrderTakeProfit();//7止赢价 
      myOrdersArray[cnt][8]=OrderMagicNumber();//8订单特征码 
      myOrdersArray[cnt][9]=OrderCommission();//9订单佣金 
      myOrdersArray[cnt][10]=OrderSwap();//10掉期 
      myOrdersArray[cnt][11]=OrderExpiration();//11挂单有效日期 
      } 
    } 
    double myTempArray[12]; //定义临时数组 //
    ArrayResize(myTempArray,myArrayRange); //重新界定临时数组 
    ArrayInitialize(myTempArray, 0.0); //初始化临时数组 //开始按条件排序 //---- 按时间降序排列数组,原始数组重新排序 
    if (myOrderSort==0) 
    { 
      for (i=0;i<=myArrayRange;i++) 
      { 
        for (j=myArrayRange;j>i;j--) 
        { 
          if (myOrdersArray[j][1]>myOrdersArray[j-1][1]) 
          { 
            myTempArray[0]=myOrdersArray[j-1][0]; 
            myTempArray[1]=myOrdersArray[j-1][1]; 
            myTempArray[2]=myOrdersArray[j-1][2]; 
            myTempArray[3]=myOrdersArray[j-1][3]; 
            myTempArray[4]=myOrdersArray[j-1][4]; 
            myTempArray[5]=myOrdersArray[j-1][5]; 
            myTempArray[6]=myOrdersArray[j-1][6]; 
            myTempArray[7]=myOrdersArray[j-1][7]; 
            myTempArray[8]=myOrdersArray[j-1][8]; 
            myTempArray[9]=myOrdersArray[j-1][9]; 
            myTempArray[10]=myOrdersArray[j-1][10]; 
            myTempArray[11]=myOrdersArray[j-1][11]; 
            myOrdersArray[j-1][0]=myOrdersArray[j][0]; 
            myOrdersArray[j-1][1]=myOrdersArray[j][1]; 
            myOrdersArray[j-1][2]=myOrdersArray[j][2]; 
            myOrdersArray[j-1][3]=myOrdersArray[j][3]; 
            myOrdersArray[j-1][4]=myOrdersArray[j][4]; 
            myOrdersArray[j-1][5]=myOrdersArray[j][5]; 
            myOrdersArray[j-1][6]=myOrdersArray[j][6]; 
            myOrdersArray[j-1][7]=myOrdersArray[j][7]; 
            myOrdersArray[j-1][8]=myOrdersArray[j][8]; 
            myOrdersArray[j-1][9]=myOrdersArray[j][9]; 
            myOrdersArray[j-1][10]=myOrdersArray[j][10]; 
            myOrdersArray[j-1][11]=myOrdersArray[j][11]; 
            myOrdersArray[j][0]=myTempArray[0];
             myOrdersArray[j][1]=myTempArray[1]; 
             myOrdersArray[j][2]=myTempArray[2]; 
             myOrdersArray[j][3]=myTempArray[3]; 
             myOrdersArray[j][4]=myTempArray[4]; 
             myOrdersArray[j][5]=myTempArray[5]; 
             myOrdersArray[j][6]=myTempArray[6]; 
             myOrdersArray[j][7]=myTempArray[7]; 
             myOrdersArray[j][8]=myTempArray[8]; 
             myOrdersArray[j][9]=myTempArray[9]; 
             myOrdersArray[j][10]=myTempArray[10]; 
             myOrdersArray[j][11]=myTempArray[11]; 
            } 
          } 
        } 
        if (myMaxMin==0) //x,0,0 
        { 
          for (cnt=myArrayRange;cnt>=0;cnt--) 
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); 
              break; 
            } 
          } 
        } 
        if (myMaxMin==1) //x,0,1 
        { 
          for (cnt=0;cnt<OrdersTotal();i++)  
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0)) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); break; 
            } 
          } 
        } 
      } 
      //---- 按订单净值降序排列数组,原始数组重新排序 
      if (myOrderSort==1 || myOrderSort==2) 
      { 
        ArrayInitialize(myTempArray, 0.0); //初始化临时数组 
        for (i=0;i<=myArrayRange;i++) 
        { 
          for (j=myArrayRange-1;j>i;j--) 
          { 
            if (myOrdersArray[j][2]>myOrdersArray[j-1][2]) 
            { 
              myTempArray[0]=myOrdersArray[j-1][0]; 
              myTempArray[1]=myOrdersArray[j-1][1]; 
              myTempArray[2]=myOrdersArray[j-1][2]; 
              myTempArray[3]=myOrdersArray[j-1][3]; 
              myTempArray[4]=myOrdersArray[j-1][4]; 
              myTempArray[5]=myOrdersArray[j-1][5]; 
              myTempArray[6]=myOrdersArray[j-1][6]; 
              myTempArray[7]=myOrdersArray[j-1][7]; 
              myTempArray[8]=myOrdersArray[j-1][8]; 
              myTempArray[9]=myOrdersArray[j-1][9]; 
              myTempArray[10]=myOrdersArray[j-1][10]; 
              myTempArray[11]=myOrdersArray[j-1][11]; 
              myOrdersArray[j-1][0]=myOrdersArray[j][0]; 
              myOrdersArray[j-1][1]=myOrdersArray[j][1]; 
              myOrdersArray[j-1][2]=myOrdersArray[j][2];
              myOrdersArray[j-1][3]=myOrdersArray[j][3]; 
              myOrdersArray[j-1][4]=myOrdersArray[j][4]; 
              myOrdersArray[j-1][5]=myOrdersArray[j][5]; 
              myOrdersArray[j-1][6]=myOrdersArray[j][6]; 
              myOrdersArray[j-1][7]=myOrdersArray[j][7]; 
              myOrdersArray[j-1][8]=myOrdersArray[j][8]; 
              myOrdersArray[j-1][9]=myOrdersArray[j][9]; 
              myOrdersArray[j-1][10]=myOrdersArray[j][10]; 
              myOrdersArray[j-1][11]=myOrdersArray[j][11]; 
              myOrdersArray[j][0]=myTempArray[0]; 
              myOrdersArray[j][1]=myTempArray[1]; 
              myOrdersArray[j][2]=myTempArray[2]; 
              myOrdersArray[j][3]=myTempArray[3]; 
              myOrdersArray[j][4]=myTempArray[4]; 
              myOrdersArray[j][5]=myTempArray[5]; 
              myOrdersArray[j][6]=myTempArray[6]; 
              myOrdersArray[j][7]=myTempArray[7]; 
              myOrdersArray[j][8]=myTempArray[8]; 
              myOrdersArray[j][9]=myTempArray[9]; 
              myOrdersArray[j][10]=myTempArray[10]; 
              myOrdersArray[j][11]=myTempArray[11]; 
            } 
          } 
        } 
        if (myOrderSort==1 && myMaxMin==1) //x,1,1 
        { 
          for (cnt=myArrayRange;cnt>=0;cnt--) 
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0) && myOrdersArray[cnt][2]>0) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); break; 
            } 
          } 
        } 
        if (myOrderSort==1 && myMaxMin==0) //x,1,0 
        { 
          for (cnt=0;cnt<OrdersTotal();i++)
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0) && myOrdersArray[cnt][2]>0) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); 
              break; 
            } 
          } 
        } 
        if (myOrderSort==2 && myMaxMin==0) //x,2,1 
        { 
          for (cnt=myArrayRange;cnt>=0;cnt--) 
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0) && myOrdersArray[cnt][2]<0) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); 
              break; 
            } 
          } 
        } 
        if (myOrderSort==2 && myMaxMin==1) //x,2,0 
        { 
          for (cnt=0;cnt<OrdersTotal();i++)
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0) && myOrdersArray[cnt][2]<0) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); 
              break; 
            } 
          } 
        } 
      } 
      //---- 按开仓价降序排列数组,原始数组重新排序 
      if (myOrderSort==3) 
      { 
        for (i=0;i<=myArrayRange;i++) 
        { 
          for (j=myArrayRange;j>i;j--) 
          { 
            if (myOrdersArray[j][5]>myOrdersArray[j-1][5]) 
            { 
              myTempArray[0]=myOrdersArray[j-1][0]; 
              myTempArray[1]=myOrdersArray[j-1][1]; 
              myTempArray[2]=myOrdersArray[j-1][2]; 
              myTempArray[3]=myOrdersArray[j-1][3]; 
              myTempArray[4]=myOrdersArray[j-1][4]; 
              myTempArray[5]=myOrdersArray[j-1][5]; 
              myTempArray[6]=myOrdersArray[j-1][6]; 
              myTempArray[7]=myOrdersArray[j-1][7]; 
              myTempArray[8]=myOrdersArray[j-1][8]; 
              myTempArray[9]=myOrdersArray[j-1][9]; 
              myTempArray[10]=myOrdersArray[j-1][10]; 
              myTempArray[11]=myOrdersArray[j-1][11]; 
              myOrdersArray[j-1][0]=myOrdersArray[j][0]; 
              myOrdersArray[j-1][1]=myOrdersArray[j][1]; 
              myOrdersArray[j-1][2]=myOrdersArray[j][2]; 
              myOrdersArray[j-1][3]=myOrdersArray[j][3]; 
              myOrdersArray[j-1][4]=myOrdersArray[j][4]; 
              myOrdersArray[j-1][5]=myOrdersArray[j][5];
              myOrdersArray[j-1][6]=myOrdersArray[j][6]; 
              myOrdersArray[j-1][7]=myOrdersArray[j][7]; 
              myOrdersArray[j-1][8]=myOrdersArray[j][8]; 
              myOrdersArray[j-1][9]=myOrdersArray[j][9]; 
              myOrdersArray[j-1][10]=myOrdersArray[j][10]; 
              myOrdersArray[j-1][11]=myOrdersArray[j][11]; 
              myOrdersArray[j][0]=myTempArray[0]; 
              myOrdersArray[j][1]=myTempArray[1]; 
              myOrdersArray[j][2]=myTempArray[2]; 
              myOrdersArray[j][3]=myTempArray[3]; 
              myOrdersArray[j][4]=myTempArray[4]; 
              myOrdersArray[j][5]=myTempArray[5]; 
              myOrdersArray[j][6]=myTempArray[6]; 
              myOrdersArray[j][7]=myTempArray[7]; 
              myOrdersArray[j][8]=myTempArray[8]; 
              myOrdersArray[j][9]=myTempArray[9]; 
              myOrdersArray[j][10]=myTempArray[10]; 
              myOrdersArray[j][11]=myTempArray[11]; 
            } 
          } 
        } 
        if (myMaxMin==1) //x,3,0 
        { 
          for (cnt=myArrayRange;cnt>=0;cnt--) 
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0) && myOrdersArray[cnt][5]>0) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); 
              break; 
            } 
          } 
        } 
        if (myMaxMin==0) //x,3,1 
        { 
          for (cnt=0;cnt<OrdersTotal();i++)
          { 
            if (myOrdersArray[cnt][0]!=0 && myOrderType==NormalizeDouble(myOrdersArray[cnt][3],0) && myOrdersArray[cnt][5]>0) 
            { 
              myReturn=NormalizeDouble(myOrdersArray[cnt][0],0); 
              break; 
            } 
          } 
        } 
      } 
      return(myReturn); 
    }
}

//+------------------------------------------------------------------+
//| 交易繁忙，程序等待，更新缓存数据                    |
//+------------------------------------------------------------------+
void iWait(int myDelayTime) 
{ 
  while (!IsTradeAllowed() || IsTradeContextBusy()) 
  Sleep(myDelayTime); 
  RefreshRates(); 
  return(0); 
}


//+------------------------------------------------------------------+
//| 显示错误信息                   |
//+------------------------------------------------------------------+
string iGetErrorInfo(int myErrorNum) 
{ 
  string myLastErrorStr; 
  if(myErrorNum>=0) 
  { 
    switch (myErrorNum) 
    { 
      case 0:myLastErrorStr="错误代码:"+0+"-没有错误返回";break; 
      case 1:myLastErrorStr="错误代码:"+1+"-没有错误返回但结果不明";break; 
      case 2:myLastErrorStr="错误代码:"+2+"-一般错误";break; 
      case 3:myLastErrorStr="错误代码:"+3+"-无效交易参量";break; 
      case 4:myLastErrorStr="错误代码:"+4+"-交易服务器繁忙";break; 
      case 5:myLastErrorStr="错误代码:"+5+"-客户终端旧版本";break; 
      case 6:myLastErrorStr="错误代码:"+6+"-没有连接服务器";break; 
      case 7:myLastErrorStr="错误代码:"+7+"-没有权限";break; 
      case 8:myLastErrorStr="错误代码:"+8+"-请求过于频繁";break; 
      case 9:myLastErrorStr="错误代码:"+9+"-交易运行故障";break; 
      case 64:myLastErrorStr="错误代码:"+64+"-账户禁止";break; 
      case 65:myLastErrorStr="错误代码:"+65+"-无效账户";break; 
      case 128:myLastErrorStr="错误代码:"+128+"-交易超时";break; 
      case 129:myLastErrorStr="错误代码:"+129+"-无效价格";break; 
      case 130:myLastErrorStr="错误代码:"+130+"-无效停止";break; 
      case 131:myLastErrorStr="错误代码:"+131+"-无效交易量";break; 
      case 132:myLastErrorStr="错误代码:"+132+"-市场关闭";break; 
      case 133:myLastErrorStr="错误代码:"+133+"-交易被禁止";break; 
      case 134:myLastErrorStr="错误代码:"+134+"-资金不足";break; 
      case 135:myLastErrorStr="错误代码:"+135+"-价格改变";break; 
      case 136:myLastErrorStr="错误代码:"+136+"-开价";break; 
      case 137:myLastErrorStr="错误代码:"+137+"-经纪繁忙";break; 
      case 138:myLastErrorStr="错误代码:"+138+"-重新开价";break; 
      case 139:myLastErrorStr="错误代码:"+139+"-定单被锁定";break; 
      case 140:myLastErrorStr="错误代码:"+140+"-只允许看涨仓位";break; 
      case 141:myLastErrorStr="错误代码:"+141+"-过多请求";break; 
      case 145:myLastErrorStr="错误代码:"+145+"-因为过于接近市场，修改无效";break; 
      case 146:myLastErrorStr="错误代码:"+146+"-交易文本已满";break; 
      case 147:myLastErrorStr="错误代码:"+147+"-时间周期被经纪否定";break; 
      case 148:myLastErrorStr="错误代码:"+148+"-开单和挂单总数已被经纪限定";break; 
      case 149:myLastErrorStr="错误代码:"+149+"-当对冲被拒绝时,打开相对于现有的一个单量";break; 
      case 150:myLastErrorStr="错误代码:"+150+"-把为反FIFO规定的单子平掉";break; 
      case 4000:myLastErrorStr="错误代码:"+4000+"-没有错误";break; 
      case 4001:myLastErrorStr="错误代码:"+4001+"-错误函数指示";break; 
      case 4002:myLastErrorStr="错误代码:"+4002+"-数组索引超出范围";break; 
      case 4003:myLastErrorStr="错误代码:"+4003+"-对于调用堆栈储存器函数没有足够内存";break; 
      case 4004:myLastErrorStr="错误代码:"+4004+"-循环堆栈储存器溢出";break; 
      case 4005:myLastErrorStr="错误代码:"+4005+"-对于堆栈储存器参量没有内存";break; 
      case 4006:myLastErrorStr="错误代码:"+4006+"-对于字行参量没有足够内存";break; 
      case 4007:myLastErrorStr="错误代码:"+4007+"-对于字行没有足够内存";break; 
      case 4008:myLastErrorStr="错误代码:"+4008+"-没有初始字行";break; 
      case 4009:myLastErrorStr="错误代码:"+4009+"-在数组中没有初始字串符";break; 
      case 4010:myLastErrorStr="错误代码:"+4010+"-对于数组没有内存";break; 
      case 4011:myLastErrorStr="错误代码:"+4011+"-字行过长";break; 
      case 4012:myLastErrorStr="错误代码:"+4012+"-余数划分为零";break; 
      case 4013:myLastErrorStr="错误代码:"+4013+"-零划分";break; 
      case 4014:myLastErrorStr="错误代码:"+4014+"-不明命令";break; 
      case 4015:myLastErrorStr="错误代码:"+4015+"-错误转换(没有常规错误)";break; 
      case 4016:myLastErrorStr="错误代码:"+4016+"-没有初始数组";break; 
      case 4017:myLastErrorStr="错误代码:"+4017+"-禁止调用DLL ";break; 
      case 4018:myLastErrorStr="错误代码:"+4018+"-数据库不能下载";break; 
      case 4019:myLastErrorStr="错误代码:"+4019+"-不能调用函数";break; 
      case 4020:myLastErrorStr="错误代码:"+4020+"-禁止调用智能交易函数";break; 
      case 4021:myLastErrorStr="错误代码:"+4021+"-对于来自函数的字行没有足够内存";break; 
      case 4022:myLastErrorStr="错误代码:"+4022+"-系统繁忙 (没有常规错误)";break; 
      case 4050:myLastErrorStr="错误代码:"+4050+"-无效计数参量函数";break; 
      case 4051:myLastErrorStr="错误代码:"+4051+"-无效开仓量";break; 
      case 4052:myLastErrorStr="错误代码:"+4052+"-字行函数内部错误";break; 
      case 4053:myLastErrorStr="错误代码:"+4053+"-一些数组错误";break; 
      case 4054:myLastErrorStr="错误代码:"+4054+"-应用不正确数组";break; 
      case 4055:myLastErrorStr="错误代码:"+4055+"-自定义指标错误";break; 
      case 4056:myLastErrorStr="错误代码:"+4056+"-不协调数组";break; 
      case 4057:myLastErrorStr="错误代码:"+4057+"-整体变量过程错误";break; 
      case 4058:myLastErrorStr="错误代码:"+4058+"-整体变量未找到";break; 
      case 4059:myLastErrorStr="错误代码:"+4059+"-测试模式函数禁止";break; 
      case 4060:myLastErrorStr="错误代码:"+4060+"-没有确认函数";break; 
      case 4061:myLastErrorStr="错误代码:"+4061+"-发送邮件错误";break; 
      case 4062:myLastErrorStr="错误代码:"+4062+"-字行预计参量";break; 
      case 4063:myLastErrorStr="错误代码:"+4063+"-整数预计参量";break; 
      case 4064:myLastErrorStr="错误代码:"+4064+"-双预计参量";break; 
      case 4065:myLastErrorStr="错误代码:"+4065+"-数组作为预计参量";break; 
      case 4066:myLastErrorStr="错误代码:"+4066+"-刷新状态请求历史数据";break; 
      case 4067:myLastErrorStr="错误代码:"+4067+"-交易函数错误";break; 
      case 4099:myLastErrorStr="错误代码:"+4099+"-文件结束";break; 
      case 4100:myLastErrorStr="错误代码:"+4100+"-一些文件错误";break; 
      case 4101:myLastErrorStr="错误代码:"+4101+"-错误文件名称";break; 
      case 4102:myLastErrorStr="错误代码:"+4102+"-打开文件过多";break; 
      case 4103:myLastErrorStr="错误代码:"+4103+"-不能打开文件";break; 
      case 4104:myLastErrorStr="错误代码:"+4104+"-不协调文件";break; 
      case 4105:myLastErrorStr="错误代码:"+4105+"-没有选择定单";break; 
      case 4106:myLastErrorStr="错误代码:"+4106+"-不明货币对";break; 
      case 4107:myLastErrorStr="错误代码:"+4107+"-无效价格";break; 
      case 4108:myLastErrorStr="错误代码:"+4108+"-无效定单编码";break; 
      case 4109:myLastErrorStr="错误代码:"+4109+"-不允许交易";break; 
      case 4110:myLastErrorStr="错误代码:"+4110+"-不允许长期";break; 
      case 4111:myLastErrorStr="错误代码:"+4111+"-不允许短期";break; 
      case 4200:myLastErrorStr="错误代码:"+4200+"-定单已经存在";break; 
      case 4201:myLastErrorStr="错误代码:"+4201+"-不明定单属性";break; 
      case 4202:myLastErrorStr="错误代码:"+4202+"-定单不存在";break; 
      case 4203:myLastErrorStr="错误代码:"+4203+"-不明定单类型";break; 
      case 4204:myLastErrorStr="错误代码:"+4204+"-没有定单名称";break; 
      case 4205:myLastErrorStr="错误代码:"+4205+"-定单坐标错误";break; 
      case 4206:myLastErrorStr="错误代码:"+4206+"-没有指定子窗口";break; 
      case 4207:myLastErrorStr="错误代码:"+4207+"-定单一些函数错误";break; 
      case 4250:myLastErrorStr="错误代码:"+4250+"-错误设定发送通知到队列中";break; 
      case 4251:myLastErrorStr="错误代码:"+4251+"-无效参量- 空字符串传递到SendNotification()函数";break; 
      case 4252:myLastErrorStr="错误代码:"+4252+"-无效设置发送通知(未指定ID或未启用通知)";break; 
      case 4253:myLastErrorStr="错误代码:"+4253+"-通知发送过于频繁";break; 
    } 
  } 
  return(myLastErrorStr); 
}


//+------------------------------------------------------------------+
//| 净值转换点数                    |
//+------------------------------------------------------------------+
int iOrderEquitToPoint(int myTicket) 
{ 
  int myPoint=0; 
  if (OrderSelect(myTicket,SELECT_BY_TICKET,MODE_TRADES)) 
  { 
    if (OrderType()==OP_BUY) 
    { 
      myPoint=(Bid-OrderOpenPrice())/Point; 
    } 
    if (OrderType()==OP_SELL) 
    { 
      myPoint=(OrderOpenPrice()-Ask)/Point; 
    } 
  } 
  return(myPoint); 
}

//+------------------------------------------------------------------+
//| 金额转换手数                    |
//+------------------------------------------------------------------+
double iFundsToHands(string mySymbol,double myFunds) 
{ 
  double myLots=myFunds/MarketInfo(mySymbol, MODE_MARGINREQUIRED);//换算可开仓手数 
  myLots=MathRound(myLots/MarketInfo(mySymbol, MODE_MINLOT))*MarketInfo(Symbol(), MODE_MINLOT);//手数整形 
  return(myLots); 
}


int iBarCode(int myBarShift)
{
  int result=0;
  double myOpen,myHigh,myLow,myClose;//开高低收
  myOpen=iOpen(NULL,0,myBarShift);
  myHigh=iHigh(NULL,0,myBarShift);
  myLow=iLow(NULL,0,myBarShift);
  myClose=iClose(NULL,0,myBarShift);
  if(myOpen<myClose&&myOpen==myLow&&myClose==myHigh)
     result=1;//光头光脚阳线
  else if(myOpen>myClose&&myOpen==myHigh&&myClose==myLow)
     result=-1;//光头光脚阴线
  else if(myOpen<myClose&&myOpen>myLow&&myClose==myHigh)
     result=2;//下引线阳线
  else if(myOpen>myClose&&myOpen==myHigh&&myClose>myLow)
     result=-2;//下引线阴线
  else if(myOpen<myClose&&myOpen==myLow&&myClose<myHigh)
     result=3;//上引线阳线
  else if(myOpen>myClose&&myOpen<myHigh&&myClose==myLow)
     result=-3;//上引线阴线
  else if(myOpen<myClose&&myOpen>myLow&&myClose<myHigh)
     result=4;//上下引线阳线
  else if(myOpen>myClose&&myOpen<myHigh&&myClose>myLow)
     result=-4;//上下引线阴线
  else if(myOpen==myClose&&myOpen==myLow&&myClose<myHigh)
     result=5;//倒T字型
  else if(myOpen==myClose&&myOpen==myHigh&&myClose>myLow)
     result=-5;//T字型
  else if(myOpen==myClose&&myOpen>myLow&&myClose<myHigh)
     result=6;//十字型
  else if(myOpen==myClose&&myOpen==myHigh&&myClose==myLow)
     result=-6;//一字型

  return(result);
}
//+------------------------------------------------------------------+
//| 使用本函数 最好不要设置止盈止损功能                   |
//+------------------------------------------------------------------+
int iOpenOrders(string myType,double myLots,int myLossStop,int myTakeProfit)
{
  int ticketNo=-1;
  int mySpread=MarketInfo(Symbol(),MODE_SPREAD);//点差 手续费 市场滑点
  double sl_buy=(myLossStop<=0)?0:(Ask-myLossStop*Point);
  double tp_buy=(myTakeProfit<=0)?0:(Ask+myTakeProfit*Point);
  double sl_sell=(myLossStop<=0)?0:(Bid+myLossStop*Point);
  double tp_sell=(myTakeProfit<=0)?0:(Bid-myTakeProfit*Point);
  if(myType=="Buy")
    ticketNo=OrderSend(Symbol(),OP_BUY,myLots,Ask,mySpread,sl_buy,tp_buy);
  if(myType=="Sell")
    ticketNo=OrderSend(Symbol(),OP_SELL,myLots,Bid,mySpread,sl_sell,tp_sell);
  
  return ticketNo;
}

//+------------------------------------------------------------------+
//| 关闭订单                  |
//+------------------------------------------------------------------+
void iCloseOrders(string myType)
{
  int cnt=OrdersTotal();
  int i;
  //选择当前持仓单
  if(OrderSelect(cnt-1,SELECT_BY_POS)==false)return;
  if(myType=="All")
  {
    for(i=cnt-1;i>=0;i--)
    {
      if(OrderSelect(i,SELECT_BY_POS)==false)continue;
      else
        OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0); //?Close[0]与OrderClosePrice()有区别么
    }
  }
  else if(myType=="Buy")
  {
    for(i=cnt-1;i>=0;i--)
    {
      if(OrderSelect(i,SELECT_BY_POS)==false)continue;
      else if(OrderType()==OP_BUY)
        OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
    }
  }
  else if(myType=="Sell")
  {
    for(i=cnt-1;i>=0;i--)
    {
      if(OrderSelect(i,SELECT_BY_POS)==false)continue;
      else if(OrderType()==OP_SELL)
        OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
    }
  }
  else if(myType=="Profit")
  {
    for(i=cnt-1;i>=0;i--)
    {
      if(OrderSelect(i,SELECT_BY_POS)==false)continue;
      else if(OrderProfit()>0)
        OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
    }
  }
  else if(myType=="Loss")
  {
    for(i=cnt-1;i>=0;i--)
    {
      if(OrderSelect(i,SELECT_BY_POS)==false)continue;
      else if(OrderProfit()<0)
        OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
    }
  }
}

//+------------------------------------------------------------------+
//| 移动止损                 |
//+------------------------------------------------------------------+
void iMoveStopLoss(int myStopLoss)
{
  int Cnt=OrdersTotal()-1;
  if(OrdersTotal()>0)
  {
    for(int i=Cnt;i>=0;i--)
    {
      if(OrderSelect(i,SELECT_BY_POS)==false)continue;
      else
      {
        if(OrderProfit()>0&& OrderType()==OP_BUY &&((Close[0]-OrderStopLoss())>2*myStopLoss*Point))
        {
          OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*myStopLoss,OrderTakeProfit(),0);
        }
        if(OrderProfit()>0&& OrderType()==OP_SELL &&((OrderStopLoss()-Close[0])>2*myStopLoss*Point))
        {
          OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*myStopLoss,OrderTakeProfit(),0);
        }
      }
    }
  }
}

//+------------------------------------------------------------------+
//| 获取当前的账户盈亏金额                    |
//+------------------------------------------------------------------+
double getProfitBuyType(int myMagicNum) {
   double returnValue = 0;
   for(int i =0; i< OrdersTotal(); i++){
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()== Symbol() && OrderMagicNumber() == myMagicNum)
      {
        returnValue = returnValue + OrderProfit() + OrderSwap()+ OrderCommission();
      }
      else{
         continue;
      }
   }
   return returnValue;
}

//+------------------------------------------------------------------+
//| 获取最新订单的类型                                   |
//+------------------------------------------------------------------+
double FindLastBuyType(int myMagicNum) 
{
  double l_ord_open_price_0;
  int l_ticket_8;
  double ld_unused_12 = 0;
  int l_ticket_20 = 0;
  for (int l_pos_24 = OrdersTotal() - 1; l_pos_24 >= 0; l_pos_24--) 
  {
    OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
    if (OrderSymbol() != Symbol() || OrderMagicNumber() != myMagicNum) continue;
    if (OrderSymbol() == Symbol() && OrderMagicNumber() == myMagicNum) 
    {
      l_ticket_8 = OrderTicket();
      if (l_ticket_8 > l_ticket_20) 
      {
        l_ord_open_price_0 = OrderType();
        ld_unused_12 = l_ord_open_price_0;
        l_ticket_20 = l_ticket_8;
      }
    }
  }
  return (l_ord_open_price_0);
}

//+------------------------------------------------------------------+
//| 获取最新订单的价格                                   |
//+------------------------------------------------------------------+
double FindLastBuyPrice(int myMagicNum) 
{
  double l_ord_open_price_0;
  int l_ticket_8;
  double ld_unused_12 = 0;
  int l_ticket_20 = 0;
  for (int l_pos_24 = OrdersTotal() - 1; l_pos_24 >= 0; l_pos_24--) 
  {
    OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
    if (OrderSymbol() != Symbol() || OrderMagicNumber() != myMagicNum) continue;
    if (OrderSymbol() == Symbol() && OrderMagicNumber() == myMagicNum) 
    {
      l_ticket_8 = OrderTicket();
      if (l_ticket_8 > l_ticket_20) 
      {
        l_ord_open_price_0 = OrderOpenPrice();
        ld_unused_12 = l_ord_open_price_0;
        l_ticket_20 = l_ticket_8;
      }
    }
  }
  return (l_ord_open_price_0);
}

//+------------------------------------------------------------------+
//| 获取最新订单的手数                                   |
//+------------------------------------------------------------------+
double FindLastBuyLots(int myMagicNum) 
{
  double l_ord_open_price_0;
  int l_ticket_8;
  double ld_unused_12 = 0;
  int l_ticket_20 = 0;
  for (int l_pos_24 = OrdersTotal() - 1; l_pos_24 >= 0; l_pos_24--) 
  {
    OrderSelect(l_pos_24, SELECT_BY_POS, MODE_TRADES);
    if (OrderSymbol() != Symbol() || OrderMagicNumber() != myMagicNum) continue;
    if (OrderSymbol() == Symbol() && OrderMagicNumber() == myMagicNum) 
    {
      l_ticket_8 = OrderTicket();
      if (l_ticket_8 > l_ticket_20) 
      {
        l_ord_open_price_0 = OrderLots();
        ld_unused_12 = l_ord_open_price_0;
        l_ticket_20 = l_ticket_8;
      }
    }
  }
  return (l_ord_open_price_0);
}

//+------------------------------------------------------------------+
//| 获取总数                                       |
//+------------------------------------------------------------------+
int GetOrderCount(int myMagicNum)
{
    int cnt, total;
    int rest=0;
    total=OrdersTotal();
    if(total<=0)
    {
      return rest;
    }
    for(cnt=total-1;cnt>=0;cnt--)
     {
         if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)==true)
         {
            if(OrderMagicNumber() == myMagicNum&&OrderSymbol() == Symbol())
            {
                rest++;
            }
         }
     }  
  return rest;
}


//+------------------------------------------------------------------+物件+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| 在屏幕上显示文字标签                    |
//+------------------------------------------------------------------+
void iDisplayInfo(string LableName,string LableDoc,int Corner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor) 
{ 
  if (Corner == -1) 
    return(0); 
  ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0); 
  ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor); 
  ObjectSet(LableName, OBJPROP_CORNER, Corner); 
  ObjectSet(LableName, OBJPROP_XDISTANCE, LableX); 
  ObjectSet(LableName, OBJPROP_YDISTANCE, LableY); 
}

//+------------------------------------------------------------------+
//| 标注符号和画线、文字                                            |
//+------------------------------------------------------------------+
void iDrawSign(string myType,int myBarPos,double myPrice,color myColor,int mySymbol,string myString,int myDocSize) 
{ 
  if (myType=="Text") 
  { 
    string TextBarString=myType+Time[myBarPos]; 
    ObjectCreate(TextBarString,OBJ_TEXT,0,Time[myBarPos],myPrice); 
    ObjectSet(TextBarString,OBJPROP_COLOR,myColor);//颜色 
    ObjectSet(TextBarString,OBJPROP_FONTSIZE,myDocSize);//大小 
    ObjectSetText(TextBarString,myString);//文字内容 
    ObjectSet(TextBarString,OBJPROP_BACK,false); 
  } 
  if (myType=="Dot") 
  { 
    string DotBarString=myType+Time[myBarPos]; 
    ObjectCreate(DotBarString,OBJ_ARROW,0,Time[myBarPos],myPrice); 
    ObjectSet(DotBarString,OBJPROP_COLOR,myColor); 
    ObjectSet(DotBarString,OBJPROP_ARROWCODE,mySymbol); 
    ObjectSet(DotBarString,OBJPROP_BACK,false); 
  } 
  if (myType=="HLine") 
  { 
    string HLineBarString=myType+Time[myBarPos]; 
    ObjectCreate(HLineBarString,OBJ_HLINE,0,Time[myBarPos],myPrice); 
    ObjectSet(HLineBarString,OBJPROP_COLOR,myColor); 
    ObjectSet(HLineBarString,OBJPROP_BACK,false); 
  } 
  if (myType=="VLine") 
  { 
    string VLineBarString=myType+Time[myBarPos]; 
    ObjectCreate(VLineBarString,OBJ_VLINE,0,Time[myBarPos],myPrice); 
    ObjectSet(VLineBarString,OBJPROP_COLOR,myColor); 
    ObjectSet(VLineBarString,OBJPROP_BACK,false); 
  } 
}

//+------------------------------------------------------------------+
//| 物件颜色                    |
//+------------------------------------------------------------------+
color iObjectColor(double myInput) 
{ 
  color myColor; 
  if (myInput > 0) 
    myColor = Green; //正数颜色为绿色 
  if (myInput < 0) 
    myColor = Red; //负数颜色为红色 
  if (myInput == 0) 
    myColor = DarkGray; //0颜色为灰色 
  return(myColor); 
}

void iBarText(string myString,int myBars,double myPrice,int docSize,string docStyle,color myColor)
{
  string TextBarString=myString+Time[myBars];//文本名称
  ObjectCreate(TextBarString,OBJ_TEXT,"",Time[myBars],myPrice);//建立一个文本对象
  ObjectSetText(TextBarString,myString,docSize,docStyle,myColor);//文字内容
}

void iDrawLine(string myObjectName,int myFirstTime,double myFirstPrice,int mySecondTime,double mySecondPrice)
{
  iTwoPointsLine(myObjectName,myFirstTime,myFirstPrice,mySecondTime,mySecondPrice,STYLE_DOT,Green);
}

void iTwoPointsLine(string myObjectName,int myFirstTime,double myFirstPrice,int mySecondTime,double mySecondPrice,int myLineStyle,color myLineColor)
{
  ObjectCreate(myObjectName,OBJ_TREND,0,myFirstTime,myFirstPrice,mySecondTime,mySecondPrice);//确定两点坐标
  ObjectSet(myObjectName,OBJPROP_STYLE,myLineStyle);//线型
  ObjectSet(myObjectName,OBJPROP_COLOR,myLineColor);//线色
  ObjectSet(myObjectName,OBJPROP_WIDTH,1);//线宽
  ObjectSet(myObjectName,OBJPROP_BACK,false);//设置背景无效
  ObjectSet(myObjectName,OBJPROP_RAY,false);//设置射线无效
}

void SetObj(int orderTicket,int orderType,int openTime,int openPrice,int closeTime,int closePrice)
{
  string objectName="订单号-"+DoubleToStr(orderTicket,0);
  ObjectCreate(objectName,OBJ_TREND,0,openTime,openPrice,closeTime,closePrice);
  color clr=(orderType==0)?Green:Red;
  ObjectSet(objectName,OBJPROP_COLOR,clr);
  ObjectSet(objectName,OBJPROP_STATE,STYLE_DOT);
  ObjectSet(objectName,OBJPROP_WIDTH,1);
  ObjectSet(objectName,OBJPROP_BACK,false);
  ObjectSet(objectName,OBJPROP_RAY,false);

}

void DrawRectangle(string myRectangleName,color myColor,int myFirstTime,double myFirstPrice,int mySecondTime,double mySecondPrice,bool myBackColor)
{
  ObjectCreate(myRectangleName,OBJ_RECTANGLE,0,myFirstTime,myFirstPrice,mySecondTime,mySecondPrice);
  ObjectSet(myRectangleName,OBJPROP_COLOR,myColor);
  ObjectSet(myRectangleName,OBJPROP_BACK,myBackColor);
}

void iDrawSign(string mySignal,double myPrice)
{
  string myObjectName;
  if(mySignal=="Buy")
  {
    myObjectName="BuyPoint-"+Time[0];
    ObjectCreate(myObjectName,OBJ_ARROW,0,Time[0],myPrice);
    ObjectSet(myObjectName,OBJPROP_COLOR,Green);
    ObjectSet(myObjectName,OBJPROP_ARROWCODE,241);
  }
  if(mySignal=="Sell")
  {
    myObjectName="SellPoint-"+Time[0];
    ObjectCreate(myObjectName,OBJ_ARROW,0,Time[0],myPrice);
    ObjectSet(myObjectName,OBJPROP_COLOR,Red);
    ObjectSet(myObjectName,OBJPROP_ARROWCODE,242);
  }
  if(mySignal=="GreenMark")
  {
    myObjectName="GreenMark-"+Time[0];
    ObjectCreate(myObjectName,OBJ_ARROW,0,Time[0],myPrice);
    ObjectSet(myObjectName,OBJPROP_COLOR,Green);
    ObjectSet(myObjectName,OBJPROP_ARROWCODE,162);
  }
  if(mySignal=="RedMark")
  {
    myObjectName="RedMark-"+Time[0];
    ObjectCreate(myObjectName,OBJ_ARROW,0,Time[0],myPrice);
    ObjectSet(myObjectName,OBJPROP_COLOR,Red);
    ObjectSet(myObjectName,OBJPROP_ARROWCODE,162);
  }
}

void iDrawSign2(string myType,int myBarPos,double myPrice,color myColor)
{
  string myObjectName;
  if(myType=="HLine")
  {
    myObjectName=myType+Time[myBarPos];
    ObjectCreate(myObjectName,OBJ_HLINE,0,Time[myBarPos],myPrice);
    ObjectSet(myObjectName,OBJPROP_COLOR,myColor);
  }
  else if(myType=="VLine")
  {
    myObjectName=myType+Time[myBarPos];
    ObjectCreate(myObjectName,OBJ_VLINE,0,Time[myBarPos],myPrice);
    ObjectSet(myObjectName,OBJPROP_COLOR,myColor);
  }
}

//+------------------------------------------------------------------+
//| 屏幕上做出开仓标记，红色箭头为卖出订单，绿色为买入订单                                             |
//+------------------------------------------------------------------+
void Draw_Mark(int myTicket)
{
  if(myTicket>0)//有效的订单
  {
    string myObjectName="Arrow-"+DoubleToStr(myTicket,0);
    OrderSelect(OrdersTotal()-1,SELECT_BY_POS);
    int arrowValue; color arrowColor;
    if(OrderType()==OP_BUY){arrowValue=221;arrowColor=Green;}
    if(OrderType()==OP_SELL){arrowValue=222;arrowColor=Red;}
    ObjectCreate(myObjectName,OBJ_ARROW,0,Time[0],OrderOpenPrice());
    ObjectSet(myObjectName,OBJPROP_ARROWCODE,arrowValue);
    ObjectSet(myObjectName,OBJPROP_COLOR,arrowColor);
  }
}

void ObjectCreat0(string A_name_0, string A_text_8, double A_x_16, double A_y_24, color A_color_32) {
   if (ObjectFind(A_name_0) >= 0) {
      ObjectSetText(A_name_0, A_text_8, 14, "微软雅黑", A_color_32);
      return;
   }
   ObjectCreate(A_name_0, OBJ_LABEL, 0, 0, 0);
   ObjectSet(A_name_0, OBJPROP_XDISTANCE, A_x_16);
   ObjectSet(A_name_0, OBJPROP_YDISTANCE, A_y_24);
   ObjectSet(A_name_0, OBJPROP_COLOR, A_color_32);
   ObjectSetText(A_name_0, A_text_8, 14, "微软雅黑", A_color_32);
}

void ButtonCreate(string Name,string txt1,string txt2,int XX,int YX,int XL,int YL,int WZ,color clr,color back_clr,color border_clr,bool ZHClr) {
if(ObjectFind(0,Name)==-1) {
  ObjectCreate(0,Name,OBJ_BUTTON,0,0,0);
  ObjectSetInteger(0,Name,OBJPROP_XDISTANCE,XX);
  ObjectSetInteger(0,Name,OBJPROP_YDISTANCE,YX);
  ObjectSetInteger(0,Name,OBJPROP_XSIZE,XL);
  ObjectSetInteger(0,Name,OBJPROP_YSIZE,YL);
  ObjectSetInteger(0,Name,OBJPROP_CORNER,WZ);
  ObjectSetString(0,Name,OBJPROP_FONT,"微软雅黑");
  ObjectSetInteger(0,Name,OBJPROP_FONTSIZE,13);
  ObjectSetInteger(0,Name,OBJPROP_BORDER_COLOR,border_clr);
  }
if(ObjectGetInteger(0,Name,OBJPROP_STATE)==1) {
  if(ZHClr) {
    ObjectSetInteger(0,Name,OBJPROP_COLOR,back_clr);
    ObjectSetInteger(0,Name,OBJPROP_BGCOLOR,clr);
    }
  ObjectSetString(0,Name,OBJPROP_TEXT,txt2);
  }
else {
  ObjectSetInteger(0,Name,OBJPROP_COLOR,clr);
  ObjectSetInteger(0,Name,OBJPROP_BGCOLOR,back_clr);
  ObjectSetString(0,Name,OBJPROP_TEXT,txt1);
  }
}
//+------------------------------------------------------------------+物件+------------------------------------------------------------------+

//+------------------------------------------------------------------+时间+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| 时间周期转换字符                                            |
//+------------------------------------------------------------------+
string iTimeFrameToString(int myTimeFrame) 
{ 
  switch(myTimeFrame) 
  { 
    case 1: return("M1"); break; 
    case 5: return("M5"); break; 
    case 15: return("M15"); break; 
    case 30: return("M30"); break; 
    case 60: return("H1"); break; 
    case 240: return("H4"); break; 
    case 1440: return("D1"); break; 
    case 10080: return("W1"); break; 
    case 43200: return("MN1"); break; 
  } 
}
//+------------------------------------------------------------------+
//| 有效时间段                    |
//+------------------------------------------------------------------+
bool iValidTime(string myStartTime,string myEndTime,bool myServerTime) 
{ 
  bool myValue=false; 
  int myST,myET; 
  if (myServerTime==true) 
  { 
    myST=StrToTime(Year()+"."+Month()+"."+Day()+" "+myStartTime); 
    myET=StrToTime(Year()+"."+Month()+"."+Day()+" "+myEndTime); 
  } 
  if (myServerTime==false) 
  { 
    myST=StrToTime(myStartTime); 
    myET=StrToTime(myEndTime); 
  } 
  if (myST>myET) 
    myET=myET+1440*60; 
  if (TimeCurrent()>myST && TimeCurrent())
  { 
    myValue=true; 
  } 
  if (TimeLocal()>myST && TimeLocal())
  { 
    myValue=true; 
  } 
  if (myST==myET) 
    myValue=true; 
  return(myValue); 
}
//+------------------------------------------------------------------+时间+------------------------------------------------------------------+


//+------------------------------------------------------------------+其他+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| *快慢指标线交叉信号 
//周期短的是快线，周期长的是慢线
//参数说明，当前快线，当前慢线，前一个快线，前一个慢线   
// DownCross 下穿 N/A 无穿越                                          |
//+------------------------------------------------------------------+
string iCrossSignal(double myFast0,double mySlow0,double myFast1,double mySlow1)
{
  string result="N/A";
  if(myFast0>mySlow0 &&myFast1<=mySlow1) result="UpCross";
  if(myFast0=mySlow1) result="DownCross";
  return result;
}

// void iHighLowInteral(int myBarShift)
// {
//   int myBarTime=iTime(NULL,0,myBarShift);//指定k线时间 ?datetime 
//   int myStartHour=StrToTime(TimeYear(myBarTime)+"."+TimeMonth(myBarTime)+"."+TimeDay(myBarTime))+StartHour*60*60;//当前区间开始时间
//   int myEndHour=myStartHour+24*60*60;
//   if(tempStartHour!=myStartHour ||tempEndHour!=myEndHour)
//   {
//     tempStartHour=myStartHour;
//     tempEndHour=myEndHour;
//     tempStartHourShift=iBarShift(NULL,0,tempStartHour);
//     tempEndHourShift=iBarShift(NULL,0,tempEndHour);
//     int tempBars=tempStartHourShift-tempEndHourShift;//区间k线数量
//     int myHighBar=iHighest(NULL,0,MODE_HIGH,tempBars,tempEndHourShift);
//     double myHighPrice=High[myHighBar];
//     int myLowBar=iLowest(NULL,0,MODE_LOW,tempBars,tempEndHourShift);
//     double myLowPrice=Low[myLowBar];
//     //给指标赋值
//     for(i=tempEndHourShift;i<=(tempEndHourShift+tempBars); i++)
//     {
//       highBuffer[i]=myHighPrice;
//       lowBuffer[i]=myLowPrice;
//     }
//   }
// }

//计算均线两个点的角度
//三角函数和直角坐标系坐标转换，某两个点Y坐标差值 (price1-price2) 对应的X坐标差值((shift2-shift1),
//二者换算,除即是正切，再反函数就是弧度，在转换为角度。即可得到这两个点连线的角度。
//startShift:左边均线位置,一般是6
//endShift:右边均线位置,一般是0
//startPrice:左边均线位置对应价格
//endPrice:右边均线位置对应价格
//type://0-弧度；1-角度  

double getAngle(int startShift,int endShift,double startPrice,double endPrice,int type=1)
{

   //Print(startShift+" "+endShift+" "+startPrice+" "+endPrice+" "+type);
  
   double angle, scale, rad;
   int xShiftDiff;
   double yPriceDiff;
   double pi=3.14159;
   rad=180.0/pi;
  
  xShiftDiff=startShift-endShift;
  yPriceDiff=(endPrice/Point) - (startPrice/Point);

   //Print(yPriceDiff);
  angle=yPriceDiff/xShiftDiff;
  
  
   if(type==1) angle = MathArctan(angle)*rad;
  
   return (angle);

}
//+------------------------------------------------------------------+其他+------------------------------------------------------------------+