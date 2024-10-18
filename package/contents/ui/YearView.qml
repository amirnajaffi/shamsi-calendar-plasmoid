import QtQuick

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "../js/calendar-ui.js" as CalendarUI
import "../js/translate.js" as Translate
import "../js/calendar.js" as CalendarJS

Grid {
  id: yearViewGrid
  rows: 4
  columns: 3
  rightPadding: Kirigami.Units.gridUnit / 2
  leftPadding: Kirigami.Units.gridUnit / 2
  bottomPadding: Kirigami.Units.gridUnit / 2
  topPadding: Kirigami.Units.gridUnit / 2
  layoutDirection: CalendarUI.useLayoutDirection()
  
  Repeater {
    model: Array.from({length: 12}, (_, index) => index + 1)
    delegate:  PlasmaComponents3.Label {
      id: label
      text: Translate.t('month.normal.' + modelData)
      width: (parent.width - Kirigami.Units.gridUnit) / yearViewGrid.columns
      height: (parent.height - Kirigami.Units.gridUnit) / yearViewGrid.rows
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.family: root.fontFamily
      font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
      font.weight: Font.DemiBold

      PlasmaExtras.Highlight {
        property bool isHovered: false
        id: yearViewHighlight
        anchors.fill: parent
        hovered: true
        visible: true
        opacity: CalendarUI.yearView_highlightOpacity(isHovered, index + 1)
      }

      MouseArea {
        id: labelMouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: yearViewHighlight.isHovered = true
        onExited: yearViewHighlight.isHovered = false
        onClicked: {
          CalendarJS.changeMonth(index+1);
          CalendarUI.stackNavigation_toOrFromYearView();
        }
      }

    }
  }
}
