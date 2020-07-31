import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import Sailfish.Pickers 1.0 // File-Loader


Page {
    id: page
    allowedOrientations: Orientation.All

    // values transmitted from FirstPage.qml
    property var inputPathPy
    property var outputPathPy

    // variables for UI
    property var itemsPerRow : 5
    property var cubeFilePath : ""
    property var cubeFileName : ""
    property var cubeImagePath : ""
    property var cubeImageName : ""
    property var lut3dType
    property var availableFilters : [
        "warmer", "colder", "sepia", "gotham", "crema",
        "juno", "kelvin", "xpro-ii", "amaro", "mayfair",
        "nineteen77", "lofi", "hudson", "redteal", "nashville",
        "hefe", "sierra", "clarendon", "reyes", "lark", ]


    Component {
       id: lutCubeFilePickerPage
       FilePickerPage {
           title: qsTr("Select LUT (*.cube, *.png)")
           nameFilters: [ '*.cube', '*.png' ]
           onSelectedContentPropertiesChanged: {
               cubeFilePath = selectedContentProperties.filePath
               cubeFileName = selectedContentProperties.fileName
               var cubeFileNameArray = cubeFileName.split(".")
               var oldFileName = (cubeFileNameArray.slice(0, cubeFileNameArray.length-1)).join(".")
               var oldFileType = cubeFileNameArray[cubeFileNameArray.length - 1]
               if ( oldFileType === "cube" || oldFileType === "CUBE" ) {
                   lut3dType = "cubeFile"
               }
               else {
                   lut3dType = "imageFile"
               }
           }
       }
    }


    Python {
        id: py
        Component.onCompleted: {
            //addImportPath(Qt.resolvedUrl('../lib'));
            addImportPath(Qt.resolvedUrl('../py'));
            importModule('graphx', function () {}); // Which Pythonfile will be used?
        }

        // calculate functions in py
        function moodsMiddleStepFunction( effectName ) {
            call("graphx.moodsMiddleStepFunction", [ effectName ])
            pageStack.pop()
        }
        function apply3dLUTcubeMiddleStepFunction() {
            call("graphx.apply3dLUTcubeMiddleStepFunction", [ cubeFilePath, lut3dType ])
            pageStack.pop()
        }

        onError: {
            // when an exception is raised, this error handler will be called
            //console.log('python error: ' + traceback);
        }
        onReceived: {
            // asychronous messages from Python arrive here; done there via pyotherside.send()
            //console.log('got message from python: ' + data);
        }
    } // end Python


    SilicaFlickable {
        id: listView
        anchors.fill: parent
        contentHeight: columnSaveAs.height  // Tell SilicaFlickable the height of its content.
        VerticalScrollDecorator {}


        Column {
            id: columnSaveAs
            width: page.width

            SectionHeader {
                id: idSectionHeader
                height: idSectionHeaderColumn.height
                Column {
                    id: idSectionHeaderColumn
                    width: parent.width / 5 * 4
                    height: idLabelProgramName.height + idLabelFilePath.height
                    anchors.top: parent.top
                    anchors.topMargin: Theme.paddingMedium
                    anchors.right: parent.right
                    Label {
                        id: idLabelProgramName
                        width: parent.width
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeLarge
                        color: Theme.highlightColor
                        text: qsTr("Color moods")
                    }
                    Label {
                        id: idLabelFilePath
                        width: parent.width
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeTiny
                        color: Theme.highlightColor
                        truncationMode: TruncationMode.Elide
                        text: qsTr("apply filter preset") + "\n "
                    }
                }
            }


            Grid {
                id: idGridEffects
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge - spacing
                rowSpacing: Theme.itemSizeExtraSmall * 0.8
                columns: itemsPerRow

                Repeater {
                    id: idRepeater
                    model: availableFilters
                    IconButton {
                        width: parent.width / itemsPerRow
                        height: Theme.itemSizeSmall
                        icon.source : "../symbols/icon-m-effect.svg"
                        icon.width: Theme.iconSizeMedium
                        icon.height: Theme.iconSizeMedium
                        onClicked: {
                            py.moodsMiddleStepFunction( modelData )
                        }
                        Label {
                            font.pixelSize: Theme.fontSizeExtraSmall
                            horizontalAlignment: Text.AlignHCenter
                            text: modelData
                            anchors {
                                top: parent.bottom
                                topMargin: -Theme.paddingSmall
                                horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }


            Rectangle {
                width: parent.width
                height: Theme.paddingLarge * 4
                color: "transparent"
            }


            SectionHeader {
                height: idSectionHeaderColumn2.height
                Column {
                    id: idSectionHeaderColumn2
                    width: parent.width / 5 * 4
                    height: idLabelFilePath2.height
                    anchors.top: parent.top
                    anchors.topMargin: Theme.paddingMedium
                    anchors.right: parent.right
                    Label {
                        id: idLabelFilePath2
                        width: parent.width
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeTiny
                        color: Theme.highlightColor
                        truncationMode: TruncationMode.Elide
                        text: qsTr("apply 3D-LUT file (cube, hald-png)") + "\n "
                    }
                }
            }


            Row {
                id: idRecolorizeInfoRow
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge - spacing
                Row {
                    width: parent.width /  itemsPerRow * (itemsPerRow-1)
                    Label {
                        width: parent.width / (itemsPerRow-1)
                        height: Theme.itemSizeSmall
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: qsTr("file:")
                    }
                    IconButton {
                        id: idFilePicker
                        enabled: true
                        width: parent.width / (itemsPerRow-1) * (itemsPerRow-2)
                        height: Theme.itemSizeSmall
                        onClicked: {
                            pageStack.push(lutCubeFilePickerPage)
                        }
                        Label {
                            visible: (idFilePicker.enabled) ? true : false
                            width: parent.width
                            height: parent.height
                            color: Theme.highlightColor
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: Theme.paddingLarge * 1.5
                            rightPadding: Theme.paddingLarge * 1.5
                            font.pixelSize: Theme.fontSizeExtraSmall
                            truncationMode: TruncationMode.Elide
                            text: (cubeFileName === "") ? qsTr("load") : cubeFileName
                        }
                    }
                }
                IconButton {
                    id: idApplyButton
                    visible:  true
                    enabled: (cubeFileName !== "") ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        py.apply3dLUTcubeMiddleStepFunction()
                    }
                }
            }


            Rectangle {
                width: parent.width
                height: Theme.paddingLarge * 1.5
                color: "transparent"
            }


        } // end Column
    } // end Silica Flickable
}
