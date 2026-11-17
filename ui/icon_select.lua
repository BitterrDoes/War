WAR.ICON_SELECT = {}

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

WAR.UI.create_dummy_avatar = function(_icon, _is_config, pos_x, pos_y, scale)
    _is_config = not not _is_config
    scale = scale or 1
    local icon_key = ((_icon and WAR.ICONS._find(_icon)) and _icon) or WAR.AVATAR.selected or "jimbo"
    local icon_data = WAR.ICONS._find(icon_key, true)
    pos_x = pos_x or 1
    pos_y = pos_y or 1

    local player_has_icon = WAR.AVATAR.is_entitled(icon_key)
    local icon_atlas = player_has_icon and icon_data.atlas or "war_icons_locked"
    local icon_row = player_has_icon and icon_data.row or 0

    -- Following is more or less just how SMODS creates dummy blind chips in the collection
    -- All we need to do is input the icon choice
    scale = scale * 1.3 
    local dummy_chip = SMODS.create_sprite(pos_x, pos_y, scale, scale, icon_atlas, { x = 0, y = icon_row or 0 }) 

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
                end
            end
        end

        WAR.AVATAR.tick_flag = true
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

        if (((WAR.AUTH.state == "logged_in" ) and WAR.AUTH.newly_logged_in) or WAR.AUTH.state == "guest") and WAR.AVATAR.selected == WAR.AVATAR.DEFAULT and not WAR.AVATAR.tick_flag then
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

WAR.UI.create_dummy_icon_card = function(_icon_key, area, has_popup, is_button, scale)
    local icon_key = ((_icon_key and WAR.ICONS._find(_icon_key)) and _icon_key) or WAR.AVATAR.selected or "jimbo"
    scale = scale or 1
    local dummy_sprite = WAR.UI.create_dummy_avatar(icon_key, false, area.T.x + area.T.w/2, area.T.y, scale);
    local card = Card(area.T.x + area.T.w/2, area.T.y, 1.3 * scale, 1.3 * scale, G.P_CARDS.empty, G.P_CENTERS.c_base)

    card.states.drag.can = false
    card.states.hover.can = true
    card.children.center = dummy_sprite
    card.icon_key = icon_key
    dummy_sprite:set_role({major = card, role_type = 'Glued', draw_major = card})
    dummy_sprite.states.drag.can = false
    dummy_sprite.states.hover.can = false
    card.states.drag.can = false
    card.set_sprites = function(...)
        local args = {...}
        if not args[1].animation then return end -- fix for debug unlock
        local c = card.children.center
        Card.set_sprites(...)
        card.children.center = c
    end
    card.states.collide.can = true
    card.config.force_focus = true
    card.hover = function()
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
            if not card.hovering and card.states.visible then
                card.hovering = true
                card.hover_tilt = 3
                card:juice_up(0.05, 0.02)
                play_sound('chips1', math.random() * 0.1 + 0.55, 0.12)
                
                if has_popup then
                    if not card._war_name_popup and WAR.AVATAR.is_entitled(icon_key) then
                        card._war_name_popup = UIBox{
                            definition = create_popup_UIBox_tooltip({ title = WAR.AVATAR.name(icon_key) }),
                            config = { align='tm', offset={x=0, y=-0.1}, parent=card,
                                        instance_type='POPUP', bond='Glued' },
                        }
                        card._war_name_popup.states.collide.can = false
                    end
                    local icon_has_condition = not not WAR.ICONS._find(icon_key, true).achieve
                    if not card._war_cond_popup and icon_has_condition then
                        card._war_cond_popup = UIBox{
                            definition = create_popup_UIBox_tooltip({ title = WAR.AVATAR.describe(icon_key) }),
                            config = { align='bm', offset={x=0, y=0.1}, parent=card,
                                        instance_type='POPUP', bond='Glued' },
                        }
                        card._war_cond_popup.states.collide.can = false
                    end
                end
                
                Node.hover(card)
                if card.children.alert then
                    card.children.alert:remove()
                    card.children.alert = nil
                    card.config.blind.alerted = true
                    G:save_progress()
                end
            end
        end
        card.stop_hover = function()
            for _, k in ipairs({ '_war_name_popup', '_war_cond_popup' }) do
                if card[k] then
                    card[k]:remove()
                    card[k] = nil
                end
            end
            card.hovering = false; Node.stop_hover(card); card.hover_tilt = 0
        end
    end

    if is_button then
        local old_click = card.click;
        card.click = function(self)
            old_click(self)
            
            if not WAR.AVATAR.is_entitled(self.icon_key) then return end
            WAR.AVATAR.save_choice(self.icon_key)
            G.FUNCS.war_refresh_selected_icon_card()
        end
    end

    return card
end

function create_custom_option_cycle(args)
    -- im not gonna lie guys
    -- this is straightup just create_option_cycle but the text refers to a specific table
    -- lmfao

    
  args = args or {}
  args.colour = args.colour or G.C.RED
  args.options = args.options or {
    'Option 1',
    'Option 2'
  }
  args.current_option = args.current_option or 1
  args.current_option_val = args.options[args.current_option]
  args.opt_callback = args.opt_callback or nil
  args.scale = args.scale or 1
  args.ref_table = args.ref_table or nil
  args.ref_value = args.ref_value or nil
  args.w = (args.w or 2.5)*args.scale
  args.h = (args.h or 0.8)*args.scale
  args.text_scale = (args.text_scale or 0.5)*args.scale
  args.l = '<'
  args.r = '>'
  args.focus_args = args.focus_args or {}
  args.focus_args.type = 'cycle'

  local info = nil
  if args.info then 
    info = {}
    for k, v in ipairs(args.info) do 
      table.insert(info, {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
        {n=G.UIT.T, config={text = v, scale = 0.3*args.scale, colour = G.C.UI.TEXT_LIGHT}}
      }})
    end
    info =  {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes=info}
  end

  local disabled = #args.options < 2
  local pips = {}
  for i = 1, #args.options do 
    pips[#pips+1] = {n=G.UIT.B, config={w = 0.1*args.scale, h = 0.1*args.scale, r = 0.05, id = 'pip_'..i, colour = args.current_option == i and G.C.WHITE or G.C.BLACK}}
  end
  
  local choice_pips = not args.no_pips and {n=G.UIT.R, config={align = "cm", padding = (0.05 - (#args.options > 15 and 0.03 or 0))*args.scale}, nodes=pips} or nil

  local t = 
        {n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, id = args.id and (not args.label and args.id or nil) or nil, focus_args = args.focus_args}, nodes={
          {n=G.UIT.C, config={align = "cm",r = 0.1, minw = 0.6*args.scale, hover = not disabled, colour = not disabled and args.colour or G.C.BLACK,shadow = not disabled, button = not disabled and 'option_cycle' or nil, ref_table = args, ref_value = 'l', focus_args = {type = 'none'}}, nodes={
            {n=G.UIT.T, config={ref_table = args, ref_value = 'l', scale = args.text_scale, colour = not disabled and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_INACTIVE}}
          }},
          args.mid and
          {n=G.UIT.C, config={id = 'cycle_main'}, nodes={
              {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
                args.mid
              }},
              not disabled and choice_pips or nil
          }}
          or {n=G.UIT.C, config={id = 'cycle_main', align = "cm", minw = args.w, minh = args.h, r = 0.1, padding = 0.05, colour = args.colour,emboss = 0.1, hover = true, can_collide = true, on_demand_tooltip = args.on_demand_tooltip}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = args.ref_table, ref_value = args.ref_value}}, colours = {G.C.UI.TEXT_LIGHT},pop_in = 0, pop_in_rate = 8, reset_pop_in = true,shadow = true, float = true, silent = true, bump = true, scale = args.text_scale, non_recalc = true})}},
              }},
              {n=G.UIT.R, config={align = "cm", minh = 0.05}, nodes={
              }},
              not disabled and choice_pips or nil
            }}
          }},
          {n=G.UIT.C, config={align = "cm",r = 0.1, minw = 0.6*args.scale, hover = not disabled, colour = not disabled and args.colour or G.C.BLACK,shadow = not disabled, button = not disabled and 'option_cycle' or nil, ref_table = args, ref_value = 'r', focus_args = {type = 'none'}}, nodes={
            {n=G.UIT.T, config={ref_table = args, ref_value = 'r', scale = args.text_scale, colour = not disabled and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_INACTIVE}}
          }},
        }}

  if args.cycle_shoulders then 
    t =    
    {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR}, nodes = {
      {n=G.UIT.C, config={minw = 0.7,align = "cm", colour = G.C.CLEAR,func = 'set_button_pip', focus_args = {button = 'leftshoulder', type = 'none', orientation = 'cm', scale = 0.7, offset = {x = -0.1, y = 0}}}, nodes = {}},
      {n=G.UIT.C, config={id = 'cycle_shoulders', padding = 0.1}, nodes={t}},
      {n=G.UIT.C, config={minw = 0.7,align = "cm", colour = G.C.CLEAR,func = 'set_button_pip', focus_args = {button = 'rightshoulder', type = 'none', orientation = 'cm', scale = 0.7, offset = {x = 0.1, y = 0}}}, nodes = {}},
    }}
  else
    t = 
    {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.0}, nodes = {
      t
    }}
  end
  if args.label or args.info then 
    t = {n=G.UIT.R, config={align = "cm", padding = 0.05, id = args.id or nil}, nodes={
      args.label and {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.T, config={text = args.label, scale = 0.5*args.scale, colour = G.C.UI.TEXT_LIGHT}}
      }} or nil,
      t,
      info,
    }}
  end
  return t
end

function G.FUNCS.war_open_icon_select()
    -- Configuration for icon select pages
    WAR.ICON_SELECT = WAR.ICON_SELECT or {}
    WAR.ICON_SELECT.config = WAR.ICON_SELECT.config or {
        page_options = { "Free", "Special", "Achievement" },
        viewing_type = 1,
        icon_page = 1
    }

    WAR.ICON_SELECT.config.viewing_type = 1
    WAR.ICON_SELECT.config.icon_page = 1
    WAR.ICON_SELECT.page_text = "Page 1"
    WAR.ICON_SELECT.current_icon_name = WAR.AVATAR.name(WAR.AVATAR.DEFAULT)
    WAR.ICON_SELECT.current_icon_description = ""

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

    WAR.ICON_SELECT.icon_cache = {}
    WAR.ICON_SELECT.icon_cache.free = free_list;
    WAR.ICON_SELECT.icon_cache.achievement = ach_list;
    WAR.ICON_SELECT.icon_cache.special = special_list;
    WAR.ICON_SELECT.rows = 4;
    WAR.ICON_SELECT.columns = 6;

    WAR.ICON_SELECT.your_icon = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h, 1.55, 1.55,
			{ card_limit = 1, type = 'title_2', highlight_limit = 0, collection = true })
    
    local viewing_type = string.lower(WAR.ICON_SELECT.config.page_options[WAR.ICON_SELECT.config.viewing_type])
    local rows, columns = WAR.ICON_SELECT.rows, WAR.ICON_SELECT.columns
    local current_page_options = {}
    local page_limit = math.ceil((#WAR.ICON_SELECT.icon_cache[viewing_type])/(rows*columns))
    for i = 1, page_limit do
        current_page_options[#current_page_options+1] = localize("war_page") .. " " .. i
    end

    WAR.ICON_SELECT.page_options = current_page_options

    G.your_collection = {}
	local deck_tables = {}
	for j = 1, rows do
		G.your_collection[j] = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h,
			columns * 1.55,
			0.95 * 1.33,
			{ card_limit = columns, type = 'title_2', highlight_limit = 0, collection = true })
		table.insert(deck_tables,
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0, no_fill = true },
				nodes = {
					j%2 == 0 and { n = G.UIT.B, config = { h = 0.2, w = 0.5 } } or nil,
					{ n = G.UIT.O, config = { object = G.your_collection[j] } },
					j%2 == 1 and { n = G.UIT.B, config = { h = 0.2, w = 0.5 } } or nil,
				}
			}
		)
	end

    -- This will hold a preview of the selected icon & whatnot
    local player_holder = {
        n = G.UIT.C,
        config = { minw = 3, minh = 7.8, r = 0.1, padding = 0.1, colour = G.C.BLACK, align = "cm" },
        nodes = {}
    }

    local profile_info = {
        n = G.UIT.R,
        config = { r = 0.1, minw = 2.8, minh=2.8, align = "cm", padding = 0.1, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.R, config = { minw = 2.8, minh = 0.2, align = "cm", padding = 0.05, colour = G.C.CLEAR },
                nodes = {
                    { 
                        n = G.UIT.T, 
                        config = { 
                            text   = localize("war_current_icon"),
                            scale  = 0.3,
                            colour = G.C.L_BLACK, 
                            shadow = true 
                        }
                    }
                }
            },
            {
                n = G.UIT.R, config = { minw = 2.8, minh = 0.6, align = "tm", padding = 0.05, colour = G.C.CLEAR },
                nodes = {
                    { 
                        n = G.UIT.T, 
                        config = { 
                            ref_table = WAR.ICON_SELECT,
                            ref_value = "current_icon_name",
                            scale  = 0.4,
                            colour = G.C.WHITE,
                            shadow = true 
                        }
                    }
                }
            },
            {
                n = G.UIT.R, config = { minw = 2.8, minh = 1.6, align = "cm", padding = 0.05, colour = G.C.CLEAR },
                nodes = { 
                    {
                        n = G.UIT.O,
                        config = { object = WAR.ICON_SELECT.your_icon }
                    }
                }
            },
            {
                n = G.UIT.R, config = { minw = 2.8, minh = 0.4, align = "cm", padding = 0.05, colour = G.C.CLEAR },
                nodes = {}
            }
        }
    }

    player_holder.nodes = { profile_info }

    -- This will hold the actual icons
    local icon_select_holder = {
        n = G.UIT.C,
        config = { minw = 9.8, minh = 7.8, r = 0.1, padding = 0.1, colour = G.C.BLACK, align = "cm" },
        nodes = {}
    }

    local icon_select_type_select = {
        n = G.UIT.R,
        config = { minw = 9.6, minh = 0.5, r = 0.1, padding = 0.1, colour = G.C.BLACK, align = "cm" },
        nodes = {
            create_option_cycle({
                options = WAR.ICON_SELECT.config.page_options,
                w = 4.5,
                cycle_shoulders = true,
                opt_callback = 'war_icon_select_page',
                focus_args = {snap_to = true, nav = 'wide'},
                current_option = WAR.ICON_SELECT.viewing_type,
                colour = G.C.RED,
                no_pips = true,
                _category = "icon_type"
            })
        }
    }

    local icon_select_icons = {
        n = G.UIT.R,
        config = { minh = 6, minw = 9.6, r = 0.1, padding = 0.1, colour = G.C.L_BLACK, align = "cm" },
        nodes = deck_tables
    }

    local icon_select_page_number = {
        n = G.UIT.R,
        config = { minh = 0.5, minw = 9.6, r = 0.1, paddingg = 0.1, colour = G.C.BLACK, align = "cm" },
        nodes = {
            create_custom_option_cycle({
                options = current_page_options,
                w = 4.5,
                cycle_shoulders = true,
                opt_callback = 'war_icon_select_page',
                focus_args = {snap_to = true, nav = 'wide'},
                current_option = WAR.ICON_SELECT.icon_page,
                colour = G.C.RED,
                no_pips = true,
                ref_table = WAR.ICON_SELECT, ref_value = "page_text",
                _category = "icon_page"
            })
        }
    }

    icon_select_holder.nodes = { icon_select_type_select, icon_select_icons, icon_select_page_number }

    -- Proper UI holder
    local ui_definition = {
        n = G.UIT.R,
        config = { minw = 12, minh = 8, r = 0.1, padding = 0.1, colour = G.C.CLEAR, align = "cm" },
        nodes = { player_holder, icon_select_holder }
    }

    -- UIBox definition
    local ui_box = {
        n = G.UIT.ROOT,
        config = { minw = 12, minh = 9, r = 0.1, padding = 0.1, colour = G.C.CLEAR, align = "cm" },
        nodes = {
            create_UIBox_generic_options({
                contents = { ui_definition }
            })
        }
    };

    G.FUNCS.war_icon_select_page()
    G.FUNCS.war_refresh_selected_icon_card()

    -- Return definition
    G.FUNCS.overlay_menu({ definition = ui_box })
end

function G.FUNCS.war_refresh_selected_icon_card()
    if #WAR.ICON_SELECT.your_icon.cards == 0 then
        local dummy_selected = WAR.UI.create_dummy_icon_card(nil, WAR.ICON_SELECT.your_icon, false, false, 1.6)
        WAR.ICON_SELECT.your_icon:emplace(dummy_selected)
    end
    
    local dummy_sprite = WAR.UI.create_dummy_avatar(nil, false, WAR.ICON_SELECT.your_icon.T.x, WAR.ICON_SELECT.your_icon.T.y, 1.6);
    dummy_sprite:set_role({major = WAR.ICON_SELECT.your_icon.cards[1], role_type = 'Glued', draw_major = WAR.ICON_SELECT.your_icon.cards[1]})
    dummy_sprite.states.drag.can = false
    dummy_sprite.states.hover.can = false
    WAR.ICON_SELECT.your_icon.cards[1].children.center:remove()
    WAR.ICON_SELECT.your_icon.cards[1].children.center = nil
    WAR.ICON_SELECT.your_icon.cards[1].children.center = dummy_sprite
    
    WAR.ICON_SELECT.current_icon_name = WAR.AVATAR.name(WAR.AVATAR.selected)
    WAR.ICON_SELECT.your_icon.cards[1]:juice_up(0.3, 0.3)
end

function G.FUNCS.war_icon_select_page(args)
	if args and args.cycle_config then
        if not args.cycle_config._category then return end
        if args.cycle_config._category == "icon_type" then
            WAR.ICON_SELECT.config.viewing_type = args.cycle_config.current_option
            WAR.ICON_SELECT.config.icon_page = 1
        elseif args.cycle_config._category == "icon_page" then
            WAR.ICON_SELECT.config.icon_page = args.cycle_config.current_option
        end
    end

    WAR.ICON_SELECT.page_text = localize("war_page") .. " ".. WAR.ICON_SELECT.config.icon_page

    -- Empty collection
    for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards, 1, -1 do
			local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
			c:remove()
			c = nil
		end
	end

    -- Fill collection
    local current_type = string.lower(WAR.ICON_SELECT.config.page_options[WAR.ICON_SELECT.config.viewing_type])
    local current_icons = WAR.ICON_SELECT.icon_cache[current_type]
    local page_id = WAR.ICON_SELECT.config.icon_page
    local page_size = WAR.ICON_SELECT.rows * WAR.ICON_SELECT.columns
    if not current_icons then return end
    for i = (page_id-1)*page_size + 1, (page_id*page_size) + 1 do
        if current_icons[i] then
            local normalized_id = i - (24*(page_id-1))
            local to_area = math.ceil(normalized_id / 6)
            if G.your_collection[to_area] then
                local dummy_icon = WAR.UI.create_dummy_icon_card(current_icons[i].key, G.your_collection[to_area], true, true)
                
                G.your_collection[to_area]:emplace(dummy_icon)
            end
        end
    end

    
    for _, area in ipairs(G.your_collection) do
        area.config.card_limit = #area.cards
        area.width = #area.cards * 1.55
    end

    print(#WAR.ICON_SELECT.your_icon.cards)
end