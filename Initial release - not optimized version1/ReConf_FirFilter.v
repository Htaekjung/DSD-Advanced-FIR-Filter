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
	input [3:0] iAddrRam,
	input signed [15:0] iWrDtRam,
	input [5:0] iNumOfCoeff,//0~40
	input signed [2:0] iFirIn,
	output signed [15:0] oFirOut
	);
	//reg [15:0] RdDtRam1, oRdDtRam2, oRdDtRam3, oRdDtRam4;
	//parameter

	integer i;

	wire [3:0] wEnMul1, wEnMul2, wEnMul3, wEnMul4;
	wire wEnAdd1, wEnAdd2, wEnAdd3, wEnAdd4;
	wire wEnAcc1, wEnAcc2, wEnAcc3, wEnAcc4;
	wire wEnDelay;
	
	//ram1
	wire wCsnRam1;
	wire wWrnRam1;
	wire [3:0] wAddrRam1;
	wire signed [15:0] wWrDtRam1;
	wire signed [15:0] wRdDtRam1;

	//ram2
	wire wCsnRam2;
	wire wWrnRam2;
	wire [3:0] wAddrRam2;
	wire signed [15:0] wWrDtRam2;
	wire signed [15:0] wRdDtRam2;

	//ram3
	wire wCsnRam3;
	wire wWrnRam3;
	wire [3:0] wAddrRam3;
	wire signed [15:0] wWrDtRam3;
	wire signed [15:0] wRdDtRam3;

	//ram4
	wire wCsnRam4;
	wire wWrnRam4;
	wire [3:0] wAddrRam4;
	wire signed [15:0] wWrDtRam4;
	wire signed [15:0] wRdDtRam4;
	
	wire signed [15:0] wMac1;
	wire signed [15:0] wMac2;
	wire signed [15:0] wMac3;
	wire signed [15:0] wMac4;
	
	wire signed  [2:0] wDelay1;
	wire signed  [2:0] wDelay2;
	wire signed  [2:0] wDelay3;
	wire signed  [2:0] wDelay4;
	wire signed  [2:0] wDelay5;
	wire signed  [2:0] wDelay6;
	wire signed  [2:0] wDelay7;
	wire signed  [2:0] wDelay8;
	wire signed  [2:0] wDelay9;
	wire signed  [2:0] wDelay10;
	wire signed  [2:0] wDelay11;
	wire signed  [2:0] wDelay12;
	wire signed  [2:0] wDelay13;
	wire signed  [2:0] wDelay14;
	wire signed  [2:0] wDelay15;
	wire signed  [2:0] wDelay16;
	wire signed  [2:0] wDelay17;
	wire signed  [2:0] wDelay18;
	wire signed  [2:0] wDelay19;
	wire signed  [2:0] wDelay20;
	wire signed  [2:0] wDelay21;
	wire signed  [2:0] wDelay22;
	wire signed  [2:0] wDelay23;
	wire signed  [2:0] wDelay24;
	wire signed  [2:0] wDelay25;
	wire signed  [2:0] wDelay26;
	wire signed  [2:0] wDelay27;
	wire signed  [2:0] wDelay28;
	wire signed  [2:0] wDelay29;
	wire signed  [2:0] wDelay30;
	wire signed  [2:0] wDelay31;
	wire signed  [2:0] wDelay32;
	wire signed  [2:0] wDelay33;

	//SpSram instance 
    SpSram_10x16 SpSram1(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam1),
        .iWrnRam(wWrnRam1),
        .iAddrRam(wAddrRam1),
        .iWrDtRam(wWrDtRam1),
        .oRdDtRam(wRdDtRam1)
    );
	
    SpSram_10x16 SpSram2(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam2),
        .iWrnRam(wWrnRam2),
        .iAddrRam(wAddrRam2),
        .iWrDtRam(wWrDtRam2),
        .oRdDtRam(wRdDtRam2)
    );

    SpSram_10x16 SpSram3(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam3),
        .iWrnRam(wWrnRam3),
        .iAddrRam(wAddrRam3),
        .iWrDtRam(wWrDtRam3),
        .oRdDtRam(wRdDtRam3)
    );

    SpSram_10x16 SpSram4(
        .iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iCsnRam(wCsnRam4),
        .iWrnRam(wWrnRam4),
        .iAddrRam(wAddrRam4),
        .iWrDtRam(wWrDtRam4),
        .oRdDtRam(wRdDtRam4)
    );


	//FSM
	Controller Controller(
		.iClk_12M(iClk_12M),
        .iRsn(iRsn),
        .iEnSample_600k(iEnSample_600k),
		.iCsnRam(iCsnRam),
        .iWrnRam(iWrnRam),
        .iCoeffiUpdateFlag(iCoeffiUpdateFlag),
        .iAddrRam(iAddrRam),   
		.iWrDtRam(iWrDtRam),
		.iNumOfCoeff(iNumOfCoeff),
        .oEnDelay(wEnDelay), //10개

        .oEnMul1(wEnMul1),
        .oEnAdd1(wEnAdd1),
        .oEnAcc1(wEnAcc1),
        .oEnMul2(wEnMul2),
        .oEnAdd2(wEnAdd2),
        .oEnAcc2(wEnAcc2),
        .oEnMul3(wEnMul3),
        .oEnAdd3(wEnAdd3),
        .oEnAcc3(wEnAcc3),
        .oEnMul4(wEnMul4),
        .oEnAdd4(wEnAdd4),
        .oEnAcc4(wEnAcc4),//12개

        // Outputs for RAMs
        .oWrDtRam1(wWrDtRam1),
        .oAddrRam1(wAddrRam1),
        .oWrnRam1(wWrnRam1),
        .oCsnRam1(wCsnRam1),

        .oWrDtRam2(wWrDtRam2),
        .oAddrRam2(wAddrRam2),
        .oWrnRam2(wWrnRam2),
        .oCsnRam2(wCsnRam2),

        .oWrDtRam3(wWrDtRam3),
        .oAddrRam3(wAddrRam3),
        .oWrnRam3(wWrnRam3),
        .oCsnRam3(wCsnRam3),

        .oWrDtRam4(wWrDtRam4),
        .oAddrRam4(wAddrRam4),
        .oWrnRam4(wWrnRam4),
        .oCsnRam4(wCsnRam4)
	);
	
	Delay_Chain Delay_Chain (
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnSample_600k(iEnSample_600k),
		.iFirIn(iFirIn),
		.iEnDelay(wEnDelay),
		.oDelay1(wDelay1),
		.oDelay2(wDelay2),
		.oDelay3(wDelay3),
		.oDelay4(wDelay4),
		.oDelay5(wDelay5),
		.oDelay6(wDelay6),
		.oDelay7(wDelay7),
		.oDelay8(wDelay8),
		.oDelay9(wDelay9),
		.oDelay10(wDelay10),
		.oDelay11(wDelay11),
		.oDelay12(wDelay12),
		.oDelay13(wDelay13),
		.oDelay14(wDelay14),
		.oDelay15(wDelay15),
		.oDelay16(wDelay16),
		.oDelay17(wDelay17),
		.oDelay18(wDelay18),
		.oDelay19(wDelay19),
		.oDelay20(wDelay20),
		.oDelay21(wDelay21),
		.oDelay22(wDelay22),
		.oDelay23(wDelay23),
		.oDelay24(wDelay24),
		.oDelay25(wDelay25),
		.oDelay26(wDelay26),
		.oDelay27(wDelay27),
		.oDelay28(wDelay28),
		.oDelay29(wDelay29),
		.oDelay30(wDelay30),
		.oDelay31(wDelay31),
		.oDelay32(wDelay32),
		.oDelay33(wDelay33)
	);


	ACC ACC_1(
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
		.iDelay8(wDelay8),
		.iDelay9(wDelay9),
		.iDelay10(wDelay10),
		.oMac(wMac1)
	);

	ACC ACC_2(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnMul(wEnMul2),
		.iEnAdd(wEnAdd2),
		.iEnAcc(wEnAcc2),
		.iCoeff(wRdDtRam2),
		.iDelay1(wDelay11),
		.iDelay2(wDelay12),
		.iDelay3(wDelay13),
		.iDelay4(wDelay14),
		.iDelay5(wDelay15),
		.iDelay6(wDelay16),
		.iDelay7(wDelay17),
		.iDelay8(wDelay18),
		.iDelay9(wDelay19),
		.iDelay10(wDelay20),
		.oMac(wMac2)
	);
	ACC ACC_3(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnMul(wEnMul3),
		.iEnAdd(wEnAdd3),
		.iEnAcc(wEnAcc3),
		.iCoeff(wRdDtRam3),
		.iDelay1(wDelay21),
		.iDelay2(wDelay22),
		.iDelay3(wDelay23),
		.iDelay4(wDelay24),
		.iDelay5(wDelay25),
		.iDelay6(wDelay26),
		.iDelay7(wDelay27),
		.iDelay8(wDelay28),
		.iDelay9(wDelay29),
		.iDelay10(wDelay30),
		.oMac(wMac3)
	);
	ACC_small ACC_4(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iEnMul(wEnMul4),
		.iEnAdd(wEnAdd4),
		.iEnAcc(wEnAcc4),
		.iCoeff(wRdDtRam4),
		.iDelay1(wDelay31),
		.iDelay2(wDelay32),
		.iDelay3(wDelay33),
		.oMac(wMac4)
	);	
	
	//Sum
	Sum Sum(
		.iClk_12M(iClk_12M),
		.iRsn(iRsn),
		.iMac1(wMac1),
		.iMac2(wMac2),
		.iMac3(wMac3),
		.iMac4(wMac4),
		.iEnDelay(wEnDelay),
		.iEnSample_600k(iEnSample_600k),
		.oFirOut(oFirOut)
	);

endmodule
	
	
	
	
	