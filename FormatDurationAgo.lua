FormatDurationAgo = {}

FormatDurationAgo.Constants = {
    FORMAT_DEFAULT = 0,
    FORMAT_ISO = 1,
    FORMAT_CUSTOM = 2,

    ADDON_ID = 'FormatDurationAgo',
    ADDON_NAME = 'Format Duration Ago',
    ADDON_AUTHOR = 'Surilindur',
    ADDON_VERSION = '3.0.0',
    ADDON_WEBSITE = 'https://github.com/surilindur/formatdurationago',
    ADDON_FEEDBACK = 'https://github.com/surilindur/formatdurationago/issues',

    SAVED_VARS_NAME = 'FormatDurationAgoSavedVariables',
    SAVED_VARS_VERSION = 3,
    SAVED_VARS_ACCOUNTWIDE = true,

    -- This should be sufficient, since os.time does not allow for milliseconds apparently
    ISO8601_FORMAT_STRING = '%Y-%m-%dT%H:%M:%S%z',

    -- The default custom format should be easier to read than the above
    DEFAULT_CUSTOM_FORMAT_STRING = '%Y-%m-%d %H:%M:%S'
}

FormatDurationAgo.Strings = {
    -- Localization of the add-on using existing strings in the game, to avoid having to write new ones
    -- just to make the add-on work in other languages. Some translations might be slightly off as a result maybe.

    DISPLAY_MODE = EsoStrings[SI_GRAPHICS_OPTIONS_VIDEO_DISPLAY_MODE],
    CUSTOM_FORMAT = EsoStrings[SI_HOUSEPERMISSIONPRESETSETTING0]..' '..EsoStrings[SI_TRADINGHOUSESORTFIELD1],

    OPTION_DEFAULT = EsoStrings[SI_AUDIOSPEAKERCONFIGURATIONS0],
    OPTION_ISO = 'ISO 8601 '..EsoStrings[SI_MASTER_WRIT_DESCRIPTION_STYLE],
    OPTION_CUSTOM = EsoStrings[SI_HOUSEPERMISSIONPRESETSETTING0]
}

FormatDurationAgo.Logger = LibDebugLogger(FormatDurationAgo.Constants.ADDON_ID)

function FormatDurationAgo.GetDefaultConfig()
    FormatDurationAgo.Logger:Debug(
        'Default mode %d, format "%s"',
        FormatDurationAgo.Constants.FORMAT_DEFAULT,
        FormatDurationAgo.Constants.DEFAULT_CUSTOM_FORMAT_STRING
    )
    return {
        DisplayMode = FormatDurationAgo.Constants.FORMAT_DEFAULT,
        CustomFormat = FormatDurationAgo.Constants.DEFAULT_CUSTOM_FORMAT_STRING
    }
end

function FormatDurationAgo.OnAddOnLoaded(_, addOnName)

    if addOnName ~= FormatDurationAgo.Constants.ADDON_ID then return end

    FormatDurationAgo.Logger:Debug('Unregistering for event with addOnName "%s"', addOnName)

    EVENT_MANAGER:UnregisterForEvent(addOnName, EVENT_ADD_ON_LOADED)

    FormatDurationAgo.Logger:Debug('Restoring or creating saved vars')

    FormatDurationAgo.Config = ZO_SavedVars:New(
        FormatDurationAgo.Constants.SAVED_VARS_NAME,
        FormatDurationAgo.Constants.SAVED_VARS_VERSION,
        FormatDurationAgo.Constants.SAVED_VARS_ACCOUNTWIDE,
        FormatDurationAgo.GetDefaultConfig()
    )

    FormatDurationAgo.ConfigMenu.Setup()

    FormatDurationAgo.Logger:Debug('Overriding ZO_FormatDurationAgo')

    ZO_FormatDurationAgo = FormatDurationAgo.CustomFormatter
end

function FormatDurationAgo.FixSecondsBug(seconds)
    --[[
        The purpose of this function was to fix a bug in the game's own seconds handling,
        where it would report the time since epoch instead of the time backwards from
        current time. This has since been fixed, but I am leaving the function here in case
        the bug is re-introduced, because I found it annoying personally and will not want
        to see it again. The performance difference should ne negligible.
    ]]
    if seconds > 946677600 then
        FormatDurationAgo.Logger:Warn('Seconds bug detected with %d seconds', seconds)
        return os.time() - seconds
    end
    return seconds
end

function FormatDurationAgo.FormatDefault(seconds)
    if seconds < ZO_ONE_MINUTE_IN_SECONDS then
        return GetString(SI_TIME_DURATION_NOT_LONG_AGO)
    end
    return zo_strformat(
        SI_TIME_DURATION_AGO,
        ZO_FormatTime(seconds, TIME_FORMAT_STYLE_SHOW_LARGEST_UNIT_DESCRIPTIVE, TIME_FORMAT_PRECISION_SECONDS)
    )
end

function FormatDurationAgo.FormatISO(seconds)
    return os.date(FormatDurationAgo.Constants.ISO8601_FORMAT_STRING, os.time() - seconds)
end

function FormatDurationAgo.FormatCustom(seconds)
    return os.date(FormatDurationAgo.Config.CustomFormat, os.time() - seconds)
end

FormatDurationAgo.Formatters = {
    [FormatDurationAgo.Constants.FORMAT_DEFAULT] = FormatDurationAgo.FormatDefault,
    [FormatDurationAgo.Constants.FORMAT_ISO] = FormatDurationAgo.FormatISO,
    [FormatDurationAgo.Constants.FORMAT_CUSTOM] = FormatDurationAgo.FormatCustom
}

function FormatDurationAgo.CustomFormatter(seconds)
    local secondsFixed = FormatDurationAgo.FixSecondsBug(seconds)
    local formatFunction = FormatDurationAgo.Formatters[FormatDurationAgo.Config.DisplayMode]
    return formatFunction(secondsFixed)
end

EVENT_MANAGER:RegisterForEvent(FormatDurationAgo.Constants.ADDON_ID, EVENT_ADD_ON_LOADED, FormatDurationAgo.OnAddOnLoaded)
