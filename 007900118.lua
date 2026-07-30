-- ============================================================================
-- 👻 KILLER HUB UNIVERSAL FRAMEWORK | OBSIDIAN ULTRA PREMIUM EDITION (V4.2.0)
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ⚡ FAST-PATH LOCALS (caché de funciones matemáticas/color de uso frecuente en Luau,
-- evita resoluciones de tabla globales repetidas durante el arrastre del Color Picker)
local mathClamp = math.clamp
local mathRound = math.round
local stringFormat = string.format
local color3FromHSV = Color3.fromHSV
local color3FromRGB = Color3.fromRGB
local color3ToHSV = Color3.toHSV

-- ============================================================================
-- 🎨 ICON LIBRARY (registro global de iconos por nombre)
-- ----------------------------------------------------------------------------
-- Permite pasar a CreateTab / CreateTabGroup:
--   • Un nombre corto           →  "Gun", "Sword", "Settings", "Skull"...
--   • Un ID plano de Roblox     →  "7059346373"
--   • Un rbxassetid completo    →  "rbxassetid://7059346373"
--   • Un asset://               →  se respeta tal cual
-- Todos los IDs son de TEXTURA (no del recurso decal), pegados directos.
-- Puedes extender la tabla en runtime: KillerHub:RegisterIcon("MiIcono","123")
-- ============================================================================
local IconLibrary = {
    Settings   = "7059346373",
    Gear       = "7059346373",
    Gun        = "126193793480527",
    Sword      = "14939026710",
    Eye        = "6523858394",
    Skull      = "134857111376422",
    Hitbox     = "126768961562737",
    Scale      = "126768961562737",
    Code       = "11348555035",
    Script     = "11348555035",
    Crosshair  = "12614416478",
    Aim        = "12614416478",
    Player     = "18832691284",
    Robot      = "130840043704422",
    Bot        = "130840043704422",
    Ak47       = "15286655815",
    Rifle      = "15286655815",
    Movement   = "8370845871",
    Movimiento = "8370845871",
    Teleport   = "6723742952",
    Warn       = "18797417802",
    Warning    = "18797417802",
    Troll      = "140731226103831",
}

local function resolveIcon(id)
    if id == nil or id == "" then return nil end
    if type(id) ~= "string" then return nil end
    -- Ya es un asset URI válido
    if id:match("^rbxassetid://") or id:match("^rbxthumb://") or id:match("^rbxasset://") or id:match("^http") then
        return id
    end
    -- Nombre registrado (case-insensitive)
    local mapped = IconLibrary[id]
    if not mapped then
        for k, v in pairs(IconLibrary) do
            if k:lower() == id:lower() then mapped = v break end
        end
    end
    if mapped then return "rbxassetid://" .. mapped end
    -- ID numérico puro
    if id:match("^%d+$") then return "rbxassetid://" .. id end
    return id -- último recurso: devolver tal cual
end



-- 🛠 ANTI-CRASH UNIVERSAL INTEGRADO (GetSafeUIParent)
local function GetSafeUIParent()
    local success, result = pcall(function()
        if gethui then return gethui() end
        local coreGui = game:GetService("CoreGui")
        if coreGui and coreGui.Name then return coreGui end
    end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local TargetParent = GetSafeUIParent()

if TargetParent:FindFirstChild("KillerHub_Universal") then
    TargetParent.KillerHub_Universal:Destroy()
end

local Themes = {
    ["Obsidian"] = {
        BG_MAIN = Color3.fromRGB(8, 8, 10),
        BG_SIDEBAR = Color3.fromRGB(4, 4, 5),
        BG_SECONDARY = Color3.fromRGB(16, 16, 20),
        ACCENT = Color3.fromRGB(222, 222, 222),
        PREMIUM_GOLD = Color3.fromRGB(255, 196, 0),
        TEXT_WHITE = Color3.fromRGB(255, 255, 255),
        TEXT_MUTED = Color3.fromRGB(130, 130, 135),
        BORDER = Color3.fromRGB(20, 0, 40)
    },
    ["Void Premium"] = {
        BG_MAIN = Color3.fromRGB(8, 5, 12),
        BG_SIDEBAR = Color3.fromRGB(11, 8, 16),
        BG_SECONDARY = Color3.fromRGB(15, 11, 22),
        ACCENT = Color3.fromRGB(138, 43, 226),
        PREMIUM_GOLD = Color3.fromRGB(255, 215, 0),
        TEXT_WHITE = Color3.fromRGB(245, 240, 255),
        TEXT_MUTED = Color3.fromRGB(130, 115, 145),
        BORDER = Color3.fromRGB(40, 0, 80)
    },
    ["Midnight Emerald"] = {
        BG_MAIN = Color3.fromRGB(10, 12, 11),
        BG_SIDEBAR = Color3.fromRGB(13, 16, 14),
        BG_SECONDARY = Color3.fromRGB(16, 22, 18),
        ACCENT = Color3.fromRGB(0, 230, 115),
        PREMIUM_GOLD = Color3.fromRGB(255, 200, 50),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 140, 130),
        BORDER = Color3.fromRGB(28, 38, 32)
    },
    ["Classic Dark"] = {
        BG_MAIN = Color3.fromRGB(15, 15, 15),
        BG_SIDEBAR = Color3.fromRGB(20, 20, 20),
        BG_SECONDARY = Color3.fromRGB(25, 25, 25),
        ACCENT = Color3.fromRGB(245, 245, 245),
        PREMIUM_GOLD = Color3.fromRGB(255, 180, 0),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 130, 130),
        BORDER = Color3.fromRGB(40, 40, 40)
    },
    ["Sakura Blossom"] = {
        BG_MAIN = Color3.fromRGB(16, 12, 14),
        BG_SIDEBAR = Color3.fromRGB(20, 15, 18),
        BG_SECONDARY = Color3.fromRGB(26, 20, 24),
        ACCENT = Color3.fromRGB(255, 143, 163),
        PREMIUM_GOLD = Color3.fromRGB(255, 210, 120),
        TEXT_WHITE = Color3.fromRGB(255, 240, 243),
        TEXT_MUTED = Color3.fromRGB(150, 120, 128),
        BORDER = Color3.fromRGB(50, 30, 38)
    },
    ["Blood"] = {
        BG_MAIN = Color3.fromRGB(10, 10, 10),
        BG_SIDEBAR = Color3.fromRGB(14, 12, 12),
        BG_SECONDARY = Color3.fromRGB(18, 14, 14),
        ACCENT = Color3.fromRGB(185, 15, 15),
        PREMIUM_GOLD = Color3.fromRGB(255, 170, 40),
        TEXT_WHITE = Color3.fromRGB(255, 255, 255),
        TEXT_MUTED = Color3.fromRGB(135, 105, 105),
        BORDER = Color3.fromRGB(46, 20, 20)
    }
}

local CurrentTheme = Themes["Obsidian"]

-- 📂 CARPETA DEDICADA: aísla el JSON de esta librería de cualquier otro script
-- que también autoguarde (incluso si ese script usa un nombre genérico tipo
-- "config.json" en la raíz). Al vivir en su propia carpeta, dos autoguardados
-- corriendo al mismo tiempo (este + el de tu otro archivo) nunca se pisan.
local CONFIG_FOLDER = "KillerHub_Config"
-- 🌐 PERSISTENCIA UNIVERSAL (una sola configuración compartida entre TODOS los juegos).
-- Antes se dividía en Global.json + Game_<PlaceId>.json, pero eso reiniciaba tus
-- toggles/sliders al abrir otro juego. Ahora todo (estética + flags) vive en
-- Universal.json y te acompaña a cualquier experiencia. Si aparecen los archivos
-- viejos (Global.json / Game_<id>.json / Core_<id>.json) se importan una vez y
-- listo — no hay dependencia de PlaceId por ningún lado.
local UNIVERSAL_FILE = CONFIG_FOLDER .. "/Universal.json"
-- Compatibilidad hacia atrás con instalaciones anteriores (se migran en silencio).
local LEGACY_GLOBAL_FILE = CONFIG_FOLDER .. "/Global.json"

pcall(function()
    if isfolder and makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end)

local DefaultConfig = {
    Volume = 0.5, ToggleKey = "RightControl", SelectedTheme = "Obsidian", SelectedFont = "GothamMedium", MenuAnimEnabled = true, AutoArrangeShortcuts = true,
    GuiWidth = 0.466, GuiHeight = 0.4, UiOpacity = 0.75, ToggleBtnSize = 46,
    MainFrameX = 0, MainFrameY = 0, BtnX = 15, BtnY = 100
}
local Config = {}
local Flags = {}
local Connections = {}

local function connect(event, callback)
    local conn = event:Connect(callback)
    table.insert(Connections, conn)
    return conn
end

local function copyTable(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then target[k] = {} copyTable(target[k], v) else target[k] = v end
    end
end
copyTable(Config, DefaultConfig)

-- 🩹 AUTOGUARDADO UNIVERSAL: un solo archivo con TODA tu configuración.
-- 1) Debounce de escritura: saveConfig() se llama en cada muestra de arrastre de
--    sliders/keybinds/toggles (varias veces por frame). El debounce colapsa
--    cualquier ráfaga del mismo resumption cycle en un solo writefile.
-- 2) pcall en cada paso (encode y write por separado): si algo falla no se
--    rompe el hub ni se deja un archivo a medio escribir con basura.
local pendingConfigSave = false
local function saveConfig()
    if pendingConfigSave then return end
    pendingConfigSave = true
    task.defer(function()
        pendingConfigSave = false
        if not writefile then return end
        local ok, enc = pcall(function() return HttpService:JSONEncode(Config) end)
        if ok and enc then pcall(function() writefile(UNIVERSAL_FILE, enc) end) end
    end)
end

-- 🩹 CARGA BLINDADA: si el archivo no existe, está corrupto, o el JSON no es
-- una tabla válida, simplemente se ignora y se usan los valores por defecto.
-- Si existen archivos de versiones anteriores (Global.json / Game_<id>.json /
-- Core_<id>.json) se fusionan una única vez dentro de Universal.json y luego
-- este pasa a ser la única fuente de verdad, sin depender del PlaceId.
local function _loadJsonInto(pathFile)
    if not (isfile and readfile and isfile(pathFile)) then return end
    local ok, raw = pcall(readfile, pathFile)
    if not (ok and raw and #raw > 0) then return end
    local decOk, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if decOk and type(data) == "table" then
        for k, v in pairs(data) do Config[k] = v end
    end
end
pcall(function()
    -- Migración silenciosa: si aún no existe Universal.json pero hay archivos
    -- viejos, los importamos en orden (global primero, luego el del juego que
    -- hayas usado por última vez) y guardamos todo consolidado.
    if isfile and not isfile(UNIVERSAL_FILE) then
        if isfile(LEGACY_GLOBAL_FILE) then _loadJsonInto(LEGACY_GLOBAL_FILE) end
        if listfiles and isfolder and isfolder(CONFIG_FOLDER) then
            local okList, files = pcall(listfiles, CONFIG_FOLDER)
            if okList and type(files) == "table" then
                for _, f in ipairs(files) do
                    local name = tostring(f)
                    if name:find("Game_") or name:find("Core_") then
                        _loadJsonInto(name)
                    end
                end
            end
        end
        saveConfig()
    end
    _loadJsonInto(UNIVERSAL_FILE)
end)

if Themes[Config.SelectedTheme] then CurrentTheme = Themes[Config.SelectedTheme] end

local function create(instanceType, properties, parent)
    local obj = Instance.new(instanceType)
    for prop, val in pairs(properties) do obj[prop] = val end
    -- 🧼 Higiene visual: fuerza TextStrokeTransparency = 1 en cualquier texto
    -- salvo que el llamador lo haya definido explicitamente. Elimina el "doble
    -- borde de color" que aparece con ciertas fuentes / DPIs altos.
    if (instanceType == "TextLabel" or instanceType == "TextButton" or instanceType == "TextBox")
       and properties.TextStrokeTransparency == nil then
        pcall(function() obj.TextStrokeTransparency = 1 end)
    end
    if parent then obj.Parent = parent end
    return obj
end

-- 🛠 UTILERÍAS EXTRA DE SEGURIDAD Y MENÚ
local function getSafeColor(flagName, defaultColor)
    local val = Config[flagName]
    if type(val) == "table" then
        local r = tonumber(val[1] or val["1"]) or defaultColor.R
        local g = tonumber(val[2] or val["2"]) or defaultColor.G
        local b = tonumber(val[3] or val["3"]) or defaultColor.B
        return Color3.new(r, g, b)
    end
    return defaultColor
end

local function setTabScrolling(element, enabled)
    local parent = element.Parent
    while parent do
        if parent:IsA("ScrollingFrame") and parent.Name ~= "SidebarTabsContainer" then
            parent.ScrollingEnabled = enabled
            break
        end
        parent = parent.Parent
    end
end

-- ============================================================================
-- 🖥 INTERFAZ CON CANVASGROUP DE ALTO RENDIMIENTO
-- ============================================================================
local ScreenGui = create("ScreenGui", {Name = "KillerHub_Universal", IgnoreGuiInset = false, ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets, ResetOnSpawn = false, DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, TargetParent)
-- 🌐 Ref global al ScreenGui para que subsistemas (notificaciones v1.3) lo
-- encuentren incluso cuando gethui() lo parenta a un contenedor no estándar
-- (CoreGui protegido en algunos executors). Sin esto las notificaciones no
-- aparecían en clientes donde findNotifContainer() sólo miraba CoreGui/PlayerGui.
_G.__KillerHub_ScreenGui__ = ScreenGui

local function playUISound()
    if not Config.Volume or Config.Volume <= 0 then return end
    pcall(function()
        local sound = create("Sound", {SoundId = "rbxassetid://101735926591481", Volume = Config.Volume}, ScreenGui)
        sound:Play() 
        Debris:AddItem(sound, 1.5)
    end)
end

local MainFrame = create("Frame", {Name = "MainFrame", BackgroundColor3 = CurrentTheme.BG_MAIN, BorderSizePixel = 0, ClipsDescendants = true, Active = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, Config.MainFrameX or 0, 0.5, Config.MainFrameY or 0)}, ScreenGui)
local MainStroke = create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 12)}, MainFrame)

local BordeGradient = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.BORDER),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    }), Rotation = 45
}, MainStroke)

-- 🌀 Rotacion del gradiente del borde: solo gasta GPU si el menu esta abierto
-- Y visible. Al cerrarlo, el RenderStepped simplemente hace early-return, sin
-- tocar propiedades ni disparar re-layouts.
local menuFocused = true
-- Throttle a ~30Hz en Heartbeat: mantiene la animacion suave del borde
-- pero reduce a la mitad los writes a UIGradient.Rotation (menos trabajo
-- de layout/GPU en moviles, menos calor y menos caidas de FPS).
local _gradAccum = 0
local gradientRotationConn = RunService.Heartbeat:Connect(function(dt)
    if not (BordeGradient and MainFrame.Visible and menuFocused) then return end
    _gradAccum = _gradAccum + dt
    if _gradAccum < 1/30 then return end
    BordeGradient.Rotation = (BordeGradient.Rotation + (15 * _gradAccum)) % 360
    _gradAccum = 0
end)
table.insert(Connections, gradientRotationConn)

local function updateGuiSize()
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, math.floor(430 + ((Config.GuiWidth or 0.466) * 280)), 0, math.floor(280 + ((Config.GuiHeight or 0.4) * 230)))
    end
end

local Topbar = create("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(4, 4, 5), BorderSizePixel = 0, Active = true, ClipsDescendants = true}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 12)}, Topbar)

local Title = create("TextLabel", {Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(0, 18, 0, 0), BackgroundTransparency = 1, Text = "Killer Hub | By Paolo", TextColor3 = CurrentTheme.TEXT_WHITE, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 14}, Topbar)
local DecorLine = create("Frame", {Size = UDim2.new(0, 60, 0, 2.5), Position = UDim2.new(0, 18, 1, -2), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0}, Topbar)
local PerformanceLabel = create("TextLabel", {Size = UDim2.new(0, 160, 1, 0), Position = UDim2.new(1, -15, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "FPS: -- | PING: --", TextColor3 = CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamMedium, TextSize = 11}, Topbar)

local fpsTimer = 0
local frameCounter = 0
local perfConn = RunService.Heartbeat:Connect(function(dt)
    fpsTimer = fpsTimer + dt
    frameCounter = frameCounter + 1
    if fpsTimer >= 1 then
        local currentFps = frameCounter
        frameCounter = 0
        fpsTimer = 0
        local ping = 0
        pcall(function()
            if Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
                ping = math.floor(Stats.Network.ServerToClientPing:GetValue())
            else
                ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            end
        end)
        PerformanceLabel.Text = string.format("FPS: %d | PING: %dms", currentFps, ping)
    end
end)
table.insert(Connections, perfConn)

-- 🛡️ ARRASTRE SIN ERRORES MULTI-TOUCH EN MÓVILES
local function makeDraggable(clickObject, dragObject)
    local dragging, dragStart, startPos, activeInput
    local moveConn, endConn
    
    connect(clickObject.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
            dragging = true 
            activeInput = input 
            dragStart = input.Position 
            startPos = dragObject.Position
            
            moveConn = connect(UserInputService.InputChanged, function(changedInput)
                if dragging and (changedInput == activeInput) then
                    task.defer(function()
                        if not dragging then return end
                        local delta = changedInput.Position - dragStart
                        local screenSize = Camera.ViewportSize
                        if dragObject.Name == "MainFrame" then
                            local frameSize = dragObject.AbsoluteSize
                            local absoluteX = (screenSize.X * 0.5) + (startPos.X.Offset + delta.X)
                            local absoluteY = (screenSize.Y * 0.5) + (startPos.Y.Offset + delta.Y)
                            local clampedX = math.clamp(absoluteX, frameSize.X / 2, screenSize.X - (frameSize.X / 2))
                            local clampedY = math.clamp(absoluteY, frameSize.Y / 2, screenSize.Y - (frameSize.Y / 2))
                            dragObject.Position = UDim2.new(0.5, clampedX - (screenSize.X * 0.5), 0.5, clampedY - (screenSize.Y * 0.5))
                        else
                            local btnSize = dragObject.AbsoluteSize
                            local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - btnSize.X)
                            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenSize.Y - btnSize.Y)
                            dragObject.Position = UDim2.new(0, newX, 0, newY)
                        end
                    end)
                end
            end)
            
            endConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput == activeInput then
                    dragging = false 
                    activeInput = nil
                    if moveConn then moveConn:Disconnect() moveConn = nil end
                    if endConn then endConn:Disconnect() end
                    if dragObject.Name == "MainFrame" then
                        Config.MainFrameX = dragObject.Position.X.Offset
                        Config.MainFrameY = dragObject.Position.Y.Offset
                        saveConfig()
                    elseif dragObject.Name == "KillerHubToggle" then
                        Config.BtnX = dragObject.Position.X.Offset
                        Config.BtnY = dragObject.Position.Y.Offset
                        saveConfig()
                    end
                end
            end)
        end
    end)
end

makeDraggable(Topbar, MainFrame)

local Sidebar = create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 125, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = CurrentTheme.BG_SIDEBAR, BorderSizePixel = 0, Active = true}, MainFrame)
local SidebarLine = create("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Color3.fromRGB(30, 30, 35), BorderSizePixel = 0}, Sidebar)

local SearchBoxContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 26), Position = UDim2.new(0, 6, 0, 8), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, Sidebar)
create("UICorner", {CornerRadius = UDim.new(0, 6)}, SearchBoxContainer)
local SearchStroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(35, 35, 40)}, SearchBoxContainer)

local SearchInput = create("TextBox", {Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, PlaceholderText = "Buscar...", PlaceholderColor3 = CurrentTheme.TEXT_MUTED, Text = "", TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false}, SearchBoxContainer)

local TabsHeader = create("Frame", {Size = UDim2.new(1, -12, 0, 18), Position = UDim2.new(0, 6, 0, 38), BackgroundTransparency = 1}, Sidebar)
local TabsHeaderLabel = create("TextLabel", {Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1, Text = "PESTAÑAS", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left}, TabsHeader)
local TabsHeaderCount = create("TextLabel", {Size = UDim2.new(0, 28, 1, 0), Position = UDim2.new(1, -28, 0, 0), BackgroundTransparency = 1, Text = "0", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right}, TabsHeader)
local SidebarTabsContainer = create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -100), Position = UDim2.new(0, 0, 0, 56), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = CurrentTheme.ACCENT, ScrollBarImageTransparency = 0.4, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollingDirection = Enum.ScrollingDirection.Y, BorderSizePixel = 0}, Sidebar)
local tabsLayout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SidebarTabsContainer)
create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, SidebarTabsContainer)

local tabsSizeConn = tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SidebarTabsContainer.CanvasSize = UDim2.new(0, 0, 0, tabsLayout.AbsoluteContentSize.Y + 10)
end)
table.insert(Connections, tabsSizeConn)

local SettingsContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 36), Position = UDim2.new(0, 6, 1, -42), BackgroundTransparency = 1}, Sidebar)
local ContentContainer = create("Frame", {Name = "ContentContainer", Size = UDim2.new(1, -123, 1, -43), Position = UDim2.new(0, 123, 0, 43), BackgroundTransparency = 1, Active = true}, MainFrame)

local OpenCloseBtn = create("TextButton", {Name = "KillerHubToggle", Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, Config.BtnX or 15, 0, Config.BtnY or 100), BackgroundColor3 = CurrentTheme.BG_MAIN, Text = "", Active = true}, ScreenGui)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, OpenCloseBtn)
local FloatingStroke = create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER}, OpenCloseBtn)
local BtnIcon = create("ImageLabel", {Name = "Icon", Size = UDim2.new(1, 0, 1, 0), ScaleType = Enum.ScaleType.Crop, BackgroundTransparency = 1, Image = "rbxassetid://84689030731870", ImageColor3 = CurrentTheme.ACCENT}, OpenCloseBtn)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, BtnIcon)

makeDraggable(OpenCloseBtn, OpenCloseBtn)

local function updateUiOpacity()
    local opacity = Config.UiOpacity or 0.75
    if MainFrame.Visible then
        MainFrame.BackgroundTransparency = 1 - opacity
    end
    Topbar.BackgroundTransparency = math.clamp((1 - opacity) + 0.1, 0, 0.95)
    Sidebar.BackgroundTransparency = math.clamp((1 - opacity) + 0.05, 0, 0.95)
end

local function updateButtonSize()
    local s = Config.ToggleBtnSize or 46
    OpenCloseBtn.Size = UDim2.new(0, s, 0, s)
end

MainFrame.Size = UDim2.new(0, math.floor(430 + ((Config.GuiWidth or 0.466) * 280)), 0, math.floor(280 + ((Config.GuiHeight or 0.4) * 230)))
updateUiOpacity()
updateButtonSize()

-- 🎬 FADE ESCALONADO SIN CANVASGROUP
-- Antes: MainFrame era un CanvasGroup y toda la interfaz se desvanecia usando
-- GroupTransparency. Ese contenedor tiene el defecto conocido de rasterizar el
-- texto a baja resolucion en ciertos dispositivos, viendose borroso. Ahora
-- MainFrame es un Frame normal (nitidez absoluta en fuentes) y el fade se
-- construye animando los subelementos por separado, con un ligero delay
-- escalonado que produce una sensacion mas premium sin costo de GPU.
local BLUR_MAX = 14
local menuBlur -- BlurEffect que solo existe mientras el menu esta abierto
local function _ensureBlur()
    if menuBlur and menuBlur.Parent then return menuBlur end
    local ok, lighting = pcall(function() return game:GetService("Lighting") end)
    if not ok or not lighting then return nil end
    menuBlur = Instance.new("BlurEffect")
    menuBlur.Name = "KillerHub_MenuBlur"
    menuBlur.Size = 0
    menuBlur.Parent = lighting
    return menuBlur
end

-- Snapshots de opacidad "en reposo" de cada capa del menu, calculadas al abrir
local function _computeLayerOpacities()
    local o = Config.UiOpacity or 0.75
    return {
        main    = 1 - o,
        topbar  = math.clamp((1 - o) + 0.1, 0, 0.95),
        sidebar = math.clamp((1 - o) + 0.05, 0, 0.95),
    }
end

local function _tween(inst, props, t, style, dir)
    return TweenService:Create(inst, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
end

local menuVisible = true
-- 🎬 Animación premium: fade + scale suave desde el centro con easing Quint.
-- El toggle Config.MenuAnimEnabled permite desactivarla (aparece/desaparece al instante).
-- Se conserva el tamaño real del MainFrame en un UIScale (no toca Size), para no
-- pelearse con updateGuiSize() ni con el layout responsive.
local _menuScale = MainFrame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
_menuScale.Scale = 1
_menuScale.Parent = MainFrame

local function _animEnabled()
    return Config.MenuAnimEnabled ~= false
end

local function setMenuVisibility(visible)
    menuVisible = visible
    menuFocused = visible
    BtnIcon.ImageColor3 = visible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE

    local target = _computeLayerOpacities()
    local anim = _animEnabled()

    if visible then
        MainFrame.Visible = true
        ContentContainer.Visible = true

        if not anim then
            _menuScale.Scale = 1
            MainFrame.BackgroundTransparency = target.main
            Topbar.BackgroundTransparency = target.topbar
            Sidebar.BackgroundTransparency = target.sidebar
            local blur = _ensureBlur() if blur then blur.Size = BLUR_MAX end
            return
        end

        MainFrame.BackgroundTransparency = 1
        Topbar.BackgroundTransparency = 1
        Sidebar.BackgroundTransparency = 1
        _menuScale.Scale = 0.92

        local IN_TIME = 0.28
        local EASE = Enum.EasingStyle.Quint
        _tween(_menuScale, {Scale = 1}, IN_TIME, EASE, Enum.EasingDirection.Out):Play()
        _tween(MainFrame, {BackgroundTransparency = target.main}, IN_TIME, EASE, Enum.EasingDirection.Out):Play()
        task.delay(0.05, function()
            if menuVisible then _tween(Topbar, {BackgroundTransparency = target.topbar}, 0.22, EASE, Enum.EasingDirection.Out):Play() end
        end)
        task.delay(0.09, function()
            if menuVisible then _tween(Sidebar, {BackgroundTransparency = target.sidebar}, 0.22, EASE, Enum.EasingDirection.Out):Play() end
        end)

        local blur = _ensureBlur()
        if blur then
            blur.Size = 0
            _tween(blur, {Size = BLUR_MAX}, IN_TIME, EASE, Enum.EasingDirection.Out):Play()
        end
    else
        if not anim then
            MainFrame.BackgroundTransparency = 1
            Topbar.BackgroundTransparency = 1
            Sidebar.BackgroundTransparency = 1
            MainFrame.Visible = false
            _menuScale.Scale = 1
            if menuBlur and menuBlur.Parent then
                pcall(function() menuBlur:Destroy() end); menuBlur = nil
            end
            return
        end

        local OUT_TIME = 0.20
        local EASE = Enum.EasingStyle.Quint
        _tween(_menuScale, {Scale = 0.94}, OUT_TIME, EASE, Enum.EasingDirection.In):Play()
        _tween(Sidebar, {BackgroundTransparency = 1}, OUT_TIME * 0.75, EASE, Enum.EasingDirection.In):Play()
        _tween(Topbar, {BackgroundTransparency = 1}, OUT_TIME * 0.85, EASE, Enum.EasingDirection.In):Play()
        local closeTween = _tween(MainFrame, {BackgroundTransparency = 1}, OUT_TIME, EASE, Enum.EasingDirection.In)
        closeTween.Completed:Connect(function()
            if not menuVisible then
                MainFrame.Visible = false
                _menuScale.Scale = 1
            end
        end)
        closeTween:Play()

        if menuBlur and menuBlur.Parent then
            local bTween = _tween(menuBlur, {Size = 0}, OUT_TIME, EASE, Enum.EasingDirection.In)
            bTween.Completed:Connect(function()
                if not menuVisible and menuBlur then
                    pcall(function() menuBlur:Destroy() end)
                    menuBlur = nil
                end
            end)
            bTween:Play()
        end
    end
end

connect(OpenCloseBtn.MouseButton1Click, function() playUISound() setMenuVisibility(not menuVisible) end)

connect(UserInputService.InputBegan, function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == (Config.ToggleKey or "RightControl") then
        playUISound() setMenuVisibility(not menuVisible)
    end
end)

local activeTweens = setmetatable({}, {__mode = "k"})

-- 🩹 BUG FIX (revert visual del Color Picker): antes, addInteractiveFeedback() guardaba
-- "baseColor" UNA SOLA VEZ al crear el botón. Cualquier color elegido después en el
-- Color Picker (ColorBtn) quedaba aplicado de verdad en Config/Flags, pero al sacar el
-- mouse del cuadrito (MouseLeave, típicamente al cerrar el menú) el tween de "hover
-- feedback" regresaba el BackgroundColor3 a ese snapshot viejo, dando la falsa
-- impresión de que el color (o el guardado) no se había aplicado.
-- InteractiveBaseColor guarda el color "real" vigente de cada botón y se mantiene
-- sincronizado vía setSwatchColor() cada vez que el color picker asigna un color de verdad.
local InteractiveBaseColor = setmetatable({}, {__mode = "k"})

local function setSwatchColor(inst, color)
    inst.BackgroundColor3 = color
    InteractiveBaseColor[inst] = color
end

local function addInteractiveFeedback(inst)
    if not inst:IsA("TextButton") then return end
    InteractiveBaseColor[inst] = InteractiveBaseColor[inst] or inst.BackgroundColor3

    connect(inst.MouseEnter, function()
        if activeTweens[inst] then activeTweens[inst]:Cancel() end
        local base = InteractiveBaseColor[inst] or inst.BackgroundColor3
        activeTweens[inst] = TweenService:Create(inst, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = base:Lerp(Color3.fromRGB(255, 255, 255), 0.08)
        })
        activeTweens[inst]:Play()
    end)
    connect(inst.MouseLeave, function()
        if activeTweens[inst] then activeTweens[inst]:Cancel() end
        local base = InteractiveBaseColor[inst] or inst.BackgroundColor3
        activeTweens[inst] = TweenService:Create(inst, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = base
        })
        activeTweens[inst]:Play()
    end)
end

-- ============================================================================
-- 📦 API CORE Y MOTOR REACTIVO (ATRIBUTOS DE ARQUITECTURA)
-- ============================================================================
local KillerHub = {
    Tabs = {}, Frames = {}, Buttons = {}, Config = Config, Flags = Flags,
    CurrentTab = nil, AllElements = {}, TargetThemeElements = {}, _Trash = {},
    Elements = {}, TabRegistry = {} -- caché {Frame,Btn,Label,Icon,Line} por pestaña: evita FindFirstChild en cada click
}

-- ============================================================================
-- 💎 SISTEMA PREMIUM DE NOTIFICACIONES DINÁMICAS
-- ============================================================================
local NotifContainer = create("Frame", {
    Name = "NotificationContainer",
    Size = UDim2.new(0, 260, 1, -20),
    Position = UDim2.new(1, -270, 0, 10),
    BackgroundTransparency = 1,
    -- 🔝 ZIndex alto para que las notificaciones nunca queden ocultas detrás
    -- del modal de shortcuts (ZIndex 50+) ni del backdrop del color picker.
    ZIndex = 900
}, ScreenGui)
local NotifLayout = create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Bottom
}, NotifContainer)

-- 🛡️ TOPE DE NOTIFICACIONES APILADAS: si algo (o alguien) llama a Notify() en ráfaga,
-- esto evita que se acumulen decenas de frames en pantalla comiéndose memoria/GPU;
-- simplemente cierra la más vieja antes de abrir una nueva por encima del límite.
local MAX_ACTIVE_NOTIFS = 5
local ActiveNotifs = {}

function KillerHub:Notify(title, text, duration, customColor)
    duration = duration or 4
    local accentColor = customColor or CurrentTheme.ACCENT

    if #ActiveNotifs >= MAX_ACTIVE_NOTIFS then
        local oldest = table.remove(ActiveNotifs, 1)
        if oldest and oldest.Parent then pcall(function() oldest:Destroy() end) end
    end

    local NotifFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = CurrentTheme.BG_MAIN,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true
    }, NotifContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, NotifFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, NotifFrame)
    
    local Line = create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0
    }, NotifFrame)
    
    local Tl = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, NotifFrame)
    
    local Tx = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 18),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, NotifFrame)

    if not customColor then
        table.insert(KillerHub.TargetThemeElements, function()
            NotifFrame.BackgroundColor3 = CurrentTheme.BG_MAIN
            Stroke.Color = CurrentTheme.BORDER
            Line.BackgroundColor3 = CurrentTheme.ACCENT
        end)
    end

    table.insert(ActiveNotifs, NotifFrame)

    TweenService:Create(NotifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 46)}):Play()
    
    task.delay(duration, function()
        if not NotifFrame or not NotifFrame.Parent then return end
        local t = TweenService:Create(NotifFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        t.Completed:Connect(function()
            pcall(function() NotifFrame:Destroy() end)
            local idx = table.find(ActiveNotifs, NotifFrame)
            if idx then table.remove(ActiveNotifs, idx) end
        end)
        t:Play()
    end)
end

-- 🛠 DEBUGGER Y VALIDADOR INTELIGENTE (SafeAssert)
local function SafeAssert(componentName, checks)
    for paramName, checkData in pairs(checks) do
        local value = checkData.value
        local expectedTypes = checkData.types
        local match = false
        
        for _, t in ipairs(expectedTypes) do
            if typeof(value) == t then match = true break end
        end
        
        if not match then
            local expectedStr = table.concat(expectedTypes, " o ")
            local errorMsg = string.format("El parametro '%s' en '%s' debia ser [%s], pero recibio [%s].", paramName, componentName, expectedStr, typeof(value))
            warn("⚠️ [KillerHub Debugger] " .. errorMsg)
            task.spawn(function()
                KillerHub:Notify("❌ Error en Componente", errorMsg, 6, Color3.fromRGB(240, 50, 50))
            end)
            return false
        end
    end
    return true
end

-- 🚨 REPORTE DE ERRORES EN TIEMPO DE EJECUCIÓN
-- safeCall(context, fn, ...) ejecuta callbacks del usuario y, si tiran error,
-- avisa por Notify con el mensaje exacto + un warn en consola con el traceback.
-- Así, si alguien pasa mal la API, escribe mal un flag o su callback truena,
-- el error no queda escondido: sale como notificación roja en pantalla.
local ErrorNotifyCooldown = {}
local function _notifyError(title, msg)
    local key = title .. "|" .. msg
    local now = os.clock()
    if ErrorNotifyCooldown[key] and (now - ErrorNotifyCooldown[key]) < 3 then return end
    ErrorNotifyCooldown[key] = now
    task.spawn(function()
        if KillerHub and KillerHub.Notify then
            KillerHub:Notify(title, msg, 7, Color3.fromRGB(240, 70, 70))
        end
    end)
end

local function safeCall(context, fn, ...)
    if type(fn) ~= "function" then return end
    local args = table.pack(...)
    local ok, err = xpcall(function() return fn(table.unpack(args, 1, args.n)) end, function(e)
        local tb = debug.traceback(tostring(e), 2)
        warn("⚠️ [KillerHub] Error en '" .. tostring(context) .. "':\n" .. tb)
        return tostring(e)
    end)
    if not ok then
        _notifyError("❌ Error en " .. tostring(context), tostring(err))
    end
end

-- Enganche global: cualquier error de un LocalScript que llegue a
-- ScriptContext.Error (por ejemplo, un error dentro de una corrutina que nadie
-- envolvió en pcall) también se muestra como notificación.
pcall(function()
    local ScriptContext = game:GetService("ScriptContext")
    connect(ScriptContext.Error, function(message, stackTrace, sc)
        local msg = tostring(message or "")
        -- Ignora ruido irrelevante o errores nuestros ya reportados
        if msg == "" then return end
        if msg:find("HTTP", 1, true) and msg:find("disabled", 1, true) then return end
        _notifyError("⚠️ Error detectado", msg)
        warn("[KillerHub] ScriptContext.Error:\n" .. tostring(stackTrace))
    end)
end)


local function updateGlobalFlags(flagName, value)
    Flags[flagName] = { CurrentValue = value }
    if getgenv().KillerHub then
        getgenv().KillerHub.Flags = Flags
    end
end

function KillerHub:SetPremiumIds(idTable) end

-- 🎨 API pública para registrar iconos personalizados en runtime
-- Uso: KillerHub:RegisterIcon("MiIcono", "1234567890")
--      KillerHub:CreateTab("Mi Pestaña", "MiIcono")
function KillerHub:RegisterIcon(name, id)
    if type(name) ~= "string" or (type(id) ~= "string" and type(id) ~= "number") then return end
    IconLibrary[name] = tostring(id)
end
function KillerHub:GetIcon(name) return resolveIcon(name) end


function KillerHub:SetFont(fontName)
    Config.SelectedFont = fontName
    saveConfig()
    local fontEnum = Enum.Font[fontName] or Enum.Font.GothamMedium
    for _, v in ipairs(ScreenGui:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
            v.Font = fontEnum
        end
    end
    -- Los shortcuts flotantes viven en OTRO ScreenGui, por eso antes no se
    -- actualizaban hasta re-activarlos. Ahora se refrescan al instante.
    if KillerHub._RefreshShortcuts then pcall(KillerHub._RefreshShortcuts) end
end

function KillerHub:AddTask(obj)
    table.insert(self._Trash, obj)
    return obj
end

-- 🛠 OPTIMIZACIÓN DE RENDIMIENTO GENERAL (Garbage Collection Integrado)
function KillerHub:Destroy()
    self:Unload()
end

function KillerHub:Unload()
    -- 🛑 PASO 0 — AVISO DE APAGADO A LOS TOGGLES ACTIVOS.
    -- Esto es lo que soluciona que "las funciones se quedan encendidas" al
    -- cerrar el hub. Antes, Unload() solo borraba la UI y limpiaba sus propias
    -- conexiones internas — pero jamás le avisaba a TU código (el callback que
    -- le pasaste a CreateToggle/CreateToggleSlider/CreateToggleColorPicker) que
    -- se estaba apagando. Si tu callback arranca un loop externo (ESP, un
    -- while true, un RenderStepped propio, etc.) controlado por una variable
    -- tipo `running`, ese loop nunca se enteraba y quedaba corriendo para
    -- siempre en segundo plano, aunque la UI ya no existiera.
    --
    -- Ahora, para cada toggle que esté ACTIVO en este momento, se le llama a su
    -- callback original con `false` — exactamente igual que si el usuario lo
    -- hubiera apagado a mano con un click. Si tu callback está escrito de forma
    -- normal (ej. `function(state) running = state end` con un loop que
    -- revisa `running`), tu loop se detiene solo, limpio.
    --
    -- ⚠️ Importante y honesto: esto NO es magia ni "borra la caché" de nada.
    -- Ningún script externo (ni este ni cualquier otro en Lua/Luau) puede matar
    -- a la fuerza un hilo/loop que OTRO script haya creado por su cuenta, salvo
    -- que ese hilo coopere revisando un estado que se le avisa que cambió. Es
    -- la misma limitación que tiene cualquier engine con corrutinas. Lo que sí
    -- puedo garantizar es que el aviso llega — si tu loop no lo respeta (por
    -- ejemplo, ignora el parámetro `state` y hace su propia cosa sin revisar
    -- nada), ningún Unload() de ninguna librería va a poder pararlo desde
    -- afuera; eso hay que arreglarlo en el propio callback de tu script.
    --
    -- A propósito esto NO pasa por Set()/saveConfig(): así el valor que quedó
    -- guardado en el JSON sigue siendo el que tenías (activo), y si vuelves a
    -- ejecutar el hub más tarde recuerda que lo tenías prendido, en vez de
    -- "olvidarlo" solo porque cerraste el menú una vez.
    for _, obj in pairs(self.Elements) do
        if type(obj) == "table" and type(obj._ShutdownNotify) == "function" then
            pcall(obj._ShutdownNotify)
        end
    end
    -- Un frame de gracia para que esos callbacks síncronos (task.spawn) alcancen
    -- a correr antes de que sigamos destruyendo instancias/tablas debajo.
    task.wait()

    for _, conn in ipairs(Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    for _, item in ipairs(self._Trash) do
        if typeof(item) == "RBXScriptConnection" then pcall(function() item:Disconnect() end)
        elseif typeof(item) == "Instance" then pcall(function() item:Destroy() end)
        -- 🛡️ Red de seguridad extra: si en algún momento se registró un thread
        -- con KillerHub:AddTask(coroutine), lo cancelamos a la fuerza aquí.
        -- Esto SÍ puede matar un hilo de golpe (a diferencia del aviso
        -- cooperativo de arriba), pero solo alcanza a los threads que el
        -- propio desarrollador decidió registrar explícitamente.
        elseif typeof(item) == "thread" then pcall(function() task.cancel(item) end) end
    end
    if ScreenGui then pcall(function() ScreenGui:Destroy() end) end

    -- 🩹 Fix: al apagar el script, retirar el BlurEffect que vive en Lighting;
    -- si no lo destruimos, el desenfoque se queda pegado en pantalla.
    if menuBlur and menuBlur.Parent then
        pcall(function() menuBlur:Destroy() end)
    end
    menuBlur = nil
    
    -- Limpieza profunda de memoria
    table.clear(Connections)
    table.clear(self._Trash)
    table.clear(self.Tabs)
    table.clear(self.Frames)
    table.clear(self.Buttons)
    table.clear(self.AllElements)
    table.clear(self.TargetThemeElements)
    table.clear(self.Elements)
    
    if getgenv().KillerHub then getgenv().KillerHub = nil end
    warn("❌ KillerHub desunificado por completo: toggles activos avisados, conexiones cerradas y memoria liberada.")
end

function KillerHub:SetTheme(themeName)
    if not Themes[themeName] then return end
    CurrentTheme = Themes[themeName]
    Config.SelectedTheme = themeName
    saveConfig()
    
    MainFrame.BackgroundColor3 = CurrentTheme.BG_MAIN
    MainStroke.Color = CurrentTheme.BORDER
    Sidebar.BackgroundColor3 = CurrentTheme.BG_SIDEBAR
    SidebarLine.BackgroundColor3 = CurrentTheme.BORDER
    Title.TextColor3 = CurrentTheme.TEXT_WHITE
    DecorLine.BackgroundColor3 = CurrentTheme.ACCENT
    PerformanceLabel.TextColor3 = CurrentTheme.TEXT_MUTED
    SearchBoxContainer.BackgroundColor3 = CurrentTheme.BG_SECONDARY
    if TabsHeaderLabel then TabsHeaderLabel.TextColor3 = CurrentTheme.TEXT_MUTED end
    if TabsHeaderCount then TabsHeaderCount.TextColor3 = CurrentTheme.ACCENT end
    if SidebarTabsContainer then SidebarTabsContainer.ScrollBarImageColor3 = CurrentTheme.ACCENT end
    SearchInput.TextColor3 = CurrentTheme.TEXT_WHITE
    SearchInput.PlaceholderColor3 = CurrentTheme.TEXT_MUTED
    OpenCloseBtn.BackgroundColor3 = CurrentTheme.BG_MAIN
    FloatingStroke.Color = CurrentTheme.BORDER
    BtnIcon.ImageColor3 = menuVisible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
    
    BordeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.BORDER),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    })

    for _, v in ipairs(ScreenGui:GetDescendants()) do
        local role = v:GetAttribute("ThemeRole")
        if role == "BG_SECONDARY" then
            v.BackgroundColor3 = CurrentTheme.BG_SECONDARY
            local s = v:FindFirstChildWhichIsA("UIStroke") if s then s.Color = CurrentTheme.BORDER end
            local tl = v:FindFirstChildWhichIsA("TextLabel") if tl and not v:GetAttribute("CustomColorLabel") then tl.TextColor3 = CurrentTheme.ACCENT end
        elseif role == "TEXT_ACCENT" then
            v.TextColor3 = CurrentTheme.ACCENT
        end
    end
    
    for _, refreshCallback in ipairs(self.TargetThemeElements) do
        pcall(refreshCallback)
    end
    self:SetFont(Config.SelectedFont or "GothamMedium")
    if KillerHub._RefreshShortcuts then pcall(KillerHub._RefreshShortcuts) end
end

-- ============================================================================
-- 🎨 PANEL COMPARTIDO DE COLOR PICKER (Canvas SV + Hue + Preview centrado + Modo RGB)
-- Antes CreateColorPicker y CreateToggleColorPicker duplicaban ~150 líneas idénticas.
-- Se centraliza aquí: menos memoria de script, un único punto de mantenimiento,
-- y así ambos widgets comparten exactamente el mismo comportamiento y optimizaciones.
-- ============================================================================
local function BuildColorPickerPanel(MasterFrame, ColorBtn, flagColor, savedColor, contentTop, fireCallback)
    local Canvas = create("ImageLabel", {
        Position = UDim2.new(0, 12, 0, contentTop),
        Size = UDim2.new(0, 190, 0, 128),
        Image = "rbxassetid://4155801252",
        BackgroundColor3 = color3FromHSV(color3ToHSV(savedColor)),
        BorderSizePixel = 0,
        Active = true
    }, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Canvas)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50)}, Canvas)

    local SVPickerKnob = create("Frame", {Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0}, Canvas)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, SVPickerKnob)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 0, 0)}, SVPickerKnob)

    local HueSlider = create("Frame", {Position = UDim2.new(0, 214, 0, contentTop), Size = UDim2.new(0, 20, 0, 128), BorderSizePixel = 0, Active = true}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, HueSlider)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50)}, HueSlider)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Rotation = 90
    }, HueSlider)
    local HueKnob = create("Frame", {Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, -2, 0, -2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0}, HueSlider)
    create("UICorner", {CornerRadius = UDim.new(0, 2)}, HueKnob)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 0, 0)}, HueKnob)

    -- Columna derecha auto-centrada: la previsualización y el hex ya no van pegados a un
    -- lado, se centran en el espacio libre junto al Hue sin importar el ancho de la ventana
    local InfoColumn = create("Frame", {Position = UDim2.new(0, 246, 0, contentTop), Size = UDim2.new(1, -258, 0, 128), BackgroundTransparency = 1}, MasterFrame)

    local PreviewFrame = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0, 58, 0, 58),
        BackgroundColor3 = savedColor
    }, InfoColumn)
    create("UICorner", {CornerRadius = UDim.new(0, 10)}, PreviewFrame)
    create("UIStroke", {Thickness = 1.5, Color = Color3.fromRGB(55, 55, 62), Transparency = 0.1}, PreviewFrame)

    local HexBox = create("TextBox", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 68),
        Size = UDim2.new(1, -8, 0, 26),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Text = "",
        PlaceholderText = "FFFFFF",
        PlaceholderColor3 = Color3.fromRGB(100, 105, 115),
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Center
    }, InfoColumn)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, HexBox)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50)}, HexBox)

    -- 🌈 Toggle "Modo RGB": activa un recorrido automático de tono (arcoíris) adaptado al tema
    local RainbowRow = create("Frame", {Position = UDim2.new(0, 12, 0, contentTop + 136), Size = UDim2.new(1, -24, 0, 30), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BackgroundTransparency = 0.3}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, RainbowRow)
    local RainbowStroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, RainbowRow)
    local RainbowLabel = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "Modo RGB (Arcoíris)", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11.5, TextXAlignment = Enum.TextXAlignment.Left}, RainbowRow)
    local RainbowBtn = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, RainbowRow)
    local RTrack = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -44, 0.5, -9), BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, RainbowRow)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, RTrack)
    local RKnob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, RTrack)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, RKnob)

    local h, s, v = color3ToHSV(savedColor)
    local rainbowActive = Config[flagColor .. "_Rainbow"] == true
    local rainbowConn = nil

    local pendingSave = false
    local function requestSave()
        if pendingSave then return end
        pendingSave = true
        task.defer(function() saveConfig() pendingSave = false end)
    end

    local function paintVisuals(col)
        SVPickerKnob.Position = UDim2.new(s, -6, 1 - v, -6)
        HueKnob.Position = UDim2.new(0.5, -10, h, -2)
        Canvas.BackgroundColor3 = color3FromHSV(h, 1, 1)
        PreviewFrame.BackgroundColor3 = col
        setSwatchColor(ColorBtn, col)
        if not HexBox:IsFocused() then
            HexBox.Text = stringFormat("#%02X%02X%02X", mathRound(col.R * 255), mathRound(col.G * 255), mathRound(col.B * 255))
        end
    end

    -- Guardado inmediato pero "debounced" a un solo writefile por frame,
    -- evita I/O redundante mientras se arrastra sin perder persistencia en tiempo real
    local function refreshColor(skipCallback)
        local col = color3FromHSV(h, s, v)
        Config[flagColor] = {col.R, col.G, col.B}
        updateGlobalFlags(flagColor, col)
        paintVisuals(col)
        requestSave()
        if not skipCallback then fireCallback(col) end
    end

    local function setRainbowVisual(active)
        RTrack.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        RKnob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        RainbowLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
    end

    -- ⚡ Ciclo de tono por Heartbeat con guardado y callback LIMITADOS por tiempo (throttle):
    -- sin esto, el modo arcoíris dispararía writefile()/callback ~60 veces por segundo y
    -- causaría lag; así se mantiene fluido a 60fps mientras solo persiste 1 vez/seg
    local rbSaveAcc, rbCallbackAcc = 0, 0
    local function rainbowStep(dt)
        h = (h + dt * 0.15) % 1
        local col = color3FromHSV(h, s, v)
        Config[flagColor] = {col.R, col.G, col.B}
        updateGlobalFlags(flagColor, col)
        paintVisuals(col)
        rbSaveAcc = rbSaveAcc + dt
        rbCallbackAcc = rbCallbackAcc + dt
        if rbSaveAcc >= 1 then rbSaveAcc = 0 saveConfig() end
        if rbCallbackAcc >= 0.1 then rbCallbackAcc = 0 fireCallback(col) end
    end

    local function setRainbow(active, skipSave)
        rainbowActive = active
        Config[flagColor .. "_Rainbow"] = active
        setRainbowVisual(active)
        if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
        if active then
            rbSaveAcc, rbCallbackAcc = 0, 0
            rainbowConn = connect(RunService.Heartbeat, rainbowStep)
        elseif not skipSave then
            saveConfig()
        end
    end

    connect(RainbowBtn.MouseButton1Click, function()
        playUISound()
        setRainbow(not rainbowActive)
    end)

    local function updateSV(input)
        local pctX = mathClamp((input.Position.X - Canvas.AbsolutePosition.X) / Canvas.AbsoluteSize.X, 0, 1)
        local pctY = 1 - mathClamp((input.Position.Y - Canvas.AbsolutePosition.Y) / Canvas.AbsoluteSize.Y, 0, 1)
        s = pctX
        v = pctY
        refreshColor()
    end

    local function updateHue(input)
        local pctY = mathClamp((input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
        h = pctY
        refreshColor()
    end

    -- Entrada Hex editable: al perder el foco (Enter o click afuera) recalcula todo
    connect(HexBox.FocusLost, function()
        local raw = HexBox.Text:gsub("#", ""):upper()
        if #raw == 6 and raw:match("^%x+$") then
            local r = tonumber(raw:sub(1, 2), 16)
            local g = tonumber(raw:sub(3, 4), 16)
            local b = tonumber(raw:sub(5, 6), 16)
            if rainbowActive then setRainbow(false) end
            h, s, v = color3ToHSV(color3FromRGB(r, g, b))
            refreshColor()
        else
            refreshColor() -- texto inválido: restaura el hex al color actual
        end
    end)

    -- Drags táctiles multi-touch independientes con control de scrolling en pestaña
    local svDragging = false
    local svActiveInput = nil
    local svDragConn, svEndConn

    connect(Canvas.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not svDragging then
            svDragging = true
            svActiveInput = input
            setTabScrolling(MasterFrame, false)
            updateSV(input)

            svDragConn = connect(UserInputService.InputChanged, function(changedInput)
                if svDragging and (changedInput == svActiveInput) then
                    updateSV(changedInput)
                end
            end)

            svEndConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput == svActiveInput then
                    svDragging = false
                    svActiveInput = nil
                    setTabScrolling(MasterFrame, true)
                    saveConfig()
                    if svDragConn then svDragConn:Disconnect() svDragConn = nil end
                    if svEndConn then svEndConn:Disconnect() svEndConn = nil end
                end
            end)
        end
    end)

    local hueDragging = false
    local hueActiveInput = nil
    local hueDragConn, hueEndConn

    connect(HueSlider.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not hueDragging then
            hueDragging = true
            hueActiveInput = input
            if rainbowActive then setRainbow(false) end -- mover el tono a mano sale del modo automático
            setTabScrolling(MasterFrame, false)
            updateHue(input)

            hueDragConn = connect(UserInputService.InputChanged, function(changedInput)
                if hueDragging and (changedInput == hueActiveInput) then
                    updateHue(changedInput)
                end
            end)

            hueEndConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput == hueActiveInput then
                    hueDragging = false
                    hueActiveInput = nil
                    setTabScrolling(MasterFrame, true)
                    saveConfig()
                    if hueDragConn then hueDragConn:Disconnect() hueDragConn = nil end
                    if hueEndConn then hueEndConn:Disconnect() hueEndConn = nil end
                end
            end)
        end
    end)

    -- Limpieza de memoria: si el contenedor se destruye a mitad de un arrastre o con el
    -- modo RGB activo (cambio de pestaña, cierre del hub, etc.) se desconecta todo
    connect(MasterFrame.Destroying, function()
        if svDragConn then svDragConn:Disconnect() svDragConn = nil end
        if svEndConn then svEndConn:Disconnect() svEndConn = nil end
        if hueDragConn then hueDragConn:Disconnect() hueDragConn = nil end
        if hueEndConn then hueEndConn:Disconnect() hueEndConn = nil end
        if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
    end)

    setRainbowVisual(rainbowActive)
    if rainbowActive then task.defer(function() setRainbow(true, true) end) end

    return {
        RefreshInit = function() refreshColor(true) end,
        SetColor = function(newColor)
            if rainbowActive then setRainbow(false) end
            h, s, v = color3ToHSV(newColor)
            refreshColor()
        end,
        Sync = function()
            local col = Flags[flagColor].CurrentValue
            setSwatchColor(ColorBtn, col)
            PreviewFrame.BackgroundColor3 = col
        end,
        ApplyTheme = function()
            RainbowStroke.Color = CurrentTheme.BORDER
            setRainbowVisual(rainbowActive)
        end
    }
end

local TabMethods = {}
TabMethods.__index = TabMethods

function TabMethods:RegisterElement(inst, textLabel, tabName)
    table.insert(KillerHub.AllElements, {Instance = inst, Label = textLabel, Tab = tabName})
    -- 🩹 FIX DE RENDIMIENTO: antes esto llamaba a KillerHub:SetFont(), que recorre
    -- TODOS los descendientes del ScreenGui, por cada widget nuevo creado. Con N
    -- elementos eso es O(n²) solo para construir el menú (perceptible con GUIs
    -- grandes, especialmente en móvil). Como el widget recién creado ya nace con
    -- la fuente por defecto de Roblox, basta con aplicarle la fuente actual
    -- únicamente a él y a sus propios descendientes.
    local fontEnum = Enum.Font[Config.SelectedFont] or Enum.Font.GothamMedium
    task.defer(function()
        if not inst or not inst.Parent then return end
        if inst:IsA("TextLabel") or inst:IsA("TextBox") or inst:IsA("TextButton") then
            inst.Font = fontEnum
        end
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
                v.Font = fontEnum
            end
        end
    end)
end

function TabMethods:CreateParagraph(title, text)
    if not SafeAssert("CreateParagraph", {
        ["title"] = {value = title, types = {"string"}},
        ["text"] = {value = text, types = {"string"}}
    }) then return end

    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.3}, self.Frame)
    Frame:SetAttribute("ThemeRole", "BG_SECONDARY") Frame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Frame)
    
    local Tl = create("TextLabel", {Size = UDim2.new(1, -24, 0, 16), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1, Text = title, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Frame)
    Tl:SetAttribute("ThemeRole", "TEXT_ACCENT")
    local Tx = create("TextLabel", {Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, Frame)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Tx.TextColor3 = CurrentTheme.TEXT_MUTED
    end)
    self:RegisterElement(Frame, Tl, self.Frame.Name)
    
    local paraObj = {
        SetTitle = function(_, t) Tl.Text = t end,
        SetText = function(_, t) Tx.Text = t end
    }
    KillerHub.Elements[title] = paraObj
    return paraObj
end

function TabMethods:CreateSection(text)
    if not SafeAssert("CreateSection", {
        ["text"] = {value = text, types = {"string"}}
    }) then return end

    -- 🎨 REDISEÑO: antes había una barrita vertical de acento a la izquierda del
    -- texto. Ahora el texto va más grande y suelto arriba, y debajo hay un
    -- divisor horizontal con degradado de transparencia (sólido a la izquierda,
    -- se desvanece hacia la derecha) — igual al estilo de la imagen de referencia.
    local SectionFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1}, self.Frame)

    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left}, SectionFrame)
    Label:SetAttribute("ThemeRole", "TEXT_ACCENT")

    local DividerLine = create("Frame", {Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 0, 27), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0}, SectionFrame)
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.55, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    }, DividerLine)
    
    table.insert(KillerHub.TargetThemeElements, function()
        DividerLine.BackgroundColor3 = CurrentTheme.ACCENT
    end)
    
    self:RegisterElement(SectionFrame, Label, self.Frame.Name)
    
    local secObj = {
        SetText = function(_, newText) Label.Text = string.upper(newText) end
    }
    KillerHub.Elements[text] = secObj
    return secObj
end

function TabMethods:CreateToggle(flagName, text, callback)
    if not SafeAssert("CreateToggle", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = false end
    updateGlobalFlags(flagName, Config[flagName])
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, Text = "", AutoButtonColor = false}, self.Frame)
    ToggleButton:SetAttribute("ThemeRole", "BG_SECONDARY") ToggleButton:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, ToggleButton)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, ToggleButton)
    
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 46, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagName] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, ToggleButton)
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagName] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagName] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local function stateUpdate()
        local active = Flags[flagName].CurrentValue
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        TweenService:Create(Track, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
    end
    
    local function executeSet(bool)
        updateGlobalFlags(flagName, bool) Config[flagName] = bool saveConfig()
        task.spawn(stateUpdate)
        task.spawn(callback, bool)
    end

    connect(ToggleButton.MouseButton1Click, function()
        playUISound()
        executeSet(not Flags[flagName].CurrentValue)
    end)
    
    table.insert(KillerHub.TargetThemeElements, stateUpdate)
    task.spawn(function() stateUpdate() safeCall("callback", callback, Flags[flagName].CurrentValue) end)

    addInteractiveFeedback(ToggleButton)
    self:RegisterElement(ToggleButton, ToggleLabel, self.Frame.Name)
    
    local toggleObj = {
        Set = function(_, bool) executeSet(bool) end,
        BindToKey = function(self, keycode)
            local keyConn = connect(UserInputService.InputBegan, function(input, gp)
                if not gp and input.KeyCode == keycode then
                    playUISound()
                    executeSet(not Flags[flagName].CurrentValue)
                end
            end)
            table.insert(Connections, keyConn)
        end,
        BindToState = function(self, evaluationFunction, checkInterval)
            checkInterval = checkInterval or 0.5
            task.spawn(function()
                while task.wait(checkInterval) do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    local success, result = pcall(evaluationFunction)
                    if success and typeof(result) == "boolean" then
                        if Flags[flagName].CurrentValue ~= result then
                            executeSet(result)
                        end
                    end
                end
            end)
        end,
        -- 🛑 Llamado únicamente por KillerHub:Unload() antes de destruir nada.
        -- Si este toggle está ACTIVO, avisa a su callback original con `false`,
        -- igual que si el usuario lo hubiera apagado a mano — para que cualquier
        -- loop externo que dependa de ese estado (ESP, aimbot, lo que sea) se
        -- detenga solo. A propósito NO pasa por executeSet/saveConfig: así el
        -- valor guardado en el JSON sigue siendo el que el usuario dejó, y al
        -- recargar el hub vuelve tal cual, en vez de "olvidarse" que estaba activo.
        _ShutdownNotify = function()
            if Flags[flagName] and Flags[flagName].CurrentValue then
                task.spawn(callback, false)
            end
        end
    }
    
    KillerHub.Elements[flagName] = toggleObj
    if KillerHub._AttachShortcut then
        KillerHub._AttachShortcut(ToggleButton, {
            id = "toggle::" .. flagName,
            kind = "toggle",
            name = text,
            flag = flagName,
            fire = function() executeSet(not Flags[flagName].CurrentValue) end,
            getState = function() return Flags[flagName] and Flags[flagName].CurrentValue end,
        })
    end
    return toggleObj
end

function TabMethods:CreatePremiumToggle(flagName, text, callback)
    return self:CreateToggle(flagName, text, callback)
end

function TabMethods:CreateToggleSlider(flagToggle, flagSlider, text, min, max, callbackToggle, callbackSlider)
    if not SafeAssert("CreateToggleSlider", {
        ["flagToggle"] = {value = flagToggle, types = {"string"}},
        ["flagSlider"] = {value = flagSlider, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["min"] = {value = min, types = {"number"}},
        ["max"] = {value = max, types = {"number"}},
        ["callbackToggle"] = {value = callbackToggle, types = {"function"}},
        ["callbackSlider"] = {value = callbackSlider, types = {"function"}}
    }) then return end

    if Config[flagToggle] == nil then Config[flagToggle] = false end
    if Config[flagSlider] == nil then Config[flagSlider] = min end
    updateGlobalFlags(flagToggle, Config[flagToggle])
    updateGlobalFlags(flagSlider, Config[flagSlider])
    
    -- 📐 LAYOUT V2: fila de toggle y fila de slider con respiración real entre
    -- ambas (antes quedaban pegadas). Alturas: 34 (toggle) + 1 (divisor) + 24 (slider)
    -- + paddings = 70px. Separadas, pero sin que parezcan dos widgets distintos.
    local TSFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    TSFrame:SetAttribute("ThemeRole", "BG_SECONDARY") TSFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, TSFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, TSFrame)
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = ""}, TSFrame)
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, ToggleButton)
    
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    -- Divisor sutil: marca la separación visual sin abrir un hueco vacío enorme
    local Divider = create("Frame", {Size = UDim2.new(1, -24, 0, 1), Position = UDim2.new(0, 12, 0, 35), BackgroundColor3 = CurrentTheme.BORDER, BackgroundTransparency = 0.55, BorderSizePixel = 0}, TSFrame)

    local SliderContainer = create("Frame", {Size = UDim2.new(1, -24, 0, 22), Position = UDim2.new(0, 12, 0, 42), BackgroundTransparency = 1}, TSFrame)

    -- Caja de valor estilo "textbox" oscura semitransparente, separada del track
    local ValueBoxBg = create("Frame", {Size = UDim2.new(0, 52, 1, 0), Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35}, SliderContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ValueBoxBg)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50), Transparency = 0.3}, ValueBoxBg)
    local ValueBox = create("TextBox", {Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false}, ValueBoxBg)
    ValueBox:SetAttribute("ThemeRole", "TEXT_ACCENT")
    
    local STrack = create("Frame", {Size = UDim2.new(1, -66, 0, 6), Position = UDim2.new(0, 0, 0.5, -3), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, SliderContainer)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, STrack)
    local SFill = create("Frame", {BackgroundColor3 = CurrentTheme.ACCENT}, STrack)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, SFill)
    
    local SKnob = create("TextButton", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false}, STrack)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, SKnob)
    -- 🎯 Hitbox invisible SOLO sobre la bolita: agranda el área táctil sin cambiar
    -- el diseño. El track ya NO inicia arrastre (evita toques involuntarios al
    -- deslizar la UI con el dedo).
    local SKnobHit = create("TextButton", {Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 10}, SKnob)


    local KNOB_ON, KNOB_OFF = UDim2.new(1, -16, 0.5, -7), UDim2.new(0, 2, 0.5, -7)
    local TRACK_OFF = Color3.fromRGB(40, 40, 45)
    local TOGGLE_TWEEN = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function stateUpdate(animate)
        local active = Flags[flagToggle].CurrentValue
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        local trackColor = active and CurrentTheme.ACCENT or TRACK_OFF
        local knobPos = active and KNOB_ON or KNOB_OFF
        if animate then
            TweenService:Create(Track, TOGGLE_TWEEN, {BackgroundColor3 = trackColor}):Play()
            TweenService:Create(Knob, TOGGLE_TWEEN, {Position = knobPos}):Play()
        else
            Track.BackgroundColor3 = trackColor
            Knob.Position = knobPos
        end
    end

    -- Mismo formato flexible que CreateSlider: enteros sin decimales, y hasta 3 cifras en rangos 0-1
    local function formatValue(v)
        if max <= 1 then
            return stringFormat("%.3f", v)
        elseif v % 1 ~= 0 then
            return stringFormat("%.2f", v)
        else
            return tostring(math.floor(v))
        end
    end

    -- ⚡ OPTIMIZACIÓN: durante el arrastre no se guarda config (evita un JSONEncode
    -- por frame) y se descartan valores repetidos, así el callback del usuario no
    -- se dispara decenas de veces con el mismo número.
    local lastValue = nil
    local function runSliderValue(v, skipCallback, deferSave)
        v = mathClamp(v, min, max)
        if lastValue == v and not skipCallback then return end
        local changed = lastValue ~= v
        lastValue = v
        updateGlobalFlags(flagSlider, v) Config[flagSlider] = v
        if not deferSave then saveConfig() end
        if changed then
            local pct = (max == min) and 0 or (v - min) / (max - min)
            SFill.Size = UDim2.new(pct, 0, 1, 0)
            SKnob.Position = UDim2.new(pct, -7, 0.5, -7)
            ValueBox.Text = formatValue(v)
        end
        if not skipCallback then safeCall("callbackSlider", callbackSlider, v) end
    end

    connect(ToggleButton.MouseButton1Click, function()
        local nextState = not Flags[flagToggle].CurrentValue
        updateGlobalFlags(flagToggle, nextState) Config[flagToggle] = nextState saveConfig() playUISound()
        stateUpdate(true) safeCall("callbackToggle", callbackToggle, nextState)
    end)

    connect(ValueBox.FocusLost, function()
        local inputNum = tonumber(ValueBox.Text)
        if not inputNum then
            ValueBox.Text = formatValue(Flags[flagSlider].CurrentValue)
        else
            runSliderValue(inputNum)
        end
    end)

    local sliding = false
    local function snap(input, deferSave)
        local size = STrack.AbsoluteSize.X
        if size <= 0 then return end
        local pct = mathClamp((input.Position.X - STrack.AbsolutePosition.X) / size, 0, 1)
        runSliderValue(min + (pct * (max - min)), false, deferSave)
    end

    local dragConn, endConn
    local activeInput = nil
    local function stopSliding()
        if not sliding then return end
        sliding = false
        activeInput = nil
        if dragConn then dragConn:Disconnect() dragConn = nil end
        if endConn then endConn:Disconnect() endConn = nil end
        saveConfig()
    end

    -- ✋ El arrastre SOLO se inicia tocando la bolita (knob). Tocar el track no
    -- mueve nada, así los scrolls verticales sobre la UI no alteran valores.
    local function beginSliding(input)
        if sliding then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        sliding = true
        activeInput = input
        dragConn = connect(UserInputService.InputChanged, function(changedInput)
            if not sliding then return end
            if changedInput ~= activeInput and changedInput.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput == activeInput then
                snap(changedInput, true)
            end
        end)
        endConn = connect(UserInputService.InputEnded, function(endedInput)
            if endedInput == activeInput or endedInput.UserInputType == Enum.UserInputType.MouseButton1 then
                stopSliding()
            end
        end)
    end

    connect(SKnob.InputBegan, beginSliding)
    connect(SKnobHit.InputBegan, beginSliding)


    table.insert(KillerHub.TargetThemeElements, function()
        SFill.BackgroundColor3 = CurrentTheme.ACCENT
        stateUpdate() runSliderValue(Flags[flagSlider].CurrentValue, true)
    end)

    task.spawn(function()
        stateUpdate() runSliderValue(Flags[flagSlider].CurrentValue, true)
        safeCall("callbackToggle", callbackToggle, Flags[flagToggle].CurrentValue) safeCall("callbackSlider", callbackSlider, Flags[flagSlider].CurrentValue)
    end)

    addInteractiveFeedback(ToggleButton)
    self:RegisterElement(TSFrame, ToggleLabel, self.Frame.Name)
    
    local tsObj = {
        SetToggle = function(_, bool) updateGlobalFlags(flagToggle, bool) Config[flagToggle] = bool saveConfig() stateUpdate(true) safeCall("callbackToggle", callbackToggle, bool) end,
        SetSlider = function(_, value) runSliderValue(value) end,
        -- ➕ Extras de API (aditivos, no rompen nada existente)
        GetToggle = function() return Flags[flagToggle] and Flags[flagToggle].CurrentValue end,
        GetSlider = function() return Flags[flagSlider] and Flags[flagSlider].CurrentValue end,
        SetText = function(_, newText) if type(newText) == "string" then ToggleLabel.Text = newText end end,
        SetVisible = function(_, bool) TSFrame.Visible = bool and true or false end,
        Instance = TSFrame,
        -- 🛑 Ver nota en CreateToggle._ShutdownNotify: mismo mecanismo, aplicado
        -- al flag de encendido/apagado de este widget combinado.
        _ShutdownNotify = function()
            if Flags[flagToggle] and Flags[flagToggle].CurrentValue then
                task.spawn(callbackToggle, false)
            end
        end
    }

    KillerHub.Elements[flagToggle] = tsObj
    return tsObj
end

function TabMethods:CreateSlider(flagName, text, min, max, callback)
    if not SafeAssert("CreateSlider", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["min"] = {value = min, types = {"number"}},
        ["max"] = {value = max, types = {"number"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = min end
    updateGlobalFlags(flagName, Config[flagName])
    
    local SliderFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, Active = true}, self.Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, SliderFrame)

    -- Caja de valor estilo "textbox" oscura semitransparente, separada del track (a un lado)
    local ValueBoxBg = create("Frame", {Size = UDim2.new(0, 54, 0, 20), Position = UDim2.new(1, -2, 0, 22), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35}, SliderFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ValueBoxBg)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50), Transparency = 0.3}, ValueBoxBg)
    local ValueBox = create("TextBox", {Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false}, ValueBoxBg)
    ValueBox:SetAttribute("ThemeRole", "TEXT_ACCENT")

    -- Track más corto (ya no ocupa todo el ancho horizontal) y un poco más grueso
    local Track = create("Frame", {Size = UDim2.new(1, -86, 0, 8), Position = UDim2.new(0, 2, 0, 26), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, SliderFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Track)
    local Fill = create("Frame", {BackgroundColor3 = CurrentTheme.ACCENT}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Fill)
    
    local Knob = create("TextButton", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Knob)
    -- 🎯 Hitbox invisible SOLO sobre la bolita (área táctil cómoda, mismo diseño)
    local KnobHit = create("TextButton", {Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 10}, Knob)

    -- Formato flexible: enteros como 1000 se muestran sin decimales, y los rangos 0-1
    -- (u otros con decimales) muestran hasta 3 cifras, permitiendo escribir 0.0, 0.00 o 0.000
    local function formatValue(v)
        if max <= 1 then
            return stringFormat("%.3f", v)
        elseif v % 1 ~= 0 then
            return stringFormat("%.2f", v)
        else
            return tostring(math.floor(v))
        end
    end

    -- ⚡ Igual que en CreateToggleSlider: sin guardado ni callbacks redundantes
    -- mientras se arrastra, para que el drag sea fluido incluso en móvil.
    local lastValue = nil
    local function runSliderValue(v, skipCallback, deferSave)
        v = mathClamp(v, min, max)
        if lastValue == v and not skipCallback then return end
        local changed = lastValue ~= v
        lastValue = v
        updateGlobalFlags(flagName, v) Config[flagName] = v
        if not deferSave then saveConfig() end
        if changed then
            local pct = (max == min) and 0 or (v - min) / (max - min)
            Fill.Size = UDim2.new(pct, 0, 1, 0) Knob.Position = UDim2.new(pct, -7, 0.5, -7)
            ValueBox.Text = formatValue(v)
        end
        if not skipCallback then safeCall("callback", callback, v) end
    end
    
    connect(ValueBox.FocusLost, function()
        local inputNum = tonumber(ValueBox.Text)
        if not inputNum then
            ValueBox.Text = formatValue(Flags[flagName].CurrentValue)
        else
            runSliderValue(inputNum)
        end
    end)
    
    local sliding = false
    local function snap(input, deferSave)
        local size = Track.AbsoluteSize.X
        if size <= 0 then return end
        local pct = mathClamp((input.Position.X - Track.AbsolutePosition.X) / size, 0, 1)
        runSliderValue(min + (pct * (max - min)), false, deferSave)
    end
    
    local dragConn, endConn
    local activeInput = nil
    local function stopSliding()
        if not sliding then return end
        sliding = false
        activeInput = nil
        if dragConn then dragConn:Disconnect() dragConn = nil end
        if endConn then endConn:Disconnect() endConn = nil end
        saveConfig()
    end

    -- ✋ El arrastre SOLO se inicia tocando la bolita (knob). Tocar el track no
    -- mueve nada, así los scrolls verticales sobre la UI no alteran valores.
    local function beginSliding(input)
        if sliding then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        sliding = true
        activeInput = input
        dragConn = connect(UserInputService.InputChanged, function(changedInput)
            if not sliding then return end
            if changedInput ~= activeInput and changedInput.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput == activeInput then
                snap(changedInput, true)
            end
        end)
        endConn = connect(UserInputService.InputEnded, function(endedInput)
            if endedInput == activeInput or endedInput.UserInputType == Enum.UserInputType.MouseButton1 then
                stopSliding()
            end
        end)
    end

    connect(Knob.InputBegan, beginSliding)
    connect(KnobHit.InputBegan, beginSliding)

    
    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        Fill.BackgroundColor3 = CurrentTheme.ACCENT
        runSliderValue(Flags[flagName].CurrentValue, true)
    end)

    task.spawn(function() runSliderValue(Flags[flagName].CurrentValue, true) safeCall("callback", callback, Flags[flagName].CurrentValue) end)
    self:RegisterElement(SliderFrame, Label, self.Frame.Name)
    
    local sliderObj = {
        Set = function(_, value) runSliderValue(value) end,
        BindToPing = function(self, baseFactor, updateInterval)
            baseFactor = baseFactor or 0.15
            updateInterval = updateInterval or 0.5
            task.spawn(function()
                while task.wait(updateInterval) do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    local ping = 0
                    pcall(function()
                        if Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
                            ping = Stats.Network.ServerToClientPing:GetValue()
                        else
                            ping = LocalPlayer:GetNetworkPing() * 1000
                        end
                    end)
                    local smartValue = ping * baseFactor
                    runSliderValue(smartValue)
                end
            end)
        end,
        -- ➕ Extras de API (aditivos)
        Get = function() return Flags[flagName] and Flags[flagName].CurrentValue end,
        SetText = function(_, newText) if type(newText) == "string" then Label.Text = newText end end,
        SetVisible = function(_, bool) SliderFrame.Visible = bool and true or false end,
        Instance = SliderFrame
    }

    
    KillerHub.Elements[flagName] = sliderObj
    return sliderObj
end

function TabMethods:CreateDropdown(flagName, text, options, callback)
    if not SafeAssert("CreateDropdown", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["options"] = {value = options, types = {"table"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = options[1] or "" end
    updateGlobalFlags(flagName, Config[flagName])
    
    local DDFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    DDFrame:SetAttribute("ThemeRole", "BG_SECONDARY") DDFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, DDFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, DDFrame)
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = ""}, DDFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0.5, -38, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = Flags[flagName].CurrentValue, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, Trigger)
    SelLabel:SetAttribute("ThemeRole", "TEXT_ACCENT")
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11}, Trigger)
    
    local hasSearch = #options > 6
    local searchHeight = hasSearch and 30 or 0
    local SearchBox
    
    if hasSearch then
        SearchBox = create("TextBox", {Size = UDim2.new(1, -16, 0, 24), Position = UDim2.new(0, 8, 0, 36), BackgroundColor3 = Color3.fromRGB(25, 25, 30), Text = "", PlaceholderText = "Filtrar opciones...", PlaceholderColor3 = CurrentTheme.TEXT_MUTED, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false, Visible = false}, DDFrame)
        create("UICorner", {CornerRadius = UDim.new(0, 5)}, SearchBox)
        create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, SearchBox)
    end
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 36 + searchHeight), BackgroundTransparency = 1, ScrollBarThickness = 2}, DDFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local open = false
    
    local function setDropdownOpen(shouldOpen)
        open = shouldOpen
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        if SearchBox then SearchBox.Visible = open if not open then SearchBox.Text = "" end end
        
        TweenService:Create(DDFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36 + targetH + searchHeight + (open and 6 or 0))}):Play()
        TweenService:Create(OptsScroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 180 or 0}):Play()
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    connect(Trigger.MouseButton1Click, function()
        playUISound()
        setDropdownOpen(not open)
    end)
    
    local function selectOption(name)
        updateGlobalFlags(flagName, name) Config[flagName] = name saveConfig() SelLabel.Text = name open = false
        if SearchBox then SearchBox.Text = "" SearchBox.Visible = false end
        TweenService:Create(DDFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
        safeCall("callback", callback, name)
    end

    local function makeOptions()
        for _, child in ipairs(OptsScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for i, name in ipairs(options) do
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 26), BackgroundColor3 = Color3.fromRGB(25, 25, 30), Text = name, TextColor3 = (name == Flags[flagName].CurrentValue) and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 5)}, OptBtn)
            
            connect(OptBtn.MouseButton1Click, function()
                playUISound()
                selectOption(name)
                makeOptions()
            end)
            addInteractiveFeedback(OptBtn)
        end
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    if SearchBox then
        connect(SearchBox:GetPropertyChangedSignal("Text"), function()
            local filter = string.lower(SearchBox.Text)
            for _, child in ipairs(OptsScroll:GetChildren()) do
                if child:IsA("TextButton") then child.Visible = (filter == "") or string.find(string.lower(child.Text), filter) and true or false end
            end
            task.defer(function()
                if not open then return end
                local targetH = math.min(layout.AbsoluteContentSize.Y, 120)
                DDFrame.Size = UDim2.new(1, 0, 0, 36 + targetH + searchHeight + 6)
                OptsScroll.Size = UDim2.new(1, -16, 0, targetH)
                OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
            end)
        end)
    end

    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        Arrow.TextColor3 = CurrentTheme.TEXT_MUTED
        if SearchBox then SearchBox.PlaceholderColor3 = CurrentTheme.TEXT_MUTED SearchBox.TextColor3 = CurrentTheme.TEXT_WHITE end
        makeOptions()
    end)

    makeOptions()
    task.spawn(function() if Flags[flagName].CurrentValue ~= "" then safeCall("callback", callback, Flags[flagName].CurrentValue) end end)

    addInteractiveFeedback(Trigger)
    self:RegisterElement(DDFrame, Label, self.Frame.Name)
    
    local ddObj = {
        Refresh = function(_, newOptions) 
            options = newOptions 
            hasSearch = #options > 6 
            searchHeight = hasSearch and 30 or 0 
            if SearchBox then SearchBox.Visible = open and hasSearch end 
            makeOptions() 
        end,
        BindToDynamicList = function(self, queryFunction, refreshInterval)
            refreshInterval = refreshInterval or 2.0
            task.spawn(function()
                while task.wait(refreshInterval) do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    local success, newList = pcall(queryFunction)
                    if success and type(newList) == "table" then
                        self:Refresh(newList)
                    end
                end
            end)
        end
    }
    
    KillerHub.Elements[flagName] = ddObj
    return ddObj
end

function TabMethods:CreateMultiDropdown(flagName, text, options, callback)
    if not SafeAssert("CreateMultiDropdown", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["options"] = {value = options, types = {"table"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil or type(Config[flagName]) ~= "table" then Config[flagName] = {} end
    updateGlobalFlags(flagName, Config[flagName])
    
    local MFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    MFrame:SetAttribute("ThemeRole", "BG_SECONDARY") MFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MFrame)
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = ""}, MFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0.5, -38, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "...", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, Trigger)
    SelLabel:SetAttribute("ThemeRole", "TEXT_ACCENT")
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11}, Trigger)
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 36), BackgroundTransparency = 1, ScrollBarThickness = 2}, MFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local function updateText()
        local selected = {}
        for _, opt in ipairs(options) do if Config[flagName][opt] then table.insert(selected, opt) end end
        if #selected == 0 then SelLabel.Text = "Ninguno" elseif #selected > 2 then SelLabel.Text = "[" .. tostring(#selected) .. " Seleccionados]" else SelLabel.Text = table.concat(selected, ", ") end
    end

    local open = false
    connect(Trigger.MouseButton1Click, function()
        open = not open playUISound()
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        TweenService:Create(MFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36 + targetH + (open and 6 or 0))}):Play()
        TweenService:Create(OptsScroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 180 or 0}):Play()
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    local cacheButtons = {}
    local function makeList()
        for _, child in ipairs(OptsScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        table.clear(cacheButtons)
        
        for i, name in ipairs(options) do
            local isChosen = Config[flagName][name] or false
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 26), BackgroundColor3 = isChosen and CurrentTheme.BG_MAIN or Color3.fromRGB(25, 25, 30), Text = name, TextColor3 = isChosen and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 5)}, OptBtn)
            cacheButtons[name] = OptBtn
            
            connect(OptBtn.MouseButton1Click, function()
                local nextState = not Config[flagName][name]
                Config[flagName][name] = nextState
                saveConfig() playUISound() updateText()
                updateGlobalFlags(flagName, Config[flagName])
                
                TweenService:Create(OptBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = nextState and CurrentTheme.BG_MAIN or Color3.fromRGB(25, 25, 30),
                    TextColor3 = nextState and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
                }):Play()
                safeCall("callback", callback, Config[flagName])
            end)
            addInteractiveFeedback(OptBtn)
        end
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        makeList()
    end)

    makeList() updateText()
    task.spawn(pcall, callback, Config[flagName])
    addInteractiveFeedback(Trigger)
    self:RegisterElement(MFrame, Label, self.Frame.Name)
    
    local mddObj = {
        GetSelected = function()
            local selected = {}
            for opt, val in pairs(Config[flagName]) do if val then table.insert(selected, opt) end end
            return selected
        end
    }
    KillerHub.Elements[flagName] = mddObj
end

-- ============================================================================
-- 🎨 COLOR PICKERS 2D PREMIUM (HSV / S-V CANVAS + TONO ARCOIRIS)
-- ============================================================================
function TabMethods:CreateToggleColorPicker(flagToggle, flagColor, text, defaultColor, callbackToggle, callbackColor)
    if not SafeAssert("CreateToggleColorPicker", {
        ["flagToggle"] = {value = flagToggle, types = {"string"}},
        ["flagColor"] = {value = flagColor, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["defaultColor"] = {value = defaultColor, types = {"Color3"}},
        ["callbackToggle"] = {value = callbackToggle, types = {"function"}},
        ["callbackColor"] = {value = callbackColor, types = {"function"}}
    }) then return end

    if Config[flagToggle] == nil then Config[flagToggle] = false end
    local savedColor = getSafeColor(flagColor, defaultColor)
    Config[flagColor] = {savedColor.R, savedColor.G, savedColor.B}
    updateGlobalFlags(flagToggle, Config[flagToggle])
    updateGlobalFlags(flagColor, savedColor)

    local CLOSED_H, OPEN_H = 36, 226 -- +1 fila para el toggle de Modo RGB, respecto al panel anterior

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, CLOSED_H), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    MasterFrame:SetAttribute("ThemeRole", "BG_SECONDARY") MasterFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MasterFrame)

    local MainTrigger = create("TextButton", {Size = UDim2.new(1, -80, 0, CLOSED_H), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, MainTrigger)

    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)}, MainTrigger)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 26, 0, 18), Position = UDim2.new(1, -38, 0, 9), BackgroundColor3 = savedColor, Text = ""}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ColorBtn)

    local Panel = BuildColorPickerPanel(MasterFrame, ColorBtn, flagColor, savedColor, 44, function(col)
        task.spawn(function() safeCall("callbackColor", callbackColor, col) end)
    end)

    local function stateUpdate()
        local active = Flags[flagToggle].CurrentValue
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        Label.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        Panel.Sync()
    end

    connect(MainTrigger.MouseButton1Click, function()
        local nextVal = not Flags[flagToggle].CurrentValue
        updateGlobalFlags(flagToggle, nextVal)
        Config[flagToggle] = nextVal saveConfig() playUISound()
        stateUpdate() safeCall("callbackToggle", callbackToggle, nextVal)
    end)

    local open = false
    connect(ColorBtn.MouseButton1Click, function() 
        open = not open playUISound() 
        TweenService:Create(MasterFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, open and OPEN_H or CLOSED_H)}):Play()
        if not open then saveConfig() end -- 💾 Autoguardado explícito al cerrar el menú del color picker
    end)
    
    table.insert(KillerHub.TargetThemeElements, function() stateUpdate() Panel.ApplyTheme() end)
    Panel.RefreshInit()
    task.spawn(function() stateUpdate() safeCall("callbackToggle", callbackToggle, Flags[flagToggle].CurrentValue) safeCall("callbackColor", callbackColor, Flags[flagColor].CurrentValue) end)

    addInteractiveFeedback(MainTrigger) addInteractiveFeedback(ColorBtn)
    self:RegisterElement(MasterFrame, Label, self.Frame.Name)

    local tsObj = {
        SetToggle = function(_, bool)
            updateGlobalFlags(flagToggle, bool) Config[flagToggle] = bool saveConfig() stateUpdate() safeCall("callbackToggle", callbackToggle, bool)
        end,
        SetColor = function(_, newColor) Panel.SetColor(newColor) end,
        -- 🛑 Ver nota en CreateToggle._ShutdownNotify: mismo mecanismo.
        _ShutdownNotify = function()
            if Flags[flagToggle] and Flags[flagToggle].CurrentValue then
                task.spawn(callbackToggle, false)
            end
        end
    }
    KillerHub.Elements[flagToggle] = tsObj
    return tsObj
end

function TabMethods:CreateColorPicker(flagColor, text, defaultColor, callback)
    if not SafeAssert("CreateColorPicker", {
        ["flagColor"] = {value = flagColor, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["defaultColor"] = {value = defaultColor, types = {"Color3"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    local savedColor = getSafeColor(flagColor, defaultColor)
    Config[flagColor] = {savedColor.R, savedColor.G, savedColor.B}
    updateGlobalFlags(flagColor, savedColor)

    local CLOSED_H, OPEN_H = 36, 226 -- +1 fila para el toggle de Modo RGB, respecto al panel anterior

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, CLOSED_H), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    MasterFrame:SetAttribute("ThemeRole", "BG_SECONDARY") MasterFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MasterFrame)

    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, CLOSED_H), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    
    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 30, 0, 18), Position = UDim2.new(1, -42, 0.5, -9), BackgroundColor3 = savedColor, Text = ""}, Trigger)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ColorBtn)

    local Panel = BuildColorPickerPanel(MasterFrame, ColorBtn, flagColor, savedColor, 44, function(col)
        task.spawn(function() safeCall("callback", callback, col) end)
    end)

    local open = false
    connect(ColorBtn.MouseButton1Click, function() 
        open = not open playUISound() 
        TweenService:Create(MasterFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, open and OPEN_H or CLOSED_H)}):Play()
        if not open then saveConfig() end -- 💾 Autoguardado explícito al cerrar el menú del color picker
    end)
    
    table.insert(KillerHub.TargetThemeElements, Panel.ApplyTheme)

    Panel.RefreshInit()
    -- 🩹 FIX: dispara el callback una vez con el color guardado para que el estado
    -- del juego (cielo, luces, etc.) refleje el valor persistido y no se quede en el default.
    -- Solo si el modo arcoíris no está activo (ese ya dispara su propio callback).
    if Config[flagColor .. "_Rainbow"] ~= true then
        task.spawn(function() safeCall("callback", callback, savedColor) end)
    end
    addInteractiveFeedback(Trigger) addInteractiveFeedback(ColorBtn)
    self:RegisterElement(MasterFrame, Label, self.Frame.Name)

    local cpObj = {
        Set = function(_, newColor) Panel.SetColor(newColor) end
    }
    KillerHub.Elements[flagColor] = cpObj
    return cpObj
end

-- ============================================================================
-- 🔓 ELEMENTOS RESTANTES (BOTONES, CONFIG, INPUTS, TECLAS)
-- ============================================================================
function TabMethods:CreateClipboardButton(text, textToCopy)
    if not SafeAssert("CreateClipboardButton", {
        ["text"] = {value = text, types = {"string"}},
        ["textToCopy"] = {value = textToCopy, types = {"string"}}
    }) then return end

    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    Frame:SetAttribute("ThemeRole", "BG_SECONDARY") Frame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Frame)
    
    local Button = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Button)
    local StatusLabel = create("TextLabel", {Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -12, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "Copiar", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right}, Button)
    StatusLabel:SetAttribute("ThemeRole", "TEXT_ACCENT")
    
    local copying = false
    connect(Button.MouseButton1Click, function()
        if copying then return end copying = true playUISound()
        local setClip = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if setClip then pcall(setClip, textToCopy) end
        StatusLabel.Text = "¡Copiado! ✓" StatusLabel.TextColor3 = Color3.fromRGB(40, 235, 40)
        task.delay(1.5, function() StatusLabel.Text = "Copiar" StatusLabel.TextColor3 = CurrentTheme.ACCENT copying = false end)
    end)
    
    table.insert(KillerHub.TargetThemeElements, function() Label.TextColor3 = CurrentTheme.TEXT_WHITE if not copying then StatusLabel.TextColor3 = CurrentTheme.ACCENT end end)
    addInteractiveFeedback(Button)
    self:RegisterElement(Frame, Label, self.Frame.Name)
    return {SetText = function(_, newText) Label.Text = newText end, SetTarget = function(_, newTarget) textToCopy = newTarget end}
end

function TabMethods:CreateInput(flagName, text, placeholder, callback)
    if not SafeAssert("CreateInput", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["placeholder"] = {value = placeholder, types = {"string"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = "" end
    updateGlobalFlags(flagName, Config[flagName])

    local InpFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    InpFrame:SetAttribute("ThemeRole", "BG_SECONDARY") InpFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, InpFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, InpFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, InpFrame)
    local Box = create("TextBox", {Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -12, 0.5, -12), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(25, 25, 30), Text = Flags[flagName].CurrentValue, PlaceholderText = placeholder, PlaceholderColor3 = Color3.fromRGB(100, 105, 115), TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false}, InpFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, Box)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Box)
    
    local history = {}
    local historyIndex = 0
    
    local function evaluateInputText(val)
        if string.sub(val, 1, 1) == "=" then
            local mathExpression = string.sub(val, 2)
            local safeExpression = string.match(mathExpression, "^[%d%.%+%-%*%/%s%(%)]+$")
            if safeExpression then
                local loadFunc, err = loadstring("return " .. safeExpression)
                if loadFunc then
                    local s, res = pcall(loadFunc)
                    if s and tonumber(res) then
                        return tostring(res)
                    end
                end
            end
        end
        return val
    end

    connect(Box.FocusLost, function()
        local rawText = Box.Text
        local processedText = evaluateInputText(rawText)
        Box.Text = processedText
        
        if processedText ~= "" and history[1] ~= processedText then
            table.insert(history, 1, processedText)
            if #history > 8 then table.remove(history, 9) end
        end
        historyIndex = 0

        updateGlobalFlags(flagName, processedText)
        Config[flagName] = processedText 
        saveConfig() 
        safeCall("callback", callback, processedText) 
    end)

    -- 🔧 BANDERA DE FOCUS: reemplaza HasFocus() que no existe en Roblox
    local boxHasFocus = false
    
    connect(Box.Focused, function()
        boxHasFocus = true
    end)
    
    connect(Box.FocusLost, function()
        boxHasFocus = false
    end)

    connect(UserInputService.InputBegan, function(input)
        if boxHasFocus then
            if input.KeyCode == Enum.KeyCode.Up then
                if historyIndex < #history then
                    historyIndex = historyIndex + 1
                    Box.Text = history[historyIndex]
                end
            elseif input.KeyCode == Enum.KeyCode.Down then
                if historyIndex > 1 then
                    historyIndex = historyIndex - 1
                    Box.Text = history[historyIndex]
                elseif historyIndex == 1 then
                    historyIndex = 0
                    Box.Text = ""
                end
            end
        end
    end)

    task.spawn(pcall, callback, Flags[flagName].CurrentValue)
    self:RegisterElement(InpFrame, Label, self.Frame.Name)
    
    local inputObj = {
        Set = function(_, val) 
            Box.Text = val 
            updateGlobalFlags(flagName, val)
            Config[flagName] = val 
            saveConfig() 
            safeCall("callback", callback, val) 
        end,
        GetHistory = function() return history end
    }
    KillerHub.Elements[flagName] = inputObj
    return inputObj
end

function TabMethods:CreateButton(text, callback)
    if not SafeAssert("CreateButton", {
        ["text"] = {value = text, types = {"string"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    local Button = create("TextButton", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.3, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamBold, TextSize = 12}, self.Frame)
    Button:SetAttribute("ThemeRole", "BG_SECONDARY") Button:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Button)
    create("UIPadding", {PaddingLeft = UDim.new(0, 48), PaddingRight = UDim.new(0, 48)}, Button)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Button)
    
    connect(Button.MouseButton1Click, function() playUISound() safeCall("callback", callback) end)
    addInteractiveFeedback(Button)
    self:RegisterElement(Button, Button, self.Frame.Name)
    
    local btnObj = {
        Fire = function() safeCall("callback", callback) end
    }
    KillerHub.Elements[text] = btnObj
    if KillerHub._AttachShortcut then
        KillerHub._AttachShortcut(Button, {
            id = "button::" .. text,
            kind = "button",
            name = text,
            fire = function() safeCall("callback", callback) end,
            getState = function() return nil end,
        })
    end
    return btnObj
end

-- Registro global de keybinds activos → detección de conflictos
KillerHub._Keybinds = KillerHub._Keybinds or {}

function TabMethods:CreateKeybind(flagName, text, defaultKey, callback)
    if not SafeAssert("CreateKeybind", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["defaultKey"] = {value = defaultKey, types = {"EnumItem"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = defaultKey.Name end
    updateGlobalFlags(flagName, Config[flagName])
    KillerHub._Keybinds[flagName] = { key = Config[flagName], text = text }

    local KFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    KFrame:SetAttribute("ThemeRole", "BG_SECONDARY") KFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, KFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, KFrame)
    
    local Lbl = create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, KFrame)
    local BBtn = create("TextButton", {Size = UDim2.new(0, 85, 0, 24), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Text = Config[flagName], TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11}, KFrame)
    BBtn:SetAttribute("ThemeRole", "TEXT_ACCENT")
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, BBtn)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, BBtn)
    
    local listening = false
    connect(BBtn.MouseButton1Click, function() listening = true BBtn.Text = "..." playUISound() end)
    
    connect(UserInputService.InputBegan, function(input, gp)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                local newKey = input.KeyCode.Name
                -- 🚨 Validar conflicto
                local conflict
                for otherFlag, info in pairs(KillerHub._Keybinds) do
                    if otherFlag ~= flagName and info.key == newKey then conflict = info break end
                end
                if conflict then
                    pcall(function()
                        KillerHub:Notify("Tecla en uso",
                            string.format("'%s' ya está asignada a: %s", newKey, conflict.text),
                            4, "warn")
                    end)
                    BBtn.Text = Config[flagName]
                    return
                end
                Config[flagName] = newKey
                KillerHub._Keybinds[flagName].key = newKey
                updateGlobalFlags(flagName, newKey)
                saveConfig() BBtn.Text = newKey safeCall("callback", callback, input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 or input.KeyCode == Enum.KeyCode.ButtonX or input.KeyCode == Enum.KeyCode.ButtonY then
                listening = false Config[flagName] = input.UserInputType.Name 
                updateGlobalFlags(flagName, input.UserInputType.Name)
                saveConfig() BBtn.Text = input.UserInputType.Name safeCall("callback", callback, input.UserInputType)
            end
        end
    end)

    task.spawn(function()
        local key = Enum.KeyCode[Flags[flagName].CurrentValue] or Enum.UserInputType[Flags[flagName].CurrentValue]
        if key then safeCall("callback", callback, key) end
    end)

    addInteractiveFeedback(BBtn)
    self:RegisterElement(KFrame, Lbl, self.Frame.Name)
end

function KillerHub:CreateTab(name, iconId, opts)
    if not SafeAssert("CreateTab", {
        ["name"] = {value = name, types = {"string"}},
        ["iconId"] = {value = iconId, types = {"string", "nil"}},
        ["opts"] = {value = opts, types = {"table", "nil"}}
    }) then return end
    -- opts.parent (Instance) permite anidar la pestaña dentro de un grupo colapsable (ver CreateTabGroup)
    local parentContainer = (opts and opts.parent) or SidebarTabsContainer

    local frame = create("ScrollingFrame", {Name = name .. "Frame", Size = UDim2.new(1, -14, 1, -13), Position = UDim2.new(0, 7, 0, 6), BackgroundColor3 = CurrentTheme.BG_MAIN, BackgroundTransparency = 0.5, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = CurrentTheme.ACCENT}, ContentContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, frame)
    local stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, frame)
    
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}, frame)
    create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8)}, frame)
    
    local sizeChangedConn = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) 
    end)
    table.insert(Connections, sizeChangedConn)

    local btn = create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.ACCENT, BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, (name == "Settings" and SettingsContainer or parentContainer))
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, btn)
    -- Resolvemos el icono: acepta nombre ("Gun"), ID plano ("14939026710") o rbxassetid completo
    local resolvedIcon = resolveIcon(iconId)
    local hasIcon = resolvedIcon ~= nil
    local btnLabel = create("TextLabel", {Size = UDim2.new(1, hasIcon and -38 or -12, 1, 0), Position = UDim2.new(0, hasIcon and 34 or 12, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left}, btn)
    pcall(function() btnLabel.TextStrokeTransparency = 1 end)

    local iconImg
    if hasIcon then iconImg = create("ImageLabel", {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8, 0.5, -9), BackgroundTransparency = 1, Image = resolvedIcon, ImageColor3 = CurrentTheme.TEXT_MUTED, ScaleType = Enum.ScaleType.Fit}, btn) end

    local line = create("Frame", {Name = "IndicatorLine", Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, -2, 0.5, -8), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0, BackgroundTransparency = 1}, btn)
    create("UICorner", {CornerRadius = UDim.new(0, 2)}, line)
    
    local isFirstTab = true for _, _ in pairs(KillerHub.Frames) do isFirstTab = false break end
    KillerHub.Frames[name] = frame KillerHub.Buttons[name] = btn
    -- Se guarda la referencia una sola vez (en vez de FindFirstChild en cada click de pestaña):
    -- más rápido y sin buscar en el árbol de instancias cada vez que se cambia de pestaña
    KillerHub.TabRegistry[name] = {Frame = frame, Btn = btn, Label = btnLabel, Icon = iconImg, Line = line}

    local function selectTab()
        for tName, reg in pairs(KillerHub.TabRegistry) do
            local isSel = (tName == name)
            reg.Frame.Visible = isSel
            reg.Label.TextColor3 = isSel and CurrentTheme.ACCENT or CurrentTheme.TEXT_MUTED
            reg.Line.BackgroundTransparency = isSel and 0 or 1
            if reg.Icon then reg.Icon.ImageColor3 = isSel and CurrentTheme.ACCENT or CurrentTheme.TEXT_MUTED end
            -- Fondo del botón: color del tema pero MUY transparente → distingue la pestaña
            -- seleccionada sin verse pesado ni tapar el texto
            if reg.Btn then
                reg.Btn.BackgroundColor3 = CurrentTheme.ACCENT
                TweenService:Create(reg.Btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = isSel and 0.82 or 1
                }):Play()
            end
        end
        KillerHub.CurrentTab = name
    end
    connect(btn.MouseButton1Click, function() if KillerHub.CurrentTab ~= name then selectTab() playUISound() end end)
    if isFirstTab or name == "Settings" then task.spawn(selectTab) end
    
    table.insert(KillerHub.TargetThemeElements, function()
        frame.BackgroundColor3 = CurrentTheme.BG_MAIN
        stroke.Color = CurrentTheme.BORDER
        line.BackgroundColor3 = CurrentTheme.ACCENT
        btn.BackgroundColor3 = CurrentTheme.ACCENT
        local isSel = (KillerHub.CurrentTab == name)
        btn.BackgroundTransparency = isSel and 0.82 or 1
        btnLabel.TextColor3 = isSel and CurrentTheme.ACCENT or CurrentTheme.TEXT_MUTED
        if iconImg then iconImg.ImageColor3 = isSel and CurrentTheme.ACCENT or CurrentTheme.TEXT_MUTED end
        btnLabel.Font = Enum.Font[Config.SelectedFont or "GothamMedium"] or Enum.Font.GothamBold
    end)

    -- Actualizar contador de pestañas (excluye Settings)
    if name ~= "Settings" and TabsHeaderCount then
        local n = 0
        for tn, _ in pairs(KillerHub.TabRegistry) do if tn ~= "Settings" then n = n + 1 end end
        TabsHeaderCount.Text = tostring(n)
        TabsHeaderCount.TextColor3 = CurrentTheme.ACCENT
    end

    local tabObj = setmetatable({ Frame = frame }, TabMethods)
    KillerHub.Tabs[name] = tabObj return tabObj
end

-- ============================================================================
-- 🗂️  CreateTabGroup: pestaña "carpeta" que agrupa varias sub-pestañas
--    Se distingue con una flecha ▾ a la derecha; al abrirse rota a ▴ (180°).
--    Las hijas se crean con group:CreateTab(name, iconId) y se muestran
--    debajo, con un ligero sangrado, ahorrando espacio en la sidebar.
-- ============================================================================
function KillerHub:CreateTabGroup(name, iconId)
    if not SafeAssert("CreateTabGroup", {
        ["name"] = {value = name, types = {"string"}},
        ["iconId"] = {value = iconId, types = {"string", "nil"}}
    }) then return end

    -- Contenedor del grupo (auto-size): apila el botón cabecera + contenedor de hijas
    local groupFrame = create("Frame", {
        Name = name .. "Group", Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1
    }, SidebarTabsContainer)
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, groupFrame)

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.ACCENT,
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1
    }, groupFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, btn)
    local resolvedIcon = resolveIcon(iconId)
    local hasIcon = resolvedIcon ~= nil
    local btnLabel = create("TextLabel", {
        Size = UDim2.new(1, hasIcon and -54 or -32, 1, 0),
        Position = UDim2.new(0, hasIcon and 34 or 12, 0, 0),
        BackgroundTransparency = 1, Text = name, TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left
    }, btn)
    pcall(function() btnLabel.TextStrokeTransparency = 1 end)

    local iconImg
    if hasIcon then
        iconImg = create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 8, 0.5, -9),
            BackgroundTransparency = 1, Image = resolvedIcon, ImageColor3 = CurrentTheme.TEXT_MUTED,
            ScaleType = Enum.ScaleType.Fit
        }, btn)
    end


    -- Chevron: ▼ cerrado, rota 180° cuando se abre (efecto ^). Usamos "▼"
    -- (mismo glifo que los dropdown y multi-dropdown ya existentes) porque
    -- "▾" no renderiza en algunas fuentes/executors y salía como cuadrito.
    local chevron = create("TextLabel", {
        Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -22, 0.5, -9),
        BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamBold, TextSize = 11, Rotation = 0
    }, btn)

    -- Contenedor de sub-pestañas, con leve sangrado izquierdo y auto-size
    local childrenContainer = create("Frame", {
        Name = "Children", Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        LayoutOrder = 2, Visible = false, ClipsDescendants = true
    }, groupFrame)
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, childrenContainer)
    create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2)}, childrenContainer)

    local open = false
    local function applyVisual()
        btn.BackgroundColor3 = CurrentTheme.ACCENT
        TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = open and 0.88 or 1}):Play()
        local col = open and CurrentTheme.ACCENT or CurrentTheme.TEXT_MUTED
        btnLabel.TextColor3 = col
        chevron.TextColor3 = col
        if iconImg then iconImg.ImageColor3 = col end
    end

    local function toggle()
        open = not open
        childrenContainer.Visible = open
        TweenService:Create(chevron, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Rotation = open and 180 or 0}):Play()
        applyVisual()
    end
    connect(btn.MouseButton1Click, function() toggle() playUISound() end)
    connect(btn.MouseEnter, function()
        if not open then
            btnLabel.TextColor3 = CurrentTheme.TEXT_WHITE
            chevron.TextColor3 = CurrentTheme.TEXT_WHITE
        end
    end)
    connect(btn.MouseLeave, function()
        if not open then
            btnLabel.TextColor3 = CurrentTheme.TEXT_MUTED
            chevron.TextColor3 = CurrentTheme.TEXT_MUTED
        end
    end)

    table.insert(KillerHub.TargetThemeElements, function()
        applyVisual()
        btnLabel.Font = Enum.Font[Config.SelectedFont or "GothamMedium"] or Enum.Font.GothamBold
    end)

    local group = {}
    function group:CreateTab(subName, subIcon)
        local child = KillerHub:CreateTab(subName, subIcon, {parent = childrenContainer})
        -- 🩹 Si esta sub-pestaña resultó ser la seleccionada por defecto (caso:
        -- es la primerísima pestaña creada en todo el hub), su contenido queda
        -- visible pero su botón vive dentro de un grupo colapsado — el usuario
        -- vería la pestaña activa sin poder ubicar ni volver a su botón. Se
        -- abre el grupo automáticamente para evitar ese estado confuso.
        if child and child.Frame and child.Frame.Visible and not open then
            toggle()
        end
        return child
    end
    function group:Toggle() toggle() end
    function group:SetOpen(v)
        if (not not v) ~= open then toggle() end
    end
    return group
end


local searchThread
-- 🆕 Filtro global en tiempo real, limitado a la pestaña activa para que la búsqueda
-- sea instantánea incluso con cientos de widgets. Debounce con task.defer + task.wait.
connect(SearchInput:GetPropertyChangedSignal("Text"), function()
    if searchThread then task.cancel(searchThread) end
    searchThread = task.defer(function()
        task.wait(0.08)
        local q = string.lower(SearchInput.Text or "")
        local currentTabFrameName = KillerHub.CurrentTab and (KillerHub.CurrentTab .. "Frame") or nil
        local processed = 0
        for _, el in pairs(KillerHub.AllElements) do
            if el.Instance and el.Label and el.Instance.Parent then
                local sameTab = (el.Tab == currentTabFrameName) or (el.Tab == KillerHub.CurrentTab)
                if not sameTab then
                    -- fuera de la pestaña activa: no ocultar, se mantiene su Visible natural
                else
                    local labelText = string.lower(el.Label.Text or "")
                    el.Instance.Visible = (q == "") or (string.find(labelText, q, 1, true) ~= nil)
                end
            end
            processed = processed + 1
            if processed % 30 == 0 then task.wait() end
        end
    end)
end)

-- ============================================================================
-- 🆕 SHORTCUT MANAGER: botones flotantes proyectados desde toggles/buttons
--    - Activador ↖ ubicado al extremo izquierdo (separado del interruptor)
--    - Multi-touch seguro: cada shortcut trackea su propio InputObject al arrastrar
--    - Modal centrado con preview en vivo, formas (Circle/Square/Rounded),
--      sliders de tamaño y opacidad, y toggle de Lock Position.
--    - Config persistente por PlaceId (usa el mismo saveConfig del hub).
-- ============================================================================
Config.Shortcuts = Config.Shortcuts or {}

-- ============================================================================
-- 🎯 CONFIGURACIÓN DEL ÍCONO DEL CUADRITO DE SHORTCUTS  ← EDITA AQUÍ
-- ----------------------------------------------------------------------------
-- Si quieres usar una IMAGEN de Roblox (asset id), pon el id como string en
-- SHORTCUT_ICON_IMAGE. Ejemplo:
--     local SHORTCUT_ICON_IMAGE = "rbxassetid://7734053426"
-- La imagen se auto-ajusta al cuadrito (padding interno) para que NO se salga.
--
-- Si SHORTCUT_ICON_IMAGE está vacío (""), se usa el TEXTO de SHORTCUT_ICON_TEXT.
-- Prueba caracteres seguros en Roblox (todos los siguientes renderizan bien):
--     "↖"  "↗"  "⬈"  "⤢"  "◤"  "◰"  "⌘"  "★"  "＋"  "SC"  "S"
-- Evita flechas "heavy" del bloque U+1F800 (🡔 🡕 …), muchas veces salen ▯▯.
-- ============================================================================
local SHORTCUT_ICON_IMAGE = "rbxassetid://135958512425125"      -- ej: "rbxassetid://7072706796"
local SHORTCUT_ICON_TEXT  = ""     -- se usa solo si SHORTCUT_ICON_IMAGE == ""

-- Colores de "activo" para el activador; en temas cuyo ACCENT es prácticamente
-- blanco, se usa un color distintivo para que se note el estado ON.
local ShortcutAccentOverrides = {
    ["Obsidian"] = { fill = Color3.fromRGB(88, 30, 168), glyph = Color3.fromRGB(15, 5, 25) },
    ["Classic Dark"] = { fill = Color3.fromRGB(215, 45, 55), glyph = Color3.fromRGB(255, 255, 255) },
}
local function getShortcutAccent()
    local ov = ShortcutAccentOverrides[Config.SelectedTheme]
    if ov then return ov.fill, ov.glyph end
    return CurrentTheme.ACCENT, CurrentTheme.TEXT_WHITE
end

-- Contenedor global de los botones flotantes; vive en su propio ScreenGui con
-- DisplayOrder menor que el hub para que queden SIEMPRE debajo del menú y así
-- no tapen opciones ni se puedan presionar accidentalmente al usar la UI.
local ShortcutScreen = create("ScreenGui", {
    Name = "KillerHub_Shortcuts",
    IgnoreGuiInset = false,
    ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
    ResetOnSpawn = false,
    DisplayOrder = 999990, -- menor que el ScreenGui principal (999999)
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, TargetParent)
local ShortcutLayer = create("Frame", {
    Name = "ShortcutLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 1
}, ShortcutScreen)

-- 🔤 Caché de la fuente activa: evita resolver Enum.Font en cada refresco de
-- cada shortcut (se invalida sola cuando cambia Config.SelectedFont).
local _fontCacheName, _fontCacheEnum = nil, Enum.Font.GothamMedium
local function currentFontEnum()
    local name = Config.SelectedFont or "GothamMedium"
    if name ~= _fontCacheName then
        _fontCacheName = name
        _fontCacheEnum = Enum.Font[name] or Enum.Font.GothamMedium
    end
    return _fontCacheEnum
end

local Shortcuts = {}          -- id -> { data, cfg, floating instances }
local ShortcutActivators = {} -- id -> { btn, stroke, glyph, refresh }

local function saveShortcuts()
    saveConfig()
end

local function defaultCfg()
    -- x/y = -1 → aún sin posición asignada; se calcula automáticamente al activar
    return { shape = "square", size = 48, opacity = 0.85, lock = false, x = -1, y = -1, active = false, userMoved = false }
end

-- 🧭 Grid automático: reparte shortcuts arriba de la pantalla en filas, evitando
-- que se amontonen cuando el usuario activa varios sin arrastrarlos.
local function nextShortcutSlot(cfg)
    local vp = Camera and Camera.ViewportSize or Vector2.new(800, 600)
    local marginTop = 90
    local marginSide = 14
    local gap = 8
    local w = (cfg.shape == "rounded") and math.floor(cfg.size * 2.2) or cfg.size
    local h = cfg.size
    local usableW = math.max(w + gap, vp.X - marginSide * 2)
    local perRow = math.max(1, math.floor(usableW / (w + gap)))
    local placed = 0
    for _, other in pairs(Shortcuts) do
        if other.cfg and other.cfg.active and not other.cfg.userMoved then
            placed = placed + 1
        end
    end
    local col = placed % perRow
    local row = math.floor(placed / perRow)
    local x = marginSide + col * (w + gap)
    local y = marginTop + row * (h + gap)
    return x, y
end

local function ensureCfg(id)
    local c = Config.Shortcuts[id]
    if type(c) ~= "table" then c = defaultCfg() Config.Shortcuts[id] = c end
    for k, v in pairs(defaultCfg()) do if c[k] == nil then c[k] = v end end
    return c
end

local function applyShape(instance, shape)
    local corner = instance:FindFirstChildOfClass("UICorner") or create("UICorner", {}, instance)
    if shape == "circle" then
        corner.CornerRadius = UDim.new(1, 0)
    elseif shape == "rounded" then
        corner.CornerRadius = UDim.new(0, 8)
    else
        corner.CornerRadius = UDim.new(0, 12)
    end
end

local function computeSize(cfg)
    if cfg.shape == "rounded" then
        return UDim2.new(0, math.floor(cfg.size * 2.2), 0, cfg.size)
    end
    return UDim2.new(0, cfg.size, 0, cfg.size)
end

-- 📐 Preview del modal: escala la forma para que NUNCA se salga del recuadro
-- de vista previa (antes la forma "rectangular" con tamaño alto se desbordaba
-- por los costados). Sólo afecta al ModalPreviewFrame, no al shortcut real.
local PREVIEW_MAX_W, PREVIEW_MAX_H = 120, 84
local function computePreviewSize(cfg)
    local w, h
    if cfg.shape == "rounded" then
        w, h = cfg.size * 2.2, cfg.size
    else
        w, h = cfg.size, cfg.size
    end
    local scale = math.min(PREVIEW_MAX_W / w, PREVIEW_MAX_H / h, 1)
    return UDim2.new(0, math.floor(w * scale), 0, math.floor(h * scale))
end

local function buildLabel(sc)
    if sc.data.kind == "toggle" then
        local state = sc.data.getState()
        return string.format("%s: %s", sc.data.name, state and "ON" or "OFF")
    end
    return sc.data.name
end

local function refreshShortcutVisual(sc)
    if not sc.frame then return end
    sc.frame.Size = computeSize(sc.cfg)
    sc.frame.BackgroundTransparency = 1 - sc.cfg.opacity
    applyShape(sc.frame, sc.cfg.shape)
    -- Borde neutro suave (no del color del tema): más limpio y legible con cualquier fuente
    if sc.stroke then sc.stroke.Color = CurrentTheme.BORDER sc.stroke.Thickness = 1.2 sc.stroke.Transparency = 0 end
    if sc.label then
        sc.label.Text = buildLabel(sc)
        sc.label.TextColor3 = (sc.data.kind == "toggle" and sc.data.getState()) and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        -- Ligeramente más pequeño para que el texto entre completo en el cuadrito
        sc.label.TextSize = math.clamp(math.floor(sc.cfg.size * 0.24), 8, 14)
        sc.label.Font = currentFontEnum()
        pcall(function() sc.label.TextStrokeTransparency = 1 end)
    end
    if sc.accentBar then
        sc.accentBar.BackgroundColor3 = (sc.data.kind == "toggle" and sc.data.getState()) and CurrentTheme.ACCENT or Color3.fromRGB(60, 60, 65)
    end
end

local function destroyShortcut(id)
    local sc = Shortcuts[id]
    if not sc then return end
    if sc.frame then pcall(function() sc.frame:Destroy() end) end
    Shortcuts[id] = nil
end

local function createFloating(sc)
    local cfg = sc.cfg
    -- Si nunca se movió (o no tiene coords válidas), colocar en grid superior
    -- Solo autoubicar en grid si la posición guardada no es válida (nunca colocado)
    -- o si aún no se movió y el auto-arrange está activo. Al re-activar tras dragging,
    -- cfg.x/cfg.y y userMoved persisten → conserva la posición del usuario.
    local needsAutoPos = ((cfg.x or -1) < 0) or ((cfg.y or -1) < 0)
    if needsAutoPos or ((Config.AutoArrangeShortcuts ~= false) and (not cfg.userMoved)) then
        local nx, ny = nextShortcutSlot(cfg)
        cfg.x, cfg.y = nx, ny
    end
    local fontEnum = currentFontEnum()
    local frame = create("TextButton", {
        Name = "Shortcut_" .. sc.data.id,
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = CurrentTheme.BG_MAIN,
        BackgroundTransparency = 1 - cfg.opacity,
        Size = computeSize(cfg),
        Position = UDim2.new(0, cfg.x, 0, cfg.y),
        Active = true,
        ZIndex = 11
    }, ShortcutLayer)
    applyShape(frame, cfg.shape)
    -- Borde sutil, no del color del tema (evita el "outline llamativo")
    local stroke = create("UIStroke", {Thickness = 1.2, Color = CurrentTheme.BORDER, Transparency = 0}, frame)
    local accentBar = create("Frame", {Size = UDim2.new(1, -14, 0, 2), Position = UDim2.new(0, 7, 1, -6), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0}, frame)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, accentBar)
    local label = create("TextLabel", {
        Size = UDim2.new(1, -8, 1, -14),
        Position = UDim2.new(0, 4, 0, 2),
        BackgroundTransparency = 1,
        Text = buildLabel(sc),
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = fontEnum,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center
    }, frame)
    -- Micro animación al aparecer
    if Config.MenuAnimEnabled ~= false then
        local scaleFx = Instance.new("UIScale"); scaleFx.Scale = 0.85; scaleFx.Parent = frame
        TweenService:Create(scaleFx, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        task.delay(0.28, function() if scaleFx then scaleFx:Destroy() end end)
    end

    sc.frame, sc.stroke, sc.label, sc.accentBar = frame, stroke, label, accentBar

    -- Drag multi-touch aislado: cada shortcut recuerda su propio input y lo
    -- ignora todo lo demás → mover cámara / caminar con otro dedo no interfiere
    local dragging, activeInput, startPos, startFramePos
    local dragMoved = false
    local dragStartTime = 0
    local moveConn, endConn

    connect(frame.InputBegan, function(input)
        if dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragMoved = false
        activeInput = input
        startPos = input.Position
        startFramePos = frame.Position
        dragStartTime = os.clock()

        moveConn = connect(UserInputService.InputChanged, function(changedInput)
            if not dragging or changedInput ~= activeInput then return end
            -- 🩹 Fix #4: filtra el tipo de input — solo nos interesa el movimiento
            -- real del mouse/dedo; ignora gamepad, scroll wheel, etc. que también
            -- disparan InputChanged y no deberían procesarse en cada frame.
            if changedInput.UserInputType ~= Enum.UserInputType.MouseMovement and changedInput.UserInputType ~= Enum.UserInputType.Touch then return end

            local delta = changedInput.Position - startPos
            -- 🩹 Fix #2: umbral de tap subido a 5px (antes 3px) — absorbe el
            -- micro-jitter táctil que a veces cancelaba clicks legítimos o los
            -- convertía en drag sin querer.
            if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then dragMoved = true end

            -- 🩹 Fix #1 (bug principal): antes este `return` ocurría ANTES de
            -- actualizar dragMoved cuando lock estaba activo -> deslizar el dedo
            -- sobre un botón bloqueado se registraba como "sin movimiento" y al
            -- soltar, InputEnded lo interpretaba como tap y disparaba la acción.
            -- Ahora dragMoved ya quedó actualizado arriba; acá solo evitamos
            -- reposicionar el frame si está lockeado.
            if sc.cfg.lock then return end

            local vp = Camera.ViewportSize
            local sz = frame.AbsoluteSize
            local newX = math.clamp(startFramePos.X.Offset + delta.X, 0, vp.X - sz.X)
            local newY = math.clamp(startFramePos.Y.Offset + delta.Y, 0, vp.Y - sz.Y)
            -- 🩹 Fix #3: guardia anti-jitter de render — solo tocar frame.Position
            -- cuando el valor realmente cambia tras el clamp. Menos churn de
            -- layout ⇒ menos tironcitos visuales en móvil.
            local curPos = frame.Position
            if curPos.X.Offset ~= newX or curPos.Y.Offset ~= newY then
                frame.Position = UDim2.new(0, newX, 0, newY)
            end
        end)
        endConn = connect(UserInputService.InputEnded, function(endedInput)
            if endedInput ~= activeInput then return end
            dragging = false
            activeInput = nil
            if moveConn then moveConn:Disconnect() moveConn = nil end
            -- 🩹 Fix #6: anular endConn tras desconectar (higiene, evita referencias
            -- colgantes si en algún flujo se reutiliza la variable).
            if endConn then endConn:Disconnect() endConn = nil end

            -- 🩹 Fix #5: duración máxima de tap (0.6s). Si mantuviste el dedo quieto
            -- mucho rato sobre el botón y sueltas, ya no cuenta como click accidental
            -- — un tap real dura menos de 0.6s.
            local heldTooLong = (os.clock() - dragStartTime) > 0.6

            if dragMoved and not sc.cfg.lock then
                sc.cfg.x = frame.Position.X.Offset
                sc.cfg.y = frame.Position.Y.Offset
                sc.cfg.userMoved = true
                saveShortcuts()
            elseif not dragMoved and not heldTooLong then
                -- Click limpio: dispara la acción (con sonido UI del hub)
                playUISound()
                pcall(sc.data.fire)
                refreshShortcutVisual(sc)
            end
        end)
    end)
end

local function setShortcutActive(sc, active)
    sc.cfg.active = active
    if active then
        if not sc.frame then createFloating(sc) end
        refreshShortcutVisual(sc)
    else
        if sc.frame then pcall(function() sc.frame:Destroy() end) end
        sc.frame, sc.stroke, sc.label, sc.accentBar = nil, nil, nil, nil
    end
    if ShortcutActivators[sc.data.id] and ShortcutActivators[sc.data.id].refresh then
        ShortcutActivators[sc.data.id].refresh()
    end
    saveShortcuts()
end

-- --------------------------------------------------------------------
-- MODAL DE CONFIGURACIÓN CENTRADO
-- --------------------------------------------------------------------
local ConfigModal, ModalBody, ModalTitle, ModalPreview, ModalPreviewFrame
local ModalShapeBtns, ModalSizeSlider, ModalOpacitySlider, ModalLockTrack, ModalLockKnob, ModalLockLabel
local ModalActionBtn, ModalActionStroke
local currentModalSc = nil

-- 🧹 API pública para limpiar TODOS los shortcuts activos (usada por el
-- botón "Remover todos los shortcuts" en Settings). No cambia la API
-- pública existente: sólo agrega el método KillerHub:ClearAllShortcuts().
function KillerHub:ClearAllShortcuts()
    local removed = 0
    for id, sc in pairs(Shortcuts) do
        if sc and sc.cfg and sc.cfg.active then
            pcall(setShortcutActive, sc, false)
            removed = removed + 1
        end
    end
    -- Higiene: cualquier config huérfana en disco (de scripts anteriores)
    -- también queda marcada como inactiva para que no reaparezcan al recargar.
    if type(Config.Shortcuts) == "table" then
        for id, c in pairs(Config.Shortcuts) do
            if type(c) == "table" then c.active = false end
        end
    end
    pcall(saveShortcuts)
    if self and self.Notify then
        if removed > 0 then
            self:Notify("Shortcuts removidos", removed .. " shortcut(s) fueron eliminados de la pantalla.", 4)
        else
            self:Notify("Sin shortcuts", "No había shortcuts activos para remover.", 3)
        end
    end
    return removed
end

-- 🔁 Refresco global de los botones flotantes: se llama desde SetFont/SetTheme
-- para que la fuente y el borde del tema cambien EN VIVO (antes había que
-- apagar y encender el shortcut para que se aplicaran).
function KillerHub._RefreshShortcuts()
    for _, sc in pairs(Shortcuts) do
        if sc.frame then pcall(refreshShortcutVisual, sc) end
    end
    local fontEnum = currentFontEnum()
    for _, act in pairs(ShortcutActivators) do
        if act.btn and act.btn.Parent then pcall(function() act.btn.Font = fontEnum end) end
    end
    if ConfigModal then
        for _, v in ipairs(ConfigModal:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then v.Font = fontEnum end
        end
    end
end

local function buildModal()
    if ConfigModal then return end
    ConfigModal = create("Frame", {
        Name = "ShortcutConfigModal",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 520, 0, 340),
        BackgroundColor3 = CurrentTheme.BG_MAIN,
        BackgroundTransparency = 0.05,
        Visible = false,
        ZIndex = 50,
        Active = true
    }, ScreenGui)
    create("UICorner", {CornerRadius = UDim.new(0, 12)}, ConfigModal)
    create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER}, ConfigModal)

    -- Backdrop clickable para cerrar
    local backdrop = create("TextButton", {
        Name = "ShortcutBackdrop",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.55,
        Text = "",
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 49
    }, ScreenGui)
    connect(backdrop.MouseButton1Click, function()
        playUISound()
        ConfigModal.Visible = false
        backdrop.Visible = false
        currentModalSc = nil
    end)
    ConfigModal:SetAttribute("BackdropName", backdrop.Name)

    ModalTitle = create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 30),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundTransparency = 1,
        Text = "Shortcut",
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51
    }, ConfigModal)

    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -34, 0, 12),
        BackgroundColor3 = Color3.fromRGB(28, 28, 32),
        Text = "×",
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 51
    }, ConfigModal)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, closeBtn)
    connect(closeBtn.MouseButton1Click, function()
        playUISound()
        ConfigModal.Visible = false
        backdrop.Visible = false
        currentModalSc = nil
    end)

    -- Preview izquierdo
    local previewCol = create("Frame", {
        Size = UDim2.new(0, 170, 1, -60),
        Position = UDim2.new(0, 16, 0, 50),
        BackgroundColor3 = Color3.fromRGB(14, 14, 18),
        BackgroundTransparency = 0.25,
        ZIndex = 51
    }, ConfigModal)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, previewCol)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, previewCol)

    create("TextLabel", {Size = UDim2.new(1, -12, 0, 18), Position = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1, Text = "Vista previa", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52}, previewCol)

    ModalPreview = previewCol

    -- 🧹 Underlay eliminado a pedido del usuario: antes había un cuadro con
    -- degradado claro detrás del preview para evidenciar la opacidad. Ya
    -- no se dibuja — el preview queda flotando sobre el fondo del modal.

    ModalPreviewFrame = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.55, 0),
        Size = UDim2.new(0, 60, 0, 60),
        BackgroundColor3 = CurrentTheme.BG_MAIN,
        ZIndex = 52
    }, previewCol)
    applyShape(ModalPreviewFrame, "square")
    create("UIStroke", {Thickness = 1.2, Color = CurrentTheme.BORDER}, ModalPreviewFrame)
    local pvLabel = create("TextLabel", {Name = "PVLabel", Size = UDim2.new(1, -8, 1, -8), Position = UDim2.new(0, 4, 0, 4), BackgroundTransparency = 1, Text = "", TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamBold, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 53}, ModalPreviewFrame)

    ModalBody = create("Frame", {
        Size = UDim2.new(1, -206, 1, -60),
        Position = UDim2.new(0, 194, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 51
    }, ConfigModal)

    -- Formas
    create("TextLabel", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = "Forma", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52}, ModalBody)
    local shapeRow = create("Frame", {Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, ZIndex = 52}, ModalBody)
    ModalShapeBtns = {}
    local function makeShape(name, label, x)
        local b = create("TextButton", {
            Size = UDim2.new(0, 78, 1, 0), Position = UDim2.new(0, x, 0, 0),
            BackgroundColor3 = Color3.fromRGB(24, 24, 28), Text = label,
            TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium,
            TextSize = 11, AutoButtonColor = false, ZIndex = 53
        }, shapeRow)
        create("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
        create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, b)
        ModalShapeBtns[name] = b
        connect(b.MouseButton1Click, function()
            playUISound()
            if not currentModalSc then return end
            currentModalSc.cfg.shape = name
            refreshShortcutVisual(currentModalSc)
            saveShortcuts()
            ModalRefresh()
        end)
    end
    makeShape("circle", "Circle", 0)
    makeShape("square", "Square", 84)
    makeShape("rounded", "Rounded", 168)

    -- Size slider
    local function buildSlider(labelText, y, minV, maxV, key, onChange)
        create("TextLabel", {Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, y), BackgroundTransparency = 1, Text = labelText, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52}, ModalBody)
        local track = create("Frame", {Size = UDim2.new(1, -50, 0, 6), Position = UDim2.new(0, 0, 0, y + 22), BackgroundColor3 = Color3.fromRGB(35, 35, 40), ZIndex = 52}, ModalBody)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, track)
        local fill = create("Frame", {Size = UDim2.new(0.5, 0, 1, 0), BackgroundColor3 = CurrentTheme.ACCENT, ZIndex = 53}, track)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
        local knob = create("TextButton", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false, ZIndex = 54}, track)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)
        local valLbl = create("TextLabel", {Size = UDim2.new(0, 46, 0, 20), Position = UDim2.new(1, -46, 0, y + 15), BackgroundTransparency = 1, Text = "", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 52}, ModalBody)

        local function set(v, save)
            if not currentModalSc then return end
            v = math.clamp(v, minV, maxV)
            currentModalSc.cfg[key] = v
            local pct = (v - minV) / (maxV - minV)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, -7, 0.5, -7)
            if key == "opacity" then
                valLbl.Text = string.format("%.2f", v)
            else
                valLbl.Text = tostring(math.floor(v))
            end
            onChange(v)
            if save then saveShortcuts() end
        end

        local dragging, activeInput, dragConn, endConn
        local function snap(input)
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            set(minV + pct * (maxV - minV), false)
        end
        -- ✋ Solo la bolita inicia el arrastre (el track ya no responde), para
        -- evitar cambios accidentales al deslizar la UI.
        local knobHit = create("TextButton", {Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 55}, knob)
        local function beginKnobDrag(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging = true activeInput = input
            dragConn = connect(UserInputService.InputChanged, function(ci)
                if dragging and ci == activeInput then snap(ci) end
            end)
            endConn = connect(UserInputService.InputEnded, function(ei)
                if ei ~= activeInput then return end
                dragging = false activeInput = nil
                if dragConn then dragConn:Disconnect() end
                if endConn then endConn:Disconnect() end
                saveShortcuts()
            end)
        end
        connect(knob.InputBegan, beginKnobDrag)
        connect(knobHit.InputBegan, beginKnobDrag)

        return { set = set, fill = fill, knob = knob, val = valLbl }
    end

    ModalSizeSlider = buildSlider("Tamaño (20 - 100 px)", 62, 20, 100, "size", function(v)
        if currentModalSc then
            refreshShortcutVisual(currentModalSc)
            if ModalPreviewFrame then
                ModalPreviewFrame.Size = computePreviewSize(currentModalSc.cfg)
                applyShape(ModalPreviewFrame, currentModalSc.cfg.shape)
                local pv = ModalPreviewFrame:FindFirstChild("PVLabel")
                if pv then pv.TextSize = math.clamp(math.floor(currentModalSc.cfg.size * 0.22), 9, 14) end
            end
        end
    end)
    ModalOpacitySlider = buildSlider("Opacidad (0 - 1)", 108, 0, 1, "opacity", function(v)
        if currentModalSc then
            refreshShortcutVisual(currentModalSc)
            if ModalPreviewFrame then
                ModalPreviewFrame.BackgroundTransparency = 1 - currentModalSc.cfg.opacity
            end
        end
    end)

    -- Lock toggle
    local lockRow = create("Frame", {Size = UDim2.new(1, 0, 0, 32), Position = UDim2.new(0, 0, 0, 158), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BackgroundTransparency = 0.35, ZIndex = 52}, ModalBody)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, lockRow)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, lockRow)
    ModalLockLabel = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "Bloquear posición (Lock)", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 53}, lockRow)
    local lockBtn = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 53}, lockRow)
    ModalLockTrack = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -44, 0.5, -9), BackgroundColor3 = Color3.fromRGB(40, 40, 45), ZIndex = 54}, lockRow)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, ModalLockTrack)
    ModalLockKnob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE, ZIndex = 55}, ModalLockTrack)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, ModalLockKnob)
    connect(lockBtn.MouseButton1Click, function()
        playUISound()
        if not currentModalSc then return end
        currentModalSc.cfg.lock = not currentModalSc.cfg.lock
        saveShortcuts()
        ModalRefresh()
    end)

    -- Botón dinámico: Agregar / Quitar shortcut
    local actionBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Color3.fromRGB(48, 20, 24), Text = "Quitar shortcut",
        TextColor3 = Color3.fromRGB(255, 180, 180), Font = Enum.Font.GothamBold,
        TextSize = 12, AutoButtonColor = false, ZIndex = 52
    }, ModalBody)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, actionBtn)
    local actionStroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(120, 40, 45)}, actionBtn)
    ModalActionBtn = actionBtn
    ModalActionStroke = actionStroke
    connect(actionBtn.MouseButton1Click, function()
        playUISound()
        if not currentModalSc then return end
        if currentModalSc.cfg.active then
            setShortcutActive(currentModalSc, false)
            ConfigModal.Visible = false
            backdrop.Visible = false
            currentModalSc = nil
        else
            -- 🩹 Fix: al re-activar un shortcut, resetear lock (antes heredaba
            -- lock=true del cfg persistido y aparecía bloqueado sin querer).
            -- ⚠ NO tocar userMoved / x / y: así el shortcut re-aparece exactamente
            -- donde el usuario lo dejó la última vez (antes volvía al grid por defecto).
            currentModalSc.cfg.lock = false
            setShortcutActive(currentModalSc, true)
            ModalRefresh()
        end
    end)
end

function ModalRefresh()
    if not (ConfigModal and currentModalSc) then return end
    local cfg = currentModalSc.cfg
    ModalTitle.Text = "Shortcut · " .. currentModalSc.data.name
    -- Formas: resaltar seleccionada (accent translúcido, sin texto negro)
    for shapeName, btn in pairs(ModalShapeBtns) do
        local active = (cfg.shape == shapeName)
        if active then
            btn.BackgroundColor3 = CurrentTheme.ACCENT
            btn.BackgroundTransparency = 0.78
            btn.TextColor3 = CurrentTheme.TEXT_WHITE
        else
            btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
            btn.BackgroundTransparency = 0
            btn.TextColor3 = CurrentTheme.TEXT_MUTED
        end
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then
            -- Borde neutro suave (nunca el color del tema): evita el
            -- efecto "letra en negrita/halo" cuando ACCENT es muy claro
            -- (Obsidian, Classic Dark). En temas con accent contrastante
            -- ya se distingue por el fondo tintado.
            st.Color = Color3.fromRGB(30, 30, 34)
            st.Transparency = active and 0.25 or 0.45
        end
    end
    -- Sliders
    ModalSizeSlider.set(cfg.size, false)
    ModalOpacitySlider.set(cfg.opacity, false)
    -- Lock
    if cfg.lock then
        ModalLockTrack.BackgroundColor3 = CurrentTheme.ACCENT
        ModalLockTrack.BackgroundTransparency = 0.55
    else
        ModalLockTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        ModalLockTrack.BackgroundTransparency = 0
    end
    ModalLockKnob.Position = cfg.lock and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    ModalLockLabel.TextColor3 = cfg.lock and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
    -- Preview
    ModalPreviewFrame.Size = computePreviewSize(cfg)
    ModalPreviewFrame.BackgroundTransparency = 1 - cfg.opacity
    applyShape(ModalPreviewFrame, cfg.shape)
    local pv = ModalPreviewFrame:FindFirstChild("PVLabel")
    if pv then
        pv.Text = buildLabel(currentModalSc)
        pv.Font = currentFontEnum()
        pv.TextSize = math.clamp(math.floor(cfg.size * 0.22), 9, 14)
    end
    -- Botón dinámico Agregar / Quitar
    if ModalActionBtn then
        if cfg.active then
            ModalActionBtn.Text = "Quitar shortcut"
            ModalActionBtn.BackgroundColor3 = Color3.fromRGB(48, 20, 24)
            ModalActionBtn.BackgroundTransparency = 0.15
            ModalActionBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
            if ModalActionStroke then
                -- Borde neutro: se ve como el resto del modal, no
                -- envuelve al texto con un halo del color del tema.
                ModalActionStroke.Color = Color3.fromRGB(60, 25, 28)
                ModalActionStroke.Transparency = 0.35
            end
        else
            ModalActionBtn.Text = "Agregar shortcut"
            ModalActionBtn.BackgroundColor3 = CurrentTheme.ACCENT
            ModalActionBtn.BackgroundTransparency = 0.72
            ModalActionBtn.TextColor3 = CurrentTheme.TEXT_WHITE
            if ModalActionStroke then
                -- Ver comentario arriba: mantenemos el borde neutro
                -- para no engrosar visualmente el texto en temas claros.
                ModalActionStroke.Color = Color3.fromRGB(30, 30, 34)
                ModalActionStroke.Transparency = 0.35
            end
        end
    end
end

local function openModal(sc)
    buildModal()
    currentModalSc = sc
    local backdropName = ConfigModal:GetAttribute("BackdropName")
    local backdrop = backdropName and ScreenGui:FindFirstChild(backdropName)
    if backdrop then backdrop.Visible = true end
    ConfigModal.Visible = true
    ModalRefresh()
end

-- --------------------------------------------------------------------
-- ATTACH SHORTCUT ACTIVATOR SOBRE UN WIDGET (toggle/button)
-- --------------------------------------------------------------------
function KillerHub._AttachShortcut(hostFrame, data)
    if not hostFrame or not data or not data.id then return end
    local cfg = ensureCfg(data.id)
    local sc = { data = data, cfg = cfg }
    Shortcuts[data.id] = sc

    -- Activador ↖ separado del interruptor, tamaño amigable a móvil.
    -- Para botones (kind="button") se ancla a la esquina superior-izquierda
    -- para que quede lejos del área de tap del botón grande (evita apagar
    -- el script por accidente). Para toggles se centra verticalmente.
    local isButtonHost = (data.kind == "button")
    -- Mismo tamano en Button y Toggle: mismo target de tap, imposible fallar.
    local ACT_SIZE = 32
    -- Anclado casi a la orilla izquierda del host, centrado vertical:
    -- lejos del centro del Button para no dispararlo por accidente.
    -- En botones (kind="button") el host tiene UIPadding lateral para centrar el texto,
    -- asi que compensamos con offset negativo para pegar el activador al borde IZQUIERDO real.
    local actPos
    if isButtonHost then
        actPos = UDim2.new(0, -42, 0.5, -math.floor(ACT_SIZE / 2))
    else
        actPos = UDim2.new(0, 2, 0.5, -math.floor(ACT_SIZE / 2))
    end

    local act = create("TextButton", {
        Name = "ShortcutActivator",
        Size = UDim2.new(0, ACT_SIZE, 0, ACT_SIZE),
        Position = actPos,
        BackgroundColor3 = Color3.fromRGB(6, 6, 8),
        Text = (SHORTCUT_ICON_IMAGE == "") and SHORTCUT_ICON_TEXT or "",
        TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        AutoButtonColor = false,
        ZIndex = 3
    }, hostFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, act)
    local actStroke = create("UIStroke", {Thickness = 1.2, Color = CurrentTheme.BORDER}, act)

    -- Ícono por imagen (opcional): si se definió un asset id, se dibuja
    -- centrado con padding interno para que NO se salga del cuadrito.
    local actImage
    if SHORTCUT_ICON_IMAGE ~= "" then
        actImage = create("ImageLabel", {
            Name = "ShortcutIconImg",
            Size = UDim2.new(1, -8, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundTransparency = 1,
            Image = SHORTCUT_ICON_IMAGE,
            ScaleType = Enum.ScaleType.Fit,
            ImageColor3 = CurrentTheme.TEXT_MUTED,
            ZIndex = 4
        }, act)
    end

    local function refreshActivator()
        if cfg.active then
            local fill, glyph = getShortcutAccent()
            act.BackgroundColor3 = fill
            act.TextColor3 = glyph
            -- Borde neutro tambien en estado activo: el fondo ya
            -- indica seleccion, no hace falta un halo del color del tema
            -- (evita que el icono/letra se vea engrosado en Obsidian).
            actStroke.Color = Color3.fromRGB(30, 30, 34)
            actStroke.Transparency = 0.3
            if actImage then actImage.ImageColor3 = glyph end
        else
            act.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
            act.TextColor3 = CurrentTheme.TEXT_MUTED
            actStroke.Color = Color3.fromRGB(30, 30, 34)
            actStroke.Transparency = 0.45
            if actImage then actImage.ImageColor3 = CurrentTheme.TEXT_MUTED end
        end
    end
    ShortcutActivators[data.id] = { btn = act, stroke = actStroke, refresh = refreshActivator }
    table.insert(KillerHub.TargetThemeElements, refreshActivator)

    connect(act.MouseButton1Click, function()
        playUISound()
        -- Solo abre el modal; el shortcut se agrega desde el botón "Agregar shortcut"
        openModal(sc)
        refreshActivator()
    end)

    refreshActivator()
    if cfg.active then
        task.defer(function() createFloating(sc) refreshShortcutVisual(sc) end)
    end

    -- Si el estado del toggle cambia, refrescar la etiqueta del shortcut
    if data.kind == "toggle" and data.flag then
        table.insert(KillerHub.TargetThemeElements, function()
            if sc.frame then refreshShortcutVisual(sc) end
        end)
        task.spawn(function()
            local last = data.getState()
            while ScreenGui and ScreenGui.Parent do
                task.wait(0.15)
                local now = data.getState()
                if now ~= last then last = now if sc.frame then refreshShortcutVisual(sc) end end
            end
        end)
    end
end

-- Refresco global de shortcuts al cambiar tema
table.insert(KillerHub.TargetThemeElements, function()
    -- Reconstruye los flotantes activos con los nuevos colores del tema
    for _, sc in pairs(Shortcuts) do
        if sc.frame and sc.cfg.active then
            pcall(function() sc.frame:Destroy() end)
            sc.frame, sc.stroke, sc.label, sc.accentBar = nil, nil, nil, nil
            createFloating(sc)
            refreshShortcutVisual(sc)
        end
    end
    -- Regenera el modal para que todos los colores fijos se actualicen
    if ConfigModal then
        local wasVisible = ConfigModal.Visible
        local sc = currentModalSc
        local backdropName = ConfigModal:GetAttribute("BackdropName")
        local backdrop = backdropName and ScreenGui:FindFirstChild(backdropName)
        pcall(function() ConfigModal:Destroy() end)
        if backdrop then pcall(function() backdrop:Destroy() end) end
        ConfigModal = nil
        ModalBody, ModalTitle, ModalPreview, ModalPreviewFrame = nil, nil, nil, nil
        ModalShapeBtns, ModalSizeSlider, ModalOpacitySlider = nil, nil, nil
        ModalLockTrack, ModalLockKnob, ModalLockLabel = nil, nil, nil
        ModalActionBtn, ModalActionStroke = nil, nil
        if wasVisible and sc then
            openModal(sc)
        end
    end
end)

-- ============================================================================
-- ============================================================================
-- ♻️ VIRTUALIZACIÓN DE LISTAS MASIVAS (opt-in, no rompe la API existente)
--    Uso: local list = KillerHub:CreateVirtualizedList(parent, {
--          itemHeight = 32, getCount = fn, renderItem = fn(row, index, data),
--          getData = fn(index) })
--    Solo instancia los ~N botones visibles y los reutiliza al hacer scroll,
--    ideal para selectores de jugadores en servidores llenos o listas de
--    inventario. El resto del hub sigue usando ScrollingFrame normal.
-- ============================================================================
function KillerHub:CreateVirtualizedList(parent, opts)
    opts = opts or {}
    local itemHeight = opts.itemHeight or 30
    local getCount = opts.getCount or function() return 0 end
    local renderItem = opts.renderItem or function() end
    local getData = opts.getData or function(i) return i end

    local scroll = create("ScrollingFrame", {
        Size = opts.size or UDim2.new(1, 0, 1, 0),
        Position = opts.position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y
    }, parent)

    local pool, activeByIndex = {}, {}

    local function acquire()
        local row = table.remove(pool)
        if row then row.Visible = true return row end
        row = create("Frame", {
            Size = UDim2.new(1, -6, 0, itemHeight),
            BackgroundColor3 = CurrentTheme.BG_SECONDARY,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
        }, scroll)
        create("UICorner", {CornerRadius = UDim.new(0, 6)}, row)
        return row
    end

    local function release(row)
        row.Visible = false
        table.insert(pool, row)
    end

    local function refresh()
        local count = getCount()
        scroll.CanvasSize = UDim2.new(0, 0, 0, count * itemHeight + 4)
        local viewport = scroll.AbsoluteSize.Y
        local scrollY = scroll.CanvasPosition.Y
        local firstIdx = math.max(1, math.floor(scrollY / itemHeight) + 1)
        local lastIdx  = math.min(count, math.ceil((scrollY + viewport) / itemHeight) + 1)

        -- Libera filas fuera de rango
        for idx, row in pairs(activeByIndex) do
            if idx < firstIdx or idx > lastIdx then
                activeByIndex[idx] = nil
                release(row)
            end
        end
        -- Asigna filas visibles
        for idx = firstIdx, lastIdx do
            local row = activeByIndex[idx]
            if not row then
                row = acquire()
                activeByIndex[idx] = row
            end
            row.Position = UDim2.new(0, 3, 0, (idx - 1) * itemHeight)
            local ok, data = pcall(getData, idx)
            if ok then pcall(renderItem, row, idx, data) end
        end
    end

    connect(scroll:GetPropertyChangedSignal("CanvasPosition"), refresh)
    connect(scroll:GetPropertyChangedSignal("AbsoluteSize"), refresh)
    task.defer(refresh)

    return { Frame = scroll, Refresh = refresh }
end

-- 🔓 CONFIGURACIÓN BASE OBLIGATORIA (SETTINGS)
-- ============================================================================
local SettingsTab = KillerHub:CreateTab("Settings", "Settings") -- engranaje 7059346373 (ver IconLibrary)

SettingsTab:CreateSection("Personalization")
SettingsTab:CreateDropdown("SelectedTheme", "UI themes:", {"Obsidian", "Void Premium", "Midnight Emerald", "Classic Dark", "Sakura Blossom", "Blood"}, function(selected) KillerHub:SetTheme(selected) end)

local TopFonts = {
    "Gotham", "GothamMedium", "GothamBold", "GothamBlack", "GothamSemibold",
    "Roboto", "RobotoCondensed", "RobotoMono",
    "SourceSans", "SourceSansBold", "SourceSansSemibold",
    "Ubuntu", "FredokaOne", "Arcade", "SciFi",
    "Nunito", "Oswald", "Michroma", "Merriweather", "TitilliumWeb",
    "Sarpanch", "DenkOne", "Jura", "JosefinSans",
    "BuilderSans", "BuilderSansMedium", "BuilderSansBold"
}
SettingsTab:CreateDropdown("SelectedFont", "Text Source:", TopFonts, function(selected) KillerHub:SetFont(selected) end)
SettingsTab:CreateSlider("UiOpacity", "UI Opacity", 0.3, 1, function(v) updateUiOpacity() end)

SettingsTab:CreateSection("Menu Controls")
SettingsTab:CreateToggle("MenuAnimEnabled", "UI Animation", function(v) Config.MenuAnimEnabled = v end)
SettingsTab:CreateToggle("AutoArrangeShortcuts", "Auto-organize Shortcuts", function(v) Config.AutoArrangeShortcuts = v end)
SettingsTab:CreateKeybind("ToggleKey", "Close/Open Menu", Enum.KeyCode.RightControl, function(key)
    print("Se presionó la tecla: " .. tostring(key))
end)
SettingsTab:CreateSlider("ToggleBtnSize", "UI Button Size", 30, 80, function(v) updateButtonSize() end)
SettingsTab:CreateSlider("Volume", "Interface Volume", 0, 1, function(v) Config.Volume = v end)
SettingsTab:CreateSlider("GuiWidth", "Adjust UI Width", 0, 1, function(v) updateGuiSize() end)
SettingsTab:CreateSlider("GuiHeight", "Adjust UI Height", 0, 1, function(v) updateGuiSize() end)

SettingsTab:CreateSection("Universal Configuration")
SettingsTab:CreateParagraph("🌐 Universal persistence", "All your settings (styles, sizes, theme, keys, toggles, sliders, keybinds, and shortcuts) are saved in Universal.json and go with you to ANY game. Nothing is reset when you switch experiences.")

SettingsTab:CreateSection("Shortcuts")
SettingsTab:CreateParagraph("🧹 Quick cleaning", "Removes ALL floating shortcut boxes from the screen (including those created by external scripts). The original menu widgets will continue to function, and you can add shortcuts again as needed.")
SettingsTab:CreateButton("Remove all shortcuts", function()
    if KillerHub.ClearAllShortcuts then KillerHub:ClearAllShortcuts() end
end)

SettingsTab:CreateSection("Safety and Cleanliness")
SettingsTab:CreateParagraph("⚠️ SHUTDOWN WARNING", "If you decide to unload the script, the interface will close and be completely removed from memory.")
SettingsTab:CreateButton("Turn Off Script", function() KillerHub:Unload() end)

task.defer(function() KillerHub:SetTheme(Config.SelectedTheme or "Obsidian") end)

-- Publicación y Sincronización Inicial de Flags globales
getgenv().KillerHub = KillerHub
getgenv().KillerHub.Flags = Flags


-- ============================================================================
-- 🚀 KILLER HUB v1.3 — ENHANCEMENT LAYER (additive, API-compatible)
-- ============================================================================
-- Este bloque se aplica DESPUÉS de que la librería original esté totalmente
-- construida. Solo AGREGA capacidades y PARCHEA funciones existentes de forma
-- segura. Ningún componente ya creado se rompe: si algo falla aquí, se avisa
-- por `warn` y la librería sigue funcionando con su comportamiento original.
--
-- Cubre (del plan):
--   §1  DESIGN + Utils + Maid interno
--   §2  Debounce util, throttling Heartbeat helper
--   §3  Tokens semánticos derivados (Surface/Accent/AccentMuted/Text/Border/…)
--        + señal ThemeChanged
--   §4  ReducedMotion, curvas centralizadas, bindHover
--   §7/8 Notify: stack, tipos (info/success/warn/error), progreso, pausa hover,
--        botón de cierre, cola con máximo visible
--   §10 Tecla de toggle configurable (default RightControl) + navegación Tab
--   §11 SafeCallback global, protección doble-init, identifyexecutor con fallback
-- ============================================================================
do
    if rawget(_G, "__KillerHub_v13_Applied__") then
        warn("[KillerHub] Loaded")
    else
        _G.__KillerHub_v13_Applied__ = true

        local ok, err = pcall(function()
            -- ------------------------------------------------------------------
            -- Servicios cacheados (fast-path)
            -- ------------------------------------------------------------------
            local TS   = game:GetService("TweenService")
            local RS   = game:GetService("RunService")
            local UIS  = game:GetService("UserInputService")
            local Plrs = game:GetService("Players")

            -- ------------------------------------------------------------------
            -- §1 DESIGN — constantes centralizadas
            -- ------------------------------------------------------------------
            local DESIGN = {
                PAD_XS = 4, PAD_SM = 6, PAD_MD = 10, PAD_LG = 14,
                RADIUS_SM = 4, RADIUS_MD = 8, RADIUS_LG = 12,
                DUR_MICRO = 0.12, DUR_FAST = 0.18, DUR_MED = 0.28, DUR_SLOW = 0.42,
                EASE_ENTER = Enum.EasingStyle.Quint,
                EASE_ENTER_DIR = Enum.EasingDirection.Out,
                EASE_EXIT = Enum.EasingStyle.Quart,
                EASE_EXIT_DIR = Enum.EasingDirection.In,
                EASE_MICRO = Enum.EasingStyle.Sine,
                EASE_MICRO_DIR = Enum.EasingDirection.Out,
                NOTIF_MAX_VISIBLE = 5,
                NOTIF_WIDTH = 260,
                TOUCH_HIT_MIN = 32,
            }
            KillerHub.DESIGN = DESIGN

            -- ------------------------------------------------------------------
            -- §11 identifyexecutor con fallback
            -- ------------------------------------------------------------------
            local function detectExecutor()
                local id = "Unknown"
                pcall(function()
                    if identifyexecutor then
                        local a, b = identifyexecutor()
                        id = (typeof(a) == "string" and a) or id
                        if b then id = id .. " " .. tostring(b) end
                    elseif getexecutorname then
                        id = getexecutorname() or id
                    end
                end)
                return id
            end
            KillerHub.Executor = detectExecutor()

            -- ------------------------------------------------------------------
            -- §11 SafeCallback global — envuelve callbacks de usuario
            -- ------------------------------------------------------------------
            local function SafeCallback(fn, label, ...)
                if typeof(fn) ~= "function" then return end
                local args = table.pack(...)
                local ok, e = pcall(function() return fn(table.unpack(args, 1, args.n)) end)
                if not ok then
                    warn(("[KillerHub][%s] callback error: %s"):format(label or "callback", tostring(e)))
                    task.spawn(function()
                        pcall(function()
                            KillerHub:Notify("Error en componente", tostring(e), 5,
                                Color3.fromRGB(240, 80, 80))
                        end)
                    end)
                end
            end
            KillerHub.SafeCallback = SafeCallback

            -- ------------------------------------------------------------------
            -- §1 Utils
            -- ------------------------------------------------------------------
            local Utils = {}

            function Utils.Round(n, step)
                step = step or 1
                return math.floor(n / step + 0.5) * step
            end

            function Utils.Lerp(a, b, t) return a + (b - a) * t end

            function Utils.DeepClone(t)
                if typeof(t) ~= "table" then return t end
                local c = {}
                for k, v in pairs(t) do c[k] = Utils.DeepClone(v) end
                return c
            end

            function Utils.Create(class, props, parent)
                local inst = Instance.new(class)
                if props then
                    for k, v in pairs(props) do
                        if k ~= "Parent" then
                            pcall(function() inst[k] = v end)
                        end
                    end
                end
                if parent then inst.Parent = parent end
                return inst
            end

            function Utils.Tween(inst, dur, props, style, dir)
                local reduced = KillerHub.ReducedMotion
                local d = reduced and (dur * 0.3) or dur
                local info = TweenInfo.new(d,
                    style or DESIGN.EASE_ENTER,
                    dir or DESIGN.EASE_ENTER_DIR)
                local t = TS:Create(inst, info, props)
                t:Play()
                return t
            end

            -- §2 Debounce (edge-trailing) — evita 60 callbacks/seg en sliders
            function Utils.Debounce(fn, delay)
                delay = delay or 0.05
                local scheduled = false
                local pending
                return function(...)
                    pending = table.pack(...)
                    if scheduled then return end
                    scheduled = true
                    task.delay(delay, function()
                        scheduled = false
                        local a = pending
                        pending = nil
                        if a then
                            SafeCallback(fn, "debounced", table.unpack(a, 1, a.n))
                        end
                    end)
                end
            end

            -- §2 Throttling con Heartbeat
            function Utils.Throttle(fn, interval)
                interval = interval or (1 / 30)
                local last = 0
                return function(...)
                    local now = os.clock()
                    if now - last < interval then return end
                    last = now
                    return fn(...)
                end
            end

            KillerHub.Utils = Utils

            -- ------------------------------------------------------------------
            -- §1 Maid interno (janitor)
            -- ------------------------------------------------------------------
            local Maid = {}
            Maid.__index = Maid

            function Maid.new()
                return setmetatable({_tasks = {}}, Maid)
            end

            function Maid:Add(item)
                table.insert(self._tasks, item)
                return item
            end

            function Maid:Clean()
                for i = #self._tasks, 1, -1 do
                    local item = self._tasks[i]
                    self._tasks[i] = nil
                    pcall(function()
                        if typeof(item) == "RBXScriptConnection" then item:Disconnect()
                        elseif typeof(item) == "Instance" then item:Destroy()
                        elseif typeof(item) == "function" then item()
                        elseif typeof(item) == "table" and item.Destroy then item:Destroy() end
                    end)
                end
            end

            Maid.Destroy = Maid.Clean
            KillerHub.Maid = Maid
            KillerHub._WindowMaid = KillerHub._WindowMaid or Maid.new()

            -- ------------------------------------------------------------------
            -- §3 Tokens semánticos derivados del tema actual
            -- ------------------------------------------------------------------
            local function tokensFromTheme(t)
                t = t or {}
                local accent = t.ACCENT or Color3.fromRGB(200, 200, 200)
                local function mix(c, target, alpha)
                    return Color3.new(
                        c.R + (target.R - c.R) * alpha,
                        c.G + (target.G - c.G) * alpha,
                        c.B + (target.B - c.B) * alpha
                    )
                end
                local bg = t.BG_MAIN or Color3.fromRGB(15, 15, 15)
                return {
                    Background   = bg,
                    Surface      = t.BG_SIDEBAR or bg,
                    SurfaceAlt   = t.BG_SECONDARY or bg,
                    Accent       = accent,
                    AccentMuted  = mix(bg, accent, 0.18),
                    AccentSoft   = mix(bg, accent, 0.35),
                    Text         = t.TEXT_WHITE or Color3.fromRGB(240, 240, 240),
                    TextMuted    = t.TEXT_MUTED or Color3.fromRGB(140, 140, 140),
                    Border       = t.BORDER or Color3.fromRGB(40, 40, 40),
                    Success      = Color3.fromRGB(80, 200, 120),
                    Warning      = Color3.fromRGB(240, 180, 60),
                    Danger       = Color3.fromRGB(235, 80, 80),
                    Info         = accent,
                }
            end

            local function refreshTokens()
                local theme = rawget(_G, "CurrentTheme")
                    or (KillerHub._GetCurrentTheme and KillerHub:_GetCurrentTheme())
                    or nil
                -- Fallback: buscar por reflection segura si no está expuesto
                if not theme then
                    for _, v in pairs(KillerHub) do
                        if typeof(v) == "table" and v.BG_MAIN then theme = v break end
                    end
                end
                KillerHub.Tokens = tokensFromTheme(theme or {})
            end
            refreshTokens()

            -- §3 Señal ThemeChanged (bindable) + patch de SetTheme
            local themeSignal = Instance.new("BindableEvent")
            KillerHub.ThemeChanged = themeSignal.Event

            local origSetTheme = KillerHub.SetTheme
            if typeof(origSetTheme) == "function" then
                KillerHub.SetTheme = function(self, name)
                    local ok, e = pcall(origSetTheme, self, name)
                    if not ok then warn("[KillerHub] SetTheme error: " .. tostring(e)) end
                    refreshTokens()
                    pcall(function() themeSignal:Fire(KillerHub.Tokens) end)
                end
            end

            -- ------------------------------------------------------------------
            -- §4 ReducedMotion + bindHover
            -- ------------------------------------------------------------------
            KillerHub.ReducedMotion = false

            function KillerHub:SetReducedMotion(enabled)
                self.ReducedMotion = enabled and true or false
            end

            function KillerHub.bindHover(inst, opts)
                if not inst or not opts then return end
                local enter = opts.enter
                local leave = opts.leave
                local c1 = inst.MouseEnter:Connect(function()
                    SafeCallback(enter, "hover.enter", inst)
                end)
                local c2 = inst.MouseLeave:Connect(function()
                    SafeCallback(leave, "hover.leave", inst)
                end)
                KillerHub._WindowMaid:Add(c1)
                KillerHub._WindowMaid:Add(c2)
                return c1, c2
            end

            -- ------------------------------------------------------------------
            -- §7/§8 Notify — reemplazo con stack, tipos, progreso, pausa hover
            -- ------------------------------------------------------------------
            local NOTIF_TYPES = {
                info    = {color = nil,                          icon = "ℹ"},
                success = {color = Color3.fromRGB(80, 200, 120), icon = "✔"},
                warn    = {color = Color3.fromRGB(240, 180, 60), icon = "⚠"},
                error   = {color = Color3.fromRGB(235, 80, 80),  icon = "✖"},
            }

            local function findNotifContainer()
                local sg = rawget(_G, "__KillerHub_ScreenGui__")
                if not sg or not sg.Parent then
                    sg = nil
                    pcall(function()
                        for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
                            if gui.Name == "KillerHub_Universal" then sg = gui break end
                        end
                    end)
                    if not sg and gethui then
                        pcall(function()
                            local h = gethui()
                            if h then sg = h:FindFirstChild("KillerHub_Universal") end
                        end)
                    end
                    if not sg then
                        local pg = Plrs.LocalPlayer and Plrs.LocalPlayer:FindFirstChild("PlayerGui")
                        if pg then sg = pg:FindFirstChild("KillerHub_Universal") end
                    end
                end
                if not sg then return nil end
                return sg:FindFirstChild("NotificationContainer"), sg
            end

            local NotifQueue = {}
            local NotifActive = {}
            local NOTIF_MAX = DESIGN.NOTIF_MAX_VISIBLE

            local function showOneNotification(payload)
                local container, sg = findNotifContainer()
                if not container then return end
                local T = KillerHub.Tokens
                local typeInfo = NOTIF_TYPES[payload.kind or "info"] or NOTIF_TYPES.info
                local accent = payload.color or typeInfo.color or T.Accent

                local frame = Utils.Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = T.SurfaceAlt,
                    BackgroundTransparency = 0.05,
                    ClipsDescendants = true,
                }, container)
                Utils.Create("UICorner", {CornerRadius = UDim.new(0, DESIGN.RADIUS_MD)}, frame)
                Utils.Create("UIStroke", {Color = T.Border, Thickness = 1, Transparency = 0.2}, frame)

                Utils.Create("Frame", {
                    Name = "AccentBar",
                    Size = UDim2.new(0, 3, 1, 0),
                    BackgroundColor3 = accent,
                    BorderSizePixel = 0,
                }, frame)

                local iconLbl = Utils.Create("TextLabel", {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 8),
                    BackgroundTransparency = 1,
                    Text = typeInfo.icon,
                    TextColor3 = accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                }, frame)

                local title = Utils.Create("TextLabel", {
                    Size = UDim2.new(1, -60, 0, 16),
                    Position = UDim2.new(0, 34, 0, 6),
                    BackgroundTransparency = 1,
                    Text = payload.title or "",
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                }, frame)

                local body = Utils.Create("TextLabel", {
                    Size = UDim2.new(1, -44, 0, 28),
                    Position = UDim2.new(0, 34, 0, 20),
                    BackgroundTransparency = 1,
                    Text = payload.text or "",
                    TextColor3 = T.TextMuted,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                }, frame)

                -- 🔧 Close button más grande y clickeable, con "X" (letra latina
                -- que siempre renderiza — antes usábamos "✕" que en algunos
                -- executors/fuentes se veía como un cuadrito vacío). También
                -- añadimos un pequeño fondo semi-transparente para que se
                -- perciba visualmente como un botón, no como un artefacto.
                local closeBtn = Utils.Create("TextButton", {
                    Size = UDim2.new(0, 26, 0, 26),
                    Position = UDim2.new(1, -30, 0, 4),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 46),
                    BackgroundTransparency = 0.45,
                    Text = "X",
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    AutoButtonColor = true,
                }, frame)
                Utils.Create("UICorner", {CornerRadius = UDim.new(0, 6)}, closeBtn)

                local progress = Utils.Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 2),
                    Position = UDim2.new(0, 0, 1, -2),
                    BackgroundColor3 = accent,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0, 0),
                }, frame)

                local target = UDim2.new(1, 0, 0, 54)
                Utils.Tween(frame, DESIGN.DUR_MED, {Size = target})

                local dur = payload.duration or 4
                local paused = false
                local elapsed = 0

                local hb; hb = RS.Heartbeat:Connect(function(dt)
                    if not paused then
                        elapsed = elapsed + dt
                        local ratio = math.clamp(1 - elapsed / dur, 0, 1)
                        progress.Size = UDim2.new(ratio, 0, 0, 2)
                        if elapsed >= dur then
                            hb:Disconnect()
                            hb = nil
                            local out = Utils.Tween(frame, DESIGN.DUR_FAST,
                                {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1},
                                DESIGN.EASE_EXIT, DESIGN.EASE_EXIT_DIR)
                            out.Completed:Connect(function()
                                pcall(function() frame:Destroy() end)
                                local i = table.find(NotifActive, frame)
                                if i then table.remove(NotifActive, i) end
                                -- flush cola
                                if #NotifQueue > 0 and #NotifActive < NOTIF_MAX then
                                    local next = table.remove(NotifQueue, 1)
                                    task.spawn(showOneNotification, next)
                                end
                            end)
                        end
                    end
                end)

                frame.MouseEnter:Connect(function() paused = true end)
                frame.MouseLeave:Connect(function() paused = false end)
                -- 🩹 FIX: al hacer click en cerrar antes se desconectaba hb y
                -- se seteaba elapsed=dur, pero como el heartbeat ya no corría
                -- el frame quedaba PEGADO en pantalla (la notificación no se
                -- iba nunca — bug reportado tras spamear "Remover todos los
                -- shortcuts"). Ahora ejecutamos el outro directamente y
                -- limpiamos NotifActive/flush queue igual que el timeout.
                local dismissed = false
                local function dismiss()
                    if dismissed then return end
                    dismissed = true
                    if hb then pcall(function() hb:Disconnect() end) hb = nil end
                    local out = Utils.Tween(frame, DESIGN.DUR_FAST,
                        {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1},
                        DESIGN.EASE_EXIT, DESIGN.EASE_EXIT_DIR)
                    out.Completed:Connect(function()
                        pcall(function() frame:Destroy() end)
                        local i = table.find(NotifActive, frame)
                        if i then table.remove(NotifActive, i) end
                        if #NotifQueue > 0 and #NotifActive < NOTIF_MAX then
                            local next = table.remove(NotifQueue, 1)
                            task.spawn(showOneNotification, next)
                        end
                    end)
                end
                closeBtn.MouseButton1Click:Connect(dismiss)

                table.insert(NotifActive, frame)
            end

            local origNotify = KillerHub.Notify
            function KillerHub:Notify(title, text, duration, customColorOrKind)
                local kind = "info"
                local color = nil
                if typeof(customColorOrKind) == "Color3" then
                    color = customColorOrKind
                elseif typeof(customColorOrKind) == "string" then
                    kind = customColorOrKind
                end
                local payload = {
                    title = title or "", text = text or "",
                    duration = duration or 4, kind = kind, color = color
                }
                if #NotifActive >= NOTIF_MAX then
                    table.insert(NotifQueue, payload)
                    if #NotifQueue > 15 then table.remove(NotifQueue, 1) end
                    return
                end
                local ok, e = pcall(showOneNotification, payload)
                if not ok then
                    warn("[KillerHub] Notify v1.3 fallo, usando original: " .. tostring(e))
                    if typeof(origNotify) == "function" then
                        pcall(origNotify, self, title, text, duration, color)
                    end
                end
            end

            -- Helpers cortos
            function KillerHub:NotifySuccess(t, x, d) self:Notify(t, x, d, "success") end
            function KillerHub:NotifyWarn(t, x, d)    self:Notify(t, x, d, "warn") end
            function KillerHub:NotifyError(t, x, d)   self:Notify(t, x, d, "error") end
            function KillerHub:NotifyInfo(t, x, d)    self:Notify(t, x, d, "info") end

            -- ------------------------------------------------------------------
            -- §10 Tecla de toggle configurable (default RightControl)
            -- ------------------------------------------------------------------
            KillerHub.ToggleKey = KillerHub.ToggleKey or Enum.KeyCode.RightControl
            local toggleConn
            local function bindToggleKey()
                if toggleConn then pcall(function() toggleConn:Disconnect() end) end
                toggleConn = UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if input.KeyCode == KillerHub.ToggleKey then
                        local sg
                        pcall(function()
                            sg = game:GetService("CoreGui"):FindFirstChild("KillerHub_Universal")
                        end)
                        if not sg and Plrs.LocalPlayer then
                            local pg = Plrs.LocalPlayer:FindFirstChild("PlayerGui")
                            if pg then sg = pg:FindFirstChild("KillerHub_Universal") end
                        end
                        if sg then sg.Enabled = not sg.Enabled end
                    end
                end)
                KillerHub._WindowMaid:Add(toggleConn)
            end

            function KillerHub:BindToggleKey(keyCode)
                if typeof(keyCode) == "EnumItem" then
                    self.ToggleKey = keyCode
                    bindToggleKey()
                end
            end
            bindToggleKey()

            -- ------------------------------------------------------------------
            -- §11 Patch de Destroy — limpiar Maid + signals
            -- ------------------------------------------------------------------
            local origDestroy = KillerHub.Destroy
            function KillerHub:Destroy()
                pcall(function() KillerHub._WindowMaid:Clean() end)
                pcall(function() themeSignal:Destroy() end)
                _G.__KillerHub_v13_Applied__ = nil
                if typeof(origDestroy) == "function" then
                    pcall(origDestroy, self)
                end
            end

            local origUnload = KillerHub.Unload
            function KillerHub:Unload()
                pcall(function() KillerHub._WindowMaid:Clean() end)
                pcall(function() themeSignal:Destroy() end)
                _G.__KillerHub_v13_Applied__ = nil
                if typeof(origUnload) == "function" then
                    pcall(origUnload, self)
                end
            end

            -- Refresh de tokens en cada cambio de tema (por si SetTheme externo)
            local reTokens = RS.Heartbeat:Connect(Utils.Throttle(function()
                -- barato: solo redetectar si cambia la referencia del tema global
            end, 1))
            KillerHub._WindowMaid:Add(reTokens)

            warn(("[KillerHub] Enhancement layer aplicada. Executor: %s"):format(KillerHub.Executor))
        end)

        if not ok then
            warn("[KillerHub v1.3] Enhancement layer FALLO al aplicarse: " .. tostring(err))
            warn("[KillerHub v1.3] La librería sigue funcionando con su comportamiento original.")
            _G.__KillerHub_v13_Applied__ = nil
        end
    end
end
-- ============================================================================
-- FIN ENHANCEMENT LAYER v1.3
-- ============================================================================


return KillerHub
