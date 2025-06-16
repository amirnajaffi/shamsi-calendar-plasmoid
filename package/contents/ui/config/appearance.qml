import QtQuick
import QtQuick.Layouts
import Qt.labs.platform as QtPlatform
import QtQuick.Controls as Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

import "../../js/constants.js" as Const
import "../../js/utils.js" as Utils
import "../../js/translate.js" as Translate

KCMUtils.SimpleKCM {
  id: appearanceConfig

  property alias cfg_holidayColor: holidayColor.text
  property alias cfg_eventColor: eventColor.text

  property string cfg_calendarCellFontSizeMode: Plasmoid.configuration.calendarCellFontSizeMode
  property alias cfg_calendarCellFontPixelSizeScale: calendarCellFontPixelSizeScale.value

  property alias cfg_panelPrimaryTextFormat: panelPrimaryTextFormat.text
  property string cfg_panelPrimaryTextFontSizeMode: Plasmoid.configuration.panelPrimaryTextFontSizeMode
  property alias cfg_panelPrimaryTextPixelSize: panelPrimaryTextPixelSize.value
  property alias cfg_secondaryText: secondaryText.checked
  property alias cfg_panelSecondaryTextFormat: panelSecondaryTextFormat.text
  property alias cfg_secondaryTextHeight: secondaryTextHeight.value
  property string cfg_panelSecondaryTextFontSizeMode: Plasmoid.configuration.panelSecondaryTextFontSizeMode
  property alias cfg_panelSecondaryTextPixelSize: panelSecondaryTextPixelSize.value

  property string cfg_fontStatus: Plasmoid.configuration.fontStatus
  property string cfg_fontFamily: Plasmoid.configuration.fontFamily

  property alias cfg_weekendHighlight: weekendHighlight.checked
  property string cfg_weekendHighlightDays: Plasmoid.configuration.weekendHighlightDays;

  readonly property var dateTemplates: [
    'YYYY MM DD',
    'YYYY-MM-DD',
    'YYYY/MM/DD',
    'M/D',
    'D MMMM',
    'D',
    'D MMMM YYYY',
    'dddd D MMMM',
    'ddd D MMMM',
    'dddd D MMM',
    'ddd D MMM',
    'D MMM',
    'dddd D MMMM YYYY',
    'ddd D MMMM YYYY',
    'dddd D MMM YY',
    'ddd D MMM YYYY',
    '<font color="#3daee9">MMM d</font>',
    '<font color="#3daee9">dddd D <font color="#D4AF37">MMMM </font>YYYY</font>',
    '<font><font color="#888">dddd</font> D</font>'
  ]

  Kirigami.FormLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    /* Start General settings */
    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('holiday_color', {lng: Plasmoid.configuration.language}) + ':'

      Controls.TextField {
        id: holidayColor
      }

      Rectangle {
        width: Kirigami.Units.gridUnit * 1.5
        height: width
        color: cfg_holidayColor

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            colorDialog.target = holidayColor
            colorDialog.color = cfg_holidayColor
            colorDialog.open()
          }
        }
      }

      Controls.Button {
        icon.name: "edit-undo"
        display: Controls.AbstractButton.IconOnly
        visible: holidayColor.text !== Const.constants.COLOR_EVENT_HOLIDAY
        onClicked: holidayColor.text = Const.constants.COLOR_EVENT_HOLIDAY
        Controls.ToolTip {
          text: Translate.tConfigScope('reset', {lng: Plasmoid.configuration.language})
        }
      }
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('event_color', {lng: Plasmoid.configuration.language}) + ':'

      Controls.TextField {
        id: eventColor
      }

      Rectangle {
        width: Kirigami.Units.gridUnit * 1.5
        height: width
        color: cfg_eventColor

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            colorDialog.target = eventColor
            colorDialog.color = cfg_eventColor
            colorDialog.open()
          }
        }
      }

      Controls.Button {
        icon.name: "edit-undo"
        display: Controls.AbstractButton.IconOnly
        visible: eventColor.text !== Const.constants.COLOR_EVENT_OTHER
        onClicked: eventColor.text = Const.constants.COLOR_EVENT_OTHER
        Controls.ToolTip {
          text: Translate.tConfigScope('reset', {lng: Plasmoid.configuration.language})
        }
      }

    }

    RowLayout {
      // Kirigami.FormData.label: Translate.tConfigScope('font', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.label: Translate.tConfigScope('calendar_cell_font_size_mode', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ButtonGroup {
        id: calendarCellFontSizeModeRadioGroup
        onCheckedButtonChanged: {
          appearanceConfig.cfg_calendarCellFontSizeMode = checkedButton.value
        }
      }

      ColumnLayout {
        Controls.RadioButton {
          text: Translate.tConfigScope('fit', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: calendarCellFontSizeModeRadioGroup
          readonly property string value: 'fit'
          checked: value === appearanceConfig.cfg_calendarCellFontSizeMode
        }

        RowLayout {
          Controls.RadioButton {
            id: fixedCalendarCellFontSizeModeRadioButton
            text: Translate.tConfigScope('fixed', {lng: Plasmoid.configuration.language})
            Controls.ButtonGroup.group: calendarCellFontSizeModeRadioGroup
            readonly property string value: 'fixed'
            checked: value === appearanceConfig.cfg_calendarCellFontSizeMode
          }
          
        }

        RowLayout {
          Controls.Label {
            text: Translate.tConfigScope('scale', {lng: Plasmoid.configuration.language}) + ':'
            visible: fixedCalendarCellFontSizeModeRadioButton.checked
          }

          Controls.Label {
            text: calendarCellFontPixelSizeScale.value
            visible: fixedCalendarCellFontSizeModeRadioButton.checked
          }

          Controls.Button {
            icon.name: "edit-undo"
            display: Controls.AbstractButton.IconOnly
            visible: fixedCalendarCellFontSizeModeRadioButton.checked && calendarCellFontPixelSizeScale.value != 1.2
            onClicked: calendarCellFontPixelSizeScale.value = 1.2
            Controls.ToolTip {
              text: Translate.tConfigScope('reset', {lng: Plasmoid.configuration.language})
            }
          }
        }

        Controls.Slider {
          id: calendarCellFontPixelSizeScale
          visible: fixedCalendarCellFontSizeModeRadioButton.checked
          from: 1.0
          to: 2.0
          stepSize: 0.1
        }
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('font', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ButtonGroup {
        id: fontRadioGroup
        onCheckedButtonChanged: {
          appearanceConfig.cfg_fontStatus = checkedButton.value
          if (checkedButton.value === Const.constants.font.MANUAL && appearanceConfig.cfg_fontFamily === "") {
            appearanceConfig.cfg_fontFamily = Kirigami.Theme.defaultFont.family
          }
        }
      }

      ColumnLayout {
        Controls.RadioButton {
          text: Translate.tConfigScope('default', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: fontRadioGroup
          readonly property string value: Const.constants.font.DEFAULT
          checked: value === appearanceConfig.cfg_fontStatus
        }

        Controls.RadioButton {
          text: Translate.tConfigScope('vazir', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: fontRadioGroup
          readonly property string value: Const.constants.font.VAZIR
          checked: value === appearanceConfig.cfg_fontStatus
        }

        Controls.Label {
          text: Translate.tConfigScope('best_look_in_persian', {lng: Plasmoid.configuration.language})
          Layout.fillWidth: true
          wrapMode: Text.Wrap
          font: Kirigami.Theme.smallFont
        }

        RowLayout {
          Controls.RadioButton {
            id: fontManualRadioButton
            text: Translate.tConfigScope('manual', {lng: Plasmoid.configuration.language})
            Controls.ButtonGroup.group: fontRadioGroup
            readonly property string value: Const.constants.font.MANUAL
            checked: value === appearanceConfig.cfg_fontStatus
          }

          Controls.Button {
            text: Translate.tConfigScope('choose_font', {lng: Plasmoid.configuration.language})
            icon.name: "settings-configure"
            enabled: fontManualRadioButton.checked
            onClicked: {
              fontDialog.font = Qt.font({family: appearanceConfig.cfg_fontFamily})
              fontDialog.open()
            }
          }
        }

        Controls.Label {
          text: Translate.tConfigScope('only_font_name_is_applied', {lng: Plasmoid.configuration.language})
          Layout.fillWidth: true
          wrapMode: Text.Wrap
          font: Kirigami.Theme.smallFont
        }

      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    Controls.Switch {
      id: weekendHighlight
      text: Translate.tConfigScope('enable_weekend_highlight', {lng: Plasmoid.configuration.language})
    }

    Item {
      readonly property int _scrollHeight: Kirigami.Units.gridUnit * 2
      readonly property int _scrollWidth: Kirigami.Units.gridUnit * 16
      implicitHeight: _scrollHeight
      implicitWidth: _scrollWidth
      Layout.minimumHeight: _scrollHeight
      Layout.maximumHeight: _scrollHeight

      Kirigami.FormData.label: Translate.tConfigScope('weekend', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ScrollView {
        clip: true
        width: parent.width
        height: parent.height
        contentWidth: availableWidth
        Flow {
          anchors.fill: parent
          spacing: Kirigami.Units.smallSpacing
          Repeater {
            model: Array.from({length: 7}, (_, index) => index + 1)
            delegate: Controls.CheckBox {
              required property string modelData
              text: Translate.tConfigScope('week_label.' + modelData, {lng: Plasmoid.configuration.language})
              enabled: weekendHighlight.checked
              checked: isChecked()

              onClicked: {
                const weekDaysArray = Utils.stringToNumberArray(appearanceConfig.cfg_weekendHighlightDays);
                if (checked) {
                  weekDaysArray.push(modelData);
                } else {
                  const index = weekDaysArray.indexOf(parseInt(modelData));
                  if (index > -1) {
                    weekDaysArray.splice(index, 1);
                  }
                }
                appearanceConfig.cfg_weekendHighlightDays = weekDaysArray.join();
                checked = Qt.binding(isChecked);
              }

              function isChecked() {
                const weekDaysArray = Utils.stringToNumberArray(appearanceConfig.cfg_weekendHighlightDays);
                return weekDaysArray.some((item) => parseInt(item) === parseInt(modelData));
              }

            } // end Checkbox
          } // end Repeater
        } // end Flow
      } // end Scrollview
    } // end item

    /* End General Settings */

    /* Start Panel Settings */
    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: Translate.tConfigScope('panel', {lng: Plasmoid.configuration.language})
    }

    Item {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: Translate.tConfigScope('primary_text', {lng: Plasmoid.configuration.language})
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('date_format', {lng: Plasmoid.configuration.language}) + ':'

      Controls.TextField {
        id: panelPrimaryTextFormat
        Layout.fillWidth: true
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('result', {lng: Plasmoid.configuration.language}) + ':'
      Controls.Label {
        Layout.maximumWidth: Kirigami.Units.gridUnit * 16
        textFormat: Text.StyledText
        text: {
          if (!panelPrimaryTextFormat.text) return null;
          return Utils.richDateFormatParser(
            undefined,
            panelPrimaryTextFormat.text,
            Translate.useLocale(Plasmoid.configuration.language)
          );
        }
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    Item {
      readonly property int _scrollHeight: Kirigami.Units.gridUnit * 6
      readonly property int _scrollWidth: Kirigami.Units.gridUnit * 16
      implicitHeight: _scrollHeight
      implicitWidth: _scrollWidth
      Layout.minimumHeight: _scrollHeight
      Layout.maximumHeight: _scrollHeight

      Kirigami.FormData.label: Translate.tConfigScope('templates', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ScrollView {
        clip: true
        width: parent.width
        height: parent.height
        contentWidth: availableWidth

        Flow {
          spacing: Kirigami.Units.smallSpacing
          anchors.fill: parent
          
          Repeater {
            model: appearanceConfig.dateTemplates
            delegate: Controls.Button {
              required property string modelData
              property string displayText: Utils.richDateFormatParser(
                undefined,
                modelData,
                Translate.useLocale(Plasmoid.configuration.language)
              )
              topPadding: Kirigami.Units.smallSpacing
              rightPadding: Kirigami.Units.smallSpacing * 2
              bottomPadding: Kirigami.Units.smallSpacing
              leftPadding: Kirigami.Units.smallSpacing * 2
              Controls.ToolTip.visible: hovered
              Controls.ToolTip.delay: 500
              Controls.ToolTip.text: displayText
              contentItem: Controls.Label {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: displayText
                textFormat: Text.StyledText
              }
              onClicked: panelPrimaryTextFormat.text = modelData
            }
          }
        }
      }
    }

    Controls.Label {
      text: Translate.tConfigScope('date_format_documentation', {lng: Plasmoid.configuration.language})
      wrapMode: Text.Wrap
      Layout.preferredWidth: Layout.maximumWidth
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      font: Kirigami.Theme.smallFont
      onLinkActivated: Qt.openUrlExternally(link)
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
      }
    }

    Controls.Label {
      text: Translate.tConfigScope('font_tag_documentation', {lng: Plasmoid.configuration.language})
      wrapMode: Text.Wrap
      Layout.preferredWidth: Layout.maximumWidth
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      font: Kirigami.Theme.smallFont
      onLinkActivated: Qt.openUrlExternally(link)
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
      }
    }

    Controls.Label {
      text: Translate.tConfigScope('format_description', {lng: Plasmoid.configuration.language})
      Layout.fillWidth: true
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      wrapMode: Text.Wrap
      font: Kirigami.Theme.smallFont
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('font_size', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop
      
      Controls.ButtonGroup {
        id: panelPrimaryTextFontSizeModeRadioGroup
        onCheckedButtonChanged: {
          appearanceConfig.cfg_panelPrimaryTextFontSizeMode = checkedButton.value
        }
      }

      ColumnLayout {
        Controls.RadioButton {
          text: Translate.tConfigScope('fit', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: panelPrimaryTextFontSizeModeRadioGroup
          readonly property string value: 'fit'
          checked: value === appearanceConfig.cfg_panelPrimaryTextFontSizeMode
        }

        RowLayout {
          Controls.RadioButton {
            id: fixedPanelPrimaryTextFontSizeModeRadioButton
            text: Translate.tConfigScope('fixed', {lng: Plasmoid.configuration.language})
            Controls.ButtonGroup.group: panelPrimaryTextFontSizeModeRadioGroup
            readonly property string value: 'fixed'
            checked: value === appearanceConfig.cfg_panelPrimaryTextFontSizeMode
          }

          Controls.SpinBox {
            id: panelPrimaryTextPixelSize
            visible: fixedPanelPrimaryTextFontSizeModeRadioButton.checked
            from: 4
            to: 99
            stepSize: 1
          }
          
          Controls.Label {
            text: 'px'
            visible: fixedPanelPrimaryTextFontSizeModeRadioButton.checked
          }
        }
      }
    }

    Item {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: Translate.tConfigScope('secondary_text', {lng: Plasmoid.configuration.language})
    }

    Controls.Switch {
      id: secondaryText
      text: Translate.tConfigScope('enable_secondary_text', {lng: Plasmoid.configuration.language})
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('date_format', {lng: Plasmoid.configuration.language}) + ':'
      opacity: secondaryText.checked ? 1 : 0.5

      Controls.TextField {
        id: panelSecondaryTextFormat
        enabled: secondaryText.checked
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('result', {lng: Plasmoid.configuration.language}) + ':'
      Controls.Label {
        Layout.maximumWidth: Kirigami.Units.gridUnit * 16
        textFormat: Text.StyledText
        opacity: secondaryText.checked ? 1 : 0.5
        text: {
          if (!panelSecondaryTextFormat.text) return null;
          return Utils.richDateFormatParser(
            undefined,
            panelSecondaryTextFormat.text,
            Translate.useLocale(Plasmoid.configuration.language)
          );
        }
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    Item {
      readonly property int _scrollHeight: Kirigami.Units.gridUnit * 6
      readonly property int _scrollWidth: Kirigami.Units.gridUnit * 16
      implicitHeight: _scrollHeight
      implicitWidth: _scrollWidth
      Layout.minimumHeight: _scrollHeight
      Layout.maximumHeight: _scrollHeight

      Kirigami.FormData.label: Translate.tConfigScope('templates', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ScrollView {
        clip: true
        width: parent.width
        height: parent.height
        contentWidth: availableWidth

        Flow {
          anchors.fill: parent
          spacing: Kirigami.Units.smallSpacing
          Repeater {
            model: appearanceConfig.dateTemplates
            delegate: Controls.Button {            
              required property string modelData  
              property string displayText: Utils.richDateFormatParser(
                undefined,
                modelData,
                Translate.useLocale(Plasmoid.configuration.language)
              )
              topPadding: Kirigami.Units.smallSpacing
              rightPadding: Kirigami.Units.smallSpacing * 2
              bottomPadding: Kirigami.Units.smallSpacing
              leftPadding: Kirigami.Units.smallSpacing * 2
              Controls.ToolTip.visible: hovered
              Controls.ToolTip.delay: 500
              Controls.ToolTip.text: displayText
              enabled: secondaryText.checked
              contentItem: Controls.Label {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: displayText
                textFormat: Text.StyledText
              }
              onClicked: panelSecondaryTextFormat.text = modelData
            }
          }
        }
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('height', {lng: Plasmoid.configuration.language}) + ':'
      opacity: secondaryText.checked ? 1 : 0.5

      Controls.Slider {
        id: secondaryTextHeight
        from: 30
        to: 70
        stepSize: 1
        enabled: secondaryText.checked
      }

      Controls.Label {
        text: secondaryTextHeight.value + "%"
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Translate.tConfigScope('font_size', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop
      
      Controls.ButtonGroup {
        id: panelSecondaryTextFontSizeModeRadioGroup
        onCheckedButtonChanged: {
          appearanceConfig.cfg_panelSecondaryTextFontSizeMode = checkedButton.value
        }
      }

      ColumnLayout {
        Controls.RadioButton {
          text: Translate.tConfigScope('fit', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: panelSecondaryTextFontSizeModeRadioGroup
          readonly property string value: 'fit'
          enabled: secondaryText.checked
          checked: value === appearanceConfig.cfg_panelSecondaryTextFontSizeMode
        }

        RowLayout {
          Controls.RadioButton {
            id: fixedPanelSecondaryTextFontSizeModeRadioButton
            text: Translate.tConfigScope('fixed', {lng: Plasmoid.configuration.language})
            Controls.ButtonGroup.group: panelSecondaryTextFontSizeModeRadioGroup
            readonly property string value: 'fixed'
            enabled: secondaryText.checked
            checked: value === appearanceConfig.cfg_panelSecondaryTextFontSizeMode
          }

          Controls.SpinBox {
            id: panelSecondaryTextPixelSize
            visible: fixedPanelSecondaryTextFontSizeModeRadioButton.checked
            enabled: secondaryText.checked
            from: 4
            to: 99
            stepSize: 1
          }
          
          Controls.Label {
            text: 'px'
            opacity: secondaryText.checked ? 1 : 0.5
            visible: fixedPanelSecondaryTextFontSizeModeRadioButton.checked
          }
        }
      }
    }
    
    Item {
      Kirigami.FormData.isSection: true
    }

    /* End Panel Settings */

  } // End Kirigami.FormLayout

  QtPlatform.FontDialog {
    id: fontDialog
    title: "Choose a Font"
    modality: Qt.WindowModal

    onAccepted: {
      appearanceConfig.cfg_fontFamily = font.family
    }
  }

  QtPlatform.ColorDialog {
    id: colorDialog
    title: "Choose a color"
    modality: Qt.WindowModal
    property var target

    onAccepted: {
      target.text = colorDialog.color
    }
    
  }

} // End ColumnLayout
