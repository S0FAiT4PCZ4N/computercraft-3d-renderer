local monitor = peripheral.find("monitor")
local terminal = term.current()
--local terminal = term.redirect(monitor)
local width, height = term.getSize()

--CUBE
local wfvertex = {{-50, -50, -50}, {50, -50, -50}, {-50, -50, 50}, {50, -50, 50}, {-50, 50, -50}, {50, 50, -50}, {-50, 50, 50}, {50, 50, 50}}
local wfedges = {{1, 2}, {1, 3}, {1, 5}, {2, 4}, {2, 6}, {3, 4}, {3, 7}, {4, 8}, {5, 6}, {5, 7}, {6 ,8}, {7, 8}}

local cube = {wfvertex, wfedges}

--LOL
local  wfvertex = {{-60, 30, 0}, {-60, -30, 0}, {-30, -30, 0}, {-15, 30, 0}, {-15, -30, 0}, {15, 30, 0}, {15, -30, 0}, {30, 30, 0}, {30, -30, 0}, {60, -30, 0}}
local wfedges = {{1, 2}, {2, 3}, {4, 5}, {4, 6}, {5, 7}, {6, 7}, {8, 9}, {9, 10}}

local lol = {wfvertex, wfedges}

local rangle = 0.1

local focal = 1
local drawColor = colors.yellow
local bgColor = colors.black

term.setBackgroundColor(bgColor)
term.clear()

local function projectVertex(vertex)

    local cx = vertex[1] * (focal / (vertex[3] + 150))
    local cy = vertex[2] * (focal / (vertex[3] + 150))

    local px = cx * -1 * width / 2 + width / 2
    local py = cy * -1 * height / 2 + height / 2
    return px, py
end

local function renderEgde(vertexA, vertexB)
    local xA, yA = projectVertex(vertexA)
    local xB, yB = projectVertex(vertexB)

    paintutils.drawLine(xA, yA, xB, yB, drawColor)
    term.setBackgroundColor(bgColor)
end

local function render(wireframe, terminal)

    local prevTerm = term.redirect(terminal)
    width, height = term.getSize()
    
    local vertex = wireframe[1]
    local edges = wireframe[2]
    for i in pairs(edges) do
        local vertexA = vertex[edges[i][1]]
        local vertexB = vertex[edges[i][2]]
        renderEgde(vertexA, vertexB)
    end
    
    term.redirect(prevTerm)
end

local function rotate(wireframe)
    local vertex = wireframe[1]
    for i in pairs(vertex) do
        local x = vertex[i][1]
        local z = vertex[i][3]

        vertex[i][1] = x * math.cos(rangle) - z * math.sin(rangle)
        vertex[i][3] = x * math.sin(rangle) + z * math.cos(rangle)
    end

    wireframe[1] = vertex
    return wireframe
end

while true do
    render(lol, terminal)
    lol = rotate(lol)
    render(cube, monitor)
    cube = rotate(cube)
    os.sleep(0.1)
    terminal.clear()
    monitor.clear()
end

