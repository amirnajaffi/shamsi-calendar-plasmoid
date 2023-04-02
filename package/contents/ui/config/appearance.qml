import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.1 as QtDialogs
import QtQuick.Controls 2.5 as Controls

import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
  id: appearanceConfig

  property string cfg_calendarCellFontMode: Plasmoid.configuration.calendarCellFontMode
  property alias cfg_calendarCellFontPixelSizeScale: calendarCellFontPixelSizeScale.value

  property alias cfg_panelPrimaryTextFormat: panelPrimaryTextFormat.text
  property alias cfg_secondaryText: secondaryText.checked
  property alias cfg_panelSecondaryTextFormat: panelSecondaryTextFormat.text
  property alias cfg_secondaryTextHeight: secondaryTextHeight.value

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

  anchors.fill: parent

  Kirigami.FormLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    /* Start General settings */
    RowLayout {
      // Kirigami.FormData.label: Qt.i18next.t('font', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.label: Qt.i18next.t('calendar_cell_font_mode', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ButtonGroup {
        id: calendarCellFontModeRadioGroup
        onCheckedButtonChanged: {
          appearanceConfig.cfg_calendarCellFontMode = checkedButton.value
        }
      }

      ColumnLayout {
        Controls.RadioButton {
          text: Qt.i18next.t('fit', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: calendarCellFontModeRadioGroup
          readonly property string value: 'fit'
          checked: value === appearanceConfig.cfg_calendarCellFontMode
        }

        RowLayout {
          Controls.RadioButton {
            id: fixedCalendarCellFontModeRadioButton
            text: Qt.i18next.t('fixed', {lng: Plasmoid.configuration.language})
            Controls.ButtonGroup.group: calendarCellFontModeRadioGroup
            readonly property string value: 'fixed'
            checked: value === appearanceConfig.cfg_calendarCellFontMode
          }
          
        }

        RowLayout {
          Controls.Label {
            text: Qt.i18next.t('scale', {lng: Plasmoid.configuration.language}) + ':'
            visible: fixedCalendarCellFontModeRadioButton.checked
          }

          Controls.Label {
            text: calendarCellFontPixelSizeScale.value
            visible: fixedCalendarCellFontModeRadioButton.checked
          }

          Controls.Button {
            icon.name: "reload"
            display: Controls.AbstractButton.IconOnly
            visible: fixedCalendarCellFontModeRadioButton.checked
            onClicked: calendarCellFontPixelSizeScale.value = 1.2
            Controls.ToolTip {
              text: Qt.i18next.t('reset', {lng: Plasmoid.configuration.language})
            }
          }
        }

        Controls.Slider {
          id: calendarCellFontPixelSizeScale
          visible: fixedCalendarCellFontModeRadioButton.checked
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
      Kirigami.FormData.label: Qt.i18next.t('font', {lng: Plasmoid.configuration.language}) + ':'
      Kirigami.FormData.labelAlignment: Qt.AlignTop

      Controls.ButtonGroup {
        id: fontRadioGroup
        onCheckedButtonChanged: {
          appearanceConfig.cfg_fontStatus = checkedButton.value
          if (checkedButton.value === Qt._sc_.const.font.MANUAL && appearanceConfig.cfg_fontFamily === "") {
            appearanceConfig.cfg_fontFamily = PlasmaCore.Theme.defaultFont.family
          }
        }
      }

      ColumnLayout {
        Controls.RadioButton {
          text: Qt.i18next.t('default', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: fontRadioGroup
          readonly property string value: Qt._sc_.const.font.DEFAULT
          checked: value === appearanceConfig.cfg_fontStatus
        }

        Controls.RadioButton {
          text: Qt.i18next.t('vazir', {lng: Plasmoid.configuration.language})
          Controls.ButtonGroup.group: fontRadioGroup
          readonly property string value: Qt._sc_.const.font.VAZIR
          checked: value === appearanceConfig.cfg_fontStatus
        }

        Controls.Label {
          text: Qt.i18next.t('best_look_in_persian', {lng: Plasmoid.configuration.language})
          Layout.fillWidth: true
          wrapMode: Text.Wrap
          font: PlasmaCore.Theme.smallestFont
        }

        RowLayout {
          Controls.RadioButton {
            id: fontManualRadioButton
            text: Qt.i18next.t('manual', {lng: Plasmoid.configuration.language})
            Controls.ButtonGroup.group: fontRadioGroup
            readonly property string value: Qt._sc_.const.font.MANUAL
            checked: value === appearanceConfig.cfg_fontStatus
          }

          Controls.Button {
            text: Qt.i18next.t('choose_font', {lng: Plasmoid.configuration.language})
            icon.name: "settings-configure"
            enabled: fontManualRadioButton.checked
            onClicked: {
              fontDialog.font = Qt.font({family: appearanceConfig.cfg_fontFamily})
              fontDialog.open()
            }
          }
        }

        Controls.Label {
          text: Qt.i18next.t('only_font_name_is_applied', {lng: Plasmoid.configuration.language})
          Layout.fillWidth: true
          wrapMode: Text.Wrap
          font: PlasmaCore.Theme.smallestFont
        }

      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    Controls.Switch {
      id: weekendHighlight
      text: Qt.i18next.t('enable_weekend_highlight', {lng: Plasmoid.configuration.language})
    }

    Item {
      readonly property int _scrollHeight: Kirigami.Units.gridUnit * 2
      readonly property int _scrollWidth: Kirigami.Units.gridUnit * 16
      implicitHeight: _scrollHeight
      implicitWidth: _scrollWidth
      Layout.minimumHeight: _scrollHeight
      Layout.maximumHeight: _scrollHeight

      Kirigami.FormData.label: Qt.i18next.t('weekend', {lng: Plasmoid.configuration.language}) + ':'
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
              text: Qt.i18next.t('week_label.' + modelData, {lng: Plasmoid.configuration.language})
              enabled: weekendHighlight.checked
              checked: isChecked()

              onClicked: {
                const weekDaysArray = Qt._sc_.utils.stringToNumberArray(appearanceConfig.cfg_weekendHighlightDays);
                if (checked) {
                  weekDaysArray.push(modelData);
                } else {
                  const index = weekDaysArray.indexOf(modelData);
                  if (index > -1) {
                    weekDaysArray.splice(index, 1);
                  }
                }
                appearanceConfig.cfg_weekendHighlightDays = weekDaysArray.join();
                checked = Qt.binding(isChecked);
              }

              function isChecked() {
                const weekDaysArray = Qt._sc_.utils.stringToNumberArray(appearanceConfig.cfg_weekendHighlightDays);
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
      Kirigami.FormData.label: Qt.i18next.t('panel', {lng: Plasmoid.configuration.language})
    }

    Item {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: Qt.i18next.t('primary_text', {lng: Plasmoid.configuration.language})
    }

    RowLayout {
      Kirigami.FormData.label: Qt.i18next.t('date_format', {lng: Plasmoid.configuration.language}) + ':'

      Controls.TextField {
        id: panelPrimaryTextFormat
        Layout.fillWidth: true
      }
    }

    Item {
      Kirigami.FormData.isSection: true
    }

    RowLayout {
      Kirigami.FormData.label: Qt.i18next.t('result', {lng: Plasmoid.configuration.language}) + ':'
      Controls.Label {
        Layout.maximumWidth: Kirigami.Units.gridUnit * 16
        textFormat: Text.StyledText
        text: {
          if (!panelPrimaryTextFormat.text) return null;
          return Qt._sc_.utils.richDateFormatParser(
            undefined,
            panelPrimaryTextFormat.text,
            Qt._sc_.useLocale(Plasmoid.configuration.language)
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

      Kirigami.FormData.label: Qt.i18next.t('templates', {lng: Plasmoid.configuration.language}) + ':'
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
              property string displayText: Qt._sc_.utils.richDateFormatParser(
                undefined,
                modelData,
                Qt._sc_.useLocale(Plasmoid.configuration.language)
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
      text: Qt.i18next.t('date_format_documentation', {lng: Plasmoid.configuration.language})
      wrapMode: Text.Wrap
      Layout.preferredWidth: Layout.maximumWidth
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      font: PlasmaCore.Theme.smallestFont
      onLinkActivated: Qt.openUrlExternally(link)
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
      }
    }

    Controls.Label {
      text: Qt.i18next.t('font_tag_documentation', {lng: Plasmoid.configuration.language})
      wrapMode: Text.Wrap
      Layout.preferredWidth: Layout.maximumWidth
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      font: PlasmaCore.Theme.smallestFont
      onLinkActivated: Qt.openUrlExternally(link)
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
      }
    }

    Controls.Label {
      text: Qt.i18next.t('format_description', {lng: Plasmoid.configuration.language})
      Layout.fillWidth: true
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      wrapMode: Text.Wrap
      font: PlasmaCore.Theme.smallestFont
    }

    Item {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: Qt.i18next.t('secondary_text', {lng: Plasmoid.configuration.language})
    }

    Controls.Switch {
      id: secondaryText
      text: Qt.i18next.t('enable_secondary_text', {lng: Plasmoid.configuration.language})
    }

    RowLayout {
      Kirigami.FormData.label: Qt.i18next.t('date_format', {lng: Plasmoid.configuration.language}) + ':'
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
      Kirigami.FormData.label: Qt.i18next.t('result', {lng: Plasmoid.configuration.language}) + ':'
      Controls.Label {
        Layout.maximumWidth: Kirigami.Units.gridUnit * 16
        textFormat: Text.StyledText
        text: {
          if (!panelSecondaryTextFormat.text) return null;
          return Qt._sc_.utils.richDateFormatParser(
            undefined,
            panelSecondaryTextFormat.text,
            Qt._sc_.useLocale(Plasmoid.configuration.language)
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

      Kirigami.FormData.label: Qt.i18next.t('templates', {lng: Plasmoid.configuration.language}) + ':'
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
              property string displayText: Qt._sc_.utils.richDateFormatParser(
                undefined,
                modelData,
                Qt._sc_.useLocale(Plasmoid.configuration.language)
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
      Kirigami.FormData.label: Qt.i18next.t('height', {lng: Plasmoid.configuration.language}) + ':'
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

    /* End Panel Settings */

  } // End Kirigami.FormLayout

  QtDialogs.FontDialog {
    id: fontDialog
    title: "Choose a Font"
    modality: Qt.WindowModal

    onAccepted: {
      appearanceConfig.cfg_fontFamily = font.family
    }
  }

} // End ColumnLayout
