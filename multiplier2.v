//MELIKA RAJABI 99101608 LAB_1.3
//-----------------------------Initializing the time unit
`timescale 1ns/1ns
//------------------------------------------------------

module multiplier2 (
//----------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output reg [15:0] Product,
   output ready
   );
//------------------------------------------------------

//---------------------------------Register deceleration
   reg [7:0] Multiplicand ;
   reg [3:0]  counter;
//------------------------------------------------------

//-------------------------------------Wire deceleration
   wire product_write_enable;
   wire [7:0] adder_output;
   wire c_out;
//------------------------------------------------------

//-----------------------------------Combinational logic
   assign {c_out, adder_output} = Multiplicand + Product[15:8];
   assign product_write_enable = Product[0];
   assign ready = counter[3];
//------------------------------------------------------

//--------------------------------------Sequential Logic
   always @ (posedge clk)
      
      if(start) begin

         counter <= 4'h0 ;
         Product[7:0] <= B; //Using half of Product as multiplier
         Product[15:8] <= 8'h00;
         Multiplicand <= A;

      end

      else if(!ready) begin

         counter <= counter + 1;
         Product <= Product >> 1;

         if(product_write_enable)
            Product[15:7] <= {c_out, adder_output};

      end   

endmodule
