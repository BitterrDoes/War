-- ui/icon_select.lua

local COLS = 8
local CHIP = 0.8

local function _icon_spr(atlas_key, row)
    local atlas = G.ANIMATION_ATLAS and G.ANIMATION_ATLAS[atlas_key]
    if not atlas then return nil end
    local ok, spr = pcall(AnimatedSprite, 0, 0, CHIP, CHIP, atlas, { x=0, y=row })
    if not ok or not spr then return nil end
    spr:define_draw_steps({ {shader="dissolve", shadow_height=0.05}, {shader="dissolve"} })
    spr.states.drag.can    = false
    spr.states.collide.can = false
    return spr
end

-- Cells that have been wired with hover popups, kept so clear_icon_tips can
-- reach them when the screen is closed from outside hover.
local _wired = {}

WAR.UI.clear_icon_tips = function()
    for _, cell in ipairs(_wired) do
        for _, k in ipairs({ '_war_name_popup', '_war_cond_popup' }) do
            if cell[k] then
                pcall(function() cell[k]:remove() end)
                cell[k] = nil
            end
        end
    end
    _wired = {}
end

-- Mirrors Node:hover()'s h_popup pattern exactly, but with two entries stored
-- as plain fields (_war_name_popup / _war_cond_popup) instead of cell.children.
-- Using cell.children would cause UIElement:draw_children() to draw them during
-- the overlay pass and set UIBox.FRAME.DRAW, so the G.I.POPUP pass would skip
-- them (the per-frame draw guard). Plain fields bypass draw_children entirely;
-- the boxes draw once, in the POPUP pass, on top of the overlay.
local function _wire_ach_hovers()
    if not G.OVERLAY_MENU or not G.OVERLAY_MENU.get_UIE_by_ID then return end
    for _, icon in ipairs(WAR.AVATAR.by_kind("achievement")) do
        local cell = G.OVERLAY_MENU:get_UIE_by_ID("war_icon_cell_" .. icon.key)
        if cell and not cell._war_tips then
            cell._war_tips = true
            _wired[#_wired + 1] = cell

            local base_hover = cell.hover
            local base_stop  = cell.stop_hover

            cell.hover = function(self)
                if base_hover then base_hover(self) end
                if not self._war_name_popup then
                    self._war_name_popup = UIBox{
                        definition = create_popup_UIBox_tooltip({ title = WAR.AVATAR.name(icon.key) }),
                        config = { align='tm', offset={x=0, y=-0.1}, parent=self,
                                   instance_type='POPUP', bond='Glued' },
                    }
                    self._war_name_popup.states.collide.can = false
                end
                if not self._war_cond_popup then
                    self._war_cond_popup = UIBox{
                        definition = create_popup_UIBox_tooltip({ title = WAR.AVATAR.describe(icon.key) }),
                        config = { align='bm', offset={x=0, y=0.1}, parent=self,
                                   instance_type='POPUP', bond='Glued' },
                    }
                    self._war_cond_popup.states.collide.can = false
                end
            end

            cell.stop_hover = function(self)
                for _, k in ipairs({ '_war_name_popup', '_war_cond_popup' }) do
                    if self[k] then
                        self[k]:remove()
                        self[k] = nil
                    end
                end
                if base_stop then base_stop(self) end
            end
        end
    end
end

local function icon_cell(icon, selected)
    local entitled = WAR.AVATAR.is_entitled(icon.key)

    if icon.achieve and not entitled then
        local locked_spr = _icon_spr("war_icons_locked", 0)
        local inner = locked_spr
            and { n=G.UIT.O, config={ object=locked_spr } }
            or  { n=G.UIT.B, config={ w=CHIP, h=CHIP } }
        return { n=G.UIT.C, config={
            id      = "war_icon_cell_" .. icon.key,
            align   = "cm", r=0.08, padding=0.06,
            colour  = { 0, 0, 0, 0 },
            hover   = true,
            can_collide = true,
        }, nodes={ inner }}
    end

    local spr = _icon_spr(icon.atlas or "war_icons_free", icon.row or 0)
    local inner = spr
        and { n=G.UIT.O, config={ object=spr } }
        or  { n=G.UIT.B, config={ w=CHIP, h=CHIP } }

    return { n=G.UIT.C, config={
        id        = "war_icon_cell_" .. icon.key,
        align     = "cm", r=0.08, padding=0.06,
        colour    = selected and {0.18, 0.55, 0.18, 1} or {0, 0, 0, 0},
        emboss    = selected and 0.08 or nil,
        hover     = true,
        button    = "war_select_icon",
        tooltip   = (not icon.achieve) and { title = WAR.AVATAR.name(icon.key) } or nil,
        can_collide = icon.achieve or nil,
        ref_table = { icon_key = icon.key },
        ref_value = "icon_key",
    }, nodes={ inner }}
end

local function build_page(icons_list)
    local rows, row = {}, nil
    for i, icon in ipairs(icons_list) do
        if (i - 1) % COLS == 0 then row = {}; rows[#rows+1] = row end
        row[#row+1] = icon_cell(icon, WAR.AVATAR.selected == icon.key)
    end
    local row_nodes = {}
    for _, r in ipairs(rows) do
        row_nodes[#row_nodes+1] = { n=G.UIT.R, config={ align="cm" }, nodes=r }
    end
    if not row_nodes[1] then
        row_nodes[1] = { n=G.UIT.R, config={ align="cm" }, nodes={
            { n=G.UIT.T, config={ text=localize("war_none") or "None", scale=0.4,
                colour=G.C.UI.TEXT_INACTIVE } }
        }}
    end
    return { n=G.UIT.ROOT, config={
        emboss=0.05, minh=4, r=0.1, minw=10,
        align="tm", padding=0.2, colour=G.C.BLACK,
    }, nodes={
        { n=G.UIT.R, config={ align="cm", r=0.1, colour=G.C.BLACK, padding=0.1, emboss=0.05 },
          nodes=row_nodes },
    }}
end

function G.UIDEF.war_icon_select()
    local free_list    = WAR.AVATAR.by_kind("free")
    local ach_list     = WAR.AVATAR.by_kind("achievement")
    local special_list = {}
    local logged_in    = WAR.AUTH and WAR.AUTH.state == "logged_in"

    -- Specials only exist for accounts that were granted them.
    for _, icon in ipairs(WAR.AVATAR.by_kind("special")) do
        if WAR.AVATAR.is_entitled(icon.key) then
            special_list[#special_list+1] = icon
        end
    end

    local tabs = {
        { label  = localize("war_tab_icons_free"),
          chosen = true,
          tab_definition_function = function() return build_page(free_list) end },
        { label  = localize("war_tab_icons_achievement"),
          tab_definition_function = function() return build_page(ach_list) end },
    }
    if logged_in and #special_list > 0 then
        tabs[#tabs+1] = {
            label  = localize("war_tab_icons_special"),
            tab_definition_function = function() return build_page(special_list) end,
        }
    end

    return create_UIBox_generic_options({
        back_func = "war_back_to_config",
        contents = {
            { n=G.UIT.C, config={ align="cm", padding=0 }, nodes={
                create_tabs({ colour=G.C.BOOSTER, tabs=tabs }),
            }},
        },
    })
end

-- Vanilla builds a tab's contents only when it is selected, so the wiring has to
-- run again on every tab change as well as on open.
local _base_change_tab = G.FUNCS.change_tab
if _base_change_tab then
    G.FUNCS.change_tab = function(e)
        _base_change_tab(e)
        WAR.UI.clear_icon_tips()
        _wire_ach_hovers()
    end
end

G.FUNCS.war_open_icon_select = function(e)
    WAR.UI.clear_icon_tips()
    WAR.UI.open_instant(G.UIDEF.war_icon_select())
    _wire_ach_hovers()
end

G.FUNCS.war_select_icon = function(e)
    local key = e.config.ref_table and e.config.ref_table.icon_key
    if not key then return end
    if not WAR.AVATAR.is_entitled(key) then return end
    WAR.UI.clear_icon_tips()
    WAR.AVATAR.save_choice(key)

    local repainted = false
    for _, icon in ipairs(WAR.ICONS) do
        local cell = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("war_icon_cell_" .. icon.key)
        if cell then
            local sel = (icon.key == key)
            cell.config.colour = sel and {0.18, 0.55, 0.18, 1} or {0, 0, 0, 0}
            cell.config.emboss = sel and 0.08 or nil
            repainted = true
        end
    end
    if not repainted then
        WAR.UI.open_instant(G.UIDEF.war_icon_select())
        _wire_ach_hovers()
    end
end

WAR.log("[WAR] ui/icon_select loaded")
