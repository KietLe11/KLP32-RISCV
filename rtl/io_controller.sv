module io_controller
(  
   // Bus 
   input  logic clk,
   input  logic reset,
   input  logic bus_cs,
   input  logic bus_wr,
   input  logic bus_rd,
   input  logic [31:0] bus_addr, // 9 LSB used; 2^4 slot/2^5 reg each 
   input  logic [31:0] bus_wr_data,
   output logic [31:0] bus_rd_data,
   // Slot interface
   output logic [15:0] slot_cs_array,
   output logic [15:0] slot_mem_rd_array,
   output logic [15:0] slot_mem_wr_array,
   output logic [4:0]  slot_reg_addr_array [15:0],
   input  logic  [31:0] slot_rd_data_array [15:0], 
   output logic [31:0] slot_wr_data_array [15:0]
);

                                        // Signal declaration
   logic [3:0] slot_addr;
   logic [4:0] reg_addr;


   assign slot_addr = bus_addr[10:7];
   assign reg_addr  = bus_addr[6:2];   //Discard byte address

                                       // Address decoding
   always_comb
   begin
      slot_cs_array = 0;//default, don't select any slot
      if (bus_cs)
         slot_cs_array[slot_addr] = 1'b1;//Chip select/enable only the slot that is addressed
   end
   
                                        // broadcast to all slots 
   generate
      genvar i;
      for (i=0; i<16; i=i+1) 
      begin:  slot_signal_gen
         assign slot_mem_rd_array[i] = bus_rd;//en
         assign slot_mem_wr_array[i] = bus_wr;//en
         assign slot_wr_data_array[i] = bus_wr_data;//data
         assign slot_reg_addr_array[i] = reg_addr;//address
      end
   endgenerate
                                       // mux for read data 
   assign bus_rd_data = slot_rd_data_array[slot_addr];   //Since it's the only input to the MCS from the bus
endmodule