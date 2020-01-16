# Interactive-Report-Checbox

Interactive Report Checkbox APEX Plugin

![Preview gif](Sources/IMG/Preview.gif)


## Table of Contents

- [Demo](#demo)
- [Features](#features)
- [How to install](#how-to-install)
- [Plugin Settings](#plugin-settings)
    - [Plugin Events](#plugin-events)
    - [Component Settings](#component-settings)
- [How to Setup](#how-to-setup)
- [Issues](#issues)
- [License](#license)
- [About Author](#about-author)
- [About Kubicek Consulting GmbH](#about-kubicek-consulting-gmbh)

## Demo
https://apex.oracle.com/pls/apex/f?p=23312

## Release History
1.0 Initial Version
1.1 Implemented fix for Internet Explorer 11.

## How to install
Download this repository and install the plug-in into your application by following those steps:
1. Install package `IR_CHECKBOX_UTIL` in Oracle APEX Schema
    * You can find it in folder : `Sources/DB`
1. Install the plugin file `dynamic_action_plugin_de_kc_ir_checkbox.sql`
    * You can find it in folder : `Sources`

## Features
* Renders checkboxes for a given column in an Interactive Report.
* Ability to select records and save source value of checkbox column to Apex Collection.
* The plugin can handle a large number of selections, because the values are stored in one large character attribute (CLOB) of apex collection.
* Developers have the possibility to :
    * Enable/disable selection on row click.
    * Clear selections of a certain report on page load.
    * Clear selections of a certain report on change of page items.
    * Refresh report on change of page items.
* Checkboxes are not rendered if the view is Chart,Pivot or Group by.
* Basic logging for Info Debug Level and advanced logging for App Trace Debug Level.

## Plugin Settings
You can find a detailed explanation of each attribute in the help section.
![Help Text gif](Sources/IMG/PluginSettings.gif)

## Plugin Events
The plugin exposes one event "Selection Changed [IR Checkbox]" , which is triggered every time the selection is changed and when the selections are cleared by change of page items.

## Component Settings
The plugin also has 3 component settings which allows the developer to change the error messages to be shown to the user.
![Component Settings png](Sources/IMG/ComponentSettings.png)

## How to Setup
* Create a virtual column or select an existing column and set the static id, which we will later set it in DA Plugin Settings.
* Disable column options allowing the user to sort, hide , filter etc. like in image below:
<p align="center">
    <img src="https://raw.githubusercontent.com/kcotoi/Interactive-Report-Checbox/master/Sources/IMG/ColumnAttributes.png" width="400px">
</p>

* Create a Click Dynamic Action.
* Bind the dynamic action to the Interactive Report Region for which you want to render checkboxes.
<p align="center">
    <img src="https://raw.githubusercontent.com/kcotoi/Interactive-Report-Checbox/master/Sources/IMG/BindDAToRegion.png" width="400px">
</p>

* Select IR Checkbox as the true action.
    * NOTE: Don't disable attribute "Fire on Initialization", if you do the checkboxes will not be rendered on page load.
* Configure the plugin settings to fit your needs.

## Issues
* Please let me know if you find any.

## Future developments
* Please let me know any of your wishes
* Find workaround for using synchronous ajax request for rendering checkboxes as this will be deprecated in the future.
* Implement option to use columns as display only checkbox. An option will be provided to specify source values to determine the state of the checkbox (checked/unchecked).

## License

MIT

## About Author
Author |Github | E-mail
-------|-------|-------
Dragos Constantin Cotoi | [@kcotoi](https://github.com/kcotoi) | [dragos.cotoi@kubicek-consulting.de](mailto:dragos.cotoi@kubicek-consulting.de)

## About Kubicek Consulting GmbH
Address | Website | E-mail
--------|---------|-------
Stubenwald-Allee 21a, 64625 Bensheim | [https://kubicek-consulting.de](https://kubicek-consulting.de) | [info@kubicek-consulting.de](mailto:info@kubicek-consulting.de)
<p align="center">
    <img src="https://raw.githubusercontent.com/kcotoi/Interactive-Report-Checbox/master/Sources/IMG/logo.png" width="400px">
</p>
