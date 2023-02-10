import QtQuick 2.12

import org.kde.plasma.components 3.0 as PlasmaComponents3

Column {
  Repeater {
    model: eventsData
    PlasmaComponents3.Label {
      width: parent.width
      text: modelData
      wrapMode: Text.WordWrap
    }
  }
}
