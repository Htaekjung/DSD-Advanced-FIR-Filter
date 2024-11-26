/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ReConf_FirFilter_tb.v
  - Description      : testbench
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
`timescale 1ns/10ps

module ReConf_FirFilter_tb;

  /***********************************************
  // Wire & Register Declarations
  ***********************************************/
  // Input signals
  reg iClk_12M;
  reg iRsn;
  reg iEnSample_600k;
  reg iCoeffiUpdateFlag;
  reg iCsnRam;
  reg iWrnRam;
  reg [3:0] iAddrRam;
  reg signed [15:0] iWrDtRam;
  reg [5:0] iNumOfCoeff;
  reg signed [2:0] iFirIn;
  // Output signal
  wire signed [15:0] oFirOut;
  // Instantiate the DUT (Device Under Test)
  ReConf_FirFilter uut (
    .iClk_12M(iClk_12M),
    .iRsn(iRsn),
    .iEnSample_600k(iEnSample_600k),
    .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
    .iCsnRam(iCsnRam),
    .iWrnRam(iWrnRam),
    .iAddrRam(iAddrRam),
    .iWrDtRam(iWrDtRam),
    .iNumOfCoeff(iNumOfCoeff),
    .iFirIn(iFirIn),
    .oFirOut(oFirOut)
  );

  /***********************************************
  // Clock Generation
  ***********************************************/
  initial
  begin
    iClk_12M     <= 1'b0;
  end
  always   begin
    // 12MHz clock
    #(83.333/2) iClk_12M <= ~iClk_12M;
  end

  /***********************************************
  // Reset Sequence
  ***********************************************/
  initial
  begin
    iRsn = 1'b1;
    repeat (  5) @(posedge iClk_12M);

    iRsn = 1'b0;
    repeat (  2) @(posedge iClk_12M);
    $display("--------------------------------------->");
    $display("**** Active low Reset released !!!! ****");
    iRsn = 1'b1;
    $display("--------------------------------------->");
  end


  /***********************************************
  // 600kHz sample enable making
  ***********************************************/

    initial begin
      #20
      repeat (150) begin
        iEnSample_600k <= 1'b1;
        #83.333
        iEnSample_600k <= 1'b0;
        #1666.67;
      end
    end
  /***********************************************
  // Switch control
  ***********************************************/
  initial
  begin
    iFirIn  <= 3'b000;
    // iSampleSelect setting
    repeat (1) @(posedge iClk_12M && iEnSample_600k);
    iFirIn  <= 3'b000;
    // 1ea 3'b001 input
    $display("------------------------------------------------->");
    $display("OOOOO 3'b001 is received from testbench  !!! OOOOO");
    $display("------------------------------------------------->");

    repeat (  2) @(posedge iClk_12M && iEnSample_600k);
    repeat (20) @(posedge iClk_12M);
    iFirIn  <= 3'b001;
    repeat (2) @(posedge iClk_12M);
      iFirIn  <= 3'b000;

    // 200ea 3'b000 input
    repeat (1000) @(posedge iClk_12M && iEnSample_600k);

  end

  /***********************************************
  // Predefined Coefficients (iWrDtRam 설정)
  ***********************************************/
  reg [15:0] coeff [0:32]; // Coefficient array for all ranges
  reg [5:0] index;

  initial begin
    coeff[0]  = 16'h0100; // Example coefficient values for SpSram1
    coeff[1]  = 16'h0200;
    coeff[2]  = 16'h0300;
    coeff[3]  = 16'h0400;
    coeff[4]  = 16'h0500;
    coeff[5]  = 16'h0600;
    coeff[6]  = 16'h0700;
    coeff[7]  = 16'h0800;
    coeff[8]  = 16'h0900;
    coeff[9]  = 16'h0A00;

    coeff[10] = 16'h1100; // Example coefficient values for SpSram2
    coeff[11] = 16'h1200;
    coeff[12] = 16'h1300;
    coeff[13] = 16'h1400;
    coeff[14] = 16'h1500;
    coeff[15] = 16'h1600;
    coeff[16] = 16'h1700;
    coeff[17] = 16'h1800;
    coeff[18] = 16'h1900;
    coeff[19] = 16'h1A00;

    coeff[20] = 16'h2100; // Example coefficient values for SpSram3
    coeff[21] = 16'h2200;
    coeff[22] = 16'h2300;
    coeff[23] = 16'h2400;
    coeff[24] = 16'h2500;
    coeff[25] = 16'h2600;
    coeff[26] = 16'h2700;
    coeff[27] = 16'h2800;
    coeff[28] = 16'h2900;
    coeff[29] = 16'h2A00;

    coeff[30] = 16'h3100; // Example coefficient values for SpSram4
    coeff[31] = 16'h3200;
    coeff[32] = 16'h3300;

  end

  integer i, j, k; // 'integer'는 올바르게 선언됨

  /**********************************/
  //iAddr 설정
  /**********************************/
  initial begin
    repeat(22) @(posedge iClk_12M);
    repeat(4) begin
      for (i = 1; i <= 10; i = i + 1) begin
          @(posedge iClk_12M);
          iAddrRam = i; // Address within 0 to 9 for each RAM
      end
  	end
  end

  initial begin
    repeat(3) @(posedge iEnSample_600k);
    repeat (20) @(posedge iClk_12M);
    repeat(33)  begin
        for (i = 1; i <= 10; i = i + 1) begin
            @(posedge iClk_12M);
            iAddrRam = i; // Address within 0 to 9 for each RAM
        end
        repeat (11) @(posedge iClk_12M);
    end
	end


  /**********************************/
  // iNumOfCoeff 설정
  /**********************************/

	initial begin
  repeat(22) @(posedge iClk_12M);
	for (j = 0; j <= 39; j = j + 1) begin
      @(posedge iClk_12M);
      iNumOfCoeff = j; // Address within 0 to 9 for each RAM    // Assign corresponding coefficient value
      iWrDtRam = coeff[iNumOfCoeff];
    end
	end



/************************************/
//FSM
/************************************/
initial begin
    // 초기화
    iCoeffiUpdateFlag = 0;
    iCsnRam = 1;
    iWrnRam = 1;
    iAddrRam = 0;
    iWrDtRam = 0;
    iNumOfCoeff = 6'b0; // 기본 계수 개수 10
    // 테스트 단계
    // 0. p_Idle 상태
    repeat (22) @(posedge iClk_12M);
    $display("TEST: p_Idle 상태로 전환");


    iCoeffiUpdateFlag = 1; // 계수 업데이트 플래그 설정
    iCsnRam = 0; 
    iWrnRam = 0; // RAM 활성화
    iNumOfCoeff = 0;
    iAddrRam = 0;
    // 1. p_SpSram 상태
    repeat (40) @(posedge iClk_12M);
    
    $display("TEST: p_SpSram 상태로 전환");
    iNumOfCoeff = 42;
    repeat (34) begin
      iWrnRam = 1; 
      iCsnRam = 0;
      iCoeffiUpdateFlag = 0;
      // 2. p_Acc 상태
      $display("TEST: p_Acc 상태로 전환");

        repeat (11) @(posedge iClk_12M);
        iCsnRam = 1;
        // 3. p_Sum 상태
        repeat (10) @(posedge iClk_12M);

        $display("TEST: p_Sum 상태로 전환");
    end
    #100; // 최종 출력 확인

    $stop; // 시뮬레이션 종료
end
endmodule
