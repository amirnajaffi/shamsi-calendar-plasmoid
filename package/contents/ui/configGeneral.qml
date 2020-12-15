import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.4 as Kirigami

Item {
    id: page

    property var compactRepresentationFormatTemp: plasmoid.configuration.compactRepresentationFormat

    property alias cfg_compactRepresentationFormat: page.compactRepresentationFormatTemp
    property alias cfg_compactRepresentationHorizontalExtraSpace: compactRepresentationHorizontalExtraSpace.value

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            text: 'Compact Representation'
            color: PlasmaCore.Theme.textColor
        }

        ToolSeparator {
            orientation: Qt.Horizontal
        }
        
        ComboBox {
            id: compactRepresentationFormatCombo
            Kirigami.FormData.label: i18n("Format:")
            textRole: "text"
            currentIndex: page.getCurrentRepresentationFormatIndex()
            model: ListModel {
                id: compactRepresentationFormatComboItems
                ListElement {text: '1399 01 01'; format: 'YYYY MM DD'}
                ListElement {text: '1399-01-01'; format: 'YYYY-MM-DD'}
                ListElement {text: '1399/01/01'; format: 'YYYY/MM/DD'}
                ListElement {text: '1 فروردین'; format: 'D MMMM'}
                ListElement {text: '1 فروردین 1399'; format: 'D MMMM YYYY'}
                ListElement {text: 'شنبه 1 فروردین'; format: 'dddd D MMMM'}
                ListElement {text: 'ش 1 فروردین'; format: 'ddd D MMMM'}
                ListElement {text: 'شنبه 1 فرو'; format: 'dddd D MMM'}
                ListElement {text: 'ش 1 فرو'; format: 'ddd D MMM'}
                ListElement {text: 'شنبه 1 فروردین 1399'; format: 'dddd D MMMM YYYY'}
                ListElement {text: 'ش 1 فروردین 1399'; format: 'ddd D MMMM YYYY'}
                ListElement {text: 'شنبه 1 فرو 1399'; format: 'dddd D MMM YYY'}
                ListElement {text: 'ش 1 فرو 1399'; format: 'ddd D MMM YYYY'}
            }
            onCurrentIndexChanged: function () {
                page.compactRepresentationFormatTemp = compactRepresentationFormatComboItems.get(currentIndex).format
            }
        }

        SpinBox {
            id: compactRepresentationHorizontalExtraSpace
            Kirigami.FormData.label: i18n("Horizontal extra space:")
        }

    }

    function getCurrentRepresentationFormatIndex() {
        for(var i = 0; i < compactRepresentationFormatComboItems.count; ++i) {
            if (compactRepresentationFormatComboItems.get(i).format == plasmoid.configuration.compactRepresentationFormat ) return i;
        }
                    
        return 0;
    }
}