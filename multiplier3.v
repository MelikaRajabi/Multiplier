//MELIKA RAJABI 99101608 LAB_2
//-----------------------------Initializing the time unit
`timescale 1ns/1ns
//------------------------------------------------------

module multiplier3 (
//----------------------Port directions and deceleration
   input clk,  
   input start,
   input [7:0] A, 
   input [7:0] B, 
   output reg signed [15:0] Product,
   output ready
   );
//------------------------------------------------------

//---------------------------------Register deceleration
   reg [8:0] Multiplicand ;
   reg [8:0] adder_output;
   reg [3:0]  counter;
//------------------------------------------------------

//-------------------------------------Wire deceleration
   wire product_write_enable;
//------------------------------------------------------

//-----------------------------------Combinational logic
   assign product_write_enable = Product[0];
   assign ready = counter[3];
//------------------------------------------------------

//--------------------------------------Sequential Logic
   always @ (posedge clk) 

      if(start) begin

         counter <= 4'h0 ;
         Product[7:0] <= B;
         Product[15:8] <= 8'h00;
         Multiplicand <= {A[7], A}; //Sign extending to avoid overflow(which can not be corrected for signed numbers after being happened)
         adder_output <= 9'b000000000; //Using 9_bit_adder
      
      end

      else if(!ready) begin

         counter = counter + 1;

         if(counter == 4'b1000) 
            Multiplicand = -Multiplicand; //The MSB in signed numbers has value of -1
         
         adder_output = {Product[15], Product[15:8]} + Multiplicand;

         Product = Product >>> 1; //Using sign shift instead of normal shift for signed numbers

         if(product_write_enable)
            Product[15:7] = adder_output;

      end 

endmodule

