`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2024 17:09:46
// Design Name: 
// Module Name: average_pixel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_detection(
input [1:0] mode,
input [3:0] p1,p2,p3,p4,p5,p6,p7,p8,p9,
output [3:0] o1
    );
    
    reg [10:0] mid1;
    always@(*)
    begin
        if(mode==1)
        begin
            mid1=(p2+p4-(4*p5)+p6+p8);
        end
        else if(mode==0)
        begin
            mid1 = (p1+2*p2+p3+2*p4+4*p5+2*p6+p7+2*p8+p9)/16;
        end
        else if(mode==2)
        begin
            mid1 = p5;
        end
    end
    assign o1=mid1[3:0];
    
endmodule