import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4


Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: columnSaveAs.height  // Tell SilicaFlickable the height of its content.
        VerticalScrollDecorator {}

        Column {
            id: columnSaveAs
            width: parent.width

            PageHeader {
                title: qsTr("Info")
            }


            Label {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "This app needs python3-pillow for image manipulation, which is available at Openrepos.net. "
            }

            Label {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.highlightColor
                text: "https://openrepos.net/content/birdzhang/python3-pillow" + "\n"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.openUrlExternally("https://openrepos.net/content/birdzhang/python3-pillow")
                    }
                }
            }

            Label {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "1) Download the latest file suitable for your device:" + "\n"
                      + "     Smartphones usually ...armv7hl.rpm" + "\n"
                      + "     Tablets possibly ...i486.rpm" + "\n"
                      + "2) Allow '3rd party software' in Sailfish settings" + "\n"
                      + "3) Install python3-pillow" + "\n"
            }

            SectionHeader {
                text: "Contact"
            }

            Label {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "planetos82@protonmail.com" + "\n"
            }




        } // end Column
    } // end Silica Flickable
}
