#property copyright "mahdy.shayesteh@gmail.com"
#property link      ""
#property version   "1.00"
#property strict

#property show_inputs
input string             InpFileName=".csv";     
input string             InpDirectoryName="Data";
input int                stratTimeHH=10;
input int                stratTimeMM=0;
input int                endTimeHH=11;
input int                endTimeMM=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

void OnStart()
  {
  int  period =  Period();
 
  switch (period)
  {
  case 1:
     period = period*15;
     break;
  
  case 5:
     period = period*12;
     break;
     
  case 15:
     period = period*16;
     break;
     
  case 60:
     period = period*24;
     break;

  default:
     break;
  }

  int candles = 2000;
  //int candles  = PERIOD_M1*1200;
  
  printf(candles); 
 
  string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);

  int file_handle=FileOpen(InpDirectoryName+"//"+IntegerToString(Period())+_Symbol+InpFileName,FILE_READ|FILE_WRITE|FILE_CSV);
  
   //printf(InpDirectoryName+"//"+IntegerToString(Period())+_Symbol+InpFileName);
  
  if(file_handle!=INVALID_HANDLE )
     {
        PrintFormat("%s file is available for writing",InpFileName);

        FileSeek(file_handle,0,SEEK_SET);
        FileWrite(file_handle,"Time","Open","High","Low","Close","|PD|","PD%","ATR", "PD% / ATR");

        for(int i=0;i<candles;i++) {
            //if(Hourfilter(Time[i]))
            //  {
                    FileWrite(file_handle,
                       TimeToStr(Time[i],TIME_DATE|TIME_MINUTES),
                       Open[i],
                       High[i],
                       Low[i],
                       Close[i],
                       MathAbs(Open[i] - Close[i]),
                       ((Open[i]-Close[i])/Open[i])*100.0,
                       iATR(NULL,PERIOD_CURRENT,24,i),
                       (((Open[i]-Close[i])/Open[i])*100.0)/ iATR(NULL,PERIOD_CURRENT,24,i)
                    );
             //}
        }
        
        //--- close the file
        FileClose(file_handle);
       PrintFormat("Data is written, %s file is closed",InpFileName);
    }
  else
  {
     PrintFormat("Failed to open %s file, Error code = %d", InpFileName, GetLastError());
  }

}

