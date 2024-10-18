import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "../js/translate.js" as Translate
import "../js/events.js" as Events

ScrollView {
  QtObject {
    id: eventsObject
    property var events: Events.getSelectedDateEvents()
  }

  clip: true
  ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
  contentWidth: availableWidth

  anchors {
    topMargin: Kirigami.Units.gridUnit
    bottomMargin: Kirigami.Units.gridUnit
  }

  Column {
    anchors.fill: parent
    spacing: Kirigami.Units.gridUnit / 2

    PlasmaComponents3.Label {
      text: Translate.t('no_event')
      visible: !eventsObject.events.length > 0
      width: parent.width
      height: parent.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 0.2
      font.family: root.fontFamily
      font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.5
      font.weight: Font.Bold
    }

    Repeater {
      model: eventsObject.events
      delegate: RowLayout {
        spacing: Kirigami.Units.gridUnit / 2
        layoutDirection: Qt.RightToLeft
        anchors {
          right: parent.right
          left: parent.left
        }

        Rectangle {
          width: height
          height: Kirigami.Units.gridUnit / 2
          radius: 180
          color: modelData[1] === true ? Plasmoid.configuration.holidayColor : Plasmoid.configuration.eventColor
        }

        PlasmaComponents3.Label {
          Layout.fillWidth: true
          text: modelData[0]
          wrapMode: Text.Wrap
          horizontalAlignment: Qt.AlignRight
          font.family: root.fontFamily
          font.weight: Font.DemiBold
        }

      } // end RowLayout
    } // end Repeater
  } // end Column
} // end ScrollView
