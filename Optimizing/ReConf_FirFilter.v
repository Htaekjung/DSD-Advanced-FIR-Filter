/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : ReConf_FirFilter.v
  - Description      : Top module
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module ReConf_FirFilter(
	input iClk_12M,
	input iRsn,
	input iEnSample_600k,
	input iCoeffiUpdateFlag,
	input iCsnRam,
	input iWrnRam,
	input [3:0] iAddrRam_pos,
	input [3:0] iAddrRam_neg,
	input signed [15:0] iWrDtRam,
	input [5:0] iNumOfCoeff,//0~40
	input signed [2:0] iFirIn,
	output signed [15:0] oFirOut
	);
	//reg [15:0] RdDtRam1, oRdDtRam2, oRdDtRam3, oRdDtRam4;
	//parameter

	integer i;

	wire [3:0] wEnMul1, wEnMul2;
	wire wEnAdd1, wEnAdd2;
	wire wEnAcc1, wEnAcc2;
	wire wEnDelay;
	
	//ram1
	wire wCsnRam1;
	wire wWrnRam1;
	wire [3:0] wAddrRam_pos;
	wire signed [15:0] wWrDtRam1;
	wire signed [15:0] wRdDtRam1;

	//ram2
	wire wCsnRam2;
	wire wWrnRam2;
	wire [3:0] wAddrRam_neg;
	wire signed [15:0] wWrDtRam2;
	wire signed [15:0] wRdDtRam2;

	
	wire signed [15:0] wMac1;
	wire signed [15:0] wMac2;
	
	wire signed  [15:0] wDelay1;
	wire signed  [15:0] wDelay2;
	wire signed  [15:0] wDelay3;
	wire signed  [15:0] wDelay4;
	wire signed  [15:0] wDelay5;
	wire signed  [15:0] wDelay6;
	wire signed  [15:0] wDelay7;
	wire signed  [15:0] wDelay8;
	wire signed  [15:0] wDelay9;
	wire signed  [15:0] wDelay10;
	wire signed  [15:0] wDelay11;
	wire signed  [15:0] wDelay12;

	//SpSram instance 
    SpSram_Param #(.DATA_WIDTH(16), .ADDR_DEPTH(7)) SpSram1_Pos(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam1),
        .iWrnRam(wWrnRam1),
        .iAddrRam(wAddrRam_pos),
        .iWrDtRam(wWrDtRam1),
        .oRdDtRam(wRdDtRam1)
    );
	
    SpSram_Param #(.DATA_WIDTH(16), .ADDR_DEPTH(5)) SpSram2_Neg(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam2),
        .iWrnRam(wWrnRam2),
        .iAddrRam(wAddrRam_neg),
        .iWrDtRam(wWrDtRam2),
        .oRdDtRam(wRdDtRam2)
    );


	//FSM
	Controller Controller(
		.iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iEnSample_600k(iEnSample_600k),
		.iCsnRam(iCsnRam),
        .iWrnRam(iWrnRam),
        .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
        .iAddrRam_pos(iAddrRam_pos),
		.iAddrRam_neg(iAddrRam_neg),   
		.iWrDtRam(iWrDtRam),
		.iNumOfCoeff(iNumOfCoeff),
        .oEnDelay(wEnDelay), //10개

        .oEnMul1(wEnMul1),
        .oEnAdd1(wEnAdd1),
        .oEnAcc1(wEnAcc1),
        .oEnMul2(wEnMul2),
        .oEnAdd2(wEnAdd2),
		.oEnAcc2(wEnAcc2),
        // Outputs for RAMs
        .oWrDtRam1(wWrDtRam1),
        .oAddrRam_pos(wAddrRam_pos),
        .oWrnRam1(wWrnRam1),
        .oCsnRam1(wCsnRam1),

        .oWrDtRam2(wWrDtRam2),
        .oAddrRam_neg(wAddrRam_neg),
        .oWrnRam2(wWrnRam2),
        .oCsnRam2(wCsnRam2)
	);
	


	Delay_Chain Delay_Chain (
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnSample_600k(iEnSample_600k),
		.iFirIn(iFirIn),
		.iEnDelay(wEnDelay),
		.wFirSum1st(wDelay1),//양
		.wFirSum2nd(wDelay8),//음
		.wFirSum3rd(wDelay2),//양
		.wFirSum4th(wDelay9),//음
		.wFirSum5th(wDelay3),//양
		.wFirSum6th(wDelay10),//음
		.wFirSum7th(wDelay4),//양
		.wFirSum8th(wDelay11),//음
		.wFirSum9th(wDelay5),//양
		.wFirSum10th(wDelay12),//음
		.wFirSum11th(wDelay6),//양
		.wFirSum12th(wDelay7)//양
	);


// 양    0, 3, 6, 9, 12, 15, 16            ,17, 20 23, 26, 29, 32		13 (대칭 6개 + 가운데 하나) 	 7		이거 8개짜리
// 제로 1, 4, 7, 10, 13, 19, 22, 25, 28, 31					10 (대칭 5개)					5		
// 음    2, 5, 8, 11, 14,                 18, 21, 24, 27, 30				10 (대칭 5개)					5		이거 8개짜리



// 양   0,  1,  3,  4,  6,  9, 12, 15, 16 				 (대칭 6개 + 가운데 하나) 	 17-> 9개		이거 8개짜리
//     32, 31, 29, 28, 26, 23, 20, 17

// 음   2,  5,  7, 8, 10, 11, 13, 14							10 (대칭 5개)		16개 -> 8개		이거 8개짜리
//      30, 27 25 24  22  21  19  18
    ACC_7 #(.COEFF_WIDTH(16), .DATA_WIDTH(16))      
     ACC_Pos (
        .iClk_12M(iClk_12M), 
        .iRsn(iRsn),           
        .iEnMul(wEnMul1),      
        .iEnAdd(wEnAdd1),          
        .iEnAcc(wEnAcc1),          
        .iCoeff(wRdDtRam1),      
        .iDelay1(wDelay1),      
        .iDelay2(wDelay2),      
        .iDelay3(wDelay3),       
        .iDelay4(wDelay4),        
        .iDelay5(wDelay5),        
        .iDelay6(wDelay6),        
        .iDelay7(wDelay7),     
        .oMac(wMac1)               
    );

	ACC_5 #(.COEFF_WIDTH(16), .DATA_WIDTH(16))
		ACC_Neg(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnMul(wEnMul2),
		.iEnAdd(wEnAdd2),
		.iEnAcc(wEnAcc2),
		.iCoeff(wRdDtRam2),
		.iDelay1(wDelay8),
		.iDelay2(wDelay9),
		.iDelay3(wDelay10),
		.iDelay4(wDelay11),
		.iDelay5(wDelay12),
		.oMac(wMac2)
	);
	
	//Sum
	Sum Sum(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iMac1(wMac1),
		.iMac2(wMac2),
		.iEnDelay(wEnDelay),
		.iEnSample_600k(iEnSample_600k),
		.oFirOut(oFirOut)
	);

endmodule
	
	
	
	
	