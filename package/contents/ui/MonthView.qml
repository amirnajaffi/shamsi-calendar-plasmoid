import QtQuick 2.12

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

Grid {
  id: monthView
  property int dayNumberHeight: Math.round((calendar.cellHeight * 80) / 100) // 80% of cell for number
  property int dayEventsHeight: calendar.cellHeight - dayNumberHeight // 20% of cell for event badges

  columns: 7
  rows: 7
  columnSpacing: 0
  rowSpacing: 0
  layoutDirection: Qt._sc_.calendarUI.useLayoutDirection()
  
  Repeater { // days name Repeater
    id: daysName
    model: Array.from({length: 7}, (_, index) => index + 1)
    delegate: PlasmaComponents3.Label {
      text: Qt._sc_.t('week_label.' + modelData) 
      width: calendar.cellWidth
      height: calendar.cellDaysNamesHeight
      verticalAlignment: Text.AlignBottom
      horizontalAlignment: Text.AlignHCenter
      opacity: 0.5
      maximumLineCount: 1
      elide: Text.ElideRight
      font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize
    }
  } // end days name Repeater

  Repeater { // days number Repeater
    id: daysRepeater
    model: Qt._sc_.store.calendarSlice.surface_daysOfMonth
    delegate: Item { // cell container Item
      id: cellContainer
      width: calendar.cellWidth
      height: calendar.cellHeight

      // TODO: add weekend highlight 
      // Rectangle {
      //   anchors.fill: parent
      //   color: "gray"
      // }

      Column { // cell design
        width: parent.width
        height: parent.height
        spacing: 0
        opacity: modelData[1] === Qt._sc_.store.calendarSlice.surface_yearAndMonth[1] ? 1 : 0.5 // less opacity for prev and next month dates

        PlasmaComponents3.Label { // cell top (number)
          text: Qt._sc_.tpd(modelData[2])
          width: height
          height: monthView.dayNumberHeight
          anchors.horizontalCenter: parent.horizontalCenter
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          maximumLineCount: 1
          elide: Text.ElideRight
          font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.2
          font.weight: modelData[1] === Qt._sc_.store.calendarSlice.surface_yearAndMonth[1] ? Font.DemiBold : Font.Normal
          color: Qt._sc_.calendarUI.monthView_repeater_dayHasHoliday(index) === true ? Qt._sc_.const.COLOR_EVENT_HOLIDAY : PlasmaCore.Theme.textColor

          RoundedHighlight {
            property bool isHovered: false
            id: monthViewHighlight
            anchors.fill: parent
            hovered: true
            visible: true
            opacity: Qt._sc_.calendarUI.monthView_highlightOpacity(isHovered, modelData)
          }

          // background: Rectangle { // Holiday background
          //   visible: Qt._sc_.calendarUI.monthView_repeater_dayHasHoliday(index)
          //   radius: 180
          //   color: Qt._sc_.const.COLOR_EVENT_HOLIDAY
          //   anchors.fill: parent
          // }

        } // end cell top (number)

        Row { // cell bottom (event badges)
          height: monthView.dayEventsHeight
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: PlasmaCore.Units.gridUnit / 4

          Rectangle {
            visible: Qt._sc_.calendarUI.monthView_repeater_dayHasOtherEvent(index)
            width: height
            height: PlasmaCore.Units.gridUnit / 4
            radius: 180
            color: Qt._sc_.const.COLOR_EVENT_OTHER
          }
        } // end cell bottom (event badges)

      } // end column

      MouseArea {
        id: labelMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: monthViewHighlight.isHovered = true
        onExited: monthViewHighlight.isHovered = false
        onClicked: {
          Qt._sc_.calendar.reducers.setSelectedDate(modelData);
        }
      }

    } // end cell container Item
  } // end days number Repeater
} // end Grid
