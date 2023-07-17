### 2.2.2
- Added a new feature: Loader Builder with `loadingBuilder` parameter in QuillHTMLEditor widget. 
- Added a new feature: Editor Loaded Callback with `onEditorLoaded` callback function. 
- Fixed bug #97 [BUG] Custom Links get changed to "about:blank"
- Updated dependencies for improved compatibility and stability.
- Fixed documentation

### 2.2.1
- Added a new feature: Loader Builder with `loadingBuilder` parameter in QuillHTMLEditor widget.
- Added a new feature: Editor Loaded Callback with `onEditorLoaded` callback function.
- Fixed bug #97 [BUG] Custom Links get changed to "about:blank"
- Updated dependencies for improved compatibility and stability.

### 2.2.0
- Removed the CDN dependency of the Scripts and Styling, bundled the Quill js and css files with the package, making the editor supporting offline mode
- Added Google Font Support for editor styling, refer documentation for examples
- Added a new `ToolBarStyle.separator`, to add custom separators in the toolbar config
- Fixed the bug #64
- Fixed the bug #71
- Fixed the bug #59 , fixed, the new line is not visible on enter
- Fixed Match visual error that appears in Flutter web console.
- Updated dependencies to the latest versions.


### 2.1.9
- Added a customisable option to make toolbar scrollable horizontally or vertically
- Fixed `onFocusChanged` method not returning focus on iOS properly
- Fixed text-change method is not returning text properly on Android
- Fixed moving cursor to end after `setDelta`
- Fix the white space in theme dark mode after adding minHeight property, thanks to `cabbagelol` for PR
- Fix Mobile Web- Clicking on toolbar icon does not toggle highlight color, and keyboard loses focus
- Updated `webview_flutter_android`, `webview_flutter_wkwebview` to latest versions
- Fix customToolBarList: ToolBarStyle.background adds table items #63
- Improved `onEditorCreated` callback functionality

### 2.1.8
- Added `setDelta` & `getDelta` methods,
- Fixed bug:getText() returns empty string if QuillEditor contains only img or iframe tags
- Fixed bug: Multiple widgets used the same GlobalKey
- Fixed bug:`hintText` padding is not applying properly
- Updated `webview_flutter` and dependant packages to latest version


### 2.1.7
- Fixed redo button throwing exception bug
- Added more customizing options to toolbar alignment
- Added `getSelectedHtmlText` that returns selected text in html format
- Other min bug fixes

### 2.1.6
- Added `onEditorResized` callback, returns the size of the editor
- Fixed transparent color conversion issue
- Fixed extra padding to the text area issue
- Other min bug fixes

### 2.1.5
- Added autoHeight, editor will have the dynamic height based on content. Thanks to **B0yma**
- **Breaking Change:** changed `height` to `minHeight` in `QuillHtmlEditor` widget
- Updated Documentation and ReadMe

### 2.1.4
- Added `undo` `redo` and `clearHistory` methods
- Added `onSelectionChanged` callback to return index and length on text selection
- Fixed bug #23
- Updated Documentation and ReadMe

###  2.1.3
- Added Documentation and Updated ReadMe
- Added `getPlainText` method

### 2.0.10 - 2.1.2
- Added Documentation

###  2.0.9
- Added `replaceText` function to replace the selected text
- Added `getSelectedText` function to get the selected text
- Added `requestFocus` and `unFocus` functions

###  2.0.8
- Added `OnEditorCreated` callback function to listen to editor loaded event
- Fixed a bug in textStyle, hintTextStyle color to css
- Support for Youtube, Vimeo embedding, `embedVideo` function now recognizes Youtube, Vimeo links and convert them to embed urls
- `embedImage` method supports inserting network image urls


### 2.0.7
- Added `OnFocusChanged` callback function to listen to editor focus changes
- Updated `webview_flutter` and dependent packages to latest versions in Webviewx
- `Breaking Change` Added textStyle, textAlign, padding options to the editor default text and
  the hint text, removed defaultFontSize, defaultFontColor fields
- Fixed - [BUG] Native HTML background is showing when keyboard appears #19
- Added Table feature, we can now add table, insert rows & columns in the editor with interactive picker
- Fixed OverlayState bug #16
- Other minor enhancements and bug fixes


### 2.0.6-dev.0.3

- Fixed the Readme file
- Added Table feature, we can now add table, insert rows & columns in the editor with interactive picker
- Fixed OverlayState bug #16
- Other minor enhancements and bug fixes


###  2.0.5 - 2.0.4
- Fixed Readme file
- Added `defaultFontColor` to the QuillHtmlEditor for custom themes, eg.Dark modes
- Fixed a bug : Toolbar crashes, when user applies multiple colors and selects the text with multiple colors
- Added `toolBarColor` for custom theme, to match the background and dropdown color with the theme.


###  2.0.3
- Added capability to change toolbar icons color and size
- Added option to change the default font size of the editor
- Fixed analysis issues with Flutter 3.7


###  2.0.2 - 2.0.1

- Added onTextChanged listeners
- Added ability to add custom toolbar buttons
- Added ability to change the padding of toolbar buttons
- Fixed bug - OnTextChanged is not firing when text is copied to editor
- Changed getSelectionRange return type from dynamic to a selection model
- Fixed bug - removed invisible extra bottom padding on focus
- Other minor bug fixes


###  2.0.0
2.0.0-beta.1

- Breaking changes - Editor toolbar is detached from editor
- Customisable toolbar
- Added support for image picking, embedding videos, hyperlink with custom UI
- Added custom Color picker
- Fixed a few bugs
- Added onTextChanged listeners
- Added custom buttons feature


###  1.0.0-dev.5

- Fixed setHtml method breaking format bug
- Fixed UX bugs
- Breaking changes - Editor toolbar is detached from editor
- Customisable toolbar
- Added support for image picking, embedding videos, hyperlink with custom UI
- Added custom Color picker
- Fixed a few bugs


###  1.0.0-dev.5

- Fixed setHtml method breaking format bug
- Fixed UX bugs


###  1.0.0-dev.4
###  1.0.0-dev.3
###  1.0.0-dev.2

- Updated Readme
- Added Customisable Toolbar
- ToolBar detached from editor
- Added Quill Controller
- Added Support for Image, Video, Hyperlink


### 0.1.5

- Updated the documentation
- Improved the method to enable/disable editor


###  0.1.4

- Fixed Readme







