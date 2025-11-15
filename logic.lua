-- PMDG 777 Left CDU Button Controller
-- Uses ROTOR_BRAKE method with proper PMDG encoding
-- Layout based on Boeing 737 FMC by Detlef von Reusner

-- PMDG Event ID Offsets (from THIRD_PARTY_EVENT_ID_MIN)
-- DO NOT use the full event ID - only the offset!
local CDU_L_OFFSET = {
    -- Line Select Keys
    L1 = 328, L2 = 329, L3 = 330, L4 = 331, L5 = 332, L6 = 333,
    R1 = 334, R2 = 335, R3 = 336, R4 = 337, R5 = 338, R6 = 339,

    -- Function Keys
    INIT_REF = 340, RTE = 341, DEP_ARR = 342, ALTN = 343,
    VNAV = 344, FIX = 345, LEGS = 346, HOLD = 347,
    PROG = 348, EXEC = 349, MENU = 350,
    PREV_PAGE = 352, NEXT_PAGE = 353,

    -- Number Keys
    K1 = 354, K2 = 355, K3 = 356, K4 = 357, K5 = 358,
    K6 = 359, K7 = 360, K8 = 361, K9 = 362, K0 = 364,
    DOT = 363, PLUS_MINUS = 365,

    -- Letter Keys
    A = 366, B = 367, C = 368, D = 369, E = 370, F = 371,
    G = 372, H = 373, I = 374, J = 375, K = 376, L = 377,
    M = 378, N = 379, O = 380, P = 381, Q = 382, R = 383,
    S = 384, T = 385, U = 386, V = 387, W = 388, X = 389,
    Y = 390, Z = 391,
    SPACE = 392, DEL = 393, SLASH = 394, CLR = 395,
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

-- ======================== Background and Button Graphics ======================

local ImgBackground = img_add_fullscreen("bg-day.png")

local gButton = {}
local gLastDatarefPressed = nil

local gSoundButtonClick = sound_add("Notebook1.wav", .4)
local gSoundButtonDepress = sound_add("Notebook1.wav", .1)

function ButtonPressed(offset)
    gLastDatarefPressed = offset
    local but = gButton[offset]
    if but == nil then return end

    move(but.img_day, but.x+1, but.y+1, but.w, but.h)

    pressCDU(offset)
    sound_play(gSoundButtonClick)
end

function ButtonReleased()
    if gLastDatarefPressed == nil then return end
    local but = gButton[gLastDatarefPressed]
    if but == nil then return end

    move(but.img_day, but.x, but.y, but.w, but.h)
    sound_play(gSoundButtonDepress)
end

-- ======================== Button Drawing Functions ======================

function PageButtonAdd(offset, x, y, w, h, text1, x1, y1, text2, x2, y2)
    gButton[offset] = {}
    local but = gButton[offset]
    but.x = x
    but.y = y
    but.w = w
    but.h = h

    but.img_day = canvas_add(x, y, w, h, function()
        _txt(text1, "font:roboto_bold.ttf; size:20; color:white; halign:left;", x1, y1)
        if text2 ~= nil then
            _txt(text2, "font:roboto_bold.ttf; size:20; color:white; halign:left;", x2, y2)
        end
    end)
end

function LetterButtonAdd(offset, x, y, bw, bh, text1)
    local w = 35
    local h = 35
    local font = "font:roboto_bold.ttf; size:34; halign:left;"

    gButton[offset] = {}
    local but = gButton[offset]
    but.x = x
    but.y = y
    but.w = bw
    but.h = bh

    but.img_day = canvas_add(x, y, bw, bh, function()
        if #text1 ~= 1 then
            font = "font:roboto_bold.ttf; size:20; halign:left;"
            _txt(text1, font..";color:white", 11, 15)
        else
            _txt(text1, font..";color:white", 15, 6)
        end
    end)
end

function NumberButtonAdd(offset, x, y, bw, bh, text1)
    local font = "font:roboto_bold.ttf; size:34; halign:left;"

    gButton[offset] = {}
    local but = gButton[offset]
    but.x = x
    but.y = y
    but.w = bw
    but.h = bh

    but.img_day = canvas_add(x, y, bw, bh, function()
        if text1 == "." then
            _circle(22, 24, 4)
            _fill("white")
        elseif text1 == "+/-" then
            _move_to(13, 13)
            _line_to(21, 13)
            _move_to(17, 9)
            _line_to(17, 17)

            _move_to(30, 11)
            _line_to(13, 28)

            _move_to(25, 24)
            _line_to(32, 24)
            _stroke("white", 2)
        else
            _txt(text1, font..";color:white", 15, 2)
        end
    end)
end

function LskButtonAdd(offset, x, y, bw, bh)
    gButton[offset] = {}
    local but = gButton[offset]
    but.x = x
    but.y = y
    but.w = bw
    but.h = bh

    but.img_day = canvas_add(x, y, bw, bh, function()
        _move_to(16, 17)
        _line_to(33, 17)
        _stroke("white", 3)
    end)
end

-- ====================== Add Buttons =======================

-- Function buttons - Row 1
local bw = 66
local bh = 48
local x0 = 42
local x = x0
local y = 376
local w = 58
local h = 40
local dx = 67

button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.INIT_REF) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.INIT_REF, x, y, w, h, "INIT", 17, 3, "REF", 17, 18)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.RTE) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.RTE, x, y, w, h, "RTE", 16, 11)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.DEP_ARR) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.DEP_ARR, x, y, w, h, "DEP", 17, 3, "ARR", 16, 18)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.ALTN) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.ALTN, x, y, w, h, "ALTN", 12, 11)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.VNAV) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.VNAV, x, y, w, h, "VNAV", 11, 11)

-- Function buttons - Row 2
x = x0
local dy = 49
y = y+dy

button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.MENU) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.MENU, x, y, w, h, "MENU", 8, 11)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.LEGS) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.LEGS, x, y, w, h, "LEGS", 12, 11)

x=x+dx*2
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.HOLD) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.HOLD, x, y, w, h, "HOLD", 11, 11)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.PROG) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.PROG, x, y, w, h, "PROG", 11, 11)

x=x+dx+17
button_add("page-released.png", "page-pressed.png", x, y+8, bw, 40, function() ButtonPressed(CDU_L_OFFSET.EXEC) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.EXEC, x, y+8, w, 32, "EXEC", 11, 7)

-- Function buttons - Row 3
x = x0
y = y+dy

button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.FIX) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.FIX, x, y, w, h, "FIX", 16, 11)

-- Function buttons - Row 4 (Nav)
x = x0
y = y+dy

button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.PREV_PAGE) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.PREV_PAGE, x, y, w, h, "PREV", 11, 3, "PAGE", 11, 18)

x=x+dx
button_add("page-released.png", "page-pressed.png", x, y, bw, bh, function() ButtonPressed(CDU_L_OFFSET.NEXT_PAGE) end, ButtonReleased)
PageButtonAdd(CDU_L_OFFSET.NEXT_PAGE, x, y, w, h, "NEXT", 11, 3, "PAGE", 11, 18)

-- Numbers
w = 44
h = 44
x = 40
y = 590
dx = 45
dy = 45

button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K1) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K1, x, y, w, h, "1")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K2) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K2, x, y, w, h, "2")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K3) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K3, x, y, w, h, "3")

x = 40
y = y+dy

button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K4) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K4, x, y, w, h, "4")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K5) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K5, x, y, w, h, "5")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K6) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K6, x, y, w, h, "6")

x = 40
y = y+dy

button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K7) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K7, x, y, w, h, "7")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K8) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K8, x, y, w, h, "8")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K9) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K9, x, y, w, h, "9")

x = 40
y = y+dy

button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.DOT) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.DOT, x, y, w, h, ".")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K0) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.K0, x, y, w, h, "0")

x=x+dx
button_add("number-released.png", "number-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.PLUS_MINUS) end, ButtonReleased)
NumberButtonAdd(CDU_L_OFFSET.PLUS_MINUS, x, y, w, h, "+/-")

-- Line Select Keys - Left
w = 50
h = 40
x = 2
y = 80
dy = 42

button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L1) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.L1, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L2) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.L2, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L3) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.L3, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L4) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.L4, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L5) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.L5, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L6) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.L6, x, y, w, h)

-- Line Select Keys - Right
x = 438
y = 80

button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R1) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.R1, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R2) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.R2, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R3) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.R3, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R4) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.R4, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R5) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.R5, x, y, w, h)

y=y+dy
button_add("lsk-released.png", "lsk-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R6) end, ButtonReleased)
LskButtonAdd(CDU_L_OFFSET.R6, x, y, w, h)

-- Letters
local x0 = 200
w = 47
h = 47
x = x0
y = 480
dx = 48
dy = 48

button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.A) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.A, x, y, w, h, "A")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.B) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.B, x, y, w, h, "B")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.C) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.C, x, y, w, h, "C")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.D) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.D, x, y, w, h, "D")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.E) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.E, x, y, w, h, "E")

x = x0
y = y+dy

button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.F) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.F, x, y, w, h, "F")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.G) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.G, x, y, w, h, "G")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.H) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.H, x, y, w, h, "H")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.I) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.I, x, y, w, h, "I")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.J) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.J, x, y, w, h, "J")

x = x0
y = y+dy

button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.K) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.K, x, y, w, h, "K")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.L) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.L, x, y, w, h, "L")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.M) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.M, x, y, w, h, "M")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.N) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.N, x, y, w, h, "N")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.O) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.O, x, y, w, h, "O")

x = x0
y = y+dy

button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.P) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.P, x, y, w, h, "P")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.Q) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.Q, x, y, w, h, "Q")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.R) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.R, x, y, w, h, "R")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.S) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.S, x, y, w, h, "S")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.T) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.T, x, y, w, h, "T")

x = x0
y = y+dy

button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.U) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.U, x, y, w, h, "U")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.V) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.V, x, y, w, h, "V")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.W) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.W, x, y, w, h, "W")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.X) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.X, x, y, w, h, "X")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.Y) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.Y, x, y, w, h, "Y")

x = x0
y = y+dy

button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.Z) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.Z, x, y, w, h, "Z")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.SPACE) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.SPACE, x, y, w, h, " SP")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.DEL) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.DEL, x, y, w, h, "DEL")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.SLASH) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.SLASH, x, y, w, h, "  /")

x=x+dx
button_add("letter-released.png", "letter-pressed.png", x, y, w, h, function() ButtonPressed(CDU_L_OFFSET.CLR) end, ButtonReleased)
LetterButtonAdd(CDU_L_OFFSET.CLR, x, y, w, h, "CLR")

-- Static graphics for LSK dashes
local gImgStatic = canvas_add(0, 0, 490, 370, function()
    local x = 52
    local y = 98
    local k
    for k=1,6 do
        _move_to(x, y)
        _line_to(x+11, y+4)

        _move_to(x+383, y)
        _line_to(x+383-11, y+4)

        y=y+42
    end
    _stroke("white", 2)
end)

print("PMDG 777 CDU Controller loaded!")
