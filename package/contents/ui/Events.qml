import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

ScrollView {
  clip: true
  ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
  anchors {
    topMargin: PlasmaCore.Units.gridUnit
    bottomMargin: PlasmaCore.Units.gridUnit
  }

  Column {
    anchors.fill: parent
    spacing: PlasmaCore.Units.gridUnit / 2

    PlasmaComponents3.Label {
      text: 'No Event'
      visible: eventsData.length > 0 ? false : true
      width: parent.width
      height: parent.height
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 0.2
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.5
      font.weight: Font.Bold
    }

    Repeater {
      model: eventsData
      delegate: RowLayout {
        spacing: PlasmaCore.Units.gridUnit / 2
        anchors {
          right: parent.right
          left: parent.left
        }

        Rectangle {
          width: height
          height: PlasmaCore.Units.gridUnit / 2
          radius: 180
          color: 'orange'
        }

        PlasmaComponents3.Label {
          Layout.fillWidth: true
          text: modelData
          wrapMode: Text.Wrap
          font.weight: Font.DemiBold
        }

      } // end RowLayout
    } // end Repeater
  } // end Column
} // end ScrollView
