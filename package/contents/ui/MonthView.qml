import QtQuick

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "../js/store.js" as Store
import "../js/calendar.js" as CalendarJS
import "../js/calendar-ui.js" as CalendarUI
import "../js/translate.js" as Translate

Grid {
  id: monthView
  property int dayNumberHeight: Math.round((calendar.cellHeight * 80) / 100) // 80% of cell for number
  property int dayEventsHeight: calendar.cellHeight - dayNumberHeight // 20% of cell for event badges
  property var weekendHighlightDaysIndexes: Plasmoid.configuration.weekendHighlight 
    ? CalendarUI.getWeekendHighlightIndexes(Plasmoid.configuration.weekendHighlightDays, rows, columns) 
    : []

  columns: 7
  rows: 7
  columnSpacing: 0
  rowSpacing: 0
  layoutDirection: CalendarUI.useLayoutDirection()
  
  Repeater { // days name Repeater
    id: daysName
    model: Array.from({length: 7}, (_, index) => index + 1)
    delegate: PlasmaComponents3.Label {
      text: Translate.t('week_label.' + modelData)
      width: calendar.cellWidth
      height: calendar.cellDaysNamesHeight
      verticalAlignment: Text.AlignBottom
      horizontalAlignment: Text.AlignHCenter
      opacity: 0.5
      maximumLineCount: 1
      elide: Text.ElideNone
      font.family: root.fontFamily
      font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
    }
  } // end days name Repeater

  Repeater { // days number Repeater
    id: daysRepeater
    model: Store.store.calendarSlice.surface_daysOfMonth
    delegate: Item { // cell container Item
      id: cellContainer
      width: calendar.cellWidth
      height: calendar.cellHeight

      Rectangle { // add weekend highlight if enabled
        visible: Plasmoid.configuration.weekendHighlight && monthView.weekendHighlightDaysIndexes.includes(index + 1)
        anchors.fill: parent
        color: Qt.darker(Kirigami.Theme.backgroundColor)
        opacity: 0.5
      }

      Column { // cell design
        width: parent.width
        height: parent.height
        spacing: 0
        opacity: modelData[1] === Store.store.calendarSlice.surface_yearAndMonth[1] ? 1 : 0.5 // less opacity for prev and next month dates

        PlasmaComponents3.Label { // cell top (number)
          text: Translate.tpd(modelData[2])
          width: height
          height: monthView.dayNumberHeight
          anchors.horizontalCenter: parent.horizontalCenter
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          maximumLineCount: 1
          elide: Text.ElideNone
          font.family: root.fontFamily
          font.pixelSize: Plasmoid.configuration.calendarCellFontSizeMode === 'fit' ? 1000 : Kirigami.Theme.defaultFont.pixelSize * Plasmoid.configuration.calendarCellFontPixelSizeScale
          fontSizeMode: Plasmoid.configuration.calendarCellFontSizeMode === 'fit' ? Text.Fit : Text.FixedSize
          font.weight: modelData[1] === Store.store.calendarSlice.surface_yearAndMonth[1] ? Font.DemiBold : Font.Normal
          color: CalendarUI.monthView_repeater_dayHasHoliday(index) === true ? Plasmoid.configuration.holidayColor : Kirigami.Theme.textColor

          PlasmaExtras.Highlight {
            property bool isHovered: false
            id: monthViewHighlight
            anchors.fill: parent
            hovered: true
            visible: true
            opacity: CalendarUI.monthView_highlightOpacity(isHovered, modelData)
          }

          // background: Rectangle { // Holiday background
          //   visible: CalendarUI.monthView_repeater_dayHasHoliday(index)
          //   radius: 180
          //   color: Plasmoid.configuration.holidayColor
          //   anchors.fill: parent
          // }

        } // end cell top (number)

        Row { // cell bottom (event badges)
          height: monthView.dayEventsHeight
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: Kirigami.Units.gridUnit / 4

          Rectangle {
            visible: CalendarUI.monthView_repeater_dayHasOtherEvent(index)
            width: height
            height: Kirigami.Units.gridUnit / 4
            radius: 180
            color: Plasmoid.configuration.eventColor
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
          CalendarJS.reducers.setSelectedDate(modelData);
        }
      }

    } // end cell container Item
  } // end days number Repeater
} // end Grid
