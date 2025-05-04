--[[
    ElvUI Controller - A plugin for ElvUI that adds controller support with FFXIV-style crossbars
]]

local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local EC = E:NewModule('Controller', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0') --Create a plugin within ElvUI and adopt AceHook-3.0, AceEvent-3.0 and AceTimer-3.0
local EP = LibStub("LibElvUIPlugin-1.0") --We can use this to automatically insert our GUI tables when ElvUI_Config is loaded.
local addonName, addonTable = ... --See http://www.wowinterface.com/forums/showthread.php?t=51502&p=304704&postcount=2

--Default options
P["Controller"] = {
    ["enabled"] = true,
    ["layout"] = "Xbox",
    ["bindings"] = {},
    ["numPages"] = 2,
}

-- Button labels for controller layouts
local controllerLayouts = {
    Xbox = { A = "A", B = "B", X = "X", Y = "Y", LB = "LB", RB = "RB", LT = "LT", RT = "RT" },
    PlayStation = { Cross = "Cross", Circle = "Circle", Square = "Square", Triangle = "Triangle", L1 = "L1", R1 = "R1", L2 = "L2", R2 = "R2" },
    Nintendo = { A = "A", B = "B", X = "X", Y = "Y", L = "L", R = "R", ZL = "ZL", ZR = "ZR" },
}

--Function we can call when a setting changes
function EC:Update()
    local enabled = E.db.Controller.enabled
    local layout = E.db.Controller.layout
    
    if enabled then
        print("Controller enabled with layout: " .. layout)
        self:ToggleCrossbar(true)
    else
        print("Controller disabled")
        self:ToggleCrossbar(false)
    end
end

--This function inserts our GUI table into the ElvUI Config
function EC:InsertOptions()
    E.Options.args.Controller = {
        order = 100,
        type = "group",
        name = "Controller",
        args = {
            header = {
                order = 1,
                type = "header",
                name = "ElvUI Controller",
            },
            enabled = {
                order = 2,
                type = "toggle",
                name = "Enable",
                get = function(info) return E.db.Controller.enabled end,
                set = function(info, value) 
                    E.db.Controller.enabled = value
                    EC:Update() --We changed a setting, call our Update function
                end,
            },
            layout = {
                order = 3,
                type = "select",
                name = "Controller Layout",
                values = { Xbox = "Xbox", PlayStation = "PlayStation", Nintendo = "Nintendo" },
                get = function(info) return E.db.Controller.layout end,
                set = function(info, value) 
                    E.db.Controller.layout = value
                    EC:Update() --We changed a setting, call our Update function
                end,
            },
            numPages = {
                order = 4,
                type = "range",
                name = "Number of Pages",
                min = 2,
                max = 8,
                step = 1,
                get = function(info) return E.db.Controller.numPages end,
                set = function(info, value) 
                    E.db.Controller.numPages = value
                    EC:Update() --We changed a setting, call our Update function
                end,
            },
        },
    }
end

-- Setup crossbar
function EC:SetupCrossbar()
    print("ElvUI Controller loaded!")
    -- Your setup code here
end

-- Toggle crossbar visibility
function EC:ToggleCrossbar(enable)
    if enable then
        -- Enable the crossbar and begin monitoring inputs
        print("Controller mode enabled")
    else
        -- Disable the crossbar
        print("Controller mode disabled")
    end
end

function EC:Initialize()
    --Register plugin so options are properly inserted when config is loaded
    EP:RegisterPlugin(addonName, EC.InsertOptions)
    
    -- Create default settings if they don't exist
    if not E.db.Controller then
        E.db.Controller = P.Controller
    end
    
    -- Register events
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "SetupCrossbar")
    
    -- Setup initial state
    self:Update()
    
    print("|cff1784d1ElvUI|r |cffffffffController|r: Initialized")
end

E:RegisterModule(EC:GetName()) --Register the module with ElvUI. ElvUI will now call EC:Initialize() when ElvUI is ready to load our plugin.
