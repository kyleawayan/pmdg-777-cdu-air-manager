-- PMDG 777 Left CDU Button Controller
-- WITH VISIBLE BUTTONS using canvas
-- Uses ROTOR_BRAKE method with proper PMDG encoding

-- PMDG Event ID Offsets (from THIRD_PARTY_EVENT_ID_MIN)
-- DO NOT use the full event ID - only the offset!
local CDU_L_OFFSET = {
    -- Line Select Keys
    L1 = 328,
    L2 = 329,
    L3 = 330,
    L4 = 331,
    L5 = 332,
    L6 = 333,
    R1 = 334,
    R2 = 335,
    R3 = 336,
    R4 = 337,
    R5 = 338,
    R6 = 339,

    -- Function Keys
    INIT_REF = 340,
    RTE = 341,
    DEP_ARR = 342,
    ALTN = 343,
    VNAV = 344,
    FIX = 345,
    LEGS = 346,
    HOLD = 347,
    PROG = 348,
    EXEC = 349,
    MENU = 350,
    PREV_PAGE = 352,
    NEXT_PAGE = 353,

    -- Number Keys
    K1 = 354,
    K2 = 355,
    K3 = 356,
    K4 = 357,
    K5 = 358,
    K6 = 359,
    K7 = 360,
    K8 = 361,
    K9 = 362,
    DOT = 363,
    K0 = 364,
    PLUS_MINUS = 365,

    -- Letter Keys
    A = 366,
    B = 367,
    C = 368,
    D = 369,
    E = 370,
    F = 371,
    G = 372,
    H = 373,
    I = 374,
    J = 375,
    K = 376,
    L = 377,
    M = 378,
    N = 379,
    O = 380,
    P = 381,
    Q = 382,
    R = 383,
    S = 384,
    T = 385,
    U = 386,
    V = 387,
    W = 388,
    X = 389,
    Y = 390,
    Z = 391,
    SPACE = 392,
    DEL = 393,
    SLASH = 394,
    CLR = 395,
}

-- Mouse action codes for ROTOR_BRAKE parameter
local MOUSE_LEFTCLICK = 1
local MOUSE_LEFTRELEASE = 4

-- Function to press a CDU button using proper PMDG ROTOR_BRAKE encoding
-- Formula: (offset * 100) + mouse_action_code
function pressCDU(offset)
    local click_code = (offset * 100) + MOUSE_LEFTCLICK
    local release_code = (offset * 100) + MOUSE_LEFTRELEASE

    print("Pressing CDU button - Click: " .. click_code .. ", Release: " .. release_code)
    msfs_event("K:ROTOR_BRAKE", click_code)
    msfs_event("K:ROTOR_BRAKE", release_code)
end

-- Test function - Press 'A' button
function testConnection()
    print("TEST: Pressing CDU_L.A button (offset 366)")
    pressCDU(CDU_L_OFFSET.A)  -- Should send 36601 and 36604
end

-- Create a canvas for the background
canvas_add(0, 0, 500, 650, function()
    -- Dark gray background
    _rect(0, 0, 500, 650)
    _fill("gray")
end)

-- Helper function to draw a button with text
function drawButton(x, y, w, h, label)
    local canvas = canvas_add(x, y, w, h, function()
        -- Button background
        _rect(0, 0, w, h)
        _fill("dimgray")
        
        -- Border
        _rect(0, 0, w, h)
        _stroke("white", 2)
        
        -- Text - correct syntax: _txt(text, font, size, style, alignment, x, y)
        _txt(label, "size:12px; color:white; halign:center; valign:center;", w/2, h/2)
    end)
    return canvas
end

-- Line Select Keys - Left
drawButton(10, 50, 50, 30, "L1")
button_add(nil, nil, 10, 50, 50, 30, function() pressCDU(CDU_L_OFFSET.L1) end)

drawButton(10, 90, 50, 30, "L2")
button_add(nil, nil, 10, 90, 50, 30, function() pressCDU(CDU_L_OFFSET.L2) end)

drawButton(10, 130, 50, 30, "L3")
button_add(nil, nil, 10, 130, 50, 30, function() pressCDU(CDU_L_OFFSET.L3) end)

drawButton(10, 170, 50, 30, "L4")
button_add(nil, nil, 10, 170, 50, 30, function() pressCDU(CDU_L_OFFSET.L4) end)

drawButton(10, 210, 50, 30, "L5")
button_add(nil, nil, 10, 210, 50, 30, function() pressCDU(CDU_L_OFFSET.L5) end)

drawButton(10, 250, 50, 30, "L6")
button_add(nil, nil, 10, 250, 50, 30, function() pressCDU(CDU_L_OFFSET.L6) end)

-- Line Select Keys - Right
drawButton(440, 50, 50, 30, "R1")
button_add(nil, nil, 440, 50, 50, 30, function() pressCDU(CDU_L_OFFSET.R1) end)

drawButton(440, 90, 50, 30, "R2")
button_add(nil, nil, 440, 90, 50, 30, function() pressCDU(CDU_L_OFFSET.R2) end)

drawButton(440, 130, 50, 30, "R3")
button_add(nil, nil, 440, 130, 50, 30, function() pressCDU(CDU_L_OFFSET.R3) end)

drawButton(440, 170, 50, 30, "R4")
button_add(nil, nil, 440, 170, 50, 30, function() pressCDU(CDU_L_OFFSET.R4) end)

drawButton(440, 210, 50, 30, "R5")
button_add(nil, nil, 440, 210, 50, 30, function() pressCDU(CDU_L_OFFSET.R5) end)

drawButton(440, 250, 50, 30, "R6")
button_add(nil, nil, 440, 250, 50, 30, function() pressCDU(CDU_L_OFFSET.R6) end)

-- Alphabet keyboard - Row 1
local letters_row1 = {"Q","W","E","R","T","Y","U","I","O","P"}
local row1_y = 300
for i, letter in ipairs(letters_row1) do
    local x = 10 + (i-1)*35
    drawButton(x, row1_y, 30, 30, letter)
    button_add(nil, nil, x, row1_y, 30, 30,
        function() pressCDU(CDU_L_OFFSET[letter]) end)
end

-- Row 2
local letters_row2 = {"A","S","D","F","G","H","J","K","L"}
for i, letter in ipairs(letters_row2) do
    local x = 25 + (i-1)*35
    drawButton(x, row1_y + 40, 30, 30, letter)
    button_add(nil, nil, x, row1_y + 40, 30, 30,
        function() pressCDU(CDU_L_OFFSET[letter]) end)
end

-- Row 3
local letters_row3 = {"Z","X","C","V","B","N","M"}
for i, letter in ipairs(letters_row3) do
    local x = 40 + (i-1)*35
    drawButton(x, row1_y + 80, 30, 30, letter)
    button_add(nil, nil, x, row1_y + 80, 30, 30,
        function() pressCDU(CDU_L_OFFSET[letter]) end)
end

-- Numbers
local nums = {
    {key="K1", label="1"},
    {key="K2", label="2"},
    {key="K3", label="3"},
    {key="K4", label="4"},
    {key="K5", label="5"},
    {key="K6", label="6"},
    {key="K7", label="7"},
    {key="K8", label="8"},
    {key="K9", label="9"},
    {key="K0", label="0"}
}
for i, num in ipairs(nums) do
    local x = 10 + (i-1)*35
    drawButton(x, row1_y + 120, 30, 30, num.label)
    button_add(nil, nil, x, row1_y + 120, 30, 30,
        function() pressCDU(CDU_L_OFFSET[num.key]) end)
end

-- Function buttons - Left column
drawButton(10, 480, 80, 35, "INIT")
button_add(nil, nil, 10, 480, 80, 35, function() pressCDU(CDU_L_OFFSET.INIT_REF) end)

drawButton(10, 520, 80, 35, "RTE")
button_add(nil, nil, 10, 520, 80, 35, function() pressCDU(CDU_L_OFFSET.RTE) end)

drawButton(10, 560, 80, 35, "LEGS")
button_add(nil, nil, 10, 560, 80, 35, function() pressCDU(CDU_L_OFFSET.LEGS) end)

-- Function buttons - Right column
drawButton(410, 480, 80, 35, "EXEC")
button_add(nil, nil, 410, 480, 80, 35, function() pressCDU(CDU_L_OFFSET.EXEC) end)

drawButton(410, 520, 80, 35, "MENU")
button_add(nil, nil, 410, 520, 80, 35, function() pressCDU(CDU_L_OFFSET.MENU) end)

drawButton(410, 560, 80, 35, "PROG")
button_add(nil, nil, 410, 560, 80, 35, function() pressCDU(CDU_L_OFFSET.PROG) end)

-- Special keys - Center
drawButton(200, 480, 40, 30, "CLR")
button_add(nil, nil, 200, 480, 40, 30, function() pressCDU(CDU_L_OFFSET.CLR) end)

drawButton(250, 480, 40, 30, "DEL")
button_add(nil, nil, 250, 480, 40, 30, function() pressCDU(CDU_L_OFFSET.DEL) end)

drawButton(200, 520, 40, 30, "/")
button_add(nil, nil, 200, 520, 40, 30, function() pressCDU(CDU_L_OFFSET.SLASH) end)

drawButton(250, 520, 40, 30, "SPC")
button_add(nil, nil, 250, 520, 40, 30, function() pressCDU(CDU_L_OFFSET.SPACE) end)

drawButton(200, 560, 40, 30, ".")
button_add(nil, nil, 200, 560, 40, 30, function() pressCDU(CDU_L_OFFSET.DOT) end)

drawButton(250, 560, 40, 30, "+/-")
button_add(nil, nil, 250, 560, 40, 30, function() pressCDU(CDU_L_OFFSET.PLUS_MINUS) end)

-- TEST BUTTON - Toggle beacon lights to verify Air Manager connection
drawButton(300, 480, 80, 35, "TEST")
button_add(nil, nil, 300, 480, 80, 35, function() testConnection() end)

print("PMDG 777 CDU Controller loaded with visible buttons!")