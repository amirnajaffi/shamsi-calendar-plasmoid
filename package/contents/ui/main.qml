import QtQuick 2.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../js/store.js" as Store
import "../js/bin/persian-date.js" as PersianDate
import "../js/bin/jalaali.js" as Jalaali
import "../js/bin/jalalidate.js" as JalaliDate
import "../js/calendar.js" as CalendarJS
import "../js/main.js" as Scripts

Item {
  id: root
  property var selectedDate: new persianDate()
  property var screenDate: new persianDate()
  property var todayDate: new persianDate()
  property var week: ['شنبه', '1شنبه', '2شنبه', '3شنبه', '4شنبه', '5شنبه', 'جمعه']
  property var days: Scripts.daysInMonth(root.screenDate)
  property int startOfWeek: Scripts.startOfWeek(screenDate)

  Plasmoid.compactRepresentation: CompactRepresentation {}
  Plasmoid.fullRepresentation: Calendar {}
  // Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

  Plasmoid.toolTipMainText: todayDate.format('dddd')
  Plasmoid.toolTipSubText: todayDate.format('D MMMM YYYY')

  QtObject {
    id: qmlStore
    objectName: 'qmlStore'
    property QtObject calendarSlice: QtObject {
      id: calendarSlice
      objectName: 'calendarSlice'
      property var jToday // array
      property var gToday // array
    }
  }

  PlasmaCore.DataSource {
    id: localTime
    engine: "time"
    connectedSources: ["Local"]
    interval: 60000
    onNewData: (sourceName, data) => {
      Qt._sc_.calendar.setDate(data.DateTime);
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

  Component.onCompleted: {
    Qt._sc_.storeUtils.setStore(qmlStore);
    Qt._sc_.calendar.setDate(localTime.data.Local.DateTime);
  }

  function isToday(date) {
    return todayDate.year() == date[0] && todayDate.month() == date[1] && todayDate.date()  == date[2];
  }
}