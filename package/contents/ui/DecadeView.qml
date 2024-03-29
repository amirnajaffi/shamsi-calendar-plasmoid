import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: decadeViewGrid
  rows: 4
  columns: 3
  rightPadding: PlasmaCore.Units.gridUnit / 2
  leftPadding: PlasmaCore.Units.gridUnit / 2
  bottomPadding: PlasmaCore.Units.gridUnit / 2
  topPadding: PlasmaCore.Units.gridUnit / 2
  layoutDirection: Qt._sc_.calendarUI.useLayoutDirection()

  Repeater {
    model: Qt._sc_.store.calendarSlice.surface_yearsOfDecade
    delegate: PlasmaComponents3.Label {
      text: Qt._sc_.tpd(modelData)
      width: (parent.width - PlasmaCore.Units.gridUnit) / decadeViewGrid.columns
      height: (parent.height - PlasmaCore.Units.gridUnit) / decadeViewGrid.rows
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: index === 0 || index === 11 ? 0.5 : 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.family: root.fontFamily
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
