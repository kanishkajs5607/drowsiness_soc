// image_acquisition.sv
// Module Name: image_acquisition
// What it does: Reads camera data and sends it to the AI module
// Think of it like: The "eyes" of our system

module image_acquisition (
    // Clock and reset - the heartbeat and restart button
    input  logic        clk,
    input  logic        rst_n,
    
    // Camera inputs - raw video data coming in
    input  logic [7:0]  cam_data,       // The actual pixel data (8 bits = 1 byte per pixel)
    input  logic        cam_vsync,      // "New frame starting!" signal
    input  logic        cam_href,       // "Valid data coming!" signal
    input  logic        cam_pclk,       // Pixel clock (tells us when to read data)
    
    // Output - sends data to the AI module
    output logic [7:0]  img_data_out,   // Processed image data going out
    output logic        img_valid       // "Hey, I have data ready!" signal
);

    // Internal variables (things only this module can see)
    logic [7:0] frame_buffer [0:1023]; // Small memory to store one row of image (up to 1024 pixels)
    int pixel_count;                    // Counts how many pixels we've received
    logic [1:0] state;                  // Tracks what we're doing right now
                                        // 00 = IDLE (waiting)
                                        // 01 = RECEIVING (getting camera data)
                                        // 10 = SENDING (giving data to AI)

    // THE MAIN LOGIC - runs every clock cycle
    always_ff @(posedge clk or negedge rst_n) begin
        // If reset is pressed (rst_n = 0), go back to start
        if (!rst_n) begin
            pixel_count <= 0;
            state <= 2'b00;     // Go to IDLE state
            img_valid <= 1'b0;  // Not sending anything yet
        end
        else begin
            case (state)
                
                // STATE 0: IDLE - Just waiting for the camera to send data
                2'b00: begin
                    img_valid <= 1'b0;
                    pixel_count <= 0;
                    // If camera says "I'm sending a new frame!" (vsync is high)
                    if (cam_vsync) begin
                        state <= 2'b01; // Move to RECEIVING state
                    end
                end
                
                // STATE 1: RECEIVING - Reading pixels from camera
                2'b01: begin
                    // If camera says "this is valid pixel data" (href is high)
                    if (cam_href) begin
                        // Store the pixel in our memory buffer
                        if (pixel_count < 1024) begin
                            frame_buffer[pixel_count] <= cam_data;
                            pixel_count <= pixel_count + 1;
                        end
                    end
                    // If vsync goes low, camera finished sending this frame
                    else if (!cam_vsync) begin
                        state <= 2'b10; // Move to SENDING state
                    end
                end
                
                // STATE 2: SENDING - Giving data to the AI module
                2'b10: begin
                    img_data_out <= frame_buffer[pixel_count];
                    img_valid <= 1'b1;  // Tell AI: "I have data for you!"
                    
                    if (pixel_count > 0) begin
                        pixel_count <= pixel_count - 1;
                    end else begin
                        img_valid <= 1'b0;
                        state <= 2'b00; // Done! Go back to IDLE
                    end
                end
                
            endcase
        end
    end

endmodule