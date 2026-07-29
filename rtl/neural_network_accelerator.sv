// neural_network_accelerator.sv
// Module Name: neural_network_accelerator
// Who builds this: Member B (AI/Model Teammate)
// What it does: Runs the AI model to detect if the driver is drowsy

module neural_network_accelerator (
    // Clock and reset
    input  logic        clk,
    input  logic        rst_n,
    
    // Input: Image data from the image_acquisition module
    input  logic [7:0]  img_data,      // Pixel data coming in
    input  logic        img_valid,     // "I have data for you!" signal
    input  logic        img_last,      // "This is the last pixel!" signal
    
    // Output: The AI's decision
    output logic [7:0]  ai_result,     // Result: 0 = alert, 1 = drowsy, 2 = distracted
    output logic        ai_done        // "I'm done processing!" signal
);

    // ============================================================
    // MEMBER B: THIS IS YOUR WORKSPACE
    // Replace the code below with your actual AI accelerator logic.
    //
    // What you need to build:
    // 1. A multiply-accumulate (MAC) unit for matrix math
    // 2. Logic to handle the quantized YOLOv8 model weights
    // 3. An output classifier that says: alert/drowsy/distracted
    //
    // Use hls4ml to convert your trained model to SystemVerilog.
    // Refer to: https://github.com/fastmachinelearning/hls4ml-tutorial
    // ============================================================

    // TEMPORARY PLACEHOLDER - Member B will replace this
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ai_result <= 8'd0;
            ai_done <= 1'b0;
        end
        else if (img_valid) begin
            // Just pass through for now (placeholder)
            ai_done <= 1'b1;
            ai_result <= 8'd0; // Default: driver is alert
        end
    end

endmodule