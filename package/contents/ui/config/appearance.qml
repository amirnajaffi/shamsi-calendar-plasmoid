import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.5 as Controls

import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.5 as Kirigami

ColumnLayout {
  id: appearanceConfig

  property alias cfg_panelPrimaryTextFormat: panelPrimaryTextFormat.text
  property alias cfg_secondaryText: secondaryText.checked
  property alias cfg_panelSecondaryTextFormat: panelSecondaryTextFormat.text
  property alias cfg_secondaryTextHeight: secondaryTextHeight.value
  property alias cfg_weekendHighlight: weekendHighlight.checked
  property string cfg_weekendHighlightDays

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
    'dddd D MMM YYY',
    'ddd D MMM YYYY',
  ]

  anchors.fill: parent

  Kirigami.FormLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

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

    RowLayout {
      Kirigami.FormData.label: Qt.i18next.t('result', {lng: Plasmoid.configuration.language}) + ':'
      Controls.Label {
        textFormat: Text.PlainText
        text: {
          if (!panelPrimaryTextFormat.text) return null;
          const locale = Qt._sc_.useLocale(Plasmoid.configuration.language);
          return new persianDate().toLocale(locale).format(panelPrimaryTextFormat.text)
        }
      }
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
              property string displayText: {
                const locale = Qt._sc_.useLocale(Plasmoid.configuration.language);
                new persianDate().toLocale(locale).format(modelData);
              }
              text: displayText
              Controls.ToolTip.visible: hovered
              Controls.ToolTip.delay: 500
              Controls.ToolTip.text: displayText
              onClicked: panelPrimaryTextFormat.text = modelData
            }
          }
        }
      }
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

    RowLayout {
      Kirigami.FormData.label: Qt.i18next.t('result', {lng: Plasmoid.configuration.language}) + ':'
      Controls.Label {
        textFormat: Text.PlainText
        text: {
          if (!panelSecondaryTextFormat.text) return null;
          const locale = Qt._sc_.useLocale(Plasmoid.configuration.language);
          return new persianDate().toLocale(locale).format(panelSecondaryTextFormat.text)
        }
      }
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
              property string displayText: {
                const locale = Qt._sc_.useLocale(Plasmoid.configuration.language);
                new persianDate().toLocale(locale).format(modelData);
              }
              text: displayText
              Controls.ToolTip.visible: hovered
              Controls.ToolTip.delay: 500
              Controls.ToolTip.text: displayText
              onClicked: panelSecondaryTextFormat.text = modelData
              enabled: secondaryText.checked
            }
          }
        }
      }
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
    /* End Panel Settings */

    /* Start Calendar Settings */
    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: Qt.i18next.t('calendar', {lng: Plasmoid.configuration.language})
    }

    Controls.Switch {
      id: weekendHighlight
      text: Qt.i18next.t('enable_weekend_highlight', {lng: Plasmoid.configuration.language})
    }

    Item {
      readonly property int _scrollHeight: Kirigami.Units.gridUnit * 3
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

        Component.onCompleted: {
          appearanceConfig.cfg_weekendHighlightDays = Plasmoid.configuration.weekendHighlightDays;
        }
      } // end Scrollview
    } // end item
    /* End Calendar Settings */

  } // End Kirigami.FormLayout
} // End ColumnLayout
