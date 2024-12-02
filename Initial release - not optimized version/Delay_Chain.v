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
    output reg signed [2:0] oDelay1,
    output reg signed [2:0] oDelay2,
    output reg signed [2:0] oDelay3,
    output reg signed [2:0] oDelay4,
    output reg signed [2:0] oDelay5,
    output reg signed [2:0] oDelay6,
    output reg signed [2:0] oDelay7,
    output reg signed [2:0] oDelay8,
    output reg signed [2:0] oDelay9,
    output reg signed [2:0] oDelay10,
    output reg signed [2:0] oDelay11,
    output reg signed [2:0] oDelay12,
    output reg signed [2:0] oDelay13,
    output reg signed [2:0] oDelay14,
    output reg signed [2:0] oDelay15,
    output reg signed [2:0] oDelay16,
    output reg signed [2:0] oDelay17,
    output reg signed [2:0] oDelay18,
    output reg signed [2:0] oDelay19,
    output reg signed [2:0] oDelay20,
    output reg signed [2:0] oDelay21,
    output reg signed [2:0] oDelay22,
    output reg signed [2:0] oDelay23,
    output reg signed [2:0] oDelay24,
    output reg signed [2:0] oDelay25,
    output reg signed [2:0] oDelay26,
    output reg signed [2:0] oDelay27,
    output reg signed [2:0] oDelay28,
    output reg signed [2:0] oDelay29,
    output reg signed [2:0] oDelay30,
    output reg signed [2:0] oDelay31,
    output reg signed [2:0] oDelay32,
    output reg signed [2:0] oDelay33
);

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
endmodule