import QtQuick 2.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../js/store.js" as Store
import "../js/bin/persian-date.js" as PersianDate
import "../js/bin/jalaali.js" as Jalaali
import "../js/bin/jalalidate.js" as JalaliDate
import "../js/main.js" as Scripts

Item {
    id: root
    property bool showTooltip: plasmoid.configuration.showTooltip
    property var selectedDate: new persianDate()
    property var screenDate: new persianDate()
    property var todayDate: new persianDate()
    property var week: ['شنبه', '1شنبه', '2شنبه', '3شنبه', '4شنبه', '5شنبه', 'جمعه']
    property var days: Scripts.daysInMonth(root.screenDate)
    property int startOfWeek: Scripts.startOfWeek(screenDate)

    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}
	// Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.toolTipMainText: todayDate.format('dddd')
    Plasmoid.toolTipSubText: todayDate.format('D MMMM YYYY')

    QtObject {
        id: store
        Component.onCompleted: Store.setStore(store)
    }

    PlasmaCore.DataSource {
        id: localTime
        engine: "time"
        connectedSources: ["Local"]
        interval: 60000
        onNewData: (sourceName, data) => {
            // Later...
        }
    }

    Timer {
       id: dateTimer
       interval: 60000
       repeat: true
       running: true
       triggeredOnStart: true
       onTriggered: todayDate = new persianDate()
   }

    function isToday(date) {
        return todayDate.year() == date[0] && todayDate.month() == date[1] && todayDate.date()  == date[2];
    }
}