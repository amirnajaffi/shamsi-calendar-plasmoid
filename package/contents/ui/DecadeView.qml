import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: decadeViewGrid
  rows: 4
  columns: 3

  Repeater {
    model: ['2019', '2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030']
    PlasmaComponents3.Label {
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
    }
  }

}
