import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaExtras.Representation {
  id: calendar
  readonly property int _minimumWidth: Math.round(PlasmaCore.Units.gridUnit * 21)
  readonly property int _minimumHeight: Math.round(PlasmaCore.Units.gridUnit * 20) + eventsHeight
  Layout.minimumWidth: _minimumWidth
  Layout.minimumHeight: _minimumHeight
  Layout.maximumWidth: PlasmaCore.Units.gridUnit * 80
  Layout.maximumHeight: PlasmaCore.Units.gridUnit * 40

  property int headerHeight: Math.round(PlasmaCore.Units.gridUnit * 3.15)
  property int footerHeight: Math.round(PlasmaCore.Units.gridUnit * 2)
  property int eventsHeight: PlasmaCore.Units.gridUnit * 6
  property int cellWidth: Math.round(( width - (monthViewAndEvents.monthView.columnSpacing * (monthViewAndEvents.monthView.columns - 1)) ) / monthViewAndEvents.monthView.columns)
  property int cellHeight: Math.round((height - PlasmaCore.Units.gridUnit - headerHeight - cellDaysNamesHeight - footerHeight - eventsHeight) / (monthViewAndEvents.monthView.rows - 1))
  property int cellDaysNamesHeight: cellWidth / 2
  
  collapseMarginsHint: true
  
  header: PlasmaExtras.PlasmoidHeading {
    id: header
    location: PlasmaExtras.PlasmoidHeading.Location.Header
    width: parent.width
    height: calendar.headerHeight

    RowLayout {
      anchors.fill: parent
      anchors.topMargin: PlasmaCore.Units.gridUnit / 3
      anchors.bottomMargin: PlasmaCore.Units.gridUnit / 3
      spacing: PlasmaCore.Units.smallSpacing

      PlasmaComponents3.Label { // header month section
        id: monthLabel
        text: Qt._sc_.t('month.normal.' + Qt._sc_.store.calendarSlice.surface_yearAndMonth[1])
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignLeft
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        font.pixelSize: 300
        font.weight: Font.DemiBold
        MouseArea {
          anchors.fill: parent
          onClicked: Qt._sc_.calendarUI.stackNavigation_toOrFromYearView()
        }
      }

      PlasmaComponents3.Label { // header year section
        id: yearLabel
        text: Qt._sc_.store.calendarSlice.surface_yearAndMonth[0]
        Layout.maximumWidth: yearLabel.paintedWidth
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignLeft
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        font.pixelSize: 300
        font.weight: Font.Light
        MouseArea {
          anchors.fill: parent
          onClicked: Qt._sc_.calendarUI.stackNavigation_toOrFromDecadeView()
        }
      }

      Item { // spacer between header month/year and header buttons
        Layout.fillWidth: true
      }
      
      RowLayout { // header buttons RowLayout
        spacing: 0

        PlasmaComponents3.ToolButton {
          id: todayButton
          property string displayText: Qt._sc_.calendarUI.headerNavigation_buttonName('current')
          icon.name: "go-jump-today"
          Accessible.description: displayText
          onClicked: Qt._sc_.calendarUI.headerNavigation_goNextModelState('current')
          PlasmaComponents3.ToolTip {
            text: parent.displayText
          }
        }

        PlasmaComponents3.ToolButton {
          property string displayText: Qt._sc_.calendarUI.headerNavigation_buttonName('prev')
          id: previousButton
          icon.name: "go-up"
          Accessible.description: displayText
          onClicked: Qt._sc_.calendarUI.headerNavigation_goNextModelState('prev')
          PlasmaComponents3.ToolTip {
            text: parent.displayText
          }
        }

        PlasmaComponents3.ToolButton {
          property string displayText: Qt._sc_.calendarUI.headerNavigation_buttonName('next')
          id: nextButton
          icon.name: "go-down"
          Accessible.description: displayText
          onClicked: Qt._sc_.calendarUI.headerNavigation_goNextModelState('next')
          PlasmaComponents3.ToolTip {
            text: parent.displayText
          }
        }

        Component.onCompleted: {
          qmlStore.uiReference.monthLabel = monthLabel
          qmlStore.uiReference.yearLabel = yearLabel
          qmlStore.uiReference.todayButton = todayButton
          qmlStore.uiReference.previousButton = previousButton
          qmlStore.uiReference.nextButton = nextButton
        }
      } // end header buttons RowLayout
    } // End header RowLayout
  } // End header PlasmaExtras.PlasmoidHeading
  
  contentItem: Item {
    id: body
    anchors {
      top: header.bottom
      right: parent.right
      bottom: footer.top
      left: parent.left
    }
    
    StackView {
      id: stack
      clip: true
      anchors.fill: parent
      initialItem: MonthViewAndEvents {
        id: monthViewAndEvents
        objectName: Qt._sc_.const.stack.MONTH_VIEW_AND_EVENTS.objectName
      }

      Component.onCompleted: qmlStore.uiReference.stack = stack
    }

  } // end contentItem

  footer: PlasmaExtras.PlasmoidHeading {
    id: footer
    location: PlasmaExtras.PlasmoidHeading.Location.Footer
    width: parent.width
    height: calendar.footerHeight

    Row { // footer buttons Row
      spacing: 0
      anchors.fill: parent
      layoutDirection: Qt.RightToLeft
      
      PlasmaComponents3.ToolButton {
        id: configButton
        property string displayText: "Configure"
        icon.name: "configure"
        Accessible.description: displayText
        onClicked: plasmoid.action("configure").trigger()
        PlasmaComponents3.ToolTip {
          text: parent.displayText
        }
      }

      PlasmaComponents3.ToolButton {
        id: pinButton
        property string displayText: "Keep Open"
        checkable: true
        icon.name: "window-pin"
        Accessible.description: displayText
        onToggled: root.hideOnWindowDeactivate = !root.hideOnWindowDeactivate
        PlasmaComponents3.ToolTip {
          text: parent.displayText
        }
      }

      PlasmaComponents3.ToolButton {
        id: langButton
        property string displayText: "Change Language"
        icon.name: "config-language"
        Accessible.description: displayText
        onClicked: Qt._sc_.changeLang()
        PlasmaComponents3.ToolTip {
          text: parent.displayText
        }
      }

    } // end footer buttons Row
  } // end footer PlasmaExtras.PlasmoidHeading

  component MonthViewAndEvents: Item {
    property alias monthView: _monthView
    property alias events: _events

    MonthView {
      id: _monthView
    }

    Events {
      id: _events
      anchors {
        top: monthView.bottom
        right: parent.right
        bottom: parent.bottom
        left: parent.left
      }
    }
  }
  
  Component {
    id: yearViewComponent
    YearView {
      objectName: Qt._sc_.const.stack.YEAR_VIEW.objectName
    }
  }

  Component {
    id: decadeViewComponent
    DecadeView {
      objectName: Qt._sc_.const.stack.DECADE_VIEW.objectName
    }
  }

  Component.onCompleted: {
    qmlStore.uiReference.yearViewComponent = yearViewComponent
    qmlStore.uiReference.decadeViewComponent = decadeViewComponent
  }

} // end PlasmaExtras.Representation
