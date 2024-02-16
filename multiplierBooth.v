//MELIKA RAJABI 99101608 LAB_Booth
//-----------------------------Initializing the time unit
`timescale 1ns/1ns
//------------------------------------------------------

module multiplierBooth #(parameter nb)(
//----------------------Port directions and deceleration
   input clk,  
   input start,
   input [nb - 1:0] A, 
   input [nb - 1:0] B, 
   output reg signed [2*nb-1:0] Product
   );
//------------------------------------------------------

//------------------------------------------------------
   reg c_out;
   reg [nb + 1:0] Multiplicand ; 
   reg [nb + 1:0] Adder_output; //Using n+2 bits to handle partial product effect and also overflow of signed numbers
   reg signed [2 * nb:0] Product_extended; //Adding a zero to the main product in order to calculate the first partial product
//------------------------------------------------------

//-----------------------------------Integer declaration
   integer counter;
//------------------------------------------------------

//--------------------------------------Sequential Logic
   always @ (posedge clk)  begin

      if(start) begin 

         counter = 0;
         Product_extended[0] = 1'b0;
         Product_extended[nb:1] = B;
         Product_extended[2 * nb:nb + 1] = (nb)'('b0);
         Multiplicand = {A[nb - 1], A[nb - 1], A};
         Adder_output = (nb + 2)'('b0);
      
      end

      else if(counter != nb / 2) begin

         counter = counter + 1;
         
         Adder_output = {Product_extended[2 * nb], Product_extended[2 * nb], Product_extended[2 * nb:nb + 1]} + BoothPartialProduct(Product_extended[2], Product_extended[1], Product_extended[0], Multiplicand);

         Product_extended = Product_extended >>> 2; //Two signed shifts in Booth algorithm

         Product_extended[2 * nb:nb - 1] = Adder_output;
      end 

      if (counter == nb / 2) 
      Product = Product_extended[2 * nb:1]; //Now take the main part of our number without the added bit

      if(counter == nb / 2 && nb % 2 != 0 ) begin //If the number of bits is odd ...

         Product = Product >>> 1; //Do one more right signed shift
         {c_out, Product} = {Product[2 * nb - 1], Product} + {BoothPartialProduct(Product_extended[1], Product_extended[1], Product_extended[0], Multiplicand), (nb - 1)'('b0)};
         //Calculate the last partial product based on the last 2 bits of the number and also sign extended of the last bit

      end

   end 

   function [nb + 1:0] BoothPartialProduct; //Declaring a function which calculates the i partial product based on the 2i + 1, 2i and 2i - 1 bits of the number

      input bit_1, bit_2, bit_3;
      input [nb + 1:0] Multiplicand;

      begin

         case({bit_1, bit_2, bit_3}) // Defining the Booth table 
            3'b001:BoothPartialProduct = Multiplicand;
            3'b010:BoothPartialProduct = Multiplicand;
            3'b011:BoothPartialProduct = Multiplicand <<< 1;
            3'b100:BoothPartialProduct = -(Multiplicand <<< 1);
            3'b101:BoothPartialProduct = -(Multiplicand);
            3'b110:BoothPartialProduct = -(Multiplicand);
            default:BoothPartialProduct = (nb + 2)'('b0);
         endcase

      end

   endfunction

endmodule