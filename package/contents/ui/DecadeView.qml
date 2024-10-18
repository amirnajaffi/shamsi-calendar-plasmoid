import QtQuick

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "../js/store.js" as Store
import "../js/calendar.js" as CalendarJS
import "../js/calendar-ui.js" as CalendarUI
import "../js/translate.js" as Translate

Grid {
  id: decadeViewGrid
  rows: 4
  columns: 3
  rightPadding: Kirigami.Units.gridUnit / 2
  leftPadding: Kirigami.Units.gridUnit / 2
  bottomPadding: Kirigami.Units.gridUnit / 2
  topPadding: Kirigami.Units.gridUnit / 2
  layoutDirection: CalendarUI.useLayoutDirection()

  Repeater {
    model: Store.store.calendarSlice.surface_yearsOfDecade
    delegate: PlasmaComponents3.Label {
      text: Translate.tpd(modelData)
      width: (parent.width - Kirigami.Units.gridUnit) / decadeViewGrid.columns
      height: (parent.height - Kirigami.Units.gridUnit) / decadeViewGrid.rows
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: index === 0 || index === 11 ? 0.5 : 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.family: root.fontFamily
      font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
      font.weight: Font.DemiBold
      
      PlasmaExtras.Highlight {
        property bool isHovered: false
        id: decadeViewHighlight
        anchors.fill: parent
        hovered: true
        visible: true
        opacity: CalendarUI.decadeView_highlightOpacity(isHovered, modelData)
      }
      
      MouseArea {
        id: labelMouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: decadeViewHighlight.isHovered = true
        onExited: decadeViewHighlight.isHovered = false
        onClicked: {
          CalendarJS.changeYear(modelData);
          CalendarUI.stackNavigation_toOrFromDecadeView(true);
        }
      }

    }
  }
}
