import QtQuick 2.12
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    onClicked: plasmoid.expanded = !plasmoid.expanded
    
    id: compactRepresentation
    property string compactRepresentationFormat: plasmoid.configuration.compactRepresentationFormat
    property int compactRepresentationHorizontalExtraSpace: plasmoid.configuration.compactRepresentationHorizontalExtraSpace
    Layout.preferredWidth: compactLabel.width + compactRepresentationHorizontalExtraSpace
    Layout.maximumWidth: compactLabel.width + compactRepresentationHorizontalExtraSpace

    PlasmaComponents.Label {
        id: compactLabel
        anchors.centerIn: parent
        wrapMode: Text.NoWrap
        smooth: true
        textFormat: Text.RichText
        font.pixelSize: Math.max(PlasmaCore.Theme.smallestFont.pixelSize, 14)
        text: root.todayDate.format(compactRepresentationFormat)
    }

}