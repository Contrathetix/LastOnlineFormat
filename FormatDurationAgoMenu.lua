FormatDurationAgo.ConfigMenu = {}

FormatDurationAgo.ConfigMenu.DisplayModeDropdownOptions = {
    [FormatDurationAgo.Constants.FORMAT_DEFAULT] = FormatDurationAgo.Strings.OPTION_DEFAULT,
    [FormatDurationAgo.Constants.FORMAT_ISO] = FormatDurationAgo.Strings.OPTION_ISO,
    [FormatDurationAgo.Constants.FORMAT_CUSTOM] = FormatDurationAgo.Strings.OPTION_CUSTOM
}

function FormatDurationAgo.ConfigMenu.Setup()
    -- The panel name is used for a global variable, so needs to be unique, just in case
    local panelName = FormatDurationAgo.Constants.ADDON_ID..'Panel'

    FormatDurationAgo.Logger:Debug('Config menu setup with panelName "%s"', panelName)

    local panelData = {
        type = 'panel',
        name = FormatDurationAgo.Constants.ADDON_NAME,
        displayName = FormatDurationAgo.Constants.ADDON_NAME,
        author = FormatDurationAgo.Constants.ADDON_AUTHOR,
        version = FormatDurationAgo.Constants.ADDON_VERSION,
        registerForRefresh = true,
        registerForDefaults = true,
        website = FormatDurationAgo.Constants.ADDON_WEBSITE,
        feedback = FormatDurationAgo.Constants.ADDON_FEEDBACK
    }

    local optionsData = {
        [1] = FormatDurationAgo.ConfigMenu.GetDisplayModeDropdownOption(),
        [2] = FormatDurationAgo.ConfigMenu.GetCustomFormatInputOption()
    }

    FormatDurationAgo.Logger:Debug('Registering add-on panel')

    LibAddonMenu2:RegisterAddonPanel(panelName, panelData)

    FormatDurationAgo.Logger:Debug('Registering options on the panel')

    LibAddonMenu2:RegisterOptionControls(panelName, optionsData)

    FormatDurationAgo.Logger:Debug('Config menu setup finished')
end
    
function FormatDurationAgo.ConfigMenu.GetDisplayModeDropdownOption()
    FormatDurationAgo.Logger:Debug('Creating display mode dropdown option data')

    return {
        type = 'dropdown',
        name = FormatDurationAgo.Strings.DISPLAY_MODE,
        tooltip = nil,
        default = FormatDurationAgo.Strings.OPTION_DEFAULT,
        choices = {
            FormatDurationAgo.Strings.OPTION_DEFAULT,
            FormatDurationAgo.Strings.OPTION_ISO,
            FormatDurationAgo.Strings.OPTION_CUSTOM,
        },
        getFunc = function()
            return FormatDurationAgo.ConfigMenu.DisplayModeDropdownOptions[FormatDurationAgo.Config.DisplayMode]
        end,
        setFunc = function(var)
            for key, value in pairs(FormatDurationAgo.ConfigMenu.DisplayModeDropdownOptions) do
                if value == var then
                    FormatDurationAgo.Config.DisplayMode = key
                end
            end
        end
    }
end

function FormatDurationAgo.ConfigMenu.GetCustomFormatInputOption()
    FormatDurationAgo.Logger:Debug('Creating custom format input option data')

    return {
        type = 'editbox',
        name = FormatDurationAgo.Strings.CUSTOM_FORMAT,
        tooltip = nil,
        width = 'full',
        default = FormatDurationAgo.Constants.DEFAULT_CUSTOM_FORMAT_STRING,
        getFunc = function()
            return FormatDurationAgo.Config.CustomFormat
        end,
        setFunc = function(var)
            FormatDurationAgo.Config.CustomFormat = var
        end
    }
end
