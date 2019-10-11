<p align="center">
    <img alt="logo" src="./.github/assets/logo.svg" width="256">
</p>

<p align="center">
  <a href="https://github.com/surilindur/formatdurationago/actions/workflows/ci.yml"><img alt="CI" src=https://github.com/surilindur/formatdurationago/actions/workflows/ci.yml/badge.svg?branch=main"></a>
  <a href="https://www.lua.org/"><img alt="C++" src="https://img.shields.io/badge/%3C%2F%3E-Lua-%232c2d72.svg"></a>
  <a href="https://opensource.org/licenses/MIT"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-%23750014.svg"></a>
</p>

**FormatDurationAgo** is an experimental tiny add-on for The Elder Scrolls Online,
to allow custom formats to be used for timestamps within the game's user interface,
such as in guild member lists, guild history, friend lists, email and other places.

## Installation

The add-on repository can be cloned to the add-ons folder and named `FormatDurationAgo` to have it load properly.

## Compatibility

The add-on achieves custom time formats by overriding the global `ZO_FormatDurationAgo` function.
The function is defined in the [global time functions library](https://github.com/esoui/esoui/blob/master/esoui/libraries/globals/time.lua).
This is maybe not the most compatible approach, so issues are to be expected with other add-ons.

Unfortunately, the same function is also used by sales announcements from [MasterMerchant](https://github.com/ESOUIMods/MasterMerchant),
so not all formats might look as elegant as intended.

## Dependencies

* [LibAddonMenu-2.0](https://github.com/sirinsidiator/ESO-LibAddonMenu)
* LibDebugLogger

## Issues

Please feel free to report any issues on the GitHub issue tracker.

## License

This code is copyrighted and released under the [MIT license](http://opensource.org/licenses/MIT).
