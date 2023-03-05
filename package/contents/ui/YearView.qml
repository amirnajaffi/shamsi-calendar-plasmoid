import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: yearViewGrid
  rows: 4
  columns: 3
  rightPadding: PlasmaCore.Units.gridUnit / 2
  leftPadding: PlasmaCore.Units.gridUnit / 2
  bottomPadding: PlasmaCore.Units.gridUnit / 2
  topPadding: PlasmaCore.Units.gridUnit / 2
  
  Repeater {
    model: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    delegate:  PlasmaComponents3.Label {
      id: label
      text: modelData
      width: (parent.width - PlasmaCore.Units.gridUnit) / yearViewGrid.columns
      height: (parent.height - PlasmaCore.Units.gridUnit) / yearViewGrid.rows
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.2
      font.weight: Font.DemiBold

      PlasmaExtras.Highlight {
        property bool isHovered: false
        id: yearViewHighlight
        anchors.fill: parent
        hovered: true
        visible: true
        opacity: Qt._sc_.calendarUI.yearView_highlightOpacity(isHovered, index + 1)
      }

      MouseArea {
        id: labelMouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: yearViewHighlight.isHovered = true
        onExited: yearViewHighlight.isHovered = false
        onClicked: {
          Qt._sc_.calendar.changeMonth(index+1);
          Qt._sc_.calendarUI.stackNavigation_toOrFromYearView();
        }
      }

    }
  }
}
