import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: decadeViewGrid
  rows: 4
  columns: 3

  Repeater {
    model: Qt._sc_.store.calendarSlice.surface_yearsOfDecade
    delegate: PlasmaComponents3.Label {
      text: modelData
      width: parent.width / decadeViewGrid.columns
      height: parent.height / decadeViewGrid.rows
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.2
      font.weight: Font.DemiBold
      
      PlasmaExtras.Highlight {
        property bool isHovered: false
        id: decadeViewHighlight
        anchors.fill: parent
        hovered: true
        visible: true
        opacity: Qt._sc_.calendarUI.decadeView_highlightOpacity(isHovered, modelData)
      }
      
      MouseArea {
        id: labelMouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: decadeViewHighlight.isHovered = true
        onExited: decadeViewHighlight.isHovered = false
        onClicked: {
          Qt._sc_.calendar.changeYear(modelData);
          Qt._sc_.calendarUI.stackNavigation_toOrFromDecadeView(true);
        }
      }

    }
  }
}
