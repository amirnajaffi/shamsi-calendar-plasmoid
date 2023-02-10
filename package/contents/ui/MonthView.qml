import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: monthViewGrid
  columns: 7
  rows: 7
  columnSpacing: 0
  rowSpacing: 0
  
  Repeater {
    id: daysName
    model: ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'] // TODO: temp data for ui testing purpose

    PlasmaComponents3.Label {
      text: modelData
      width: calendar.cellWidth
      height: calendar.cellDaysNamesHeight
      verticalAlignment: Text.AlignBottom
      horizontalAlignment: Text.AlignHCenter
      opacity: 0.5
      maximumLineCount: 1
      elide: Text.ElideRight
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize
    }
  } // end Repeater

  Repeater {
    id: daysRepeat
    model: Array.from(Array(41).keys()) // TODO: temp data for ui testing purpose

    PlasmaComponents3.Label {
      text: modelData
      width: calendar.cellWidth
      height: calendar.cellHeight
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.2
      font.weight: Font.DemiBold
    }
  } // end Repeater
} // end Grid
