import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: yearViewGrid
  rows: 4
  columns: 3
  
  Repeater {
    model: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    PlasmaComponents3.Label {
      text: modelData
      width: parent.width / yearViewGrid.columns
      height: parent.height / yearViewGrid.rows
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      opacity: 1
      maximumLineCount: 1
      elide: Text.ElideRight
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.2
      font.weight: Font.DemiBold
    }
  }

}
