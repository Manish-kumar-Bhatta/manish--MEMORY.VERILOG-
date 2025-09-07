module memory(clk,res,addr,wr_rd,wdata,rdata,valid,ready);
	parameter WIDTH=8;
	parameter DEPTH=16;
	parameter ADDR_WIDTH=$clog2(DEPTH);
	
	input clk,res,wr_rd,valid;
	input[WIDTH-1:0]wdata;
	input[ADDR_WIDTH-1:0]addr;
	output reg[WIDTH-1:0]rdata;
	output reg ready;
	integer i;

	reg[WIDTH-1:0]mem[DEPTH-1:0];
	
	always@(posedge clk) begin
		if(res==1) begin
			rdata=0;
			ready=0;
			for(i=0;i<DEPTH;i=i+1) mem[i]=0;
		end
		else begin
			if(valid==1) begin
				ready=1;
				if(wr_rd==1) mem[addr]=wdata;
				else rdata=mem[addr];
			end
		end
	end
endmodule
