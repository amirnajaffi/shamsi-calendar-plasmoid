import QtQuick 2.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../js/persian-date/persian-date.min.js" as PersianDate
import "../js/main.js" as Scripts

Item {
    id: root
    property bool showTooltip:         plasmoid.configuration.showTooltip
    property var selectedDate: new persianDate();
    property var screenDate: new persianDate();
    property var todayDate: new persianDate();
    property var week: ['شنبه', '1شنبه', '2شنبه', '3شنبه', '4شنبه', '5شنبه', 'جمعه']
    property var days: Scripts.daysInMonth(root.screenDate);
    property int startOfWeek: Scripts.startOfWeek(screenDate);

    Plasmoid.compactRepresentation: CompactRepresentation {}
    Plasmoid.fullRepresentation: FullRepresentation {}

	// Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.toolTipMainText: todayDate.format('dddd')
    Plasmoid.toolTipSubText: todayDate.format('D MMMM YYYY')

    function isToday(date) {
        return todayDate.year() == date[0] && todayDate.month() == date[1] && todayDate.date()  == date[2];
    }
}