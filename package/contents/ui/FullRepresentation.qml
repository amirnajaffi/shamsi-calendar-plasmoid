import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtQml.Models 2.2
import org.kde.kirigami 2.4 as Kirigami
import "../js/bin/jalalidate.js" as Ghamari
import "../js/holidays.js" as Holidays
import "../js/bin/persian-date.js" as PersianDate
import "../js/main.js" as Scripts

Item {
    id: calendar
    width: 375
    height: 410 + (Scripts.getHolidays(selectedDate).length * 30)
    Layout.preferredWidth: 375
    Layout.preferredHeight: 410 + (Scripts.getHolidays(selectedDate).length * 30)
    anchors.topMargin: 10
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    anchors.fill: parent
    ColumnLayout {
        RowLayout {
            id: grid

            ComboBox {
                property var _maxWidth: 85
                currentIndex: Scripts.getYearIndexOf(screenDate.year())
                id: yearsCombo
                width: _maxWidth
                Layout.maximumWidth: _maxWidth
                model: ListModel {
                    id: yearsComboModel
                    Component.onCompleted: {
                        Scripts.makeYears(yearsComboModel)
                    }
                }
                
                onCurrentIndexChanged: function () {
                    if (yearsComboModel.get(currentIndex)) {
                        screenDate = Scripts.yearChanged(yearsComboModel.get(currentIndex).name, screenDate);
                    }
                    days = Scripts.daysInMonth(screenDate);
                }
                
                delegate: ItemDelegate {
                    width: yearsCombo.width
                    contentItem: Text {
                        text: modelData
                        color: Kirigami.Theme.textColor
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: yearsCombo.highlightedIndex === index
                }

                contentItem: Text {} // It must exist here otherwise error will occur in QtQuick.Controls below v2.15

                popup: Popup {
                    y: yearsCombo.height - 1
                    width: yearsCombo.width
                    implicitHeight: 250
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: yearsCombo.popup.visible ? yearsCombo.delegateModel : null
                        currentIndex: yearsCombo.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        border.color: PlasmaCore.Theme.backgroundColor
                        radius: 2
                    }
                }
            }

            ComboBox {
                property var _maxWidth: 85
                currentIndex: Scripts.getMonthIndexOf(screenDate.month())
                id: monthCombo
                width: _maxWidth
                Layout.maximumWidth: _maxWidth
                textRole: "name"
                model: ListModel {
                    id: monthComboModel
                    Component.onCompleted: {
                        Scripts.makeMonths(monthComboModel)
                    }
                }

                delegate: ItemDelegate {
                    width: monthCombo.width
                    contentItem: Text {
                        text: name
                        color: Kirigami.Theme.textColor
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: monthCombo.highlightedIndex === index
                }

                onCurrentIndexChanged: function () {
                    if (monthComboModel.get(currentIndex)) {
                        var monthNum = 1;
                        if (monthComboModel.get(currentIndex).monthNumber) {
                            monthNum = monthComboModel.get(currentIndex).monthNumber;
                        }
                        root.screenDate = Scripts.monthChanged(monthNum, screenDate);
                        root.days = Scripts.daysInMonth(screenDate);
                    }
                }

                contentItem: Text {} // It must exist here otherwise error will occur in QtQuick.Controls below v2.15

                popup: Popup {
                    y: monthCombo.height - 1
                    width: monthCombo.width
                    implicitHeight: 250
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: monthCombo.popup.visible ? monthCombo.delegateModel : null
                        currentIndex: monthCombo.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        border.color: PlasmaCore.Theme.backgroundColor
                        radius: 2
                    }
                }
            }
            
            // Spacer between Combos and Buttons in header
            Item {
                Layout.fillWidth: true
            }

           RowLayout {
                spacing: PlasmaCore.Units.smallSpacing

                PlasmaComponents.ToolButton {
                    id: previousButton
                    iconName: "go-previous" // You have previous expectation...
                    tooltip: "ماه بعدی"       //But... I know, iii know, It's not fair.
                    onClicked: function() {
                        screenDate = screenDate.add('months', 1);
                    }
                    Accessible.name: tooltip
                    Layout.preferredHeight: implicitHeight + implicitHeight%2
                }

                PlasmaComponents.ToolButton {
                    iconName: "go-jump-today"
                    onClicked: function() {
                        screenDate = new persianDate();
                        todayDate = new persianDate();
                    }
                    tooltip: "امروز"
                    Accessible.name: tooltip
                    Accessible.description: "بازنشانی به تاریخ امروز"
                    Layout.preferredHeight: implicitHeight + implicitHeight%2
                }

                PlasmaComponents.ToolButton {
                    id: nextButton
                    iconName: "go-next"
                    tooltip: "ماه قبلی"  //I know this is not right!
                    onClicked: function() {
                        screenDate = screenDate.subtract('months', 1);
                    }
                    Accessible.name: tooltip
                    Layout.preferredHeight: implicitHeight + implicitHeight%2
                }
            } 

        }

        Grid {
            id: dayCell
            columns: 7
            // rows: Math.floor((days + (startOfWeek - 1)) / 7)
            layoutDirection: Qt.RightToLeft
            spacing: 1

            readonly property int cellWidth: Math.floor(calendar.width / dayCell.columns - 2)
            readonly property int cellHeight:  Math.floor(calendar.width / dayCell.columns - 4)

            // days name
            Repeater {
                model: week
                PlasmaComponents.Label {
                    height: dayCell.cellWidth
                    width: dayCell.cellHeight
                    text: modelData
                    font.pixelSize: Math.max(PlasmaCore.Theme.smallestFont.pixelSize, dayCell.cellHeight / 3)
                    opacity: 0.4
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    fontSizeMode: Text.HorizontalFit
                }
            }

            // Days offset
            Repeater {
                model: startOfWeek - 1
                Rectangle {
                    width: dayCell.cellWidth
                    height: dayCell.cellHeight
                    opacity: 0
                }
            }

            // Days cell
            Repeater {
                model: days
                id: daysRepeater
                
                MouseArea {
                    id: dayStyle
                    hoverEnabled: true
                    width: dayCell.cellWidth
                    height: dayCell.cellHeight
                    onClicked: root.selectedDate = new persianDate([modelData[0], modelData[1], modelData[2]])

                    Rectangle {
                        id: todayRect
                        anchors.fill: parent
                        opacity: {
                            if (
                                // Selected and Today
                                   todayDate.year()  == selectedDate.year() 
                                && todayDate.month() == selectedDate.month()
                                && todayDate.date()  == selectedDate.date()
                                && todayDate.year()  == modelData[0]
                                && todayDate.month() == modelData[1]
                                && todayDate.date()  == modelData[2]
                            ){
                                0.6
                            } else if (
                                // Today
                                   todayDate.year()  == modelData[0]
                                && todayDate.month() == modelData[1]
                                && todayDate.date()  == modelData[2]
                            ){
                                0.4
                            } else {
                                0
                            }
                        }
                        Behavior on opacity { NumberAnimation { duration: PlasmaCore.Units.shortDuration*2 } }
                        color: PlasmaCore.Theme.textColor
                    }

                    Rectangle {
                        id: highlightDate
                        anchors.fill: todayRect
                        opacity: {
                            if (
                                // Selected
                                   selectedDate.year()  == modelData[0]
                                && selectedDate.month() == modelData[1]
                                && selectedDate.date()  == modelData[2]
                            ){
                                0.6
                            } else if (dayStyle.containsMouse){
                                0.4
                            } else {
                                0
                            }
                        }
                        
                        Behavior on opacity { NumberAnimation { duration: PlasmaCore.Units.shortDuration*2 } }
                        color: PlasmaCore.Theme.highlightColor
                        z: todayRect.z - 1
                    }

                    Rectangle {
                        id: highlightHoliday
                        anchors.fill: todayRect
                        opacity: Scripts.isHoliday(modelData) ? 0.3 : (modelData[3] == 7 ? 0.05 : 0)
                        Behavior on opacity { NumberAnimation { duration: PlasmaCore.Units.shortDuration*2 } }
                        color: '#e81c1c'
                        z: todayRect.z - 1
                    }

                    // Show days number on screen
                    PlasmaComponents.Label {
                        id: label
                        anchors {
                            fill: todayRect
                            margins: PlasmaCore.Units.smallSpacing
                        }
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: modelData[2]
                        opacity: 1
                        wrapMode: Text.NoWrap
                        elide: Text.ElideRight
                        fontSizeMode: Text.HorizontalFit
                        font.pixelSize: Math.max(PlasmaCore.Theme.smallestFont.pixelSize, 14)
                        font.pointSize: -1
                        color: root.isToday(modelData) ? PlasmaCore.Theme.backgroundColor : PlasmaCore.Theme.textColor
                        Behavior on color {
                            ColorAnimation { duration: PlasmaCore.Units.shortDuration * 2 }
                        }
                    }
                    
                }
            }
        }

        // Show holidays event
        ColumnLayout {
            Layout.preferredWidth: calendar.width
            width: calendar.width

            Repeater {
                model: Scripts.getHolidays(root.selectedDate)
                Text {
                    rightPadding: 10
                    horizontalAlignment: Text.AlignLeft
                    LayoutMirroring.enabled: true
                    Layout.preferredWidth: calendar.width
                    width: calendar.width
                    text: modelData
                    wrapMode: Text.WordWrap
                    color: '#e81c1c'
                }
            }
        }
    }

    function isToday(date) {
        return todayDate.year() == date[0] && todayDate.month() == date[1] && todayDate.date()  == date[2];
    }

}