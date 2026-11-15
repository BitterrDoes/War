-- This will be moved to another file if necessary
WAR.ICONS._find = function(icon, get)
    get = not not get
    for _, v in ipairs(WAR.ICONS) do
        if v.key == icon then
            return (get and v) or v.key
        end
    end

    return false
end

WAR.UI.create_dummy_avatar = function(_icon, _is_config)
    _is_config = not not _is_config
    local icon_key = (_icon and WAR.ICONS._find(_icon)) or WAR.AVATAR.selected or "jimbo"
    local icon_data = WAR.ICONS._find(icon_key, true)

    -- Following is more or less just how SMODS creates dummy blind chips in the collection
    -- All we need to do is input the icon choice
    local scale = 1.3
    local dummy_chip = SMODS.create_sprite(0, 0, scale, scale, icon_data.atlas, { x = 0, y = icon_data.row or 0 }) 

    dummy_chip:define_draw_steps({
        {shader = 'dissolve', shadow_height = 0.05},
        {shader = 'dissolve'}
    })
    
    dummy_chip.float = true
    dummy_chip.states.hover.can = true
    dummy_chip.states.drag.can = false
    dummy_chip.states.collide.can = true
    dummy_chip.config = { force_focus = true }
    dummy_chip.hover = function()
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not dummy_chip.hovering and dummy_chip.states.visible then
                dummy_chip.hovering = true
                dummy_chip.hover_tilt = 1
                dummy_chip:juice_up(0.05, 0.02)
                play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                Node.hover(dummy_chip)

                if dummy_chip.children.alert then 
                    dummy_chip.children.alert:remove(); 
                    dummy_chip.children.alert = nil;
                    WAR.AVATAR.tick_flag = true
                end
            end
        end
    end
    
    dummy_chip.stop_hover = function() 
        dummy_chip.hovering = false;
        Node.stop_hover(dummy_chip);
        dummy_chip.hover_tilt = 0;
    end

    if _is_config then
        -- Override the draw function for the sprite
        local _pre_draw = dummy_chip.draw;
        dummy_chip.draw = function(_self, overlay)
            _pre_draw(_self, overlay);
            if _self.states.hover.is and not _self.children.icon_select then 
                _self.children.icon_select = UIBox{
                    definition = 
                        {n=G.UIT.ROOT, config = {align = 'cm', padding = 0.1, r =0.1, colour = G.C.CLEAR, func = 'set_button_pip', focus_args = {button = 'triggerright', orientation = 'bm', scale = 0.6}}, nodes={
                            {n=G.UIT.R, config={align = "cm", padding = 0.05, r =0.1, colour = adjust_alpha(G.C.BLACK, 0.67), minw = 1.4, minh = 1.4}, nodes={
                                {n=G.UIT.R, config={align = "cm", minw = 1.4}, nodes={
                                    {n=G.UIT.T, config={text = localize('war_click_to'), scale = 0.48, colour = G.C.WHITE, shadow = true}}
                                }},
                                {n=G.UIT.R, config={align = "cm", minw = 1.4}, nodes={
                                    {n=G.UIT.T, config={text = localize('war_customize'), scale = 0.38, colour = G.C.WHITE, shadow = true}}
                                }},
                            }},
                        }},
                    config = { align = 'cm', offset = {x=0,y=0}, major = _self, parent = _self}
                }
                _self.children.icon_select.states.collide.can = false
            end
            if not _self.states.hover.is and _self.children.icon_select then _self.children.icon_select:remove(); _self.children.icon_select = nil end
        end

        local _pre_click = dummy_chip.click;
        dummy_chip.click = function(_self)
            _pre_click(_self);

            G.E_MANAGER:add_event(Event({
                trigger = "after", delay = 0, blockable = false,
                func = function() G.FUNCS.war_open_icon_select({}); return true end,
            }))
        end

        if (WAR.AUTH.state == "idle" or WAR.AUTH.newly_logged_in) or WAR.AUTH.state == "guest" and WAR.AVATAR.selected == WAR.AVATAR.DEFAULT and not WAR.AVATAR.tick_flag then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    dummy_chip.children.alert = UIBox{
                        definition = create_UIBox_card_alert(), 
                        config = { align="tri", offset = {x = 0.1, y = 0.1}, parent = dummy_chip }
                    }
                    dummy_chip.children.alert.states.collide.can = false
                    return true
                end)
            }))
        end
    end

    return dummy_chip;
end