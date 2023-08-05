import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

ScrollView {
  QtObject {
    id: eventsObject
    property var events: Qt._sc_.events.getSelectedDateEvents()
  }

  clip: true
  ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
  contentWidth: availableWidth

  anchors {
    topMargin: PlasmaCore.Units.gridUnit
    bottomMargin: PlasmaCore.Units.gridUnit
  }

  Column {
    anchors.fill: parent
    spacing: PlasmaCore.Units.gridUnit / 2

    PlasmaComponents3.Label {
      text: Qt._sc_.t('no_event')
      visible: !eventsObject.events.length > 0
      width: parent.width
      height: parent.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 0.2
      font.family: root.fontFamily
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.5
      font.weight: Font.Bold
    }

    Repeater {
      model: eventsObject.events
      delegate: RowLayout {
        spacing: PlasmaCore.Units.gridUnit / 2
        layoutDirection: Qt.RightToLeft
        anchors {
          right: parent.right
          left: parent.left
        }

        Rectangle {
          width: height
          height: PlasmaCore.Units.gridUnit / 2
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
