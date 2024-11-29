/*********************************************************************
  - Project          : Team Project (FIR filter w/ Kaiser window)
  - File name        : Delay_Chain.v
  - Description      : Delay chain w/ 33 taps
  - Owner            : Hyuntaek.Jung
  - Revision history : 1) 2024.11.26 : Initial release
*********************************************************************/
module Delay_Chain(
    input iClk_12M,
    input iRsn,
    input iEnSample_600k,
    input signed [2:0] iFirIn,
    input iEnDelay,
    output signed [15:0] wFirSum1st,
    output signed [15:0] wFirSum2nd,
    output signed [15:0] wFirSum3rd,
    output signed [15:0] wFirSum4th,
    output signed [15:0] wFirSum5th,
    output signed [15:0] wFirSum6th,
    output signed [15:0] wFirSum7th,
    output signed [15:0] wFirSum8th,
    output signed [15:0] wFirSum9th,
    output signed [15:0] wFirSum10th,
    output signed [15:0] wFirSum11th,
    output signed [15:0] wFirSum12th
);

     reg signed [2:0] oDelay1;
     reg signed [2:0] oDelay2;
     reg signed [2:0] oDelay3;
     reg signed [2:0] oDelay4;
     reg signed [2:0] oDelay5;
     reg signed [2:0] oDelay6;
     reg signed [2:0] oDelay7;
     reg signed [2:0] oDelay8;
     reg signed [2:0] oDelay9;
     reg signed [2:0] oDelay10;
     reg signed [2:0] oDelay11;
     reg signed [2:0] oDelay12;
     reg signed [2:0] oDelay13;
     reg signed [2:0] oDelay14;
     reg signed [2:0] oDelay15;
     reg signed [2:0] oDelay16;
     reg signed [2:0] oDelay17;
     reg signed [2:0] oDelay18;
     reg signed [2:0] oDelay19;
     reg signed [2:0] oDelay20;
     reg signed [2:0] oDelay21;
     reg signed [2:0] oDelay22;
     reg signed [2:0] oDelay23;
     reg signed [2:0] oDelay24;
     reg signed [2:0] oDelay25;
     reg signed [2:0] oDelay26;
     reg signed [2:0] oDelay27;
     reg signed [2:0] oDelay28;
     reg signed [2:0] oDelay29;
     reg signed [2:0] oDelay30;
     reg signed [2:0] oDelay31;
     reg signed [2:0] oDelay32;
     reg signed [2:0] oDelay33;


    always @(posedge iClk_12M)
    begin
        if(!iRsn) begin
            oDelay1 <= 16'h0;
            oDelay2 <= 16'h0;
            oDelay3  <= 16'h0;
            oDelay4  <= 16'h0;
            oDelay5  <= 16'h0;
            oDelay6  <= 16'h0;
            oDelay7  <= 16'h0;
            oDelay8  <= 16'h0;
            oDelay9  <= 16'h0;
            oDelay10 <= 16'h0;
            oDelay11 <= 16'h0;
            oDelay12 <= 16'h0;
            oDelay13 <= 16'h0;
            oDelay14 <= 16'h0;
            oDelay15 <= 16'h0;
            oDelay16 <= 16'h0;
            oDelay17 <= 16'h0;
            oDelay18 <= 16'h0;
            oDelay19 <= 16'h0;
            oDelay20 <= 16'h0;
            oDelay21 <= 16'h0;
            oDelay22 <= 16'h0;
            oDelay23 <= 16'h0;
            oDelay24 <= 16'h0;
            oDelay25 <= 16'h0;
            oDelay26 <= 16'h0;
            oDelay27 <= 16'h0;
            oDelay28 <= 16'h0;
            oDelay29 <= 16'h0;
            oDelay30 <= 16'h0;
            oDelay31 <= 16'h0;
            oDelay32 <= 16'h0;
            oDelay33 <= 16'h0;
        end else if (iEnDelay && iEnSample_600k) begin
            oDelay1 <= iFirIn;
            oDelay2 <= oDelay1;
            oDelay3 <= oDelay2;
            oDelay4 <= oDelay3;
            oDelay5 <= oDelay4;
            oDelay6 <= oDelay5;
            oDelay7 <= oDelay6;
            oDelay8 <= oDelay7;
            oDelay9 <= oDelay8;
            oDelay10 <= oDelay9;
            oDelay11 <= oDelay10;
            oDelay12 <= oDelay11;
            oDelay13 <= oDelay12;
            oDelay14 <= oDelay13;
            oDelay15 <= oDelay14;
            oDelay16 <= oDelay15;
            oDelay17 <= oDelay16;
            oDelay18 <= oDelay17;
            oDelay19 <= oDelay18;
            oDelay20 <= oDelay19;
            oDelay21 <= oDelay20;
            oDelay22 <= oDelay21;
            oDelay23 <= oDelay22;
            oDelay24 <= oDelay23;
            oDelay25 <= oDelay24;
            oDelay26 <= oDelay25;
            oDelay27 <= oDelay26;
            oDelay28 <= oDelay27;
            oDelay29 <= oDelay28;
            oDelay30 <= oDelay29;
            oDelay31 <= oDelay30;
            oDelay32 <= oDelay31;
            oDelay33 <= oDelay32;
        end else begin
            oDelay1 <= oDelay1;
            oDelay2 <= oDelay2;
            oDelay3 <= oDelay3;
            oDelay4 <= oDelay4;
            oDelay5 <= oDelay5;
            oDelay6 <= oDelay6;
            oDelay7 <= oDelay7;
            oDelay8 <= oDelay8;
            oDelay9 <= oDelay9;
            oDelay10 <= oDelay10;
            oDelay11 <= oDelay11;
            oDelay12 <= oDelay12;
            oDelay13 <= oDelay13;
            oDelay14 <= oDelay14;
            oDelay15 <= oDelay15;
            oDelay16 <= oDelay16;
            oDelay17 <= oDelay17;
            oDelay18 <= oDelay18;
            oDelay19 <= oDelay19;
            oDelay20 <= oDelay20;
            oDelay21 <= oDelay21;
            oDelay22 <= oDelay22;
            oDelay23 <= oDelay23;
            oDelay24 <= oDelay24;
            oDelay25 <= oDelay25;
            oDelay26 <= oDelay26;
            oDelay27 <= oDelay27;
            oDelay28 <= oDelay28;
            oDelay29 <= oDelay29;
            oDelay30 <= oDelay30;
            oDelay31 <= oDelay31;
            oDelay32 <= oDelay32;
            oDelay33 <= oDelay33;
        end
    end

    //양
    assign wFirSum1st  = {{13{oDelay1[2]}},  oDelay1[2:0]}
                     + {{13{oDelay33[2]}}, oDelay33[2:0]};

    // oDelay[3] & oDelay[31] - 음
    assign wFirSum2nd  = {{13{oDelay3[2]}},  oDelay3[2:0]}
                        + {{13{oDelay31[2]}}, oDelay31[2:0]};


    // oDelay[4] & oDelay[30] - 양
    assign wFirSum3rd  = {{13{oDelay4[2]}},  oDelay4[2:0]}
                        + {{13{oDelay30[2]}}, oDelay30[2:0]};


    // oDelay[6] & oDelay[28] - 음
    assign wFirSum4th  = {{13{oDelay6[2]}},  oDelay6[2:0]}
                        + {{13{oDelay28[2]}}, oDelay28[2:0]};

    // oDelay[7] & oDelay[27] - 양
    assign wFirSum5th  = {{13{oDelay7[2]}},  oDelay7[2:0]}
                        + {{13{oDelay27[2]}}, oDelay27[2:0]};


    // oDelay[9] & oDelay[25] - 음
    assign wFirSum6th  = {{13{oDelay9[2]}},  oDelay9[2:0]}
                        + {{13{oDelay25[2]}}, oDelay25[2:0]};

    // oDelay[10] & oDelay[24] - 양
    assign wFirSum7th  = {{13{oDelay10[2]}}, oDelay10[2:0]}
                        + {{13{oDelay24[2]}}, oDelay24[2:0]};


    // oDelay[12] & oDelay[22] - 음
    assign wFirSum8th  = {{13{oDelay12[2]}}, oDelay12[2:0]}
                        + {{13{oDelay22[2]}}, oDelay22[2:0]};

    // oDelay[13] & oDelay[21] - 양
    assign wFirSum9th  = {{13{oDelay13[2]}}, oDelay13[2:0]}
                        + {{13{oDelay21[2]}}, oDelay21[2:0]};


    // oDelay[15] & oDelay[19] - 음
    assign wFirSum10th = {{13{oDelay15[2]}}, oDelay15[2:0]}
                        + {{13{oDelay19[2]}}, oDelay19[2:0]};

    // oDelay[16] & oDelay[18] - 양
    assign wFirSum11th = {{13{oDelay16[2]}}, oDelay16[2:0]}
                        + {{13{oDelay18[2]}}, oDelay18[2:0]};


    // oDelay[17] - 양
    assign wFirSum12th = {{13{oDelay17[2]}}, oDelay17[2:0]};

endmodule
