-- War mod localisation — Russian (ru) by TheOneGoofAli
-- All user-visible strings live here; UI files call localize('war_key').
-- SMODS merges this into G.localization at load time.

return {
    -- SMODS object descriptions
    descriptions = {
        Mod = {
            War = {
                name = "War",
                text = {
                    "Наилучший PvP в Balatro",
                },
            },
        },
        -- Player icons (see WAR.ICONS in core/avatar.lua).
        -- No individual names — all display as "Your Rival" and are replaced
        -- in-run with the actual rival username.
        WAR_Icon = {
            -- Free
            war_icon_jimbo            = { name = "Джимбо", },
            war_icon_blueprint        = { name = "Чертёж" },
            war_icon_brainstorm       = { name = "Мозговой штурм" },
            war_icon_verity           = { name = "Верити" },
            war_icon_sock_and_buskin  = { name = "Трагедия и комедия" },
            war_icon_photograph       = { name = "Фотография" },
            war_icon_drool            = { name = "Слюни" },
            war_icon_stencil          = { name = "Трафарет" },
            war_icon_spades           = { name = "Пики" },
            war_icon_hearts           = { name = "Червы" },
            war_icon_clubs            = { name = "Трефы" },
            war_icon_diamonds         = { name = "Бубны" },
            war_icon_spades_hc        = { name = "Пики (Повышенный контраст)" },
            war_icon_hearts_hc        = { name = "Червы (Повышенный контраст)" },
            war_icon_clubs_hc         = { name = "Трефы (Повышенный контраст)" },
            war_icon_diamonds_hc      = { name = "Бубны (Повышенный контраст)" },
            war_icon_ralsei           = { name = "Ральзей" },
            war_icon_eight_ball       = { name = "Магический шар" },
            war_icon_even_steven      = { name = "Стивен Чётный" },
            war_icon_odd_todd         = { name = "Тодд Нечётный" },
            war_icon_missing          = { name = "Потерянный" },
            war_icon_azure            = { name = "Синева" },
            war_icon_flowery          = { name = "Флаури" },
            war_icon_pig              = { name = "Свинья" },
            war_icon_persona          = { name = "Персона" },
            war_icon_raised_fist      = { name = "Поднятый кулак" },
            war_icon_popcorn          = { name = "Попкорн" },
            war_icon_gift_card        = { name = "Подарочная карта" },
            war_icon_stamp            = { name = "Штамп" },
            war_icon_superposition    = { name = "Суперпозиция" },
            war_icon_fibonacci        = { name = "Фибоначчи" },
            war_icon_scholar          = { name = "Учёный" },
            war_icon_ride_the_bus     = { name = "Автобусный тур" },
            war_icon_pareidolia       = { name = "Парейдолия" },
            war_icon_brutalists_heart = { name = "Сердце бруталиста" },
            war_icon_chud             = { name = "Чуд" },
            war_icon_sob              = { name = "Рыдание" },
            war_icon_tasque_manager   = { name = "Таск-менеджер" },
            war_icon_mizzle           = { name = "Миззл" },
            war_icon_ironclad         = { name = "Несокрушимый" },
            war_icon_rodeo_abandoned_by_god = { name = "Родео, Покинутое Богом" },
            war_icon_three_cheers_one = { name = "Троекратное Ура (Один)" },
            war_icon_three_cheers_two = { name = "Троекратное Ура (Два)" },

            -- Achievement
            war_icon_jolly            = { name = "Весёлый", text = { "Выиграй партию, не сыграв ни одной руки с Парой" } }, -- in vanilla this is Pair, Two Pair, Three of a Kind, Full House, Four of a Kind, Five of a Kind, Flush House, Flush Five and sometimes Flush
            war_icon_oops             = { name = "Упс", text = { "Проделайте 25 успешних шансов в одной партии" } },
            war_icon_droll            = { name = "Слюни", text = { "Выиграй партию, используя только руки с Флешем" } }, -- in vanilla this is Flush, Straight Flush, Flush House and Flush Five
            war_icon_meta             = { name = "Мета", text = { "Сыграй 100 матчей" } },
            war_icon_brilliant        = { name = "Великолепно", text = { "Выиграй 10 партий" } },
            war_icon_blunder          = { name = "Прокол", text = { "Проиграй 10 партий" } },
            war_icon_the_soul         = { name = "Душа", text = { "Используй Душу в партии" } },
            war_icon_oneshot          = { name = "OneShot", text = { "Используй Солнце 100 раз" } }, -- the tarot, should work across matches like all the other count ones
            war_icon_egg              = { name = "Яйцо", text = { "Продай Яйцо, которое стоит $15 или больше" } },
            war_icon_bloodstone       = { name = "Гелиотроп", text = { "Подсчитай 100 карт с мастью Червы" } },
            war_icon_pizza            = { name = "Пицца", text = { "Подсчитай 250 карт с Красной или Золотой печатью" } }, -- scored, so retriggers don't double count
            war_icon_riff_raff        = { name = "Сомнительная компания", text = { "Выиграй партию, используя только Обычные Джокеры" } },
            war_icon_garygpt          = { name = "ГарриGPT", text = { "Уничтожь Всплеск Джокер в матче" } }, -- not selling, specifically something like dagger/madness
            war_icon_missing_joker    = { name = "Потерянный Джокер", text = { "Выиграй партию, не заполнив все слоты Джокеров" } }, -- ie always playing with #OfJokerSlots>#OfOwnedJokers
            war_icon_cola             = { name = "Кола", text = { "Имей 5 тэгов за раз в партии" } },
            war_icon_osage            = { name = "Осейдж", text = { "Подсчитай 1000 Каменных карт" } }, -- just 10x the stone card icon unlock
            war_icon_stone            = { name = "Камень", text = { "Подсчитай 100 Каменных карт" } },
            war_icon_gold             = { name = "Золото", text = { "Активируй эффект Золотых карт 100 раз" } }, -- them paying out 100 times
            war_icon_steel            = { name = "Сталь", text = { "Активируй эффект Стальных карт 100 раз" } }, -- them triggering while held in hand 100 times
            war_icon_wild             = { name = "Дикий", text = { "Подсчитай 100 Диких карт" } },
            war_icon_mult             = { name = "Множитель", text = { "Подсчитай 100 карт с множителем" } },
            war_icon_lucky            = { name = "Счастливый", text = { "Активируй эффект Счастливых карт 100 раз" } }, -- the mult or money triggers
            war_icon_white_stake      = { name = "White ставка", text = { "Сыграй 10 матчей на Белой ставке" } },
            war_icon_red_stake        = { name = "Красная ставка", text = { "Сыграй 10 матчей на Красной ставке" } },
            war_icon_green_stake      = { name = "Зелёная ставка", text = { "Сыграй 10 матчей на Зелёной ставке" } },
            war_icon_blue_stake       = { name = "Синия ставка", text = { "Сыграй 10 матчей на Синей ставке" } },
            war_icon_black_stake      = { name = "Чёрная ставка", text = { "Сыграй 10 матчей на Чёрной ставке" } },
            war_icon_purple_stake     = { name = "Фиолетовая ставка", text = { "Сыграй 10 матчей на Фиолетовой ставке" } },
            war_icon_orange_stake     = { name = "Оранжевая ставка", text = { "Сыграй 10 матчей на Оранжевой ставке" } },
            war_icon_gold_stake       = { name = "Золотая ставка", text = { "Сыграй 10 матчей на Золотой ставке" } },
            war_icon_jimbo_stake      = { name = "Джимбо ставка", text = { "Сыграй 10 матчей на каждой ванильной ставке" } },
            war_icon_red_deck         = { name = "Красная колода", text = { "Сыграй 10 матчей с Красной колодой" } },
            war_icon_blue_deck        = { name = "Синия колода", text = { "Сыграй 10 матчей с Синей колодой" } },
            war_icon_yellow_deck      = { name = "Жёлтая колода", text = { "Сыграй 10 матчей с Жёлтой колодой" } },
            war_icon_green_deck       = { name = "Зелёная колода", text = { "Сыграй 10 матчей с Зелёной колодой" } },
            war_icon_black_deck       = { name = "Чёрная колода", text = { "Сыграй 10 матчей с Чёрной колодой" } },
            war_icon_ghost_deck       = { name = "Призрачная колода", text = { "Сыграй 10 матчей с Призрачной колодой" } },
            war_icon_painted_deck     = { name = "Рисованная колода", text = { "Сыграй 10 матчей с Рисованной колодой" } },
            war_icon_plasma_deck      = { name = "Плазменная колода", text = { "Сыграй 10 матчей с Плазменной колодой" } },
            war_icon_red_seal         = { name = "Красная печать", text = { "Активируй Красную печать 100 раз" } }, -- having it retrigger a card 100 times
            war_icon_blue_seal        = { name = "Синия печать", text = { "Активируй Синию печать 100 раз" } }, -- getting a planet from it 100 times
            war_icon_gold_seal        = { name = "Золотая печать", text = { "Активируй Золотую печать 100 раз" } }, -- getting the money from it 100 times
            war_icon_purple_seal      = { name = "Фиолетовая печать", text = { "Активируй Фиолетовую печать 100 раз" } }, -- getting the tarot from one 100 times
            war_icon_eyes             = { name = "Глаза", text = { ">смотрит внутрь" } }, -- have both photograph and hanging chad at the same time waow
            war_icon_hack             = { name = "Паяц", text = { "Переподсчитай c достоиноством 2-5 20 раз за один матч" } },
            war_icon_hit_the_road     = { name = "В путь-дорогу", text = { "Сбрось 50 Вальтов в одном матче" } },
            war_icon_supernova        = { name = "Сверхновая", text = { "Сыграй одну руку 25 раз в одном матче" } }, -- so 25 pairs, 25 flushes whatever
            war_icon_anaglyph_deck    = { name = "Анаглифная колода", text = { "Сыграй 10 матчей с Анаглифной колодой" } },
            war_icon_black_hole       = { name = "Чёрная дыра", text = { "Используй Чёрную дыру в матче" } },
            war_icon_canio            = { name = "Канио", text = { "Выйграй партию с Канио" } },
            war_icon_chicot           = { name = "Шико", text = { "Выйграй партию с Шико" } },
            war_icon_perkeo           = { name = "Перкео", text = { "Выйграй партию с Перкео" } },
            war_icon_tribuolet        = { name = "Трибуле", text = { "Выйграй партию с Трибуле" } },
            war_icon_yorick           = { name = "Йорик", text = { "Выйграй партию с Йориком" } },
            war_icon_windows_7        = { name = "Windows 7", text = { "Сыграй Каре из 7-ок с 4-мя разными мастями" } },

            -- Special
            war_icon_bean             = { name = "Bean" },
            war_icon_zaino            = { name = "Zaino" },
            war_icon_thunderedge      = { name = "ThunderEdge" },
            war_icon_doc              = { name = "Doc" },
            war_icon_murphy           = { name = "Murphy" },
            war_icon_soulware         = { name = "Soulware" },
            war_icon_sheila           = { name = "Sheila" },
            war_icon_astra            = { name = "Astra" },
            war_icon_lizie            = { name = "lizie" },
            war_icon_inky             = { name = "Inky" },
            war_icon_revo             = { name = "Revo" },
            war_icon_argel            = { name = "Argel" },
            war_icon_baggute          = { name = "Baggute" },
            war_icon_amolyte          = { name = "Amolyte" },
            war_icon_gabby            = { name = "Gabby" },
            war_icon_willow           = { name = "Willow" },
            war_icon_george_the_rat   = { name = "GeorgeTheRat" },
            war_icon_fir              = { name = "Fir" },
            war_icon_belenos_bear     = { name = "Belenos Bear" },
            war_icon_vagabond         = { name = "Vagabond" },
        },
        Blind = {},
    },

    misc = {
        dictionary = {
            -- Main menu / navigation
            war_github          = "Страница War на Github", -- unused currently
            war_kofi            = "Страница War на Kofi", -- unused currently
            war_discord         = "Вступить в Discord сервер",
            war_single_player   = "Одиночная игра",
            war_online          = "Онлайн",

            -- Private lobby screens
            war_join_lobby            = "Подключиться к комнате",
            war_create_lobby          = "Создать комнату",
            war_lobby_code_prompt     = "Код комнаты",
            war_paste_code            = "Подключиться с скопированным кодом",
            war_clipboard_empty       = "Нету скопированного кода комнаты",
            war_join                  = "Подключиться",

            -- Gamemode / ruleset selection
            war_gamemodes             = "Режимы игры",
            war_rulesets              = "Правила",
            war_next                  = "Далее",

            -- Gamemode: Vanilla
            war_gm_vanilla_name   = "Ванильная",
            war_gm_vanilla_desc   = {
                "Обычный Balatro PvP.",
                "С Анте 3, босс блайнды",
                "становятся PvP раундами.",
                "Игрок с меньшим количеством очков теряет жизнь.",
            },

            -- Ruleset: Standard
            war_rs_standard_name   = "Стандарт",
            war_rs_standard_desc   = {"Правила по умолчанию", "Без ограничений."},

            -- Ruleset: Mini World
            war_rs_weeworld_name   = "Трусливый Мир",
            war_rs_weeworld_desc   = {
                "Убирает большинство Джокеров,",
                "Расходников, Бустерных Наборов и Тэгов"

            -- Ruleset: Packaged
            war_rs_packaged_name   = "Упакованный",
            war_rs_packaged_desc   = {
                "Предметы магазина становятся Наборами их типа.",
                "Это не затрагивает купоны.",
            },

            -- Lobby bar buttons
            war_ready                 = "ГОТОВ",
            war_unready               = "НЕ ГОТОВ",
            war_lobby_settings        = "НАСТРОЙКИ КОМНАТЫ",
            war_deck_stake            = "КОЛОДА И СТАВКА",
            war_players               = "ИГРОКИ",
            war_code                  = "КОД",
            war_leave                 = "ПОКИНУТЬ",

            -- Lobby status line
            war_status_waiting        = "Ожидаем оппонента...",
            war_status_connected      = "Оппонента подключился",
            war_version_mismatch      = "У одного из вас может быть старая сборка",
            war_end_board_waiting     = "Доска загружается...",
            war_end_board_empty       = "Нету Джокеров",
            war_status_you_ready      = "Ожидаем оппонента...",
            war_status_opp_ready      = "Оппонент готов!",
            war_status_starting       = "Начинаем!",
            war_stake                 = "Ставка ",

            -- Code popup
            war_code_label            = "Код комнаты",
            war_reveal                = "Нажми, чтобы показать",
            war_copy                  = "Скопировать код",

            -- Options popup
            war_host_only             = "Только хост может менять настройки",
            war_score_new_record      = "Новый рекорд!",
            war_score_tied            = "Сравнял с наилучшим результатом!",
            war_score_best            = "Лучший:",
            war_tab_icons_free        = "Обычные",
            war_tab_icons_achievement = "Достижения",
            war_tab_icons_special     = "Специальные",
            war_tab_general           = "Общие",
            war_tab_gameplay          = "Игра",
            war_tab_bans              = "Баны",
            war_opt_lives             = "Кол-во жизней на старте",
            war_opt_timer             = "Таймер",
            war_opt_boss_effects      = "Эффекты боссов в PvP",
            war_opt_pvp_ante          = "Появление PvP раундов в Анте",
            war_opt_death_round       = "Смерть при проигрыше раунда",
            war_opt_hide_score        = "Спрятать очки перед сыгранной рукой",
            war_opt_comeback_gold     = "Бонус камбека",

            -- In-run cash-out
            war_comeback_bonus        = "Камбек",

            -- Ruleset bans
            war_bans_title            = "Что эти правила банят",
            war_view_bans             = "ПОСМОТРЕТЬ БАНЫ",
            war_bans_jokers           = "Запрещённые Джокеры",
            war_bans_consumables      = "Запрещённые Расходники",
            war_bans_vouchers         = "Запрещённые Купоны",
            war_bans_enhancements     = "Запрещённые Улучшения",
            war_bans_tags             = "Запрещённые Тэги",
            war_bans_blinds           = "Запрещённые Блайнды",
            war_bans_none             = "Ничего не запрещено",

            -- Players popup
            war_players_title         = "Игроки в комнате",
            war_role_host             = "Хост",
            war_role_guest            = "Гость",
            war_waiting_ellipsis      = "Ожидаем...",

            -- Connection status indicator
            war_cs_in_lobby           = "В комнате",
            war_cs_connected          = "Подключено",
            war_cs_offline            = "Оффлайн",
            war_cs_label              = "[War] Версия %s (%s)",

            -- Lobby side panels
            war_panel_players         = "Игроки",
            war_panel_spectators      = "Наблюдатель",
            war_panel_deck            = "Колода",
            war_panel_stake           = "Ставка",
            war_panel_seed            = "Сид:",
            war_panel_seed_random     = "Случайный сид",
            war_panel_lives_label     = "жизней",
            war_panel_timer_off       = "Таймер: Выключен",
            war_panel_timer_label     = "Таймер",
            war_timer_off             = "Выключен",
            war_blind_hurry           = "Оппонент вас ждёт — выберите блайнд!",
            war_timeout_you           = "Время вышло! Вы потеряли жизнь.",
            war_timeout_enemy         = "Время вышло у оппонента! Они потеряли жизнь.",
            war_panel_challenge       = "Испытание",
            war_select_cap            = "ВЫБРАТЬ",
            war_end_ante              = "Анте",
            war_end_new_record        = "Новый рекорд!",
            war_end_view_mine         = "Моя доска",
            war_end_view_opp          = "Их доска",
            war_end_opponent          = "Оппонент",

            -- In-run HUD
            war_hud_lives             = "Жизни",
            war_round_timer           = "Таймер",
            war_round_paused          = "Приостановлено",
            war_hud_enemy_score       = "Очки врага",
            war_hud_enemy_hands       = "Руки врага ",
            war_life_lost             = "Жизнь потеряна!",
            war_rival_life_lost       = "Враг потерял жизнь",
            war_wait_enemy            = "Ожидаем оппонента...",

            -- PvP round popup
            war_pvp_waiting           = "Ожидаем оппонента...",
            war_round_won             = "Раунд побеждён!",
            war_round_lost            = "Раунд проигран!",
            war_you_scored_more       = "Ваш оппонент наиграл меньше очков.",
            war_you_scored_less       = "Ваш оппонент наиграл больше очков.",
            war_lives_you             = "Ваши жизни: ",
            war_lives_opp             = "Оппонент: ",
            war_continue              = "Продолжить",

            -- End-game popup
            war_defeated_opp          = "Вы победили вашего оппонента!",
            war_better_luck           = "Удачи в следующий раз.",
            war_back_to_menu          = "Вернуться в меню",
            war_ok                    = "ОК",

            -- Error / info messages
            war_could_not_join        = "Не смогли подключиться: ",
            war_could_not_create      = "Не смогли создать: ",
            war_disconnected          = "Отключены от комнаты.",
            war_relay_lost            = "Потеряно подключение к направителю.",
            war_server_error          = "Ошибка сервера.",
            war_game_stopped          = "Игра остановлена.",
            war_opp_disconnected      = "Оппонент отключился.",
            war_opp_left              = "Оппонент покинул игру.",

            -- Server error codes (see WAR.ERROR_KEYS)
            war_err_missing_fields    = "Не указано имя пользователя или пароль.",
            war_err_bad_username      = "Неправильное имя пользователя.",
            war_err_username_taken    = "Это имя пользователя уже занято.",
            war_err_bad_credentials   = "Неправильное имя пользователя или пароль.",
            war_err_invalid_token     = "Сессия истекла. Войдите заново.",
            war_err_no_user           = "Не авторизован.",
            war_err_no_lobby          = "Комната не найдена.",
            war_err_lobby_full        = "Комната заполнена.",

            -- Deck selector
            -- Replaces vanilla "PLAY" button text while WAR._deck_selecting is active.
            war_select                = "ВЫБРАТЬ",

            -- Account screens
            war_account_label         = "Аккаунт: ",
            war_signed_in_as          = "Авторизован как",
            war_not_logged_in         = "Не авторизован!",
            war_guest_display_name    = "Гость-игрок",
            war_manage_account        = "Управление аккаунтом",
            war_current_account       = "Текущий: ",
            war_log_in                = "Войти",
            war_register              = "Регистрация",
            war_log_out               = "Выйти",
            war_close                 = "Закрыть",
            war_create_account        = "Создать аккаунт",
            war_username_prompt       = "Имя пользователя",
            war_password_prompt       = "Пароль",
            war_confirm_pass_prompt   = "Подтвердите пароль",
            war_logout_confirm        = "Выйти из аккаунта?",
            war_yes_log_out           = "Да",
            war_no_stay               = "Нет",
            war_none                  = "Ничего",
            war_wins                  = "Побед",
            war_losses                = "Поражений",
            war_win_percent           = "% побед",
            war_click_to              = "Нажмите для",
            war_customize             = "Персонализация",

            -- Mod config screens
            war_icon                  = "Иконка",
        }
    }
}
