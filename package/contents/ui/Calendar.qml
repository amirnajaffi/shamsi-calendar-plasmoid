import QtQuick 2.12
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaExtras.Representation {
  id: calendar

  readonly property int _minimumWidth: Math.round(PlasmaCore.Units.gridUnit * 21)
  readonly property int _minimumHeight: Math.round(PlasmaCore.Units.gridUnit * 20) + eventsHeight

  implicitWidth: _minimumWidth
  Layout.preferredWidth: _minimumWidth
  Layout.minimumWidth: _minimumWidth
  Layout.maximumWidth: _minimumWidth
  Layout.preferredHeight: _minimumHeight
  Layout.minimumHeight: _minimumHeight
  Layout.maximumHeight: _minimumHeight

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
      spacing: PlasmaCore.Units.smallSpacing
      layoutDirection: Qt._sc_.calendarUI.useLayoutDirection()
      anchors.fill: parent
      anchors.topMargin: PlasmaCore.Units.gridUnit / 3
      anchors.bottomMargin: PlasmaCore.Units.gridUnit / 3

      PlasmaComponents3.Label { // header month section
        id: monthLabel
        text: Qt._sc_.t('month.normal.' + Qt._sc_.store.calendarSlice.surface_yearAndMonth[1])
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignLeft
        leftPadding: PlasmaCore.Units.largeSpacing / 2
        rightPadding: PlasmaCore.Units.largeSpacing / 2
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        wrapMode: Text.Wrap
        elide: Text.ElideRight
        font.family: root.fontFamily
        font.pixelSize: 300
        font.weight: Font.DemiBold
        MouseArea {
          anchors.fill: parent
          onClicked: Qt._sc_.calendarUI.stackNavigation_toOrFromYearView()
        }
      }

      Item { // spacer between header month and header buttons/year
        Layout.fillWidth: true
      }
      
      RowLayout { // header buttons/year RowLayout
        spacing: 0
        layoutDirection: Qt._sc_.calendarUI.useLayoutDirection()
        Layout.rightMargin: PlasmaCore.Units.largeSpacing / 2
        Layout.leftMargin: PlasmaCore.Units.largeSpacing / 2

        PlasmaComponents3.Label { // header year section
          leftPadding: 2
          rightPadding: 2
          id: yearLabel
          text: Qt._sc_.tpd(Qt._sc_.store.calendarSlice.surface_yearAndMonth[0])
          Layout.maximumWidth: calendar.width / 3
          Layout.minimumWidth: calendar.width / 3
          Layout.fillHeight: true
          horizontalAlignment: Qt._sc_.calendarUI.useTextHorizontalAlignment(true)
          verticalAlignment: Text.AlignVCenter
          fontSizeMode: Text.Fit
          wrapMode: Text.Wrap
          elide: Text.ElideRight
          font.family: root.fontFamily
          font.pixelSize: 300
          font.weight: Font.Light
          MouseArea {
            anchors.fill: parent
            onClicked: Qt._sc_.calendarUI.stackNavigation_toOrFromDecadeView()
          }
        }

        PlasmaComponents3.ToolButton {
          id: todayButton
          property string displayText: Qt._sc_.t(Qt._sc_.calendarUI.headerNavigation_buttonName('current'))
          icon.name: "go-jump-today"
          Accessible.description: displayText
          onClicked: Qt._sc_.calendarUI.headerNavigation_goNextModelState('current')
          PlasmaComponents3.ToolTip {
            text: parent.displayText
            font.family: root.fontFamily
          }
        }

        PlasmaComponents3.ToolButton {
          property string displayText: Qt._sc_.t(Qt._sc_.calendarUI.headerNavigation_buttonName('prev'))
          id: previousButton
          icon.name: "go-up"
          Accessible.description: displayText
          onClicked: Qt._sc_.calendarUI.headerNavigation_goNextModelState('prev')
          PlasmaComponents3.ToolTip {
            text: parent.displayText
            font.family: root.fontFamily
          }
        }

        PlasmaComponents3.ToolButton {
          property string displayText: Qt._sc_.t(Qt._sc_.calendarUI.headerNavigation_buttonName('next'))
          id: nextButton
          icon.name: "go-down"
          Accessible.description: displayText
          onClicked: Qt._sc_.calendarUI.headerNavigation_goNextModelState('next')
          PlasmaComponents3.ToolTip {
            text: parent.displayText
            font.family: root.fontFamily
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

      pushEnter: Transition {
        NumberAnimation {
          duration: PlasmaCore.Units.shortDuration
          property: "opacity"
          from: 0
          to: 1
        }
        NumberAnimation {
          duration: PlasmaCore.Units.shortDuration
          property: "scale"
          from: 1.5
          to: 1
        }
      }

      pushExit: Transition {
        NumberAnimation {
          duration: PlasmaCore.Units.shortDuration
          property: "opacity"
          from: 1
          to: 0
        }
      }

      popEnter: Transition {
        NumberAnimation {
          duration: PlasmaCore.Units.shortDuration
          property: "opacity"
          from: 0
          to: 1
        }
      }

      popExit: Transition {
        id: popExit
        NumberAnimation {
          duration: PlasmaCore.Units.shortDuration
          property: "opacity"
          from: 1
          to: 0
        }
        NumberAnimation {
          duration: PlasmaCore.Units.shortDuration
          property: "scale"
          to: popExit.ViewTransition.item.scale * 1.5
        }
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
        property string displayText: Qt._sc_.t("configure")
        icon.name: "configure"
        Accessible.description: displayText
        onClicked: plasmoid.action("configure").trigger()
        PlasmaComponents3.ToolTip {
          text: parent.displayText
          font.family: root.fontFamily
        }
      }

      PlasmaComponents3.ToolButton {
        id: pinButton
        property string displayText: Qt._sc_.t("keep_open")
        checkable: true
        icon.name: "window-pin"
        Accessible.description: displayText
        onToggled: root.hideOnWindowDeactivate = !root.hideOnWindowDeactivate
        PlasmaComponents3.ToolTip {
          text: parent.displayText
          font.family: root.fontFamily
        }
      }

      PlasmaComponents3.ToolButton {
        id: langButton
        property string displayText: Qt._sc_.t("change_language")
        icon.name: "config-language"
        Accessible.description: displayText
        onClicked: {
          const newLang = Plasmoid.configuration.tempLanguage === 'en' ? 'fa' : 'en';
          Plasmoid.configuration.tempLanguage = newLang;
        }
        PlasmaComponents3.ToolTip {
          text: parent.displayText
          font.family: root.fontFamily
        }
      }

    } // end footer buttons/year Row
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
