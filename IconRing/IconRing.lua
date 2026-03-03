-- ============================================
-- Главная перетаскиваемая кнопка (48x48) с рамкой
-- ============================================
local mainButton = CreateFrame("Button", "IconRingMainButton", UIParent)
mainButton:SetSize(48, 48)
mainButton:SetMovable(true)
mainButton:RegisterForDrag("LeftButton")

mainButton:SetScript("OnDragStart", mainButton.StartMoving)
mainButton:SetScript("OnDragStop", mainButton.StopMovingOrSizing)

-- Текстуры главной кнопки (если нет своих, замените на стандартные)
mainButton:SetNormalTexture("Interface\\AddOns\\IconRing\\mainicon.tga")
mainButton:SetPushedTexture("Interface\\AddOns\\IconRing\\mainicon_pushed.tga")
mainButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

mainButton:SetPoint("CENTER")

-- Рамка для главной кнопки
local buttonBorder = CreateFrame("Frame", nil, mainButton)
buttonBorder:SetPoint("TOPLEFT", -4, 4)
buttonBorder:SetPoint("BOTTOMRIGHT", 4, -4)
buttonBorder:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
buttonBorder:SetBackdropBorderColor(1, 1, 1, 1)
buttonBorder:SetFrameLevel(mainButton:GetFrameLevel() + 2)

-- Подсветка рамки при наведении
mainButton:SetScript("OnEnter", function()
    buttonBorder:SetBackdropBorderColor(1, 0.8, 0.2, 1)  -- золотой
end)
mainButton:SetScript("OnLeave", function()
    buttonBorder:SetBackdropBorderColor(1, 1, 1, 1)    -- белый
end)

-- Таблица локаций
local locations = {
    { file = "anka.tga",    name = "Анкахет" },
    { file = "baston.tga",  name = "Бастионы" },
    { file = "chm.tga",     name = "Чертоги молний" },
    { file = "darktar.tga", name = "Драктарон" },
    { file = "grob.tga",    name = "Гробницы" },
    { file = "kyznia.tga",  name = "Кузня" },
    { file = "utgard.tga",  name = "Утгард" },
    { file = "uzil.tga",    name = "Узилище" }
}

-- Параметры текстовых кнопок
local radius = 150
local btnWidth = 150
local btnHeight = 30
local textButtons = {}
local buttonsVisible = false

-- Создаём 8 текстовых кнопок
for i, loc in ipairs(locations) do
    local btn = CreateFrame("Button", nil, mainButton)
    btn:SetSize(btnWidth, btnHeight)
    btn:SetText(loc.name)
    btn:SetNormalFontObject("GameFontNormal")
    btn:SetHighlightFontObject("GameFontHighlight")
    
    btn:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    btn:SetBackdropColor(0, 0, 0, 0.8)
    
    btn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.3, 0.3, 0.3, 0.9)
    end)
    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(0, 0, 0, 0.8)
    end)
    
    -- Анимация прозрачности для плавного появления
    btn:SetAlpha(0)
    
    local angle = (i - 1) * 45 * math.pi / 180
    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)
    btn:SetPoint("CENTER", mainButton, "CENTER", x, y)
    
    btn:Hide()
    table.insert(textButtons, btn)
end

-- Показать/скрыть кольцо с анимацией
local function ShowButtons(show)
    buttonsVisible = show
    if show then
        for _, btn in ipairs(textButtons) do
            btn:Show()
            btn:SetAlpha(0)
            UIFrameFadeIn(btn, 0.3, 0, 1)
        end
    else
        for _, btn in ipairs(textButtons) do
            UIFrameFadeOut(btn, 0.2, 1, 0)
            btn:SetScript("OnUpdate", function(self, elapsed)
                if self:GetAlpha() <= 0 then
                    self:Hide()
                    self:SetScript("OnUpdate", nil)
                end
            end)
        end
    end
end

mainButton:SetScript("OnClick", function()
    ShowButtons(not buttonsVisible)
end)

-- ============================================
-- Окно просмотра с улучшенной рамкой
-- ============================================
local viewer = CreateFrame("Frame", "IconRingViewer", UIParent)
viewer:SetSize(720, 750)
viewer:SetPoint("CENTER")
viewer:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\AchievementFrame\\AchievementFrame-Border",
    tile = true, tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
viewer:Hide()
viewer:EnableMouse(true)
viewer:SetFrameStrata("DIALOG")

-- Заголовок (полоса)
local titleBar = CreateFrame("Frame", nil, viewer)
titleBar:SetHeight(30)
titleBar:SetPoint("TOPLEFT", viewer, "TOPLEFT", 5, -5)
titleBar:SetPoint("TOPRIGHT", viewer, "TOPRIGHT", -5, -5)
titleBar:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\AchievementFrame\\AchievementFrame-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
titleBar:SetBackdropColor(0.2, 0.2, 0.2, 0.9)
titleBar:EnableMouse(true)
titleBar:SetMovable(true)
titleBar:RegisterForDrag("LeftButton")
titleBar:SetScript("OnDragStart", function() viewer:StartMoving() end)
titleBar:SetScript("OnDragStop", function() viewer:StopMovingOrSizing() end)

-- Ник по центру
local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
titleText:SetText("chirikan228 x NeyDDo")
titleText:SetTextColor(1, 1, 1)

-- Кнопка закрытия
local closeButton = CreateFrame("Button", nil, titleBar, "UIPanelCloseButton")
closeButton:SetPoint("RIGHT", titleBar, "RIGHT", -5, 0)
closeButton:SetScript("OnClick", function() viewer:Hide() end)

-- Текстура с картинкой (исправлено: чуть больше отступы для гарантии)
local viewerTexture = viewer:CreateTexture(nil, "ARTWORK")
viewerTexture:SetPoint("TOPLEFT", viewer, "TOPLEFT", 13, -38)    -- отступ слева 13, сверху 38
viewerTexture:SetPoint("BOTTOMRIGHT", viewer, "BOTTOMRIGHT", -14, 14) -- отступ справа 14, снизу 14
viewerTexture:SetTexCoord(0, 1, 0, 1)

-- ============================================
-- Затемнение фона
-- ============================================
local blackout = CreateFrame("Frame", nil, UIParent)
blackout:SetAllPoints()
blackout:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
blackout:SetBackdropColor(0, 0, 0, 0.5)
blackout:Hide()
blackout:SetFrameLevel(viewer:GetFrameLevel() - 1)
blackout:EnableMouse(true)
blackout:SetScript("OnMouseDown", function()
    viewer:Hide()
end)

-- При показе окна: затемнение и звук открытия окна персонажа
viewer:SetScript("OnShow", function()
    blackout:Show()
    PlaySoundFile("Sound\\Interface\\CharacterWindowOpen.wav")
end)

viewer:SetScript("OnHide", function()
    blackout:Hide()
end)

-- Клик по текстовой кнопке – показать картинку, скрыть кольцо, открыть окно
for i, btn in ipairs(textButtons) do
    btn:SetScript("OnClick", function()
        local path = "Interface\\AddOns\\IconRing\\" .. locations[i].file
        viewerTexture:SetTexture(path)
        viewer:Show()
        if buttonsVisible then
            ShowButtons(false)
        end
    end)
end


-- ============================================
-- Слаш-команда для скрытия/показа главной кнопки
-- ============================================
SLASH_ICONRING1 = "/ir"
SlashCmdList["ICONRING"] = function()
    if mainButton:IsShown() then
        mainButton:Hide()
        print("|cff00ff00IconRing:|r Главная кнопка скрыта. Чтобы вернуть, введите /ir ещё раз.")
    else
        mainButton:Show()
        print("|cff00ff00IconRing:|r Главная кнопка показана.")
    end
end