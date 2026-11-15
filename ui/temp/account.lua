function G.UIDEF.war_account_screen()
    local name      = WAR.AUTH.user or localize('war_guest_display_name')
    local logged_in = WAR.AUTH.state == "logged_in"

    -- Gonna break this up again for ease of readability
    local ui_definition = {
        n = G.UIT.ROOT,
        config = { r = 0.1, minw = 5, minh = 6, align = "cm", padding = 0.1, colour = G.C.CLEAR },
    }

    local management = {
        n = G.UIT.R,
        config = { r = 0.1, minw = 5, minh = 6, align = "cm", padding = 0.1, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.C,
                config = { r = 0.1, minw = 6, minh = 6, align = "tm", padding = 0.1, colour = G.C.CLEAR },
            }
        }
    }

    local logged_in_text = {
        n = G.UIT.R,
        config = { r = 0.1, minw = 5, align = "cm", padding = 0, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.T,
                config = { 
                    text   = (WAR.AUTH.state == "logged_in") and localize('war_signed_in_as') or localize('war_not_logged_in'), 
                    scale  = 0.35,
                    colour = G.C.UI.TEXT_INACTIVE,
                    shadow = false 
                }
            }
        }
    }

    local profile_info = {
        n = G.UIT.R,
        config = { r = 0.1, minw = 4.4, align = "cm", padding = 0.1, colour = G.C.BLACK },
        nodes = {
            {
                n = G.UIT.R, config = { minw = 2.8, minh = 0.4, align = "cm", padding = 0.05, colour = G.C.CLEAR },
                nodes = {
                    { 
                        n = G.UIT.T, 
                        config = { 
                            text   = (WAR.AUTH.state == "logged_in") and WAR.AUTH.user or localize('war_guest_display_name'), 
                            scale  = 0.5,
                            colour = G.C.GOLD, 
                            shadow = true 
                        }
                    }
                }
            },
            {
                n = G.UIT.R, config = { minw = 2.8, minh = 1.2, align = "cm", padding = 0.05, colour = G.C.CLEAR },
                nodes = { 
                    {
                        n = G.UIT.O,
                        config = { object = WAR.UI.create_dummy_avatar(nil, true) }
                    }
                }
            }
        }
    }

    local menu_options = {
        n = G.UIT.R,
        config = { r = 0.2, minw = 5, padding = 0.1, colour = G.C.CLEAR, align = "cm" },
        nodes = {}
    }
    if not logged_in then
        menu_options.nodes[#menu_options.nodes+1] = {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = {
                UIBox_button({ label={localize('war_log_in')},   button="war_open_login",
                colour=G.C.BLUE,  minw=2.2 })
            }
        }
        menu_options.nodes[#menu_options.nodes+1] = {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = {
                UIBox_button({ label={localize('war_register')}, button="war_open_register",
                colour=G.C.GREEN, minw=2.2 })
            }
        }
    else
        menu_options.nodes[#menu_options.nodes+1] = UIBox_button({ label={localize('war_log_out')}, button="war_confirm_logout",
            colour=G.C.RED, minw=3.4 })
    end

    local nodes = { logged_in_text, profile_info, menu_options }

    return create_UIBox_generic_options({ contents = nodes })
end