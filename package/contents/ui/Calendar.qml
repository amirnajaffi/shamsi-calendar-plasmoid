import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras


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
  property int eventsHeight: eventsData.length * PlasmaCore.Units.gridUnit
  property int cellWidth: Math.round(( width - (monthViewAndEvents.monthView.columnSpacing * (monthViewAndEvents.monthView.columns - 1)) ) / monthViewAndEvents.monthView.columns)
  property int cellHeight: Math.round((height - headerHeight - cellDaysNamesHeight - footerHeight - eventsHeight) / (monthViewAndEvents.monthView.rows - 1))
  property int cellDaysNamesHeight: cellWidth / 2
  property var eventsData: [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "2Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "3Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "4Lorem ipsum dolor sit amet, consectetur adipiscing elit",
  ] // TODO: temp data for ui testing purpose
  
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
        text: "February"
        Layout.maximumWidth: monthLabel.paintedWidth
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
          onClicked: {
            stack.push(yearViewComponent);
          }
        }
      }

      PlasmaComponents3.Label { // header year section
        id: yearLabel
        text: "2022"
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
          onClicked: {
            stack.push(decadeViewComponent);
          }
        }
      }

      Item { // spacer between header month/year and header buttons
        Layout.fillWidth: true
      }
      
      RowLayout { // header buttons RowLayout
        spacing: 0

        PlasmaComponents3.ToolButton {
          property string displayText: "Today"
          id: todayButton
          icon.name: "go-jump-today"
          Accessible.description: displayText
          onClicked: function() {}
          PlasmaComponents3.ToolTip {
            text: parent.displayText
          }
        }

        PlasmaComponents3.ToolButton {
          property string displayText: "Previous Month"
          id: previousButton
          icon.name: "go-up"
          Accessible.description: displayText
          onClicked: function() {}
          PlasmaComponents3.ToolTip {
            text: parent.displayText
          }
        }

        PlasmaComponents3.ToolButton {
          property string displayText: "Next Month"
          id: nextButton
          icon.name: "go-down"
          Accessible.description: displayText
          onClicked: function() {}
          PlasmaComponents3.ToolTip {
            text: parent.displayText
          }
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
      }
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
        onClicked: function() {}
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
        onClicked: function() {}
        PlasmaComponents3.ToolTip {
          text: parent.displayText
        }
      }

    } // end footer buttons Row
  } // end footer PlasmaExtras.PlasmoidHeading

  component MonthViewAndEvents: Item {
    property Grid monthView: _monthView
    property Column events: _events

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
      id: yearView
    }
  }

  Component {
    id: decadeViewComponent
    DecadeView {
      id: decadeView
    }
  }

} // end PlasmaExtras.Representation
