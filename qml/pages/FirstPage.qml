import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0 // File-Loader
import io.thp.pyotherside 1.4
import "perspectivetransformhelper.js" as PerspT

Page {
    id: page
    allowedOrientations: Orientation.All
    onIsLandscapeChanged: {
        var tempRotateImagePath = idImageLoadedFreecrop.source
        idImageLoadedFreecrop.source = ""
        idImageLoadedFreecrop.source = tempRotateImagePath
        presetCroppingFree()
        if( idImageLoadedFreecrop.sourceSize.width < idImageLoadedFreecrop.width) {
            idPaintPasteButton.down = false
        }
    }
    onIsPortraitChanged:  {
        var tempRotateImagePath = idImageLoadedFreecrop.source
        idImageLoadedFreecrop.source = ""
        idImageLoadedFreecrop.source = tempRotateImagePath
        presetCroppingFree()
        if( idImageLoadedFreecrop.sourceSize.width < idImageLoadedFreecrop.width) {
            idPaintPasteButton.down = false
        }
    }


    // file cariables
    property string homeDirectory
    property string origImageFilePath : ""
    property string origImageFileName
    property string origImageFolderPath
    property string tempImageFolderPath //: "/home" + "/nemo" + "/imageworks_tmp/"
    property string saveImageFolderPath //: "/home" + "/nemo" + "/Pictures" + "/Imageworks/"
    property string symbolSourceFolder: "/usr" + "/share" + "/harbour-simplecrop" + "/qml" + "/symbols/"
    property string filterSourceFolder: "/usr" + "/share" + "/harbour-simplecrop" + "/qml" + "/filters/"
    property string tempCopyPasteFileName: "copyPaste"
    property string inputPathPy
    property string outputPathPy
    property string copyPastePath
    property var templock : (((idLabelFilePath.text).toString()).indexOf("empty.tmp"))
    property bool warningNoPillow : false
    property string customFontFilePath : ""
    property string customFontName : ""

    // UI Variables
    property var opacityCut : 0.75
    property var opacityEdges : 0.75
    property var paintRegionOpacity : 0.2
    property var handleWidth : 2* Theme.paddingLarge
    property var handleHeight : 2* Theme.paddingLarge
    property var opticalDividersWidth : 1
    property int oldmouseX
    property int oldmouseY
    property var oldWidth
    property var oldHeight
    property var oldFullAreaHeight
    property var oldFullAreaWidth
    property var oldWhichSquareLEFT
    property var oldWhichSquareUP
    property var rectX
    property var rectY
    property var rectHeight
    property var rectWidth
    property var factorToScale : 1
    property var scaleDisplayFactorCrop
    property var correctXmini : 0
    property int placeholderManualCrop : 1
    property var toolsDrawingColorFrame : Theme.errorColor //Theme.secondaryHighlightColor
    property var zoomWindowVisible : ( (dragArea1.pressed || dragArea2.pressed || dragPerspective1.pressed || dragPerspective2.pressed || dragPerspective3.pressed || dragPerspective4.pressed) && (buttonCrop.down && pickerTransformOrCropIndex !== 0) || ( mouseCanvasArea.pressed || idPaintLineButton.down || idPaintPointButton.down || idPaintShapesButton.down || idPaintTextButton.down || idPaintColorPickerButton.down ) && buttonPaint.down ) ? true : false
    property int itemsPerRow : 6
    property int itemsPerRowLess : 5
    property bool stretchOversizeActive : ( ( idPaintLineButton.down || idPaintPointButton.down || idPaintTextButton.down || idPaintShapesButton.down || idPaintColorPickerButton.down || buttonCrop.down) && buttonPaint.down || (buttonCrop.down && pickerTransformOrCropIndex !== 0) ) ? true : false
    property var zoomItemCenterTolerance : 4*Theme.paddingLarge

    // crop transform variables
    property var transformPerspectiveMode : "stretch" // or "fold"
    property var pickerTransformOrCropIndex : 0
    property var actionCutSelection : "keep" //or "remove"
    property var paddingRatio : page.width / page.height

    // color variables
    property var factorEnhanceColor : 1
    property var factorEnhanceBrightness : 1
    property var factorEnhanceSharpness : 1
    property var factorEnhanceContrast : 1

    // scale variables
    property var toScaleWidth : idImageLoadedFreecrop.sourceSize.width
    property var toScaleHeight : idImageLoadedFreecrop.sourceSize.height
    property var freeScaleWidth  : idImageLoadedFreecrop.sourceSize.width
    property var freeScaleHeight : idImageLoadedFreecrop.sourceSize.height
    property var maxScalePixels : 9999

    // paint variables
    property var paintBlurRadius : 10
    property var paintToolColor : "#ffffffff"
    property var paintFrameThickness
    property var paintLineThickness
    property var paintTextSize : 20
    property int paintTextNameNr : 0
    property int paintTextStyleNr : 0
    property var textDirectionPickerCounter : 0
    property var paintTextDirection : "left"
    property var paintSymbolSizeFaktor : 1
    property var paintToolText : idTextPaintInput.text
    property var myColors: [
        "black", "darkSlateGray", "slateGray",
        "gray", "white", "red",
        "crimson", "#e6007c", "#e700cc",
        "#9d00e7", "#7b00e6", "#5d00e5",
        "#0077e7","#01a9e7", "#00cce7",
        "#00e696","#00e600", "#99e600",
        "#e3e601","goldenRod", "#e78601"]
    property var cycleThroughSymbolsCounter : 1
    property var paintRadiusSpray : 2
    property var symbolPickerCounter : 0
    property var solidPickerCounter : 0
    property var framePickerCounter : 0
    property var solidTypeTool : "rectangle"
    property var frameTypeTool : "rectangle"
    property var symbolSourcePath
    property var oldColorPaintManualInput
    property var freeDrawXpos
    property var freeDrawYpos
    property var freeDrawLineWidth : Theme.paddingSmall
    property var freeDrawPolyCoordinates : ""
    property var paintCanvasThickness
    property bool freeDrawLock : false
    property var drawType : "polyline" // "fill"
    property var cutFillColor : paintToolColor


    // copy paste variables
    property var copyPasteRegionRatioHW : 0
    property var copyPasteOldCopyZoneSourceWidth
    property var copyPasteOldCopyZoneDisplayHeight
    property var copyPasteOldCopyZoneDisplayWidth
    property var copyPasteX1
    property var copyPasteY1
    property var copyPasteX2
    property var copyPasteY2
    property var copyPasteImageWidth : 0
    property var copyPasteImageHeight : 0

    // crop handles variables
    property var croppingRatio : 0
    property var oldPosX1
    property var oldPosY1
    property var diffX1
    property var diffY1
    property var stopX1
    property var oldPosX2
    property var oldPosY2
    property var diffX2
    property var diffY2
    property var stopX2

    // undo variables
    property int undoNr : 0
    property bool finishedLoading : true
    property var lastTMP2delete
    property var new_imagePath

    // effects variables
    property var tintColor
    property var targetColor2Alpha : "black"
    property var extractColorCounter : 0
    property var colorExtractARGB : "R"
    property var extractChannelCounter : 0
    property var channelExtractARGB : "A"
    property var alphaBWCounter : 0

    // autostart functions
    Component.onCompleted: {
        py.getHomePath() // also deletes TMPs on path returned to qml, see handler "homePathFolder"
        hexToRGBA(paintToolColor)
    }


    // special auto resetter for markers, when stretchOversizeActive changess
    Item {
        id: idResetOversizeNormalChange
        enabled: (stretchOversizeActive === true) ? true : false
        onEnabledChanged: {
            setTransformationMarkersFullImage()
            setCropmarkersFullImage()
        }
    }
    Timer {
        id: idDelayTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: pageStack.push(fontPickerPage)
    }
    Component {
       id: filePickerPage
       FilePickerPage {
           title: qsTr("Select image")
           nameFilters: [ '*.jpg', '*.jpeg', '*.png', '*.tif', '*.tiff', '*.bmp', '*.gif' ]
           onSelectedContentPropertiesChanged: {
               origImageFilePath = selectedContentProperties.filePath
               origImageFileName = selectedContentProperties.fileName
               origImageFolderPath = origImageFilePath.replace(selectedContentProperties.fileName, "")
               idLabelFilePath.text = origImageFilePath
               idImageLoadedFreecrop.source = encodeURI(origImageFilePath)
               py.deleteAllTMPFunction()
               undoNr = 0
               presetCroppingFree()
               allSlidersReset()
           }
       }
    }
    Component {
       id: imagePickerPage
       ImagePickerPage {
           onSelectedContentPropertiesChanged: {
               origImageFilePath = selectedContentProperties.filePath
               origImageFileName = selectedContentProperties.fileName
               origImageFolderPath = origImageFilePath.replace(selectedContentProperties.fileName, "")
               idLabelFilePath.text = origImageFilePath
               idImageLoadedFreecrop.source = encodeURI(origImageFilePath)
               py.deleteAllTMPFunction()
               undoNr = 0
               presetCroppingFree()
               allSlidersReset()
           }
       }
    }
    Component {
       id: fontPickerPage
       FilePickerPage {
           title: qsTr("Select font")
           nameFilters: [ '*.ttf', '*.otf' ]
           onSelectedContentPropertiesChanged: {
               customFontFilePath = selectedContentProperties.filePath
               customFontName = selectedContentProperties.fileName
           }
       }
    }
    RemorsePopup {
        id: remorse
    }




    // Python connections and signals, callable from QML side
    Python {
        id: py
        Component.onCompleted: {
            //addImportPath(Qt.resolvedUrl('../lib'));
            addImportPath(Qt.resolvedUrl('../py'));
            importModule('graphx', function () {});


            // Handlers = Signals to do something in QML whith received Infos from pyotherside
            setHandler('homePathFolder', function( homeDir ) {
                tempImageFolderPath = homeDir + "/imageworks_tmp/"
                saveImageFolderPath = homeDir + "/Music" + "/Imageworks/"
                homeDirectory = homeDir
                py.createTmpAndSaveFolder()
                py.deleteAllTMPFunction()
                py.deleteCopyPasteImage()
            });
            setHandler('exchangeImage', function(new_imagePath) {
                idImageLoadedFreecrop.source ="" // Patch: make sure not to get old content ever
                idImageLoadedFreecrop.source = encodeURI(new_imagePath)
                setCropmarkersFullImage()
                setTransformationMarkersFullImage()
                allSlidersReset()
                finishedLoading = true
            });
            setHandler('exchangeImageFromPainting', function(new_imagePath) {
                idImageLoadedFreecrop.source = encodeURI(new_imagePath)
                finishedLoading = true
            });
            setHandler('finishedCopyFromPainting', function(new_imagePath, widthCP, heightCP) {
                finishedLoading = true
                copyPastePath = new_imagePath
                copyPasteImageWidth = widthCP
                copyPasteImageHeight = heightCP
            });
            setHandler('deleteImage', function() {
                idLabelFilePath.text = ""
                idImageLoadedFreecrop.source = ""
                toScaleWidth = 0
                toScaleHeight = 0
                undoNr = 0
            });
            setHandler('copyPasteImageDeleted', function(inputPathPy) {
                //console.log("copyPaste file deleted: " + inputPathPy)
                copyPastePath = ""
            });
            setHandler('clearDrawCanvas', function(inputPathPy) {
                freeDrawPolyCoordinates = ""
                freeDrawCanvas.clear_canvas()
                freeDrawLock = false
            });
            setHandler('finishedSavingRenaming', function(new_imagePath) {
                undoNr = 0
                idLabelFilePath.text = new_imagePath
                var newPathArray = new_imagePath.split("/")
                origImageFilePath = new_imagePath
                origImageFolderPath = (newPathArray.slice(0, newPathArray.length-1)).join("/") + "/"
                origImageFileName = newPathArray.slice(-1)[0]
                buttonCrop.down = false
                buttonScale.down = false
                buttonPaint.down = false
                buttonShape.down = false
                buttonColors.down = false
                buttonEffects.down = false
                buttonFile.down = true
            });
            setHandler('getPixelValuesRGBA', function(r,g,b,a, hexaColorARGB) {
                finishedLoading = true
                paintToolColor = hexaColorARGB
                idColorPaintManualInput.text = paintToolColor
                idSliderColorRed.value = r
                idSliderColorGreen.value = g
                idSliderColorBlue.value = b
                idSliderColorAlpha.value = a
            });
            setHandler('updateSliderScale', function() {
                toScaleWidth = Math.round(idImageLoadedFreecrop.sourceSize.width * factorToScale)
                toScaleHeight = Math.round(idImageLoadedFreecrop.sourceSize.height * factorToScale)
            });
            setHandler('startRepixelFunctionFromPy', function( oldA, oldR, oldG, oldB, newA, newR, newG, newB, compareA, compareR, compareG, compareB, tolA, tolR, tolG, tolB, changeA, changeR, changeG, changeB, modePixeldraw ) {
                finishedLoading = false
                py.replacePixelsFunction( oldA, oldR, oldG, oldB, newA, newR, newG, newB, compareA, compareR, compareG, compareB, tolA, tolR, tolG, tolB, changeA, changeR, changeG, changeB, modePixeldraw )
            });
            setHandler('startRechannelFunctionFromPy', function( channelPathAlpha, channelPathRed, channelPathGreen, channelPathBlue, factorA, factorR, factorG, factorB, saturationA, saturationR, saturationG, saturationB, invertA, invertR, invertG, invertB ) {
                finishedLoading = false
                py.rechannelFunctionFromPy( channelPathAlpha, channelPathRed, channelPathGreen, channelPathBlue, factorA, factorR, factorG, factorB, saturationA, saturationR, saturationG, saturationB, invertA, invertR, invertG, invertB )
            });
            setHandler('startColorCurveFunctionFromPy', function( curveFactors, currentColor, minValue, maxValue ) {
                finishedLoading = false
                py.colorCurveFunctionFromPy( curveFactors, currentColor, minValue, maxValue )
            });
            setHandler('startMoodsFunctionFromPy', function( effectName ) {
                finishedLoading = false
                if (effectName === "gotham") {
                    py.gothamFilterFunction()
                }
                else if (effectName === "crema") {
                    py.cremaFilterFunction()
                }
                else if (effectName === "juno") {
                    py.junoFilterFunction()
                }
                else if (effectName === "kelvin") {
                    py.kelvinFilterFunction()
                }
                else if (effectName === "xpro-ii") {
                    py.xproiiFilterFunction()
                }
                else if (effectName === "warmer") {
                    tintColor = "warmer"
                    py.tintWithColorFunction()
                }
                else if (effectName === "colder") {
                    tintColor = "colder"
                    py.tintWithColorFunction()
                }
                else if (effectName === "amaro") {
                    py.amaroFilterFunction()
                }
                else if (effectName === "mayfair") {
                    py.mayfairFilterFunction()
                }
                else if (effectName === "nineteen77") {
                    py.nineteen77FilterFunction()
                }
                else if (effectName === "lofi") {
                    py.lofiFilterFunction()
                }
                else if (effectName === "hudson") {
                    py.hudsonFilterFunction()
                }
                else if (effectName === "redteal") {
                    py.redtealFilterFunction()
                }
                else if (effectName === "sepia") {
                    py.sepiaFunction()
                }
                else if (effectName === "nashville") {
                    py.nashvilleFilterFunction()
                }
                else if (effectName === "hefe") {
                    py.hefeFilterFunction()
                }
                else if (effectName === "sierra") {
                    py.sierraFilterFunction()
                }
                else if (effectName === "clarendon") {
                    var cubeFilePath = "/" + filterSourceFolder + "Clarendon.png"
                    var lut3dType = "imageFile"
                    py.apply3dLUTcubeFileFromPy( cubeFilePath, lut3dType )
                }
                else if (effectName === "reyes") {
                    cubeFilePath = "/" + filterSourceFolder + "Reyes.png"
                    lut3dType = "imageFile"
                    py.apply3dLUTcubeFileFromPy( cubeFilePath, lut3dType )
                }
                else if (effectName === "moon") {
                    cubeFilePath = "/" + filterSourceFolder + "Moon.png"
                    lut3dType = "imageFile"
                    py.apply3dLUTcubeFileFromPy( cubeFilePath, lut3dType )
                }
                else if (effectName === "lark") {
                    cubeFilePath = "/" + filterSourceFolder + "Lark.png"
                    lut3dType = "imageFile"
                    py.apply3dLUTcubeFileFromPy( cubeFilePath, lut3dType )
                }
            });
            setHandler('startApply3dLUTcubeFileFromPy', function( cubeFilePath, lut3dType ) {
                finishedLoading = false
                py.apply3dLUTcubeFileFromPy( cubeFilePath, lut3dType )
            });
            setHandler('tempFilesDeleted', function(i) {
                //console.log("temp files deleted: " + i)
            });
            setHandler('deleteLastTMP', function(i) {
                //console.log("last tmp deleted: " + i)
                finishedLoading = true
            });
            setHandler('folderExistence', function() {
                //console.log("tmp and save folders created")
            });
            setHandler('warningPILNotAvailable', function() {
                idLabelFilePath.text = qsTr("python3-pillow is not installed")
                warningNoPillow = true
            });
            setHandler('debugPythonLogs', function(i) {
                console.log(i)
            });
        }


        // cropping and perspective functions
        function getHomePath() {
            call("graphx.getHomePath", [])
        }
        function croppingFunctionHandles() {
            generatePathAndUndoNr()
            generateCroppingPixelsFromHandles()
            call("graphx.cropNowFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, undoNr ])
        }
        function croppingFunctionCoordinates() {
            generatePathAndUndoNr()
            generateCroppingPixelsFromCoordinates()
            if (rectWidth === 0) {
                if (rectX > 0) {
                    rectX = rectX - 1
                    idInputManualX1.text = rectX
                }
                else {
                    idInputManualX2.text = rectX+1
                }
                rectWidth = 1
            }
            if (rectHeight === 0) {
                if (rectY > 0) {
                    rectY = rectY - 1
                    idInputManualY1.text = rectY
                }
                else {
                    idInputManualY2.text = rectY+1
                }
                rectHeight = 1
            }
            call("graphx.cropCoordinatesFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, undoNr ])
        }
        function perspectiveCorrection() {
            generatePathAndUndoNr()
            generateCroppingPixelsFromHandles()
            var x1_old = (rectPerspective1.x + handleWidth/2) * scaleDisplayFactorCrop
            var y1_old = (rectPerspective1.y + handleWidth/2) * scaleDisplayFactorCrop
            var x2_old = (rectPerspective2.x + handleWidth/2) * scaleDisplayFactorCrop
            var y2_old = (rectPerspective2.y + handleWidth/2) * scaleDisplayFactorCrop
            var x3_old = (rectPerspective3.x + handleWidth/2) * scaleDisplayFactorCrop
            var y3_old = (rectPerspective3.y + handleWidth/2) * scaleDisplayFactorCrop
            var x4_old = (rectPerspective4.x + handleWidth/2) * scaleDisplayFactorCrop
            var y4_old = (rectPerspective4.y + handleWidth/2) * scaleDisplayFactorCrop
            var srcPts = [0, 0, idImageLoadedFreecrop.sourceSize.width, 0, idImageLoadedFreecrop.sourceSize.width, idImageLoadedFreecrop.sourceSize.height, 0, idImageLoadedFreecrop.sourceSize.height]
            var dstPts = [x1_old, y1_old, x2_old, y2_old, x3_old, y3_old, x4_old, y4_old]
            if (transformPerspectiveMode === "stretch") { var perspT = getNormalizationCoefficients(srcPts, dstPts, false) }
            else { perspT = getNormalizationCoefficients(srcPts, dstPts, true) }
            call("graphx.perspectiveCorrectionFunction", [ inputPathPy, outputPathPy, perspT, scaleDisplayFactorCrop, undoNr, paintToolColor ])
        }


        // shape functions
        function rotateLeftFunction() {
            generatePathAndUndoNr()
            call("graphx.rotateLeftFunction", [ inputPathPy, outputPathPy ])
        }
        function mirrorHorizontalFunction() {
            generatePathAndUndoNr()
            call("graphx.mirrorHorizontalFunction", [ inputPathPy, outputPathPy ])
        }
        function tiltAngleFunction() {
            generatePathAndUndoNr()
            var tiltAngle = idRotateAngleManualInput.text
            if (tiltAngle === "") {
                tiltAngle = 0
                idRotateAngleManualInput.text = "0"
            }
            call("graphx.tiltAngleFunction", [ inputPathPy, outputPathPy , tiltAngle, paintToolColor ])
        }
        function mirrorVerticalFunction() {
            generatePathAndUndoNr()
            call("graphx.mirrorVerticalFunction", [ inputPathPy, outputPathPy ])
        }
        function rotateRightFunction() {
            generatePathAndUndoNr()
            call("graphx.rotateRightFunction", [ inputPathPy, outputPathPy ])
        }
        function paddingImage() {
            generatePathAndUndoNr()
            call("graphx.paddingImageFunction", [ inputPathPy, outputPathPy, paddingRatio, paintToolColor ])
        }


        // scale functions
        function scaleFunction() {
            generatePathAndUndoNr()
            call("graphx.scaleFunction", [ inputPathPy, outputPathPy, factorToScale ])
        }
        function freescaleFunction() {
            generatePathAndUndoNr()
            call("graphx.freescaleFunction", [ inputPathPy, outputPathPy, freeScaleWidth, freeScaleHeight ])
        }


        // color functions
        function enhanceColorFunction() {
            generatePathAndUndoNr()
            call("graphx.enhanceColorFunction", [ inputPathPy, outputPathPy, idSliderColor.value ])
        }
        function enhanceContrastFunction() {
            generatePathAndUndoNr()
            call("graphx.enhanceContrastFunction", [ inputPathPy, outputPathPy, idSliderContrast.value ])
        }
        function enhanceBrightnessFunction() {
            generatePathAndUndoNr()
            call("graphx.enhanceBrightnessFunction", [ inputPathPy, outputPathPy, idSliderBrightness.value ])
        }
        function enhanceSharpnessFunction() {
            generatePathAndUndoNr()
            call("graphx.enhanceSharpnessFunction", [ inputPathPy, outputPathPy, idSliderSharpness.value ])
        }


        // effect functions
        function apply3dLUTcubeFileFromPy( cubeFilePath, lut3dType ) {
            generatePathAndUndoNr()
            call("graphx.apply3dLUTcubeFile", [ inputPathPy, cubeFilePath, lut3dType, outputPathPy ])
        }
        function grayscaleFunction() {
            generatePathAndUndoNr()
            call("graphx.grayscaleFunction", [ inputPathPy, outputPathPy ])
        }
        function blackWhiteFunction() {
            generatePathAndUndoNr()
            call("graphx.blackWhiteFunction", [ inputPathPy, outputPathPy ])
        }
        function equalizeFunction() {
            generatePathAndUndoNr()
            call("graphx.equalizeFunction", [ inputPathPy, outputPathPy ])
        }
        function solarizeFunction() {
            generatePathAndUndoNr()
            call("graphx.solarizeFunction", [ inputPathPy, outputPathPy ])
        }
        function invertFunction() {
            generatePathAndUndoNr()
            call("graphx.invertFunction", [ inputPathPy, outputPathPy ])
        }
        function autocontrastFunction() {
            generatePathAndUndoNr()
            call("graphx.autocontrastFunction", [ inputPathPy, outputPathPy ])
        }
        function blurFunction() {
            generatePathAndUndoNr()
            call("graphx.blurFunction", [ inputPathPy, outputPathPy, 5 ])
        }
        function unsharpmaskFunction() {
            generatePathAndUndoNr()
            var radiusMask = 3 //2
            var percentMask = 150 //150
            var thresholdMask = 4 //3
            call("graphx.unsharpmaskFunction", [ inputPathPy, outputPathPy, radiusMask, percentMask, thresholdMask ])
        }
        function findedgesFunction() {
            generatePathAndUndoNr()
            var fileTargetType = inputPathPy.slice(inputPathPy.length - 4)
            call("graphx.findedgesFunction", [ inputPathPy, outputPathPy, fileTargetType ])
        }
        function contourFunction() {
            generatePathAndUndoNr()
            call("graphx.contourFunction", [ inputPathPy, outputPathPy ])
        }
        function embossFunction() {
            generatePathAndUndoNr()
            call("graphx.embossFunction", [ inputPathPy, outputPathPy ])
        }
        function modedrawingFunction() {
            generatePathAndUndoNr()
            call("graphx.modedrawingFunction", [ inputPathPy, outputPathPy ])
        }
        function edgeenhanceFunction() {
            generatePathAndUndoNr()
            call("graphx.edgeenhanceFunction", [ inputPathPy, outputPathPy ])
        }
        function sepiaFunction() {
            generatePathAndUndoNr()
            call("graphx.sepiaFunction", [ inputPathPy, outputPathPy ])
        }
        function stretchContrastFunction() {
            generatePathAndUndoNr()
            call("graphx.stretchContrastFunction", [ inputPathPy, outputPathPy ])
        }
        function posterizeFunction() {
            generatePathAndUndoNr()
            call("graphx.posterizeFunction", [ inputPathPy, outputPathPy ])
        }
        function blurImageSidesFunctiom() {
            generatePathAndUndoNr()
            var radiusEdgeBlur = handleWidth * idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width / 2.5
            call("graphx.blurImageSidesFunctiom", [ inputPathPy, outputPathPy, radiusEdgeBlur, paintToolColor ])
        }
        function tintWithColorFunction() {
            generatePathAndUndoNr()
            var factorBrightnessTint = 1.2
            call("graphx.tintWithColorFunction", [ inputPathPy, outputPathPy, tintColor, factorBrightnessTint ])
        }
        function centerFocusFunction() {
            generatePathAndUndoNr()
            var alphaMaskPath = "/" + symbolSourceFolder + "alphaMaskCircleSmall.png"
            var radiusEdgeBlur = 6 // 4
            var enhanceColorFaktor = 1
            var enhanceContrastFaktor = 1
            var addExtraBlurAroundPath = "none"
            call("graphx.miniatureFocusFunction", [ inputPathPy, outputPathPy, alphaMaskPath, radiusEdgeBlur, enhanceColorFaktor, enhanceContrastFaktor, addExtraBlurAroundPath ])
        }
        function miniatureFocusFunction() {
            generatePathAndUndoNr()
            var alphaMaskPath = "/" + symbolSourceFolder + "alphaMaskStandard.png"
            var radiusEdgeBlur = 5 // 4
            var enhanceColorFaktor = 1.75 // 1.9
            var enhanceContrastFaktor = 1.3 // 1.4
            var addExtraBlurAroundPath = "/" + symbolSourceFolder + "alphaMaskCircleSmall.png"
            call("graphx.miniatureFocusFunction", [ inputPathPy, outputPathPy, alphaMaskPath, radiusEdgeBlur, enhanceColorFaktor, enhanceContrastFaktor, addExtraBlurAroundPath ])
        }
        function smoothSurfaceFunction() {
            generatePathAndUndoNr()
            var smoothingStrength = "strong"
            call("graphx.smoothSurfaceFunction", [ inputPathPy, outputPathPy, smoothingStrength ])
        }
        function quantizeFunction() {
            generatePathAndUndoNr()
            var colorsAmount = idReduceColorEffect.text
            if (colorsAmount === "") {
                colorsAmount = 256
                idReduceColorEffect.text = "256"
            }
            call("graphx.quantizeFunction", [ inputPathPy, outputPathPy, colorsAmount ])
        }
        function colorToAlphaFunction() {
            generatePathAndUndoNr()
            var targetColorTolerance = "30"
            call("graphx.colorToAlphaFunction", [ inputPathPy, outputPathPy, targetColor2Alpha, targetColorTolerance ])
        }
        function replacePixelsFunction( oldA, oldR, oldG, oldB, newA, newR, newG, newB, compareA, compareR, compareG, compareB, tolA, tolR, tolG, tolB, changeA, changeR, changeG, changeB, modePixeldraw ) {
            generatePathAndUndoNr()
            call("graphx.replacePixelsFunction", [ inputPathPy, outputPathPy, oldA, oldR, oldG, oldB, newA, newR, newG, newB, compareA, compareR, compareG, compareB, tolA, tolR, tolG, tolB, changeA, changeR, changeG, changeB, modePixeldraw ])
        }
        function rechannelFunctionFromPy( channelPathAlpha, channelPathRed, channelPathGreen, channelPathBlue, factorA, factorR, factorG, factorB, saturationA, saturationR, saturationG, saturationB, invertA, invertR, invertG, invertB ) {
            generatePathAndUndoNr()
            call("graphx.rechannelFunction", [ inputPathPy, outputPathPy, channelPathAlpha, channelPathRed, channelPathGreen, channelPathBlue, factorA, factorR, factorG, factorB, saturationA, saturationR, saturationG, saturationB, invertA, invertR, invertG, invertB ])
        }
        function colorCurveFunctionFromPy ( curveFactors, currentColor, minValue, maxValue ) {
            generatePathAndUndoNr()
            call("graphx.colorCurveFunction", [ inputPathPy, outputPathPy, curveFactors, currentColor, minValue, maxValue ])
        }
        function addAlphaFunction() {
            generatePathAndUndoNr()
            var percentAlpha = idAddAlphaEffect.text
            if (percentAlpha === "") {
                percentAlpha = 100
                idAddAlphaEffect.text = "100"
            }
            call("graphx.addAlphaFunction", [ inputPathPy, outputPathPy, percentAlpha ])
        }
        function extractColorFunction() {
            generatePathAndUndoNr()
            call("graphx.extractColorFunction", [ inputPathPy, outputPathPy, colorExtractARGB ])
        }
        function extractChannelFunction() {
            generatePathAndUndoNr()
            call("graphx.extractChannelFunction", [ inputPathPy, outputPathPy, channelExtractARGB ])
        }
        function coalFilterFunction() {
            generatePathAndUndoNr()
            var blurRadius = 20
            call("graphx.coalFilterFunction", [ inputPathPy, outputPathPy, blurRadius ])
        }
        function gothamFilterFunction() {
            generatePathAndUndoNr()
            var sharpenValue = 1.3
            call("graphx.gothamFilterFunction", [ inputPathPy, outputPathPy, sharpenValue ])
        }
        function cremaFilterFunction() {
            generatePathAndUndoNr()
            var colorFactor = 0.8
            var contrastFactor = 0.9
            call("graphx.cremaFilterFunction", [ inputPathPy, outputPathPy, colorFactor, contrastFactor ])
        }
        function junoFilterFunction() {
            generatePathAndUndoNr()
            var brightnessValue = 1.15
            var saturationValue = 1.7
            call("graphx.junoFilterFunction", [ inputPathPy, outputPathPy, brightnessValue, saturationValue ])
        }
        function kelvinFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.kelvinFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function xproiiFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.xproiiFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function amaroFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.amaroFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function mayfairFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.mayfairFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function nineteen77FilterFunction() {
            generatePathAndUndoNr()
            call("graphx.nineteen77FilterFunction", [ inputPathPy, outputPathPy ])
        }
        function lofiFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.lofiFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function hudsonFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.hudsonFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function redtealFilterFunction() {
            generatePathAndUndoNr()
            var colorFactor = 1.35
            call("graphx.redtealFilterFunction", [ inputPathPy, outputPathPy, colorFactor ])
        }
        function nashvilleFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.nashvilleFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function hefeFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.hefeFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function sierraFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.sierraFilterFunction", [ inputPathPy, outputPathPy ])
        }
        function clarendonFilterFunction() {
            generatePathAndUndoNr()
            call("graphx.sierraFilterFunction", [ inputPathPy, outputPathPy ])
        }



        // paint functions
        function paintBlurRegion() {
            generatePathAndUndoNr()
            paintGetBlurRadius()
            generateCroppingPixelsFromHandles()
            call("graphx.paintBlurRegionFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, paintBlurRadius ])
        }
        function paintRectangleRegion() {
            generatePathAndUndoNr()
            generateCroppingPixelsFromHandles()
            call("graphx.paintRectangleRegionFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, paintToolColor, solidTypeTool ])
        }
        function paintFrameRegion() {
            generatePathAndUndoNr()
            paintCalculateFrameThickness()
            generateCroppingPixelsFromHandles()
            call("graphx.paintFrameRegionFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, paintToolColor, paintFrameThickness, frameTypeTool ])
        }
        function paintLineRegion() {
            generatePathAndUndoNr()
            paintCalculateLinePixels()
            call("graphx.paintLineRegionFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, paintToolColor, paintLineThickness ])
        }
        function paintTextRegion() {
            generatePathAndUndoNr()
            paintCalculateTextSize()
            generateCroppingPixelsFromHandles()
            var rectXcenter = rectX + handleWidth/2
            var rectYcenter = rectY + handleHeight/2
            var paintTextAngle = idInputAngleManual.text
            if (paintTextAngle === "") {
                paintTextAngle = 0
                idInputAngleManual.text = "0"
            }
            call("graphx.paintTextRegionFunction", [ inputPathPy, outputPathPy, rectXcenter, rectYcenter, scaleDisplayFactorCrop, paintToolColor, paintToolText, paintTextSize, paintTextNameNr, paintTextStyleNr, paintTextAngle, paintTextDirection, customFontFilePath ]  )
        }
        function paintPointRegion() {
            generatePathAndUndoNr()
            paintCalculatePointPixels()
            call("graphx.paintPointRegionFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, paintToolColor ])
        }
        function paintCopyFunction() {
            inputPathPy = decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") )
            outputPathPy = tempImageFolderPath + tempCopyPasteFileName + ".png"
            generateCroppingPixelsFromHandles()
            call("graphx.paintCopyFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop ])
        }
        function paintPasteFunction() {
            generatePathAndUndoNr()
            generateCroppingPixelsFromHandles()
            call("graphx.paintPasteRegionFunction", [ inputPathPy, copyPastePath, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop ])
        }
        function paintSprayFunction() {
            generatePathAndUndoNr()
            generateCroppingPixelsFromHandles()
            paintCalculateSprayDiameter()
            var gaussSigmaWidth = 6 // where most of the content stays, more = middle, less = wider
            var paintAmountSpray = idSliderSprayAmount.value.toString()
            call("graphx.paintSprayFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, paintToolColor, paintRadiusSpray, paintAmountSpray, gaussSigmaWidth ])
        }
        function paintSymbolRegion() {
            generatePathAndUndoNr()
            paintCalculateShapeSize()
            paintCalculateSymbolPixels()
            call("graphx.paintSymbolFunction", [ inputPathPy, symbolSourcePath, outputPathPy, rectX, rectY, scaleDisplayFactorCrop, paintToolColor, paintSymbolSizeFaktor ])
        }
        function paintPickColorFunction() {
            generateCoordinatesColorPicker()
            call("graphx.paintGetColorPointFunction", [ inputPathPy, rectX, rectY, scaleDisplayFactorCrop ])
        }

        function getDominantColorFunction() {
            generateCoordinatesColorPicker()
            call("graphx.getDominantColorFunction", [ inputPathPy ])
        }
        function paintConvertRGBAFunction() {
            var rgbR = idSliderColorRed.value
            var rgbG = idSliderColorGreen.value
            var rgbB = idSliderColorBlue.value
            var rgbA = idSliderColorAlpha.value
            call("graphx.paintConvertRGBAFunction", [ rgbR, rgbG, rgbB, rgbA ])
        }
        function paintCanvasFunction() {
                generatePathAndUndoNr()
                paintCalculateCanvasPixels()
                call("graphx.paintCanvasFunction", [ inputPathPy, outputPathPy, freeDrawPolyCoordinates, scaleDisplayFactorCrop, paintToolColor, paintCanvasThickness, drawType ])
        }
        function cropCanvasPolygonFunction() {
                generatePathAndUndoNr()
                paintCalculateCanvasPixels()
                call("graphx.cropCanvasPolygonFunction", [ inputPathPy, outputPathPy, freeDrawPolyCoordinates, scaleDisplayFactorCrop, cutFillColor, actionCutSelection ])
        }
        function cropCanvasShapeFunction() {
                generatePathAndUndoNr()
                generateCroppingPixelsFromHandles()
                var croppingColor = "#00000000"
                call("graphx.cropCanvasShapeFunction", [ inputPathPy, outputPathPy, rectX, rectY, rectWidth, rectHeight, scaleDisplayFactorCrop, croppingColor, actionCutSelection, solidTypeTool ])
        }



        // file operations
        function deleteOriginalFunction() {
            py.deleteAllTMPFunction()
            undoNr = 0
            var inputPathPy = "/" + origImageFilePath.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"")
            call("graphx.deleteNowFunction", [ inputPathPy ])
        }
        function deleteLastTMPFunction() {
            call("graphx.deleteLastTMPFunction", [ lastTMP2delete ])
        }
        function deleteAllTMPFunction() {
            undoNr = 0
            idImageLoadedFreecrop.source = encodeURI(origImageFilePath)
            call("graphx.deleteAllTMPFunction", [ tempImageFolderPath ])
        }
        function createTmpAndSaveFolder() {
            call("graphx.createTmpAndSaveFolder", [ tempImageFolderPath, saveImageFolderPath ])
        }
        function deleteCopyPasteImage() {
            var copyPastePath = tempImageFolderPath + tempCopyPasteFileName + ".png"
            call("graphx.deleteCopyPasteFunction", [ copyPastePath, tempImageFolderPath ])
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
        anchors.fill: parent
        contentHeight: column.height  // Tell SilicaFlickable the height of its content

        PullDownMenu {
            MenuItem {
                enabled: ( warningNoPillow === false ) ? true : false
                text: qsTr("Files")
                onClicked: pageStack.push(filePickerPage)
            }
            MenuItem {
                enabled: ( warningNoPillow === false ) ? true : false
                text: qsTr("Gallery")
                onClicked: pageStack.push(imagePickerPage)
            }
            MenuItem {
                text: qsTr("Save")
                enabled: ( idImageLoadedFreecrop.status !== Image.Null ) ? true : false
                onClicked: { pageStack.push(Qt.resolvedUrl("SavePage.qml"), {
                    homeDirectory : homeDirectory,
                    origImageFileName : origImageFileName,
                    origImageFolderPath : origImageFolderPath,
                    tempImageFolderPath : tempImageFolderPath,
                    imageWidthSave : idImageLoadedFreecrop.sourceSize.width,
                    imageHeightSave : idImageLoadedFreecrop.sourceSize.height,
                    inputPathPy : idImageLoadedFreecrop.source.toString()
                } ) }
            }
            MenuItem {
                text: qsTr("View")
                enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ViewPage.qml"), {
                        inputPathPy : idImageLoadedFreecrop.source.toString()
                    })
                }
            }
        }

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

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
                        color: Theme.primaryColor
                        text: "Imageworks"
                    }
                    Label {
                        id: idLabelFilePath
                        width: parent.width
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeTiny
                        color: Theme.primaryColor
                        truncationMode: TruncationMode.Elide
                        text: idImageLoadedFreecrop.source.toString() //origImageFilePath
                    }
                }
                IconButton {
                    id: idIconUndoButton
                    width: (parent.width - 2*Theme.paddingLarge) / 5
                    height: idLabelProgramName.height + idLabelFilePath.height
                    anchors.top: parent.top
                    anchors.topMargin: Theme.paddingMedium
                    anchors.left: parent.left
                    enabled: ( undoNr >= 1 && finishedLoading === true && idImageLoadedFreecrop.status !== Image.Null) ? true : false
                    visible: ( undoNr >= 1 && finishedLoading === true ) ? true : false
                    Image {
                        id: idUndoImage
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingSmall/2
                        fillMode: Image.PreserveAspectFit
                        source: "image://theme/icon-m-refresh?"
                        mirror: true
                        scale: 1.5
                    }
                    Label {
                        anchors.horizontalCenter: idUndoImage.horizontalCenter
                        anchors.verticalCenter: idUndoImage.verticalCenter
                        font.pixelSize: Theme.fontSizeTiny
                        text: undoNr
                    }
                    onClicked: {
                        undoBackwards()
                        finishedLoading = false
                    }
                }
                BusyIndicator {
                    anchors.left: parent.left
                    anchors.verticalCenter: idIconUndoButton.verticalCenter
                    anchors.verticalCenterOffset: Theme.paddingSmall/2
                    running: (finishedLoading === true) ? false : true
                    size: BusyIndicatorSize.Medium
                }
            }
            Rectangle {
                // spacer item
                width: parent.width
                height: 1
                color: "transparent"
            }


            Image {
                id: idImageLoadedFreecrop
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                fillMode: Image.PreserveAspectFit
                source: origImageFilePath
                cache: false
                onSourceSizeChanged: {
                    //freeDrawPolyCoordinates = ""
                    freeDrawCanvas.clear_canvas()
                    if (sourceSize.width < width) {
                        idItemCropzoneHandles.anchors.leftMargin = (width-sourceSize.width) / 2
                        idItemCropzoneHandles.anchors.rightMargin = (width-sourceSize.width) / 2
                    }
                    else {
                        idItemCropzoneHandles.anchors.leftMargin = 0
                        idItemCropzoneHandles.anchors.rightMargin = 0
                    }
                    setCropmarkersFullImage()
                    setTransformationMarkersFullImage()
                }

                Item {
                    id: idItemCropzoneHandles
                    anchors.fill: parent
                    visible: ( idImageLoadedFreecrop.status !== Image.Null && ( (buttonCrop.down === true && pickerTransformOrCropIndex === 0) || buttonPaint.down === true)) ? true : false

                    // The handles to define a rectangle that will remain after cropping
                    Rectangle {
                        id: rectDrag1
                        visible: ( (buttonCrop.down && idComboBoxCrop.currentIndex === 12 && pickerTransformOrCropIndex === 0) || (idPaintCanvasButton.down && buttonPaint.down ) ) ? false : true
                        x: parent.x
                        y: parent.y
                        radius: ( (idPaintLineButton.down || idPaintPointButton.down || idPaintTextButton.down || idPaintShapesButton.down || idPaintColorPickerButton.down) && buttonPaint.down ) ? handleWidth : 0
                        width: handleWidth
                        height: handleHeight
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges
                        MouseArea {
                            id: dragArea1
                            preventStealing: true // Patch: crop by coordinates disables moving...
                            enabled: ( (buttonCrop.down) && (pickerTransformOrCropIndex === 0) && (idComboBoxCrop.currentIndex === 12) ) ? false : true
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: (stretchOversizeActive === true) ? (0-handleWidth/2) : (0) //idItemCropzoneHandles.x
                            drag.maximumX: (stretchOversizeActive === true) ? (idItemCropzoneHandles.width - handleWidth/2) : (idItemCropzoneHandles.width - handleWidth)
                            drag.minimumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.y - handleHeight/2) : (idItemCropzoneHandles.y)
                            drag.maximumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.height - handleHeight/2) : (idItemCropzoneHandles.height - handleHeight)
                            onEntered: {
                                oldPosX1 = rectDrag1.x
                                oldPosY1 = rectDrag1.y
                                calculateZoomImagePart(rectDrag1)
                            }
                            onPositionChanged: {
                                if (croppingRatio != 0) {
                                    diffX1 = rectDrag1.x - oldPosX1
                                    diffY1 = (diffX1 / croppingRatio)
                                    rectDrag1.y = oldPosY1 + diffY1
                                    if (rectDrag1.y > (idItemCropzoneHandles.height - handleHeight)) {
                                        rectDrag1.y = idItemCropzoneHandles.height - handleHeight
                                        rectDrag1.x = stopX1
                                    }
                                    else if (rectDrag1.y < 0) {
                                        rectDrag1.y = 0
                                        rectDrag1.x = stopX1
                                    }
                                    else {
                                        stopX1 = rectDrag1.x
                                    }
                                }
                                calculateZoomImagePart(rectDrag1)
                            }
                        }
                    }

                    Rectangle {
                        id: rectDrag2
                        visible: ( buttonPaint.down && (idPaintTextButton.down || idPaintPointButton.down || idPaintShapesButton.down || idPaintColorPickerButton.down)
                                  || ( buttonCrop.down && idComboBoxCrop.currentIndex === 12 && pickerTransformOrCropIndex === 0 ) || (idPaintCanvasButton.down && buttonPaint.down ) ) ? false : true
                        x: parent.width - handleWidth
                        y: parent.height - handleHeight
                        radius: (idPaintLineButton.down && buttonPaint.down) ? handleWidth : 0
                        height: handleHeight
                        width: handleWidth
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges
                        MouseArea {
                            id: dragArea2
                            preventStealing: true
                            // Patch: crop by coordinates disables moving...
                            enabled: ( (buttonCrop.down) && (pickerTransformOrCropIndex === 0) && (idComboBoxCrop.currentIndex === 12) ) ? false : true
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: (stretchOversizeActive === true) ? (0-handleWidth/2) : (0) //idItemCropzoneHandles.x
                            drag.maximumX: (stretchOversizeActive === true) ? (idItemCropzoneHandles.width - handleWidth/2) : (idItemCropzoneHandles.width - handleWidth)
                            drag.minimumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.y - handleHeight/2) : (idItemCropzoneHandles.y)
                            drag.maximumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.height - handleHeight/2) : (idItemCropzoneHandles.height - handleHeight)
                            onEntered: {
                                oldPosX2 = rectDrag2.x
                                oldPosY2 = rectDrag2.y
                                calculateZoomImagePart(rectDrag2)
                            }
                            onPositionChanged: {
                                if (croppingRatio != 0) {
                                    diffX2 = rectDrag2.x - oldPosX2
                                    diffY2 = (diffX2 / croppingRatio)
                                    rectDrag2.y = oldPosY2 + diffY2
                                    if (rectDrag2.y > (idItemCropzoneHandles.height - handleHeight)) {
                                        rectDrag2.y = idItemCropzoneHandles.height - handleHeight
                                        rectDrag2.x = stopX2
                                    }
                                    else if (rectDrag2.y < 0) {
                                        rectDrag2.y = 0
                                        rectDrag2.x = stopX2
                                    }
                                    else {
                                        stopX2 = rectDrag2.x
                                    }
                                }
                                calculateZoomImagePart(rectDrag2)
                            }
                        }
                    }

                    // The main resulting rectangle, containing the cropped part of the image
                    Rectangle {
                        id: frameRectangleCroppingzone
                        z: -1
                        visible: ( buttonPaint.down && ( idPaintTextButton.down || idPaintPointButton.down || idPaintLineButton.down || idPaintShapesButton.down || idPaintColorPickerButton.down ) ) ? false : true
                        color: ( buttonPaint.down && ( idPaintSolidButton.down || idPaintCopyButton.down || idPaintPasteButton.down ) ) ? toolsDrawingColorFrame : "transparent"
                        opacity: paintRegionOpacity
                        border.color: ( buttonPaint.down && (idPaintFrameButton.down || idPaintSprayButton.down) ) ? toolsDrawingColorFrame : "transparent"
                        border.width: opticalDividersWidth * 20
                        anchors.top: (rectDrag1.y < rectDrag2.y) ? rectDrag1.top : rectDrag2.top
                        anchors.left: (rectDrag1.x < rectDrag2.x) ? rectDrag1.left : rectDrag2.left
                        anchors.bottom: ((rectDrag1.y + rectDrag1.height) > (rectDrag2.y + rectDrag2.height)) ? rectDrag1.bottom : rectDrag2.bottom
                        anchors.right: ((rectDrag1.x + rectDrag1.width) > (rectDrag2.x + rectDrag2.width)) ? rectDrag1.right : rectDrag2.right
                        MouseArea {
                            id: dragAreaFullCroppingZone
                            // Patch: crop by coordinates disables moving...
                            enabled: ( (buttonCrop.down) && (pickerTransformOrCropIndex === 0) && (idComboBoxCrop.currentIndex === 12) ) ? false : true
                            anchors.fill: parent
                            drag.target:  parent
                            onEntered: {
                                oldmouseX = mouseX
                                oldmouseY = mouseY
                                oldWidth = parent.width
                                oldHeight = parent.height
                                oldFullAreaWidth = idItemCropzoneHandles.width
                                oldFullAreaHeight = idItemCropzoneHandles.height
                                if (rectDrag1.x < rectDrag2.x) { oldWhichSquareLEFT = "left1" }
                                    else { oldWhichSquareLEFT = "left2" }
                                if (rectDrag1.y < rectDrag2.y) { oldWhichSquareUP = "up1" }
                                    else { oldWhichSquareUP = "up2" }
                            }
                            onMouseXChanged: {
                                rectDrag1.x = rectDrag1.x + (mouseX - oldmouseX)
                                rectDrag2.x = rectDrag2.x + (mouseX - oldmouseX)
                                if (oldWhichSquareLEFT === "left1") {
                                    if (rectDrag1.x < 0) {
                                        rectDrag1.x = 0
                                        rectDrag2.x = oldWidth - rectDrag1.width
                                    }
                                    if ((rectDrag2.x+rectDrag2.width) > oldFullAreaWidth) {
                                        rectDrag2.x = oldFullAreaWidth - rectDrag2.width
                                        rectDrag1.x = oldFullAreaWidth - oldWidth
                                    }
                                }
                                if (oldWhichSquareLEFT === "left2") {
                                    if (rectDrag2.x < 0) {
                                        rectDrag2.x = 0
                                        rectDrag1.x = oldWidth - rectDrag2.width
                                    }
                                    if ((rectDrag1.x+rectDrag1.width) > oldFullAreaWidth) {
                                        rectDrag1.x = oldFullAreaWidth - rectDrag1.width
                                        rectDrag2.x = oldFullAreaWidth - oldWidth
                                    }
                                }
                            }
                            onMouseYChanged: {
                                rectDrag1.y = rectDrag1.y + (mouseY - oldmouseY)
                                rectDrag2.y = rectDrag2.y + (mouseY - oldmouseY)
                                if (oldWhichSquareUP === "up1") {
                                    if (rectDrag1.y < 0) {
                                        rectDrag1.y = 0
                                        rectDrag2.y = oldHeight - rectDrag1.height
                                    }
                                    if ((rectDrag2.y+rectDrag2.height) > oldFullAreaHeight) {
                                        rectDrag2.y = oldFullAreaHeight - rectDrag2.height
                                        rectDrag1.y = oldFullAreaHeight - oldHeight
                                    }
                                }
                                if (oldWhichSquareUP === "up2") {
                                    if (rectDrag2.y < 0) {
                                        rectDrag2.y = 0
                                        rectDrag1.y = oldHeight - rectDrag2.height
                                    }
                                    if ((rectDrag1.y+rectDrag1.height) > oldFullAreaHeight) {
                                    rectDrag1.y = oldFullAreaHeight - rectDrag1.height
                                    rectDrag2.y = oldFullAreaHeight - oldHeight
                                    }
                                }
                            }
                        }
                    } // end Rectangle Croppingzone

                    Rectangle {
                        id: drawingLingHelping
                        visible: ( buttonPaint.down && idPaintLineButton.down ) ? true : false
                        opacity: paintRegionOpacity
                        color: toolsDrawingColorFrame
                        anchors.verticalCenter: frameRectangleCroppingzone.verticalCenter
                        anchors.horizontalCenter: frameRectangleCroppingzone.horizontalCenter
                        width: Math.sqrt( ((rectDrag2.x - rectDrag1.x) * (rectDrag2.x - rectDrag1.x)) + ((rectDrag2.y - rectDrag1.y) * (rectDrag2.y - rectDrag1.y)) )
                        height: opticalDividersWidth * 20
                        rotation: Math.atan( (rectDrag2.y - rectDrag1.y) / (rectDrag2.x - rectDrag1.x) ) * (180 / Math.PI)
                    }

                    // The gray zones which will be cut away
                    Rectangle {
                        id: grayzoneUP
                        anchors.top: parent.top
                        anchors.left: parent.left
                        width: idItemCropzoneHandles.width
                        height: Math.min(rectDrag1.y, rectDrag2.y)
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }
                    Rectangle {
                        id: grayzoneLEFT
                        anchors.left: parent.left
                        y: Math.min(rectDrag1.y, rectDrag2.y)
                        width: Math.min(rectDrag1.x, rectDrag2.x)
                        height: Math.max(rectDrag1.y+rectDrag1.height, rectDrag2.y+rectDrag2.height) - Math.min(rectDrag1.y, rectDrag2.y)
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }
                    Rectangle {
                        id: grayzoneDOWN
                        anchors.left: parent.left
                        y: Math.max((rectDrag1.y + rectDrag1.height), (rectDrag2.y + rectDrag2.height))
                        width: idItemCropzoneHandles.width
                        height: idItemCropzoneHandles.height - Math.max(rectDrag1.y + rectDrag1.height, rectDrag2.y + rectDrag2.height)
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }
                    Rectangle {
                        id: grayzoneRIGHT
                        x: Math.max(rectDrag1.x + rectDrag1.width, rectDrag2.x + rectDrag2.width)
                        y: Math.min(rectDrag1.y, rectDrag2.y)
                        width: idItemCropzoneHandles.width - Math.max(rectDrag1.x + rectDrag1.width, rectDrag2.x + rectDrag2.width)
                        height: Math.max(rectDrag1.y+rectDrag1.height, rectDrag2.y+rectDrag2.height) - Math.min(rectDrag1.y, rectDrag2.y)
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }

                    // Optical deviders to divide height and width into thirds
                    Rectangle {
                        id: grayVerticalDevider1
                        x: Math.min(rectDrag1.x, rectDrag2.x) + (Math.max(rectDrag2.x+rectDrag2.width, rectDrag1.x+rectDrag1.width) - Math.min(rectDrag1.x, rectDrag2.x))/3
                        y: Math.min(rectDrag1.y, rectDrag2.y)
                        z: -1
                        width: opticalDividersWidth
                        height: Math.max(rectDrag1.y+rectDrag1.height, rectDrag2.y+rectDrag2.height) - Math.min(rectDrag1.y, rectDrag2.y)
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }
                    Rectangle {
                        id: grayVerticalDevider2
                        x: Math.min(rectDrag1.x, rectDrag2.x) + (Math.max(rectDrag2.x+rectDrag2.width, rectDrag1.x+rectDrag1.width) - Math.min(rectDrag1.x, rectDrag2.x))/3*2
                        y: Math.min(rectDrag1.y, rectDrag2.y)
                        z: -1
                        width: opticalDividersWidth
                        height: Math.max(rectDrag1.y+rectDrag1.height, rectDrag2.y+rectDrag2.height) - Math.min(rectDrag1.y, rectDrag2.y)
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }
                    Rectangle {
                        id: grayHorizontalDevider1
                        x: Math.min(rectDrag1.x, rectDrag2.x)
                        y: Math.min(rectDrag1.y, rectDrag2.y) + (Math.max(rectDrag2.y+rectDrag2.height, rectDrag1.y+rectDrag1.height) - Math.min(rectDrag1.y, rectDrag2.y))/3
                        z: -1
                        width: Math.max(rectDrag1.x+rectDrag1.width, rectDrag2.x+rectDrag2.width) - Math.min(rectDrag1.x, rectDrag2.x)
                        height: opticalDividersWidth
                        color: (buttonPaint.down) ? "transparent" : "black"
                        opacity: opacityCut
                    }
                    Rectangle {
                        id: grayHorizontalDevider2
                        x: Math.min(rectDrag1.x, rectDrag2.x)
                        y: Math.min(rectDrag1.y, rectDrag2.y) + (Math.max(rectDrag2.y+rectDrag2.height, rectDrag1.y+rectDrag1.height) - Math.min(rectDrag1.y, rectDrag2.y))/3*2
                        z: -1
                        width: Math.max(rectDrag1.x+rectDrag1.width, rectDrag2.x+rectDrag2.width) - Math.min(rectDrag1.x, rectDrag2.x)
                        height: opticalDividersWidth
                        color: (buttonPaint.down) ? "transparent" : "black" // Theme.highlightColor
                        opacity: opacityCut
                    }
                }

                Item {
                    id: idItemPerspectiveHandles
                    visible: ( idImageLoadedFreecrop.status !== Image.Null && (  (buttonCrop.down === true && pickerTransformOrCropIndex !== 0) )) ? true : false
                    anchors.fill: idItemCropzoneHandles
                    // Handles for image transformation
                    Rectangle {
                        id: rectPerspective1
                        x: parent.x
                        y: parent.y
                        radius: handleWidth
                        width: handleWidth
                        height: handleHeight
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges
                        MouseArea {
                            id: dragPerspective1
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: (stretchOversizeActive === true) ? (0-handleWidth/2) : (0) //idItemCropzoneHandles.x
                            drag.maximumX: (stretchOversizeActive === true) ? (idItemCropzoneHandles.width - handleWidth/2) : (idItemCropzoneHandles.width - handleWidth)
                            drag.minimumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.y - handleHeight/2) : (idItemCropzoneHandles.y)
                            drag.maximumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.height - handleHeight/2) : (idItemCropzoneHandles.height - handleHeight)
                            onEntered: {
                                calculateZoomImagePart(rectPerspective1)
                            }

                            onPositionChanged: {
                                calculateZoomImagePart(rectPerspective1)
                            }
                        }
                    }
                    Rectangle {
                        id: rectPerspective2
                        x: parent.width - handleWidth
                        y: parent.y
                        radius: handleWidth
                        width: handleWidth
                        height: handleHeight
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges
                        MouseArea {
                            id: dragPerspective2
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: (stretchOversizeActive === true) ? (0-handleWidth/2) : (0) //idItemCropzoneHandles.x
                            drag.maximumX: (stretchOversizeActive === true) ? (idItemCropzoneHandles.width - handleWidth/2) : (idItemCropzoneHandles.width - handleWidth)
                            drag.minimumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.y - handleHeight/2) : (idItemCropzoneHandles.y)
                            drag.maximumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.height - handleHeight/2) : (idItemCropzoneHandles.height - handleHeight)
                            onEntered: {
                                calculateZoomImagePart(rectPerspective2)
                            }

                            onPositionChanged: {
                                calculateZoomImagePart(rectPerspective2)
                            }
                        }
                    }
                    Rectangle {
                        id: rectPerspective3
                        x: parent.width - handleWidth
                        y: parent.height - handleHeight
                        radius: handleWidth
                        width: handleWidth
                        height: handleHeight
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges
                        MouseArea {
                            id: dragPerspective3
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: (stretchOversizeActive === true) ? (0-handleWidth/2) : (0) //idItemCropzoneHandles.x
                            drag.maximumX: (stretchOversizeActive === true) ? (idItemCropzoneHandles.width - handleWidth/2) : (idItemCropzoneHandles.width - handleWidth)
                            drag.minimumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.y - handleHeight/2) : (idItemCropzoneHandles.y)
                            drag.maximumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.height - handleHeight/2) : (idItemCropzoneHandles.height - handleHeight)
                            onEntered: {
                                calculateZoomImagePart(rectPerspective3)
                            }

                            onPositionChanged: {
                                calculateZoomImagePart(rectPerspective3)
                            }
                        }
                    }
                    Rectangle {
                        id: rectPerspective4
                        x: parent.x
                        y: parent.height - handleHeight
                        radius: handleWidth
                        width: handleWidth
                        height: handleHeight
                        color: toolsDrawingColorFrame
                        opacity: opacityEdges
                        MouseArea {
                            id: dragPerspective4
                            anchors.fill: parent
                            drag.target: parent
                            drag.minimumX: (stretchOversizeActive === true) ? (0-handleWidth/2) : (0) //idItemCropzoneHandles.x
                            drag.maximumX: (stretchOversizeActive === true) ? (idItemCropzoneHandles.width - handleWidth/2) : (idItemCropzoneHandles.width - handleWidth)
                            drag.minimumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.y - handleHeight/2) : (idItemCropzoneHandles.y)
                            drag.maximumY: (stretchOversizeActive === true) ? (idItemCropzoneHandles.height - handleHeight/2) : (idItemCropzoneHandles.height - handleHeight)
                            onEntered: {
                                calculateZoomImagePart(rectPerspective4)
                            }

                            onPositionChanged: {
                                calculateZoomImagePart(rectPerspective4)
                            }
                        }
                    }
                    Rectangle {
                        id: rectanglePerspective1_2
                        visible: true //( buttonPaint.down && ( idPaintTextButton.down || idPaintPointButton.down || idPaintLineButton.down || idPaintShapesButton.down ) ) ? false : true
                        color: "transparent"
                        anchors.top: (rectPerspective1.y < rectPerspective2.y) ? rectPerspective1.top : rectPerspective2.top
                        anchors.left: (rectPerspective1.x < rectPerspective2.x) ? rectPerspective1.left : rectPerspective2.left
                        anchors.bottom: ((rectPerspective1.y + rectPerspective1.height) > (rectPerspective2.y + rectPerspective2.height)) ? rectPerspective1.bottom : rectPerspective2.bottom
                        anchors.right: ((rectPerspective1.x + rectPerspective1.width) > (rectPerspective2.x + rectPerspective2.width)) ? rectPerspective1.right : rectPerspective2.right
                    }
                    Rectangle {
                        id: perspectiveLine1
                        visible: true // ( buttonShape.down ) ? true : false
                        opacity: paintRegionOpacity
                        color: toolsDrawingColorFrame
                        anchors.verticalCenter: rectanglePerspective1_2.verticalCenter
                        anchors.horizontalCenter: rectanglePerspective1_2.horizontalCenter
                        width: Math.sqrt( ((rectPerspective2.x - rectPerspective1.x) * (rectPerspective2.x - rectPerspective1.x)) + ((rectPerspective2.y - rectPerspective1.y) * (rectPerspective2.y - rectPerspective1.y)) ) - handleWidth
                        height: opticalDividersWidth * 20
                        rotation: Math.atan( (rectPerspective2.y - rectPerspective1.y) / (rectPerspective2.x - rectPerspective1.x) ) * (180 / Math.PI)
                    }
                    Rectangle {
                        id: rectanglePerspective2_3
                        visible: true //( buttonPaint.down && ( idPaintTextButton.down || idPaintPointButton.down || idPaintLineButton.down || idPaintShapesButton.down ) ) ? false : true
                        color: "transparent"
                        anchors.top: (rectPerspective2.y < rectPerspective3.y) ? rectPerspective2.top : rectPerspective3.top
                        anchors.left: (rectPerspective2.x < rectPerspective3.x) ? rectPerspective2.left : rectPerspective3.left
                        anchors.bottom: ((rectPerspective2.y + rectPerspective2.height) > (rectPerspective3.y + rectPerspective3.height)) ? rectPerspective2.bottom : rectPerspective3.bottom
                        anchors.right: ((rectPerspective2.x + rectPerspective2.width) > (rectPerspective3.x + rectPerspective3.width)) ? rectPerspective2.right : rectPerspective3.right
                    }
                    Rectangle {
                        id: perspectiveLine2
                        visible: true // ( buttonShape.down ) ? true : false
                        opacity: paintRegionOpacity
                        color: toolsDrawingColorFrame
                        anchors.verticalCenter: rectanglePerspective2_3.verticalCenter
                        anchors.horizontalCenter: rectanglePerspective2_3.horizontalCenter
                        width: Math.sqrt( ((rectPerspective3.x - rectPerspective2.x) * (rectPerspective3.x - rectPerspective2.x)) + ((rectPerspective3.y - rectPerspective2.y) * (rectPerspective3.y - rectPerspective2.y)) ) - handleWidth
                        height: opticalDividersWidth * 20
                        rotation: Math.atan( (rectPerspective3.y - rectPerspective2.y) / (rectPerspective3.x - rectPerspective2.x) ) * (180 / Math.PI)
                    }
                    Rectangle {
                        id: rectanglePerspective3_4
                        visible: true //( buttonPaint.down && ( idPaintTextButton.down || idPaintPointButton.down || idPaintLineButton.down || idPaintShapesButton.down ) ) ? false : true
                        color: "transparent"
                        anchors.top: (rectPerspective3.y < rectPerspective4.y) ? rectPerspective3.top : rectPerspective4.top
                        anchors.left: (rectPerspective3.x < rectPerspective4.x) ? rectPerspective3.left : rectPerspective4.left
                        anchors.bottom: ((rectPerspective3.y + rectPerspective3.height) > (rectPerspective4.y + rectPerspective4.height)) ? rectPerspective3.bottom : rectPerspective4.bottom
                        anchors.right: ((rectPerspective3.x + rectPerspective3.width) > (rectPerspective4.x + rectPerspective4.width)) ? rectPerspective3.right : rectPerspective4.right
                    }
                    Rectangle {
                        id: perspectiveLine3
                        visible: true // ( buttonShape.down ) ? true : false
                        opacity: paintRegionOpacity
                        color: toolsDrawingColorFrame
                        anchors.verticalCenter: rectanglePerspective3_4.verticalCenter
                        anchors.horizontalCenter: rectanglePerspective3_4.horizontalCenter
                        width: Math.sqrt( ((rectPerspective4.x - rectPerspective3.x) * (rectPerspective4.x - rectPerspective3.x)) + ((rectPerspective4.y - rectPerspective3.y) * (rectPerspective4.y - rectPerspective3.y)) ) - handleWidth
                        height: opticalDividersWidth * 20
                        rotation: Math.atan( (rectPerspective4.y - rectPerspective3.y) / (rectPerspective4.x - rectPerspective3.x) ) * (180 / Math.PI)
                    }
                    Rectangle {
                        id: rectanglePerspective4_1
                        visible: true //( buttonPaint.down && ( idPaintTextButton.down || idPaintPointButton.down || idPaintLineButton.down || idPaintShapesButton.down ) ) ? false : true
                        color: "transparent"
                        anchors.top: (rectPerspective4.y < rectPerspective1.y) ? rectPerspective4.top : rectPerspective1.top
                        anchors.left: (rectPerspective4.x < rectPerspective1.x) ? rectPerspective4.left : rectPerspective1.left
                        anchors.bottom: ((rectPerspective4.y + rectPerspective4.height) > (rectPerspective1.y + rectPerspective1.height)) ? rectPerspective4.bottom : rectPerspective1.bottom
                        anchors.right: ((rectPerspective4.x + rectPerspective4.width) > (rectPerspective1.x + rectPerspective1.width)) ? rectPerspective4.right : rectPerspective1.right
                    }
                    Rectangle {
                        id: perspectiveLine4
                        visible: true // ( buttonShape.down ) ? true : false
                        opacity: paintRegionOpacity
                        color: toolsDrawingColorFrame
                        anchors.verticalCenter: rectanglePerspective4_1.verticalCenter
                        anchors.horizontalCenter: rectanglePerspective4_1.horizontalCenter
                        width: Math.sqrt( ((rectPerspective1.x - rectPerspective4.x) * (rectPerspective1.x - rectPerspective4.x)) + ((rectPerspective1.y - rectPerspective4.y) * (rectPerspective1.y - rectPerspective4.y)) ) - handleWidth
                        height: opticalDividersWidth * 20
                        rotation: Math.atan( (rectPerspective1.y - rectPerspective4.y) / (rectPerspective1.x - rectPerspective4.x) ) * (180 / Math.PI)
                    }
                }

                Item {
                    id: canvasFreeDrawing
                    anchors.fill: idItemCropzoneHandles
                    visible: ( idImageLoadedFreecrop.status !== Image.Null && buttonPaint.down === true && idPaintCanvasButton.down ) ? true : false
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        Canvas {
                            id: freeDrawCanvas
                            enabled: (freeDrawLock === false) ? true : false
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext('2d')
                                ctx.beginPath()
                                ctx.lineCap = 'round'
                                ctx.strokeStyle = toolsDrawingColorFrame
                                ctx.lineWidth = freeDrawLineWidth
                                ctx.moveTo(freeDrawXpos, freeDrawYpos)
                                ctx.lineTo(mouseCanvasArea.mouseX, mouseCanvasArea.mouseY)
                                ctx.stroke()
                                ctx.closePath()
                                freeDrawXpos = mouseCanvasArea.mouseX
                                freeDrawYpos = mouseCanvasArea.mouseY
                            }

                            function clear_canvas() {
                                var ctx = getContext("2d")
                                ctx.reset()
                                freeDrawCanvas.requestPaint()
                            }
                            MouseArea {
                                id: mouseCanvasArea
                                preventStealing: true
                                anchors.fill: parent

                                onEntered: {
                                //onPressed: {
                                    freeDrawXpos = mouseX
                                    freeDrawYpos = mouseY
                                    calculateZoomImagePart(mouseCanvasArea)
                                }
                                onPositionChanged: {
                                    freeDrawCanvas.requestPaint()
                                    freeDrawPolyCoordinates = freeDrawPolyCoordinates + freeDrawXpos + ";" + freeDrawYpos + ";"
                                    calculateZoomImagePart(mouseCanvasArea)
                                }
                                onReleased: {
                                    freeDrawPolyCoordinates = freeDrawPolyCoordinates + mouseX + ";" + mouseY + ";" + "/"
                                    //freeDrawLock = true
                                }
                            }
                        }
                    }
                }
            } // end Image area
            Rectangle {
                width: parent.width
                height: 1
                color: "transparent"
            }


            Row {
                id: idToolsRow
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge

                IconButton {
                    id: buttonCrop
                    icon.opacity: 1
                    down: false
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-crop?"
                    icon.color: undefined
                    onClicked: {
                        buttonCrop.down = true
                        buttonScale.down = false
                        buttonPaint.down = false
                        buttonShape.down = false
                        buttonColors.down = false
                        buttonEffects.down = false
                        buttonFile.down = false
                        idCropTransformPicker.icon.source = "../symbols/icon-m-cut.svg"
                        pickerTransformOrCropIndex = 0
                        presetCroppingFree() // Patch: reset cropping markers to free when returning to cropping tool
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
                IconButton {
                    id: buttonPaint
                    icon.opacity: 1
                    down: false
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-edit?"
                    onClicked: {
                        buttonCrop.down = false
                        buttonScale.down = false
                        buttonPaint.down = true
                        buttonShape.down = false
                        buttonColors.down = false
                        buttonEffects.down = false
                        buttonFile.down = false
                        presetCroppingFree()
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
                IconButton {
                    id: buttonShape
                    icon.opacity: 1
                    down: false
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-rotate?"
                    onClicked: {
                        buttonCrop.down = false
                        buttonScale.down = false
                        buttonPaint.down = false
                        buttonShape.down = true
                        buttonColors.down = false
                        buttonEffects.down = false
                        buttonFile.down = false
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
                IconButton {
                    id: buttonColors
                    icon.opacity: 1
                    down: false
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-light-contrast?"
                    onClicked: {
                        buttonCrop.down = false
                        buttonScale.down = false
                        buttonPaint.down = false
                        buttonShape.down = false
                        buttonColors.down = true
                        buttonEffects.down = false
                        buttonFile.down = false
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
                IconButton {
                    id: buttonScale
                    icon.opacity: 1
                    down: false
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-scale?"
                    onClicked: {
                        buttonCrop.down = false
                        buttonScale.down = true
                        buttonPaint.down = false
                        buttonShape.down = false
                        buttonColors.down = false
                        buttonEffects.down = false
                        buttonFile.down = false
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
                IconButton {
                    id: buttonEffects
                    icon.opacity: 1
                    down: false
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effects.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        buttonCrop.down = false
                        buttonScale.down = false
                        buttonPaint.down = false
                        buttonShape.down = false
                        buttonColors.down = false
                        buttonEffects.down = true
                        buttonFile.down = false
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
                IconButton {
                    id: buttonFile
                    icon.opacity: 1
                    down: true
                    width: parent.width/7
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-file-document-light?"
                    onClicked: {
                        buttonCrop.down = false
                        buttonScale.down = false
                        buttonPaint.down = false
                        buttonShape.down = false
                        buttonColors.down = false
                        buttonEffects.down = false
                        buttonFile.down = true
                    }
                    Rectangle {
                        anchors.top: parent.bottom
                        anchors.topMargin:  Theme.paddingMedium
                        height: Theme.paddingSmall
                        width: parent.width
                        color: (parent.down === true) ? "transparent" : Theme.secondaryColor
                        border.color: Theme.secondaryColor
                    }
                }
            } // end ToolsRow
            Rectangle {
                // spacer item
                width: parent.width
                height: 1
                color: "transparent"
            }


            Grid {
                id: idGridCropPerspectivePicker
                visible: (buttonCrop.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge
                columns: 3
                IconButton {
                    id: idCropTransformPicker
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-cut.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        handleWidth = 2* Theme.paddingLarge
                        handleHeight = 2* Theme.paddingLarge
                        idComboBoxCrop.currentIndex = 0
                        if (pickerTransformOrCropIndex === 1) {
                            icon.source = "../symbols/icon-m-cut.svg"
                            croppingRatio = 0
                            stretchOversizeActive === true
                            stretchOversizeActive === false
                            setCropmarkersFullImage()
                            pickerTransformOrCropIndex = 0
                        }
                        else {
                            icon.source = "../symbols/icon-m-transform.svg"
                            croppingRatio = 0
                            setCropmarkersFullImage()
                            pickerTransformOrCropIndex = 1
                        }
                    }
                }
                ComboBox {
                    id: idComboBoxFoldStretch
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    visible: ( pickerTransformOrCropIndex !== 0 ) ? true: false
                    width: parent.width / itemsPerRow * (itemsPerRow-2)
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("stretch to edges")
                            font.pixelSize: Theme.fontSizeExtraSmall
                        }
                        MenuItem {
                            text: qsTr("fold from edges")
                            font.pixelSize: Theme.fontSizeExtraSmall
                        }
                    }
                }
                ComboBox {
                    id: idComboBoxCrop
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    visible: ( pickerTransformOrCropIndex === 0 ) ? true: false
                    width: parent.width / itemsPerRow * (itemsPerRow-2)
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("free")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 0
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersFullImage()
                            }
                        }
                        MenuItem {
                            text: qsTr("original")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                // original ration of cropping zone, takes handles into account
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                croppingRatio = (idItemCropzoneHandles.width - handleWidth) / (idItemCropzoneHandles.height - handleHeight)
                                setCropmarkersFullImage()
                            }
                        }
                        MenuItem {
                            text: qsTr("manual")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 1
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                idCropInputRatioHeight.text = placeholderManualCrop
                                idCropInputRatioWidth.text = placeholderManualCrop
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("DIN-landscape")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 1754/1240
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("DIN-portrait")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 1240/1754
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("4:3")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 4/3
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("16:10")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 16/10
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("16:9")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 16/9
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("21:9")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 21/9
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("1:1")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 1
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("3:4")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 3/4
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("1:2")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 1/2
                                handleWidth = 2 * Theme.paddingLarge
                                handleHeight = 2 * Theme.paddingLarge
                                setCropmarkersRatio()
                            }
                        }
                        MenuItem {
                            text: qsTr("pixels")
                            font.pixelSize: Theme.fontSizeExtraSmall
                            onClicked: {
                                croppingRatio = 0
                                handleWidth = 1
                                handleHeight = 1
                                setCropmarkersFullImage()
                                idInputManualX1.text = 0
                                idInputManualY1.text = 0
                                idInputManualX2.text = idImageLoadedFreecrop.sourceSize.width
                                idInputManualY2.text = idImageLoadedFreecrop.sourceSize.height
                            }
                        }
                    }
                }
                IconButton {
                    enabled: ( (idCropInputRatioWidth.text !== "" && idCropInputRatioHeight.text !== "" && idInputManualX1.text !== "" && idInputManualX2.text !== "" && idInputManualY1.text !== "" && idInputManualY2.text !== "" ) && ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true )) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        if ( pickerTransformOrCropIndex === 0  ) {
                            finishedLoading = false
                            if ( idComboBoxCrop.currentIndex !== 12) {
                                py.croppingFunctionHandles()
                            }
                            else {
                                py.croppingFunctionCoordinates()
                            }
                            presetCroppingFree()
                        }
                        if ( pickerTransformOrCropIndex !== 0 ) {
                            finishedLoading = false
                            if (idComboBoxFoldStretch.currentIndex === 0) {
                                transformPerspectiveMode = "stretch"
                            }
                            else {
                                transformPerspectiveMode = "fold"
                            }
                            py.perspectiveCorrection()
                        }
                    }
                }

                Item {
                    visible: ( ((idComboBoxCrop.currentIndex === 2) || (idComboBoxCrop.currentIndex === 12) ) && pickerTransformOrCropIndex === 0 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.iconSizeSmall
                }
                Row {
                    id: idCropInputManual
                    x: Theme.paddingLarge
                    width: parent.width / itemsPerRow * (itemsPerRow-2)
                    visible: (idComboBoxCrop.currentIndex === 2 && pickerTransformOrCropIndex === 0 ) ? true : false
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    height: Theme.itemSizeMedium * 1.1

                    TextField {
                        id: idCropInputRatioWidth
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                        text: placeholderManualCrop
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: 99 }
                        EnterKey.onClicked: {
                            if (idCropInputRatioWidth.text < 1 || idCropInputRatioWidth.text === "") {
                                idCropInputRatioWidth.text = placeholderManualCrop
                            }
                            croppingRatio = parseInt(idCropInputRatioWidth.text) / parseInt(idCropInputRatioHeight.text)
                            idCropInputRatioWidth.focus = false
                            setCropmarkersRatio()
                        }
                    }
                    Label {
                        width: Theme.paddingLarge / 4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -Theme.paddingLarge
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: ":"
                    }
                    TextField {
                        id: idCropInputRatioHeight
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                        text: placeholderManualCrop
                        horizontalAlignment: Text.AlignRight
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: 99 }
                        EnterKey.onClicked: {
                            if (idCropInputRatioHeight.text < 1 || idCropInputRatioHeight.text === "") {
                                idCropInputRatioHeight.text = placeholderManualCrop
                            }
                            croppingRatio = parseInt(idCropInputRatioWidth.text) / parseInt(idCropInputRatioHeight.text)
                            idCropInputRatioHeight.focus = false
                            setCropmarkersRatio()
                        }
                    }
                }

                Row {
                    id: idCropInputCoordinates
                    x: Theme.paddingLarge
                    width: parent.width / itemsPerRow * (itemsPerRow-2)
                    visible: ( buttonCrop.down && idComboBoxCrop.currentIndex === 12 && pickerTransformOrCropIndex === 0 ) ? true : false
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    height: Theme.itemSizeMedium * 1.1

                    TextField {
                        id: idInputManualX1
                        width: parent.width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        text: "0"
                        label: qsTr("point 1x")
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: idImageLoadedFreecrop.sourceSize.width }
                        EnterKey.onClicked: {
                            idInputManualX1.focus = false
                            setCropmarkersCoordinates()
                        }
                    }
                    TextField {
                        id: idInputManualX2
                        width: parent.width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        text: idImageLoadedFreecrop.sourceSize.width
                        label: qsTr("point 2x")
                        horizontalAlignment: Text.AlignRight
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: idImageLoadedFreecrop.sourceSize.width }
                        EnterKey.onClicked: {
                            idInputManualX2.focus = false
                            setCropmarkersCoordinates()
                        }
                    }
                }
                Item {
                    visible: ( ((idComboBoxCrop.currentIndex === 2) || (idComboBoxCrop.currentIndex === 12) ) && pickerTransformOrCropIndex === 0 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.iconSizeSmall
                }
                Item {
                    visible: ( ((idComboBoxCrop.currentIndex === 2) || (idComboBoxCrop.currentIndex === 12) ) && pickerTransformOrCropIndex === 0 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.iconSizeSmall
                }
                Row {
                    id: idCropInputCoordinates2
                    x: Theme.paddingLarge
                    width: parent.width / itemsPerRow * (itemsPerRow-2)
                    visible: ( buttonCrop.down && idComboBoxCrop.currentIndex === 12 && pickerTransformOrCropIndex === 0 ) ? true : false
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    height: Theme.itemSizeMedium * 1.1

                    TextField {
                        id: idInputManualY1
                        width: parent.width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        text: "0"
                        label: qsTr("point 1y")
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: idImageLoadedFreecrop.sourceSize.height }
                        EnterKey.onClicked: {
                            idInputManualY1.focus = false
                            setCropmarkersCoordinates()
                        }
                    }
                    TextField {
                        id: idInputManualY2
                        width: parent.width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        text: idImageLoadedFreecrop.sourceSize.height
                        label: qsTr("point 2y")
                        horizontalAlignment: Text.AlignRight
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: idImageLoadedFreecrop.sourceSize.height }
                        EnterKey.onClicked: {
                            idInputManualY2.focus = false
                            setCropmarkersCoordinates()
                        }
                    }

                }

            } //end tools crop


            Grid {
                id: idGridScale
                visible: (buttonScale.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge - spacing
                columns: 2

                Slider {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    id: idSliderScale
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall
                    minimumValue: 0.1
                    maximumValue: 5
                    value: 1
                    stepSize: 0.1
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    smooth: true
                    onValueChanged: {
                        factorToScale = value
                        toScaleWidth = Math.round(idImageLoadedFreecrop.sourceSize.width * factorToScale)
                        toScaleHeight = Math.round(idImageLoadedFreecrop.sourceSize.height * factorToScale)
                    }
                    Label {
                        text: parent.value + " x " + "[" + toScaleWidth + " x " + toScaleHeight + "]"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true  && (toScaleWidth <= maxScalePixels) && (toScaleHeight <= maxScalePixels) ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.scaleFunction()
                    }
                }

                Row {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    TextField {
                        id: idScaleInputWidth
                        width: parent.width / 4 + Theme.paddingLarge/2
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingLarge
                        text: idImageLoadedFreecrop.sourceSize.width
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: maxScalePixels }
                        EnterKey.onClicked: idScaleInputWidth.focus = false
                    }
                    Label {
                        width: parent.width / 4*3 - Theme.paddingLarge/2
                        height: parent.height
                        rightPadding: Theme.paddingLarge
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeExtraSmall
                        truncationMode: TruncationMode.Fade
                        text: qsTr("width, preserve aspect")
                    }
                }
                IconButton {
                    enabled: ( (idScaleInputWidth.text !=="" ) && idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        if (idScaleInputWidth.text < 1) {
                            idScaleInputWidth.text = "1"
                        }
                        if (idScaleInputWidth.text === "") {
                            idScaleInputWidth.text = idImageLoadedFreecrop.sourceSize.width
                        }
                        factorToScale = (idScaleInputWidth.text / idImageLoadedFreecrop.sourceSize.width)
                        py.scaleFunction()
                    }
                }

                Row {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    TextField {
                        id: idScaleInputHeight
                        width: parent.width / 4 + Theme.paddingLarge/2
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingLarge
                        text: idImageLoadedFreecrop.sourceSize.height
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: maxScalePixels }
                        EnterKey.onClicked: idScaleInputHeight.focus = false
                    }
                    Label {
                        width: parent.width / 4*3 - Theme.paddingLarge/2
                        height: parent.height
                        rightPadding: Theme.paddingLarge
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeExtraSmall
                        truncationMode: TruncationMode.Fade
                        text: qsTr("height, preserve aspect")
                    }
                }
                IconButton {
                    enabled: ( (idScaleInputHeight.text !=="" ) && idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        if (idScaleInputHeight.text < 1) {
                            idScaleInputHeight.text = "1"
                        }
                        if (idScaleInputHeight.text === "") {
                            idScaleInputHeight.text = idImageLoadedFreecrop.sourceSize.height
                        }
                        factorToScale = (idScaleInputHeight.text / idImageLoadedFreecrop.sourceSize.height)
                        py.scaleFunction()
                    }
                }

                Row {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    TextField {
                        id: idScaleInputWidth2
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingLarge
                        text: idImageLoadedFreecrop.sourceSize.width
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: maxScalePixels }
                        EnterKey.onClicked: idScaleInputWidth2.focus = false
                    }
                    Label {
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width: Theme.paddingLarge/4
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        opacity: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? 1 : 0.6
                        text: "x"
                    }
                    TextField {
                        id: idScaleInputHeight2
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingLarge
                        text: idImageLoadedFreecrop.sourceSize.height
                        horizontalAlignment: Text.AlignRight
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: maxScalePixels }
                        EnterKey.onClicked: idScaleInputHeight2.focus = false
                    }
                    Label {
                        width: parent.width / 2 - Theme.paddingLarge/4
                        height: parent.height
                        rightPadding: Theme.paddingLarge
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeExtraSmall
                        truncationMode: TruncationMode.Fade
                        text: qsTr("width  x  height")
                    }
                }
                IconButton {
                    enabled: ( (idScaleInputWidth2.text !== "" && idScaleInputHeight2.text !== "" ) && idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && (    ((idLabelFilePath.text).toString()).indexOf("empty") === -1)    ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        if (idScaleInputWidth2.text < 1) {
                            idScaleInputWidth2.text = "1"
                        }
                        if (idScaleInputWidth2.text === "") {
                            idScaleInputWidth2.text = idImageLoadedFreecrop.sourceSize.width
                        }

                        if (idScaleInputHeight2.text < 1) {
                            idScaleInputHeight2.text = "1"
                        }
                        if (idScaleInputHeight2.text === "") {
                            idScaleInputHeight2.text = idImageLoadedFreecrop.sourceSize.height
                        }
                        freeScaleWidth = Math.round(idScaleInputWidth2.text, 0)
                        freeScaleHeight = Math.round(idScaleInputHeight2.text, 0)
                        py.freescaleFunction()
                    }
                }

                Row {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    ComboBox {
                        id: idComboBoxPadding
                        width: parent.width / 2 + Theme.paddingMedium
                        menu: ContextMenu {
                            MenuItem {
                                text: qsTr("screen")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = page.width/page.height
                                }
                            }
                            MenuItem {
                                text: qsTr("manual")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = idPaddingInputWidth.text / idPaddingInputHeight.text
                                }
                            }
                            MenuItem {
                                text: qsTr("DIN-landscape")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 1754/1240
                                }
                            }
                            MenuItem {
                                text: qsTr("DIN-portrait")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 1240/1754
                                }
                            }
                            MenuItem {
                                text: qsTr("4:3")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 4/3
                                }
                            }
                            MenuItem {
                                text: qsTr("16:10")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 16/10
                                }
                            }
                            MenuItem {
                                text: qsTr("16:9")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 16/9
                                }
                            }
                            MenuItem {
                                text: qsTr("21:9")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 21/9
                                }
                            }
                            MenuItem {
                                text: qsTr("1:1")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 1
                                }
                            }
                            MenuItem {
                                text: qsTr("3:4")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 3/4
                                }
                            }
                            MenuItem {
                                text: qsTr("1:2")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                onClicked: {
                                    paddingRatio = 1/2
                                }
                            }

                        }
                    }
                    Label {
                        width: parent.width / 2 - Theme.paddingMedium
                        height: parent.height
                        rightPadding: Theme.paddingLarge
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: Theme.fontSizeExtraSmall
                        truncationMode: TruncationMode.Fade
                        text: qsTr("image padding ratio")
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && (((idLabelFilePath.text).toString()).indexOf("empty") === -1) &&  idPaddingInputHeight.text !== "" && idPaddingInputWidth.text !==""  ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.paddingImage()
                    }
                }
                Row {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    visible: idComboBoxPadding.currentIndex === 1
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    TextField {
                        id: idPaddingInputWidth
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingLarge
                        text: "1"
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: 99 }
                        EnterKey.onClicked: idPaddingInputWidth.focus = false
                    }
                    Label {
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width: Theme.paddingLarge/4
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.highlightColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        opacity: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? 1 : 0.6
                        text: ":"
                    }
                    TextField {
                        id: idPaddingInputHeight
                        width: parent.width / 4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: Theme.paddingLarge
                        text: "1"
                        horizontalAlignment: Text.AlignRight
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: 99 }
                        EnterKey.onClicked: idPaddingInputHeight.focus = false
                    }
                }
            } // end tools scale


            Grid {
                id: idGridShape
                visible: (buttonShape.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                columns: 5

                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width/5
                    height: Theme.itemSizeExtraSmall
                    icon.source: "image://theme/icon-m-rotate-left?"
                    onClicked: {
                        finishedLoading = false
                        py.rotateLeftFunction()
                    }
                    Label {
                        text: qsTr("left")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width/5
                    height: Theme.itemSizeExtraSmall
                    icon.source: "image://theme/icon-m-rotate-right?"
                    onClicked: {
                        finishedLoading = false
                        py.rotateRightFunction()
                    }
                    Label {
                        text: qsTr("right")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width/5
                    height: Theme.itemSizeExtraSmall
                    icon.source: "image://theme/icon-m-flip?"
                    icon.rotation: 90
                    onClicked: {
                        finishedLoading = false
                        py.mirrorVerticalFunction()
                    }
                    Label {
                        text: qsTr("flip")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall * 0.9 // Patch: better optical alignment
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width/5
                    height: Theme.itemSizeExtraSmall
                    icon.source: "image://theme/icon-m-flip?"
                    onClicked: {
                        finishedLoading = false
                        py.mirrorHorizontalFunction()
                    }
                    Label {
                        text: qsTr("mirror")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( (idRotateAngleManualInput.text !== "") && idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width/5
                    height: Theme.itemSizeExtraSmall
                    icon.source: "../symbols/icon-m-tilt.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.tiltAngleFunction()
                    }
                    TextField {
                        id: idRotateAngleManualInput
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width:  parent.width
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingMedium
                            horizontalCenter: parent.horizontalCenter
                        }
                        text: "0"
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: -360; top: 360 }
                        EnterKey.onClicked: {
                            idRotateAngleManualInput.focus = false
                        }
                    }
                }
            } // end tools shape


            Grid {
                id: idGridColors
                visible: (buttonColors.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge - spacing
                columns: 2

                Slider {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    id: idSliderContrast
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall
                    minimumValue: 0
                    maximumValue: 2
                    value: 1
                    stepSize: 0.02
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    smooth: true
                    Label {
                        text: qsTr("contrast") + " " + idSliderContrast.value
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }

                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.enhanceContrastFunction()
                    }
                }
                Slider {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    id: idSliderBrightness
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    minimumValue: 0
                    maximumValue: 2
                    value: 1
                    stepSize: 0.02
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    smooth: true
                    Label {
                        text: qsTr("brightness") + " " + idSliderBrightness.value
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.enhanceBrightnessFunction()
                    }
                }
                Slider {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    id: idSliderColor
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    minimumValue: 0
                    maximumValue: 2
                    value: 1
                    stepSize: 0.02
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    smooth: true
                    Label {
                        text: qsTr("color") + " " + idSliderColor.value
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.enhanceColorFunction()
                    }
                }
                Slider {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    id: idSliderSharpness
                    width: parent.width / itemsPerRow * (itemsPerRow-1)
                    height: Theme.itemSizeSmall * 1.1
                    minimumValue: 0
                    maximumValue: 2
                    value: 1
                    stepSize: 0.02
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    smooth: true
                    Label {
                        text: qsTr("sharpness") + " " + idSliderSharpness.value
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall * 1.1
                    icon.source: "../symbols/icon-m-apply.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.enhanceSharpnessFunction()
                    }
                }

            } // end tools colors


            Grid {
                id: idGridEffects
                visible: ( buttonEffects.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge - spacing
                rowSpacing: Theme.itemSizeExtraSmall * 0.8
                columns: itemsPerRowLess

                IconButton {
                    id: idIconButtonReColorize
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-repixel.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    icon.rotation: 180
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("PixelBench.qml"), {
                                           inputPathPy : decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") ),
                                           outputPathPy : tempImageFolderPath + origImageFileName + ".tmp" + (undoNr+1) + ".png",
                                           oldA_tmp : idSliderColorAlpha.value,
                                           oldR_tmp : idSliderColorRed.value,
                                           oldG_tmp : idSliderColorGreen.value,
                                           oldB_tmp : idSliderColorBlue.value,
                                       } ) }
                    Label {
                        id: idReColorizeLabel
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("pixel") + "\n" + qsTr("bench")
                    }
                }
                IconButton {
                    id: idIconButtonReChannel
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-levels"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("ChannelBench.qml"), {
                                           inputPathPy : decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") ),
                                           outputPathPy : tempImageFolderPath + origImageFileName + ".tmp" + (undoNr+1) + ".png",
                                       } ) }
                    Label {
                        id: idReChannelLabel
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("channel") + "\n" + qsTr("bench")
                    }
                }
                IconButton {
                    id: idIconButtonColorcurves
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-colorcurve.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("ColorcurveBench.qml"), {
                                           inputPathPy : decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") ),
                                           outputPathPy : tempImageFolderPath + origImageFileName + ".tmp" + (undoNr+1) + ".png",
                                           tempImageFolderPath : tempImageFolderPath,
                                           handleWidth : handleWidth,
                                           handleHeight : handleHeight,
                                           toolsDrawingColorFrame : toolsDrawingColorFrame,
                                           opacityEdges : opacityEdges,
                                           opticalDividersWidth : opticalDividersWidth
                                       } ) }
                    Label {
                        id: idColorcurvesLabel
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("color") + "\n" + qsTr("bench")
                    }
                }
                IconButton {
                    id: idIconButtonMoods
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-moods.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("MoodsBench.qml"), {
                                           inputPathPy : decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") ),
                                           outputPathPy : tempImageFolderPath + origImageFileName + ".tmp" + (undoNr+1) + ".png",
                                       } ) }
                    Label {
                        id: idMoodsLabel
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("color") + "\n" + qsTr("moods")
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.autocontrastFunction()
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("auto") + "\n" + qsTr("contrast")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.stretchContrastFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("stretch") // + "\n" + qsTr("contrast")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.blackWhiteFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("dither")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.coalFilterFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("coal")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.grayscaleFunction()
                    }
                    Label {
                        text: qsTr("gray")
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.invertFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("invert")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.equalizeFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("equalize")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.solarizeFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("solarize")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.modedrawingFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("drawing")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.posterizeFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("posterize")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.blurFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("blur")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.smoothSurfaceFunction()
                    }
                    Label {
                        id: idSmoothText
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("smooth") + "\n" + qsTr("surface")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.centerFocusFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("central") + "\n" + qsTr("focus")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.miniatureFocusFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("miniature") + "\n" + qsTr("world")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.edgeenhanceFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("enhance") + "\n" + qsTr("edges")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.unsharpmaskFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("depth") + "\n" + qsTr("of field")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.findedgesFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("edges")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.contourFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("contour")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.embossFunction()
                    }
                    Label {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("emboss")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.blurImageSidesFunctiom()
                    }
                    Label {
                        id: idTestFrameBlurOut
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("frame")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Rectangle {
                        anchors {
                            top: idTestFrameBlurOut.bottom
                            topMargin: Theme.paddingSmall*1.2
                            horizontalCenter: idTestFrameBlurOut.horizontalCenter
                        }
                        height: Theme.paddingSmall
                        width: Theme.iconSizeMedium
                        color: paintToolColor
                    }
                }
                IconButton {
                    id: idIconButtonTintColor
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        tintColor = paintToolColor
                        finishedLoading = false
                        py.tintWithColorFunction()
                    }
                    Label {
                        id: idTintColorLabel
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("tint")
                    }
                    Rectangle {
                        anchors {
                            top: idTintColorLabel.bottom
                            topMargin: Theme.paddingSmall
                            horizontalCenter: idTintColorLabel.horizontalCenter
                        }
                        height: Theme.paddingSmall
                        width: Theme.iconSizeMedium
                        color: paintToolColor
                    }
                }
                IconButton {
                    enabled: ( (idReduceColorEffect.text !== "") && idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.quantizeFunction()
                    }
                    Label {
                        id: idReduceColorEffectText
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("colors")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    TextField {
                        id: idReduceColorEffect
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width:  parent.width
                        anchors {
                            top: idReduceColorEffectText.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: idReduceColorEffectText.horizontalCenter
                        }
                        text: "256"
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 1; top: 256 }
                        EnterKey.onClicked: {
                            idReduceColorEffect.focus = false
                        }
                    }
                }
                IconButton {
                    enabled: ( (idAddAlphaEffect.text !== "") && idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.addAlphaFunction()
                    }
                    Label {
                        id: idAddAlphaEffectText
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("opacity")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    TextField {
                        id: idAddAlphaEffect
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width:  parent.width
                        anchors {
                            top: idAddAlphaEffectText.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: idAddAlphaEffectText.horizontalCenter
                        }
                        text: "100"
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pixelSize: Theme.fontSizeExtraSmall
                        validator: IntValidator { bottom: 0; top: 100 }
                        EnterKey.onClicked: {
                            idAddAlphaEffect.focus = false
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.colorToAlphaFunction()
                    }
                    Label {
                        id: idAlphaFromBEText
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("alpha") //α
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Label {
                        id: idAlphaFromBEchoice
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width:  parent.width
                        anchors {
                            top: idAlphaFromBEText.bottom
                            //topMargin: -Theme.paddingSmall
                            horizontalCenter: idAlphaFromBEText.horizontalCenter
                        }
                        text: qsTr("black")
                        opacity: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? 1 : 0.6
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: (idAlphaFromBEchoice.enabled === true) ? Theme.highlightColor : Theme.secondaryHighlightColor
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                alphaBWCounter = alphaBWCounter + 1
                                if (alphaBWCounter === 0) {
                                    idAlphaFromBEchoice.text = qsTr("black")
                                    targetColor2Alpha = "black"
                                }
                                if (alphaBWCounter === 1) {
                                    idAlphaFromBEchoice.text = qsTr("white")
                                    targetColor2Alpha = "white"
                                    alphaBWCounter = -1
                                }
                            }
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.extractColorFunction()
                    }
                    Label {
                        id: idAddSplitColorText
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("extract")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Label {
                        id: idAddSplitColorEffect
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width:  parent.width
                        anchors {
                            top: idAddSplitColorText.bottom
                            //topMargin: -Theme.paddingSmall
                            horizontalCenter: idAddSplitColorText.horizontalCenter
                        }
                        text: qsTr("red")
                        opacity: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? 1 : 0.6
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: (idAddSplitColorEffect.enabled === true) ? Theme.highlightColor : Theme.secondaryHighlightColor
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                extractColorCounter = extractColorCounter + 1
                                if (extractColorCounter === 0) {
                                    idAddSplitColorEffect.text = qsTr("red")
                                    colorExtractARGB = "R"
                                }
                                if (extractColorCounter === 1) {
                                    idAddSplitColorEffect.text = qsTr("green")
                                    colorExtractARGB = "G"
                                }
                                if (extractColorCounter === 2) {
                                    idAddSplitColorEffect.text = qsTr("blue")
                                    colorExtractARGB = "B"
                                    extractColorCounter = -1
                                }
                            }
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRowLess
                    height: Theme.itemSizeSmall
                    icon.source : "../symbols/icon-m-effect.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        finishedLoading = false
                        py.extractChannelFunction()
                    }
                    Label {
                        id: idAddSplitChannelText
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("channel")
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Label {
                        id: idAddSplitChannelEffect
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width:  parent.width
                        anchors {
                            top: idAddSplitChannelText.bottom
                            //topMargin: -Theme.paddingSmall
                            horizontalCenter: idAddSplitChannelText.horizontalCenter
                        }
                        text: qsTr("alpha")
                        opacity: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? 1 : 0.6
                        font.pixelSize: Theme.fontSizeExtraSmall
                        horizontalAlignment: Text.AlignHCenter
                        color: (idAddSplitChannelEffect.enabled === true) ? Theme.highlightColor : Theme.secondaryHighlightColor
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                extractChannelCounter = extractChannelCounter + 1
                                if (extractChannelCounter === 0) {
                                    idAddSplitChannelEffect.text = qsTr("alpha")
                                    channelExtractARGB = "A"
                                }
                                if (extractChannelCounter === 1) {
                                    idAddSplitChannelEffect.text = qsTr("red")
                                    channelExtractARGB = "R"
                                }
                                if (extractChannelCounter === 2) {
                                    idAddSplitChannelEffect.text = qsTr("green")
                                    channelExtractARGB = "G"
                                }
                                if (extractChannelCounter === 3) {
                                    idAddSplitChannelEffect.text = qsTr("blue")
                                    channelExtractARGB = "B"
                                    extractChannelCounter = -1
                                }
                            }
                        }
                    }
                }

            } // end tools effects


            Grid {
                id: idGridFile
                visible: ( buttonFile.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge - spacing
                rowSpacing: Theme.itemSizeExtraSmall * 0.8
                columns: itemsPerRow

                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && undoNr >= 1 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-backspace?"
                    onClicked: {
                        remorse.execute( qsTr("Restore original?"),  py.deleteAllTMPFunction )
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("restore")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && templock === -1 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-diagnostic?"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("MetadataPage.qml"), {
                                           origImageFileName : origImageFileName,
                                           origImageFolderPath : origImageFolderPath,
                                           tempImageFolderPath : tempImageFolderPath,
                                           imageWidthSave : idImageLoadedFreecrop.sourceSize.width,
                                           imageHeightSave : idImageLoadedFreecrop.sourceSize.height,
                                           inputPathPy : idImageLoadedFreecrop.source.toString()
                                       } ) }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("meta")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && templock === -1 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-font-size?"
                    onClicked: { pageStack.push(Qt.resolvedUrl("RenamePage.qml"), {
                        origImageFilePath : idLabelFilePath.text,
                        origImageFileName : origImageFileName,
                        origImageFolderPath : origImageFolderPath,
                        tempImageFolderPath : tempImageFolderPath,
                        imageWidthSave : idImageLoadedFreecrop.sourceSize.width,
                        imageHeightSave : idImageLoadedFreecrop.sourceSize.height,
                        inputPathPy : idImageLoadedFreecrop.source.toString()
                    } ) }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("rename")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && templock === -1 ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-delete?"
                    onClicked: remorse.execute( qsTr("Delete file?"),  py.deleteOriginalFunction )
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("delete")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( finishedLoading === true && warningNoPillow === false ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-add?"
                    onClicked: { pageStack.push(Qt.resolvedUrl("NewPage.qml"), {
                        tempImageFolderPath : tempImageFolderPath,
                        myColors : myColors,
                        maxScalePixels : maxScalePixels,
                        copyPasteImageWidth : copyPasteImageWidth,
                        copyPasteImageHeight : copyPasteImageHeight,
                    } ) }

                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("new")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    enabled: ( finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-about?"
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("about")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            } // end tools file


            Grid {
                id: idGridPaint
                visible: (buttonPaint.down === true) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2*Theme.paddingLarge
                rowSpacing: Theme.itemSizeExtraSmall * 0.5
                columns: itemsPerRow

                IconButton {
                    id: idPaintCanvasButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    down: true
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-freedraw.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        idPaintCanvasButton.down = true
                        idPaintPointButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("free")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintSolidButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-area.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        idPaintSolidButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("area")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintFrameButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-file-image?"
                    onClicked: {
                        idPaintFrameButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("frame")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintSprayButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-spray.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        idPaintSprayButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false                        
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("spray")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintCopyButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-up?"
                    onClicked: {
                        idPaintCopyButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("copy")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintPasteButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && copyPastePath !== "") ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-down?"
                    onDownChanged: {
                        croppingRatio = 0 //before onClicked signal, to make sure whenever this button is not down, it resets the handles ratio to "free"
                    }
                    onClicked: {
                        idPaintPasteButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                        croppingRatio = copyPasteRegionRatioHW
                        setCropmarkersPaste() //including Patch: resetting cropmarkers when pasting from big image on smaller one
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("paste")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintLineButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-line.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        idPaintLineButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("line")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintPointButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-point.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        idPaintPointButton.down = true
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("point")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintShapesButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-symbols.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {
                        idPaintShapesButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("symbol")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintTextButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "image://theme/icon-m-font-size?" // annotation
                    onClicked: {
                        idPaintTextButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                        idPaintColorPickerButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("label")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
                IconButton {
                    id: idPaintColorPickerButton
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: "../symbols/icon-m-colorpicker.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    onClicked: {                        
                        idPaintColorPickerButton.down = true
                        idPaintPointButton.down = false
                        idPaintCanvasButton.down = false
                        idPaintSolidButton.down = false
                        idPaintFrameButton.down = false
                        idPaintLineButton.down = false
                        idPaintTextButton.down = false
                        idPaintCopyButton.down = false
                        idPaintPasteButton.down = false
                        idPaintSprayButton.down = false
                        idPaintShapesButton.down = false
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("color")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }

                }
                IconButton {
                    id: idPaintColorPickerButtonPresets
                    enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                    width: parent.width / itemsPerRow
                    height: Theme.itemSizeSmall
                    icon.source: (paintToolColor === "#00000000") ? "../symbols/icon-m-color-alpha.svg" : "../symbols/icon-m-color.svg"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    icon.color: (paintToolColor === "#00000000") ? "white" : paintToolColor
                    onClicked: {
                        var page = pageStack.push("Sailfish.Silica.ColorPickerPage", { "colors" : myColors})
                        page.colorClicked.connect(function(color) {
                            paintToolColor = color.toString().replace("#", "#ff")
                            idColorPaintManualInput.text = paintToolColor
                            pageStack.pop()
                            hexToRGBA(paintToolColor)
                        })
                    }
                    Label {
                        horizontalAlignment: Text.AlignHCenter
                        text: ( idPaintShapesButton.down ) ? qsTr("100%") : Math.round( idSliderColorAlpha.value/255*100) + "%"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        anchors {
                            top: parent.bottom
                            topMargin: -Theme.paddingSmall
                            horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            } // end tools paint
            Rectangle {
                visible: (buttonPaint.down === true ) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge
                height: Theme.paddingMedium //1
                color: "transparent"
            }


            Grid {
                id: idGridSubmodulPaint
                visible: (buttonPaint.down === true ) ? true : false
                x: Theme.paddingLarge
                width: parent.width - 2* Theme.paddingLarge
                columns: 2
                Row {
                    width: parent.width / itemsPerRowLess * (itemsPerRowLess-1)
                    Grid {
                        id: idRowCanvasFreedraw
                        width: parent.width
                        visible: ( idPaintCanvasButton.down ) ? true : false
                        columns: 2

                        IconButton {
                            id: idClearCanvasButton
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true && freeDrawPolyCoordinates !== "" ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                            icon.source: "image://theme/icon-m-clear?"
                            onClicked: {
                                freeDrawPolyCoordinates = ""
                                freeDrawCanvas.clear_canvas()
                                freeDrawLock = false
                            }
                        }
                        ComboBox {
                            id: idComboBoxCanvasDraw
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            menu: ContextMenu {
                                MenuItem {
                                    text: qsTr("line")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                MenuItem {
                                    text: qsTr("fill")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                MenuItem {
                                    text: qsTr("keep")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                MenuItem {
                                    text: qsTr("remove")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                /*
                                MenuItem {
                                    text: qsTr("save")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                */
                            }
                        }
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idCanvasThicknessSlider
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            visible: (idComboBoxCanvasDraw.currentIndex === 0) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 3
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("size") + " " + idCanvasThicknessSlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                    Row {
                        id: idRowSolidTool
                        width: parent.width
                        visible: ( idPaintSolidButton.down ) ? true : false
                        IconButton {
                            id: idSolidArea
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            icon.source: "image://theme/icon-m-tabs?"
                            onClicked: {
                                solidPickerCounter = solidPickerCounter + 1
                                if (solidPickerCounter === 0) {
                                    idSolidArea.icon.source = "image://theme/icon-m-tabs?"
                                    idSolidArea.icon.scale = 1
                                    solidTypeTool = "rectangle"
                                }
                                if (solidPickerCounter === 1) {
                                    idSolidArea.icon.source = "../symbols/icon-m-circle.svg"
                                    idSolidArea.icon.scale = 0.9
                                    solidTypeTool = "circle"
                                }
                                if (solidPickerCounter === 2) {
                                    idSolidArea.icon.source = "../symbols/icon-m-blur.svg"
                                    idSolidArea.icon.scale = 1
                                    solidTypeTool = "blur"
                                    solidPickerCounter = -1
                                }
                            }
                        }
                        Slider {
                            id: idBlurIntensitySlider
                            visible: ( solidTypeTool === "blur" ) ? true : false
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 1
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("blur") + " " + idBlurIntensitySlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                        ComboBox {
                            id: idComboBoxCutShape
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            visible: ( solidTypeTool !== "blur" ) ? true : false
                            width: parent.width / itemsPerRow * (itemsPerRow-2)
                            menu: ContextMenu {
                                MenuItem {
                                    text: qsTr("fill")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                MenuItem {
                                    text: qsTr("keep")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                                MenuItem {
                                    text: qsTr("remove")
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                }
                            }
                        }
                    }
                    Row {
                        id: idRowFrameTool
                        width: parent.width
                        visible: ( idPaintFrameButton.down ) ? true : false
                        IconButton {
                            id: idFrameArea
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            icon.source: "image://theme/icon-m-tabs?"
                            onClicked: {
                                framePickerCounter = framePickerCounter + 1
                                if (framePickerCounter === 0) {
                                    idFrameArea.icon.source = "image://theme/icon-m-tabs?"
                                    idFrameArea.icon.scale = 1
                                    frameTypeTool = "rectangle"
                                }
                                if (framePickerCounter === 1) {
                                    idFrameArea.icon.source = "../symbols/icon-m-circle.svg"
                                    idFrameArea.icon.scale = 0.9
                                    frameTypeTool = "circle"
                                    framePickerCounter = -1
                                }
                            }
                        }
                        Slider {
                            id: idFrameThicknessSlider
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 1
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("size") + " " + idFrameThicknessSlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                    Grid {
                        id: idRowSprayTool
                        width: parent.width
                        visible: ( idPaintSprayButton.down ) ? true : false
                        columns: 2
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idSprayThicknessSlider
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 1
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("size") + " " + idSprayThicknessSlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idSliderSprayAmount
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            visible: ( idPaintSprayButton.down ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 10
                            maximumValue: 1000
                            value: 200
                            stepSize: 10
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("dots") + " " + idSliderSprayAmount.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                    Row {
                        id: idRowSymbolTool
                        width: parent.width
                        visible: ( idPaintShapesButton.down ) ? true : false
                        IconButton {
                            id: idComboBoxPaintSymbolPicker
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                            icon.source: "image://theme/icon-m-favorite-selected"
                            onClicked: {
                                symbolPickerCounter = symbolPickerCounter + 1
                                if (symbolPickerCounter === 0) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-favorite-selected"
                                }
                                if (symbolPickerCounter === 1) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-favorite"
                                }
                                if (symbolPickerCounter === 2) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-asterisk"
                                }
                                if (symbolPickerCounter === 3) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-add"
                                }
                                if (symbolPickerCounter === 4) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-clear"
                                }
                                if (symbolPickerCounter === 5) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-up"
                                }
                                if (symbolPickerCounter === 6) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-down"
                                }
                                if (symbolPickerCounter === 7) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-left"
                                }
                                if (symbolPickerCounter === 8) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-right"
                                }
                                if (symbolPickerCounter === 9) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-accept"
                                }
                                if (symbolPickerCounter === 10) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-cancel"
                                }
                                if (symbolPickerCounter === 11) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-home"
                                }
                                if (symbolPickerCounter === 12) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-location"
                                }
                                if (symbolPickerCounter === 13) {
                                    idComboBoxPaintSymbolPicker.icon.source = "image://theme/icon-m-people"
                                    symbolPickerCounter = -1
                                }
                            }
                        }
                        Slider {
                            id: idShapeThicknessSlider
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 1
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("size") + " " + idShapeThicknessSlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                    Row {
                        id: idRowPointTool
                        width: parent.width
                        visible: ( idPaintPointButton.down ) ? true : false
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idPointThicknessSlider
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 1
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("size") + " " + idPointThicknessSlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                    Row {
                        id: idRowLineTool
                        width: parent.width
                        visible: ( idPaintLineButton.down ) ? true : false
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idLineThicknessSlider
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall
                            minimumValue: 1
                            maximumValue: 6
                            value: 1
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("size") + " " + idLineThicknessSlider.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                    Grid {
                        id: idRowTextTool
                        width: parent.width
                        visible: ( idPaintTextButton.down ) ? true : false
                        columns: 2
                        Column {
                            spacing: Theme.paddingSmall
                            width: parent.width / (itemsPerRowLess-1)
                            IconButton {
                                id: idTextDirection
                                enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                                width: parent.width
                                height: Theme.itemSizeSmall
                                icon.width: Theme.iconSizeMedium
                                icon.height: Theme.iconSizeMedium
                                icon.source: "../symbols/icon-m-circle.svg"
                                icon.scale: 0.9
                                icon.opacity: 0.6
                                onClicked: {
                                    textDirectionPickerCounter = textDirectionPickerCounter + 1
                                    if (textDirectionPickerCounter === 0) {
                                        paintTextDirection = "left"
                                        idTextDirectionLabel.text = "L.."
                                    }
                                    if (textDirectionPickerCounter === 1) {
                                        paintTextDirection = "center"
                                        idTextDirectionLabel.text = "C"
                                    }
                                    if (textDirectionPickerCounter === 2) {
                                        paintTextDirection = "right"
                                        idTextDirectionLabel.text = "..R"
                                        textDirectionPickerCounter = -1
                                    }
                                }
                                Label {
                                    id: idTextDirectionLabel
                                    anchors.centerIn: parent
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                    text: "L.."
                                }
                            }
                            Item {
                                enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                                visible: ( idPaintTextButton.down ) ? true : false
                                width: parent.width
                                height: Theme.itemSizeSmall * 1.1
                                TextField {
                                    id: idInputAngleManual
                                    width: parent.width
                                    height: parent.height
                                    text: "0"
                                    anchors.top: parent.top
                                    anchors.topMargin: Theme.paddingMedium * 1.4 // 1.5
                                    horizontalAlignment: Text.AlignHCenter
                                    color: Theme.highlightColor
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    font.pixelSize: Theme.fontSizeSmall
                                    validator: IntValidator { bottom: -90; top: 90 }
                                    EnterKey.onClicked: {
                                        idInputAngleManual.focus = false
                                        if (idInputAngleManual.text === "") {
                                            idInputAngleManual.text = "0"
                                        }
                                    }
                                    Label {
                                        //text: qsTr("α")
                                        text: qsTr("°")
                                        color: Theme.highlightColor
                                        font.pixelSize: Theme.fontSizeExtraSmall
                                        anchors {
                                            left: parent.right
                                            leftMargin: -Theme.paddingMedium
                                            verticalCenter: parent.verticalCenter
                                            verticalCenterOffset: -Theme.paddingSmall * 0.4
                                        }
                                    }
                                }
                            }
                        }
                        Column {
                            spacing: Theme.paddingSmall
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            Slider {
                                id: idTextThicknessSlider
                                enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                                width: parent.width
                                height: Theme.itemSizeSmall
                                minimumValue: 1
                                maximumValue: 6
                                value: 1
                                stepSize: 1
                                leftMargin: Theme.paddingLarge
                                rightMargin: Theme.paddingLarge
                                Label {
                                    text: qsTr("size") + " " + idTextThicknessSlider.value
                                    font.pixelSize: Theme.fontSizeExtraSmall
                                    anchors {
                                        bottom: parent.bottom
                                        bottomMargin: -Theme.paddingSmall
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                            Row {
                                enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                                width: parent.width
                                ComboBox {
                                    id: idComboBoxFontPicker
                                    width: parent.width
                                    menu: ContextMenu {
                                        MenuItem {
                                            text: qsTr("Sailfish font")
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 0
                                                paintTextNameNr = 0
                                            }
                                        }
                                        MenuItem {
                                            text: ( customFontName ==="" ) ? qsTr("load custom font") : ( customFontName + " " + qsTr("(custom)"))
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 0
                                                paintTextNameNr = 1
                                                idDelayTimer.running = true
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Sans normal")
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 0
                                                paintTextNameNr = 2
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Sans bold")
                                            font.bold : true
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 1
                                                paintTextNameNr = 2
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Sans italic")
                                            font.italic : true
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 2
                                                paintTextNameNr = 2
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Serif normal")
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 0
                                                paintTextNameNr = 3
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Serif bold")
                                            font.bold : true
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 1
                                                paintTextNameNr = 3
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Serif italic")
                                            font.italic : true
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 2
                                                paintTextNameNr = 3
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Mono normal")
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 0
                                                paintTextNameNr = 4
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Mono bold")
                                            font.bold : true
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 1
                                                paintTextNameNr = 4
                                            }
                                        }
                                        MenuItem {
                                            text: qsTr("Mono italic")
                                            font.italic : true
                                            font.pixelSize: Theme.fontSizeExtraSmall
                                            onClicked: {
                                                paintTextStyleNr = 2
                                                paintTextNameNr = 4
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Grid {
                        id: idColorTool
                        width: parent.width
                        visible: ( idPaintColorPickerButton.down ) ? true : false
                        columns: 2
                        IconButton {
                            id: idDominantColor
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            icon.source: "../symbols/icon-m-colorpicker2.svg"
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            onClicked: {
                                finishedLoading = false
                                py.getDominantColorFunction()
                            }
                            Label {
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("average")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    top: parent.bottom
                                    topMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                        Slider {
                            id: idSliderColorAlpha
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            //height: Theme.itemSizeSmall * 1.1
                            minimumValue: 0
                            maximumValue: 255
                            value: 255
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("visibility") + " " + Math.round( idSliderColorAlpha.value/255*100) + "%" // + " (" + idSliderColorAlpha.value + ")"
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                            onReleased: {
                                py.paintConvertRGBAFunction()
                            }
                        }
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idSliderColorRed
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall * 1.1
                            minimumValue: 0
                            maximumValue: 255
                            value: 0
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("red") + " " + idSliderColorRed.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                            onReleased: {
                                py.paintConvertRGBAFunction()
                            }
                        }
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idSliderColorGreen
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall * 1.1
                            minimumValue: 0
                            maximumValue: 255
                            value: 0
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("green") + " " + idSliderColorGreen.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                            onReleased: {
                                py.paintConvertRGBAFunction()
                            }
                        }
                        Item {
                            width: parent.width / itemsPerRow
                            height: Theme.itemSizeSmall
                        }
                        Slider {
                            id: idSliderColorBlue
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.itemSizeSmall * 1.1
                            minimumValue: 0
                            maximumValue: 255
                            value: 0
                            stepSize: 1
                            leftMargin: Theme.paddingLarge
                            rightMargin: Theme.paddingLarge
                            Label {
                                text: qsTr("blue") + " " + idSliderColorBlue.value
                                font.pixelSize: Theme.fontSizeExtraSmall
                                anchors {
                                    bottom: parent.bottom
                                    bottomMargin: -Theme.paddingSmall
                                    horizontalCenter: parent.horizontalCenter
                                }
                            }
                            onReleased: {
                                py.paintConvertRGBAFunction()
                            }
                        }
                        Item {
                            enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                            width: parent.width / (itemsPerRowLess-1)
                            height: Theme.itemSizeSmall
                        }
                        Item {
                            width: parent.width / (itemsPerRowLess-1) * (itemsPerRowLess-2)
                            height: Theme.iconSizeLarge //paddingLarge * 3.25
                            visible: ( idPaintColorPickerButton.down ) ? true : false
                            TextField {
                                id: idColorPaintManualInput
                                anchors.bottom: parent.bottom
                                width: parent.width
                                color: Theme.highlightColor
                                labelVisible: false
                                text: paintToolColor
                                font.pixelSize: Theme.fontSizeExtraSmall
                                horizontalAlignment: Text.AlignHCenter
                                validator: RegExpValidator { regExp: /[a-f0-9#]*$/ }
                                onClicked: {
                                    oldColorPaintManualInput = idColorPaintManualInput.text
                                }
                                EnterKey.onClicked: {
                                    if ( ((idColorPaintManualInput.text).length === 7 || (idColorPaintManualInput.text).length === 9)  && (idColorPaintManualInput.text)[0] === "#" ) {
                                        if ((idColorPaintManualInput.text).length === 7 ) {
                                            idColorPaintManualInput.text = (idColorPaintManualInput.text).toString().replace("#", "#ff")
                                        }
                                        paintToolColor = idColorPaintManualInput.text
                                    }
                                    else {
                                        idColorPaintManualInput.text = oldColorPaintManualInput
                                        paintToolColor = "#ffffffff" //oldColorPaintManualInput
                                    }
                                    hexToRGBA(paintToolColor)
                                    idColorPaintManualInput.focus = false
                                }
                            }

                        }
                    }
                    Item {
                        id: idCopyPasteSpacer
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        visible: ( idPaintCopyButton.down || idPaintPasteButton.down ) ? true : false
                        width: parent.width
                        height: Theme.itemSizeSmall
                    }
                }
                IconButton {
                        id: idButtonPaintIt
                        enabled: ( idImageLoadedFreecrop.status !== Image.Null && finishedLoading === true ) ? true : false
                        width: parent.width / itemsPerRowLess
                        icon.source: ( idPaintColorPickerButton.down ) ? "../symbols/icon-m-colorpicker2.svg" : "../symbols/icon-m-apply.svg"
                        icon.width: Theme.iconSizeMedium
                        icon.height: Theme.iconSizeMedium
                        onClicked: {
                            finishedLoading = false
                            if (idPaintCanvasButton.down === true && idComboBoxCanvasDraw.currentIndex === 0 ) {
                                drawType = "polyline"
                                py.paintCanvasFunction()
                            }
                            if (idPaintCanvasButton.down === true && idComboBoxCanvasDraw.currentIndex === 1) {
                                cutFillColor = paintToolColor
                                actionCutSelection = "remove"
                                drawType = "fill"
                                py.paintCanvasFunction()
                            }
                            if (idPaintCanvasButton.down === true && idComboBoxCanvasDraw.currentIndex === 2) {
                                cutFillColor = "#00000000"
                                actionCutSelection = "keep"
                                py.cropCanvasPolygonFunction()
                            }
                            if (idPaintCanvasButton.down === true && idComboBoxCanvasDraw.currentIndex === 3) {
                                cutFillColor = "#00000000"
                                actionCutSelection = "remove"
                                py.cropCanvasPolygonFunction()
                            }
                            /*
                            if (idPaintCanvasButton.down === true && idComboBoxCanvasDraw.currentIndex === 4) {
                                console.log("ToDo")
                            }
                            */
                            if (idPaintCopyButton.down === true) {
                                copyPasteRegionRatioHW = (frameRectangleCroppingzone.width) / (frameRectangleCroppingzone.height)
                                copyPasteOldCopyZoneDisplayHeight = idImageLoadedFreecrop.height
                                copyPasteOldCopyZoneDisplayWidth = idImageLoadedFreecrop.width
                                copyPasteOldCopyZoneSourceWidth = idImageLoadedFreecrop.sourceSize.width
                                copyPasteX1 = rectDrag1.x
                                copyPasteY1 = rectDrag1.y
                                copyPasteX2 = rectDrag2.x
                                copyPasteY2 = rectDrag2.y
                                py.paintCopyFunction()
                            }
                            if (idPaintPasteButton.down === true) {
                                py.paintPasteFunction()
                            }
                            if (idPaintPointButton.down === true) {
                                py.paintPointRegion()
                            }
                            if ( idPaintSolidButton.down === true && solidTypeTool === "blur" ) {
                                py.paintBlurRegion()
                            }
                            if ( idPaintSolidButton.down === true && (solidTypeTool === "rectangle" || solidTypeTool === "circle")  ) {
                                if (idComboBoxCutShape.currentIndex === 0 ) { py.paintRectangleRegion() }
                                if (idComboBoxCutShape.currentIndex === 1 ) {
                                    actionCutSelection = "keep"
                                    py.cropCanvasShapeFunction()
                                }
                                if (idComboBoxCutShape.currentIndex === 2 ) {
                                    actionCutSelection = "remove"
                                    py.cropCanvasShapeFunction()
                                }
                            }
                            if (idPaintFrameButton.down === true) {
                                py.paintFrameRegion()
                            }
                            if (idPaintLineButton.down === true) {
                                py.paintLineRegion()
                            }
                            if (idPaintTextButton.down === true) {
                                py.paintTextRegion()
                            }
                            if (idPaintSprayButton.down === true) {
                                py.paintSprayFunction()
                            }
                            if (idPaintShapesButton.down === true) {
                                py.paintSymbolRegion()
                            }
                            if (idPaintColorPickerButton.down === true) {
                                py.paintPickColorFunction()
                            }
                        }
                        Label {
                            //visible: ( parents.visible ) ? true : false
                            horizontalAlignment: Text.AlignHCenter
                            text: ( idPaintColorPickerButton.down ) ?  qsTr("cursor") : ""
                            font.pixelSize: Theme.fontSizeExtraSmall
                            anchors {
                                top: parent.bottom
                                topMargin: -Theme.paddingSmall
                                horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
            } // end submodul paint


            TextField {
                id: idTextPaintInput
                x: Theme.paddingLarge
                width: parent.width  - 2* Theme.paddingLarge
                height: Theme.iconSizeLarge
                visible: ( buttonPaint.down && idPaintTextButton.down ) ? true : false
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                EnterKey.onClicked: {
                    idTextPaintInput.focus = false
                }
            }


            Rectangle {
                // necessary for effects bottom
                width: parent.width
                height: Theme.itemSizeMedium
                color: "transparent"
            }

        } // end Column
    } // end SilicaFlickable



    Item {
        id: idZoomItem
        visible: ( zoomWindowVisible === true && (dragArea1.pressed || dragArea2.pressed || dragPerspective1.pressed || dragPerspective2.pressed || dragPerspective3.pressed || dragPerspective4.pressed || mouseCanvasArea.pressed) ) ? true : false
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingMedium
        width: page.width/4
        height: page.width/4
        z: 5
        clip: true
        function reanchorToRight() {
            anchors.leftMargin = undefined
            anchors.rightMargin = Theme.paddingSmall
            anchors.left = undefined
            anchors.right = parent.right
        }
        function reanchorToLeft() {
            anchors.rightMargin = undefined
            anchors.leftMargin = Theme.paddingSmall
            anchors.right = undefined
            anchors.left = parent.left
        }
        Rectangle {
            anchors.fill: parent
            color: "black"
        }
        Image {
            id: idZoomImagePart
            x: 0
            y: 0
            cache: false
            source: idImageLoadedFreecrop.source
            fillMode: Image.PreserveAspectFit
            scale: 1
        }
        Rectangle {
            id: idZoomImageFrame
            anchors.fill: parent
            color: "transparent"
            border.color: Theme.highlightColor
            border.width: Theme.paddingSmall/2
        }
        Rectangle {
            id: grayVerticalDeviderZoom
            x: parent.width/2
            y: 0
            width: opticalDividersWidth
            height: parent.height
            color: Theme.highlightColor
            opacity: opacityCut
        }
        Rectangle {
            id: grayHorizontalDeviderZoom
            x: 0
            y: parent.height/2
            width: parent.width
            height: opticalDividersWidth
            color: Theme.highlightColor
            opacity: opacityCut
        }
    }



    //*************************************** Important Functions ***************************************//

    function presetCroppingFree () {
        handleWidth = 2 * Theme.paddingLarge
        handleHeight = 2 * Theme.paddingLarge
        idComboBoxCrop.currentIndex = 0
        croppingRatio = 0
        setCropmarkersFullImage()
        setTransformationMarkersFullImage()
    }

    function setCropmarkersFullImage() {
        idItemCropzoneHandles.width = idImageLoadedFreecrop.width
        idItemCropzoneHandles.height = idImageLoadedFreecrop.width
        if (stretchOversizeActive === true && (buttonCrop.down === true && pickerTransformOrCropIndex !== 0)) {
            rectDrag1.x = parent.x - handleWidth/2
            rectDrag1.y = parent.y - handleHeight/2
            rectDrag2.x = idItemCropzoneHandles.width - handleWidth/2
            rectDrag2.y = idItemCropzoneHandles.height - handleHeight/2
        }
        else {
            rectDrag1.x = parent.x //0
            rectDrag1.y = parent.y //0
            rectDrag2.x = idItemCropzoneHandles.width - handleWidth
            rectDrag2.y = idItemCropzoneHandles.height - handleHeight
        }
    }

    function setTransformationMarkersFullImage() {
        idItemCropzoneHandles.width = idImageLoadedFreecrop.width
        idItemCropzoneHandles.height = idImageLoadedFreecrop.width
        if (stretchOversizeActive === true) {
            rectPerspective1.x = parent.x - handleWidth/2
            rectPerspective1.y = parent.y - handleHeight/2
            rectPerspective2.x = idItemCropzoneHandles.width - handleWidth/2
            rectPerspective2.y = parent.y - handleHeight/2
            rectPerspective3.x = idItemCropzoneHandles.width - handleWidth/2
            rectPerspective3.y = idItemCropzoneHandles.height - handleHeight/2
            rectPerspective4.x = parent.x - handleWidth/2
            rectPerspective4.y = idItemCropzoneHandles.height - handleHeight/2
        }
        else {
            rectPerspective1.x = parent.x
            rectPerspective1.y = parent.y
            rectPerspective2.x = idItemCropzoneHandles.width - handleWidth
            rectPerspective2.y = parent.y
            rectPerspective3.x = idItemCropzoneHandles.width - handleWidth
            rectPerspective3.y = idItemCropzoneHandles.height - handleHeight
            rectPerspective4.x = parent.x
            rectPerspective4.y = idItemCropzoneHandles.height - handleHeight
        }
    }

    function setCropmarkersCoordinates() {
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else {
            scaleDisplayFactorCrop = 1
        }
        var coordX1 = parseInt(idInputManualX1.text)
        var coordY1 = parseInt(idInputManualY1.text)
        var coordX2 = parseInt(idInputManualX2.text)
        var coordY2 = parseInt(idInputManualY2.text)

        // Patch
        if (coordX1 < coordX2) {
            rectDrag1.x = (coordX1 / scaleDisplayFactorCrop)
            rectDrag2.x = (coordX2 / scaleDisplayFactorCrop) // - handleWidth
        }
        else {
            rectDrag1.x = (coordX1 / scaleDisplayFactorCrop) // - handleWidth
            rectDrag2.x = (coordX2 / scaleDisplayFactorCrop)
        }

        if (coordY1 < coordY2) {
            rectDrag1.y = coordY1 / scaleDisplayFactorCrop
            rectDrag2.y = (coordY2 / scaleDisplayFactorCrop) // - handleHeight
        }
        else {
            rectDrag1.y = (coordY1 / scaleDisplayFactorCrop) // - handleHeight
            rectDrag2.y = (coordY2 / scaleDisplayFactorCrop)
        }

    }

    function setCropmarkersRatio() {
        rectDrag1.x = 0
        rectDrag1.y = 0
        idItemCropzoneHandles.width = parent.width
        idItemCropzoneHandles.height = parent.height

        // check how the cropping zone in the image, to define which value touches the border first: x or y?
        if ( croppingRatio <= (idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.sourceSize.height) ) {
            rectDrag2.y = idItemCropzoneHandles.height - handleHeight
            // Patch: takes into account handle disposition
            var correctionFactorY = handleWidth - (handleHeight * croppingRatio)
            rectDrag2.x = rectDrag2.y * croppingRatio - correctionFactorY
        }
        else {
            rectDrag2.x = idItemCropzoneHandles.width - handleWidth
            // Patch: takes into account handle disposition
            var correctionFactorX = handleHeight - (handleWidth / croppingRatio)
            rectDrag2.y = rectDrag2.x / croppingRatio - correctionFactorX
        }

        // place cropping zone in vertical center
        var diffMarkerRatiosY = (idItemCropzoneHandles.height - (rectDrag2.y + rectDrag2.height))
        if ((rectDrag2.y + diffMarkerRatiosY/2) <= idItemCropzoneHandles.height) {
            rectDrag1.y = rectDrag1.y + diffMarkerRatiosY/2
            rectDrag2.y = rectDrag2.y + diffMarkerRatiosY/2
        }
        else {
            rectDrag1.x = 0
            rectDrag1.y = 0
            rectDrag2.y = idItemCropzoneHandles.height - handleHeight
            rectDrag2.x = rectDrag2.y * croppingRatio
            var diffMarkerRatiosX2 = (idItemCropzoneHandles.width - (rectDrag2.x + rectDrag2.width))
            rectDrag1.x = rectDrag1.x + diffMarkerRatiosX2/2
            rectDrag2.x = rectDrag2.x + diffMarkerRatiosX2/2
        }

        // place cropping zone in horizontal center
        var diffMarkerRatiosX = (idItemCropzoneHandles.width - (rectDrag2.x + rectDrag2.width))
        if ((rectDrag1.x + diffMarkerRatiosX/2) >= 0) {
            rectDrag1.x = rectDrag1.x + diffMarkerRatiosX/2
            rectDrag2.x = rectDrag2.x + diffMarkerRatiosX/2
        }
        else {
            rectDrag1.x = 0
            rectDrag1.y = 0
            rectDrag2.x = idItemCropzoneHandles.width - handleWidth
            rectDrag2.y = rectDrag2.x / croppingRatio
            var diffMarkerRatiosY1 = (idItemCropzoneHandles.height - (rectDrag2.y + rectDrag2.height))
            rectDrag1.y = rectDrag1.y + diffMarkerRatiosY1/2
            rectDrag2.y = rectDrag2.y + diffMarkerRatiosY1/2
        }

    }

    function setCropmarkersPaste() {
        // if new image has same dimensions as the one in clipboard... fill it completely with clipboard
        if ((idImageLoadedFreecrop.sourceSize.width === copyPasteImageWidth) && (idImageLoadedFreecrop.sourceSize.height === copyPasteImageHeight)) {
            rectDrag1.x = parent.x //0
            rectDrag1.y = parent.y //0
            idItemCropzoneHandles.width = parent.width
            idItemCropzoneHandles.height = parent.height
            rectDrag2.y = idItemCropzoneHandles.height - handleHeight
            rectDrag2.x = idItemCropzoneHandles.width - handleWidth
        }

        // if new clipboard would still fit into the new image ... paste it directly on the old positions
        else if ( (idImageLoadedFreecrop.width >= copyPasteOldCopyZoneDisplayWidth ) && (idImageLoadedFreecrop.height >= copyPasteOldCopyZoneDisplayHeight) ) {
            rectDrag1.x = copyPasteX1
            rectDrag1.y = copyPasteY1
            rectDrag2.x = copyPasteX2
            rectDrag2.y = copyPasteY2
        }

        // but if it would not fit in, it has to be resized
        else {
            rectDrag1.x = parent.x //0
            rectDrag1.y = parent.y //0
            idItemCropzoneHandles.width = parent.width
            idItemCropzoneHandles.height = parent.height

            // if paste-onto-image wider than high
            if ((copyPasteImageWidth / copyPasteImageHeight) <= (idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.sourceSize.height) ) {
                rectDrag2.y = idItemCropzoneHandles.height - handleHeight
                // Patch: takes into account handle disposition
                var correctionFactorY = handleWidth - (handleHeight * croppingRatio)
                rectDrag2.x = rectDrag2.y * croppingRatio - correctionFactorY
                }
            else {
                rectDrag2.x = idItemCropzoneHandles.width - handleWidth
                // Patch: takes into account handle disposition
                var correctionFactorX = handleHeight - (handleWidth / croppingRatio)
                rectDrag2.y = rectDrag2.x / croppingRatio - correctionFactorX
            }

            // place paste zone in vertical center
            var diffMarkerRatiosY = (idItemCropzoneHandles.height - (rectDrag2.y + rectDrag2.height))
            if ((rectDrag2.y + diffMarkerRatiosY/2) <= idItemCropzoneHandles.height) {
                rectDrag1.y = rectDrag1.y + diffMarkerRatiosY/2
                rectDrag2.y = rectDrag2.y + diffMarkerRatiosY/2
            }
            else {
                rectDrag1.x = 0
                rectDrag1.y = 0
                rectDrag2.y = idItemCropzoneHandles.height - handleHeight
                rectDrag2.x = rectDrag2.y * croppingRatio
                var diffMarkerRatiosX2 = (idItemCropzoneHandles.width - (rectDrag2.x + rectDrag2.width))
                rectDrag1.x = rectDrag1.x + diffMarkerRatiosX2/2
                rectDrag2.x = rectDrag2.x + diffMarkerRatiosX2/2
            }

            // place paste zone in horizontal center
            var diffMarkerRatiosX = (idItemCropzoneHandles.width - (rectDrag2.x + rectDrag2.width))
            if ((rectDrag1.x + diffMarkerRatiosX/2) >= 0) {
                rectDrag1.x = rectDrag1.x + diffMarkerRatiosX/2
                rectDrag2.x = rectDrag2.x + diffMarkerRatiosX/2
            }
            else {
                rectDrag1.x = 0
                rectDrag1.y = 0
                rectDrag2.x = idItemCropzoneHandles.width - handleWidth
                rectDrag2.y = rectDrag2.x / croppingRatio
                var diffMarkerRatiosY1 = (idItemCropzoneHandles.height - (rectDrag2.y + rectDrag2.height))
                rectDrag1.y = rectDrag1.y + diffMarkerRatiosY1/2
                rectDrag2.y = rectDrag2.y + diffMarkerRatiosY1/2
            }

        }
    }

    function generateCroppingPixelsFromHandles() {
        rectX = Math.min(rectDrag1.x, rectDrag2.x)
        rectY = Math.min(rectDrag1.y, rectDrag2.y)
        rectWidth = Math.max(rectDrag1.x+rectDrag1.width, rectDrag2.x+rectDrag2.width) - Math.min(rectDrag1.x, rectDrag2.x)
        rectHeight = Math.max(rectDrag1.y+rectDrag1.height, rectDrag2.y+rectDrag2.height) - Math.min(rectDrag1.y, rectDrag2.y)
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else {
            scaleDisplayFactorCrop = 1
        }
    }

    function generateCroppingPixelsFromCoordinates() {
        rectX =     Math.min( parseInt(idInputManualX1.text), parseInt(idInputManualX2.text) )
        rectY =     Math.min( parseInt(idInputManualY1.text), parseInt(idInputManualY2.text) )
        rectWidth = Math.max( parseInt(idInputManualX1.text), parseInt(idInputManualX2.text) ) - Math.min( parseInt(idInputManualX1.text), parseInt(idInputManualX2.text) )
        rectHeight =Math.max( parseInt(idInputManualY1.text), parseInt(idInputManualY2.text) ) - Math.min( parseInt(idInputManualY1.text), parseInt(idInputManualY2.text) )
    }

    function generateCoordinatesColorPicker() {
        inputPathPy = decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") )
        rectX = rectDrag1.x + handleWidth/2
        rectY = rectDrag1.y + handleHeight/2
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else {
            scaleDisplayFactorCrop = 1
        }
    }

    function calculateZoomImagePart(activeHandleName) {
        if (activeHandleName !== mouseCanvasArea) {
            if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
                if (activeHandleName.x >= (idImageLoadedFreecrop.width/2 - handleWidth/2 + zoomItemCenterTolerance/2) ) {
                    idZoomItem.reanchorToLeft()
                }
                else if (activeHandleName.x <= (idImageLoadedFreecrop.width/2 - handleWidth/2 - zoomItemCenterTolerance/2) ) {
                    idZoomItem.reanchorToRight()
                }
                scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
            }
            else {
                if (activeHandleName.x >= (idImageLoadedFreecrop.sourceSize.width/2 - handleWidth/2) + zoomItemCenterTolerance/2 ) {
                    idZoomItem.reanchorToLeft()
                }
                else if (activeHandleName.x <= (idImageLoadedFreecrop.sourceSize.width/2 - handleWidth/2) - zoomItemCenterTolerance/2 ) {
                    idZoomItem.reanchorToRight()
                }
                scaleDisplayFactorCrop = 1
            }
            idZoomImagePart.x = - ( activeHandleName.x + handleWidth/2 ) * scaleDisplayFactorCrop + idZoomItem.width/2
            idZoomImagePart.y = - ( activeHandleName.y + handleHeight/2 ) * scaleDisplayFactorCrop + idZoomItem.height/2
        }
        else {
            if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
                if (activeHandleName.mouseX >= (idImageLoadedFreecrop.width/2 + zoomItemCenterTolerance/2 ) ) {

                    idZoomItem.reanchorToLeft()
                }
                else if (activeHandleName.mouseX <= (idImageLoadedFreecrop.width/2 - zoomItemCenterTolerance/2 ) ) {
                    idZoomItem.reanchorToRight()
                }
                scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
            }
            else {
                if (activeHandleName.mouseX >= (idImageLoadedFreecrop.sourceSize.width/2 + zoomItemCenterTolerance/2 ) ) {
                    idZoomItem.reanchorToLeft()
                }
                else if (activeHandleName.mouseX <= (idImageLoadedFreecrop.sourceSize.width/2 - zoomItemCenterTolerance/2 ) ) {
                    idZoomItem.reanchorToRight()
                }
                scaleDisplayFactorCrop = 1
            }
            idZoomImagePart.x = - ( mouseCanvasArea.mouseX ) * scaleDisplayFactorCrop + idZoomItem.width/2
            idZoomImagePart.y = - ( mouseCanvasArea.mouseY ) * scaleDisplayFactorCrop + idZoomItem.height/2
        }
    }

    function allSlidersReset() {
        handleWidth = 2 * Theme.paddingLarge
        handleHeight = 2 * Theme.paddingLarge
        idSliderScale.value = 1
        toScaleWidth = idImageLoadedFreecrop.sourceSize.width
        toScaleHeight = idImageLoadedFreecrop.sourceSize.height
        idSliderSharpness.value = 1
        idSliderContrast.value = 1
        idSliderColor.value = 1
        idSliderBrightness.value = 1
        idSliderSprayAmount.value = 200
        idInputManualX1.text = "0"
        idInputManualY1.text = "0"
        idInputManualX2.text = idImageLoadedFreecrop.sourceSize.width
        idInputManualY2.text = idImageLoadedFreecrop.sourceSize.height
        idRotateAngleManualInput.text = "0"
        freeDrawCanvas.clear_canvas()
        freeDrawPolyCoordinates = ""
    }


    function generatePathAndUndoNr() {
        undoNr = undoNr + 1
        inputPathPy = decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") )
        outputPathPy = tempImageFolderPath + origImageFileName + ".tmp" + undoNr + ".png"
    }

    function undoBackwards() {
        undoNr = undoNr - 1
        lastTMP2delete = decodeURIComponent( "/" + idImageLoadedFreecrop.source.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"") )
        if (undoNr <= 0) {
            undoNr = 0
            idImageLoadedFreecrop.source = encodeURI(origImageFilePath)
        }
        else {
            idImageLoadedFreecrop.source = idImageLoadedFreecrop.source.toString().replace(".tmp"+(undoNr+1), ".tmp"+(undoNr))
        }
        allSlidersReset()
        presetCroppingFree()
        py.deleteLastTMPFunction()
    }

    function paintCalculateLinePixels() {
        // rectWidth = x-coordinate of second point, rectHeight = y-coordinate of second point !!!
        var imageRatio = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        if (idLineThicknessSlider.value === 1) { paintLineThickness = idImageLoadedFreecrop.width / 330 * imageRatio }
        if (idLineThicknessSlider.value === 2) { paintLineThickness = idImageLoadedFreecrop.width / 130 * imageRatio }
        if (idLineThicknessSlider.value === 3) { paintLineThickness = idImageLoadedFreecrop.width / 75 * imageRatio }
        if (idLineThicknessSlider.value === 4) { paintLineThickness = idImageLoadedFreecrop.width / 47 * imageRatio }
        if (idLineThicknessSlider.value === 5) { paintLineThickness = idImageLoadedFreecrop.width / 30 * imageRatio }
        if (idLineThicknessSlider.value === 6) { paintLineThickness = idImageLoadedFreecrop.width / 20 * imageRatio }
        if (paintLineThickness <=1) {
            paintLineThickness = 1
        }
        rectX = rectDrag1.x + handleWidth/2
        rectY = rectDrag1.y + handleHeight/2
        rectWidth = rectDrag2.x + handleWidth/2
        rectHeight = rectDrag2.y + handleHeight/2
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else { scaleDisplayFactorCrop = 1 }
    }

    function paintCalculateCanvasPixels() {
        var imageRatio = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        if (idCanvasThicknessSlider.value === 1) { paintCanvasThickness = idImageLoadedFreecrop.width / 330 * imageRatio }
        if (idCanvasThicknessSlider.value === 2) { paintCanvasThickness = idImageLoadedFreecrop.width / 130 * imageRatio }
        if (idCanvasThicknessSlider.value === 3) { paintCanvasThickness = idImageLoadedFreecrop.width / 75 * imageRatio }
        if (idCanvasThicknessSlider.value === 4) { paintCanvasThickness = idImageLoadedFreecrop.width / 47 * imageRatio }
        if (idCanvasThicknessSlider.value === 5) { paintCanvasThickness = idImageLoadedFreecrop.width / 30 * imageRatio }
        if (idCanvasThicknessSlider.value === 6) { paintCanvasThickness = idImageLoadedFreecrop.width / 20 * imageRatio }
        if (paintCanvasThickness <=1) {
            paintCanvasThickness = 1
        }
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else { scaleDisplayFactorCrop = 1 }
    }

    function paintCalculatePointPixels() {
        // rectWidth = x-coordinate of second point, rectHeight = y-coordinates of second point !!!
        if (idPointThicknessSlider.value === 1) {
            rectX = rectDrag1.x + handleWidth/2.5
            rectY = rectDrag1.y + handleHeight/2.5
            rectWidth = (rectDrag1.x + handleWidth) - handleWidth/2.5
            rectHeight = (rectDrag1.y + handleHeight) - handleHeight/2.5
        }
        if (idPointThicknessSlider.value === 2) {
            rectX = rectDrag1.x + handleWidth/3.5
            rectY = rectDrag1.y + handleHeight/3.5
            rectWidth = (rectDrag1.x + handleWidth) - handleWidth/4
            rectHeight = (rectDrag1.y + handleHeight) - handleHeight/4
        }
        if (idPointThicknessSlider.value === 3) {
            rectX = rectDrag1.x + handleWidth/6
            rectY = rectDrag1.y + handleHeight/6
            rectWidth = (rectDrag1.x + handleWidth) - handleWidth/6
            rectHeight = (rectDrag1.y + handleHeight) - handleHeight/6
        }
        if (idPointThicknessSlider.value === 4) {
            rectX = rectDrag1.x
            rectY = rectDrag1.y
            rectWidth = rectDrag1.x + handleWidth
            rectHeight = rectDrag1.y + handleHeight
        }
        if (idPointThicknessSlider.value === 5) {
            rectX = rectDrag1.x - handleWidth/6
            rectY = rectDrag1.y  - handleHeight/6
            rectWidth = (rectDrag1.x + handleWidth) + handleWidth/6
            rectHeight = (rectDrag1.y + handleHeight) + handleHeight/6
        }
        if (idPointThicknessSlider.value === 6) {
            rectX = rectDrag1.x - handleWidth/3
            rectY = rectDrag1.y  - handleHeight/3
            rectWidth = (rectDrag1.x + handleWidth) + handleWidth/3
            rectHeight = (rectDrag1.y + handleHeight) + handleHeight/3
        }
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else { scaleDisplayFactorCrop = 1 }
    }

    function paintCalculateSymbolPixels() {
        rectX = rectDrag1.x + handleWidth/2
        rectY = rectDrag1.y + handleHeight/2
        rectWidth = (rectDrag1.x + handleWidth) - handleWidth/2
        rectHeight = (rectDrag1.y + handleHeight) - handleHeight/2
        if (idImageLoadedFreecrop.sourceSize.width > idImageLoadedFreecrop.width) {
            scaleDisplayFactorCrop = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        }
        else { scaleDisplayFactorCrop = 1 }
    }

    function paintCalculateFrameThickness() {
        var imageRatio = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        if (idFrameThicknessSlider.value === 1) { paintFrameThickness = idImageLoadedFreecrop.width / 330 * imageRatio }
        if (idFrameThicknessSlider.value === 2) { paintFrameThickness = idImageLoadedFreecrop.width / 130 * imageRatio }
        if (idFrameThicknessSlider.value === 3) { paintFrameThickness = idImageLoadedFreecrop.width / 75 * imageRatio }
        if (idFrameThicknessSlider.value === 4) { paintFrameThickness = idImageLoadedFreecrop.width / 47 * imageRatio }
        if (idFrameThicknessSlider.value === 5) { paintFrameThickness = idImageLoadedFreecrop.width / 30 * imageRatio }
        if (idFrameThicknessSlider.value === 6) { paintFrameThickness = idImageLoadedFreecrop.width / 20 * imageRatio }
        if (paintFrameThickness <=1) {
            paintFrameThickness = 1
        }
    }

    function paintCalculateTextSize() {
        var imageRatio = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width

        if (idTextThicknessSlider.value === 1) { paintTextSize = idImageLoadedFreecrop.width / 40 * imageRatio }
        if (idTextThicknessSlider.value === 2) { paintTextSize = idImageLoadedFreecrop.width / 30 * imageRatio }
        if (idTextThicknessSlider.value === 3) { paintTextSize = idImageLoadedFreecrop.width / 21 * imageRatio }
        if (idTextThicknessSlider.value === 4) { paintTextSize = idImageLoadedFreecrop.width / 14 * imageRatio }
        if (idTextThicknessSlider.value === 5) { paintTextSize = idImageLoadedFreecrop.width / 9 * imageRatio }
        if (idTextThicknessSlider.value === 6) { paintTextSize = idImageLoadedFreecrop.width / 5 * imageRatio }
        if (paintTextSize <=15) {
            paintTextSize = 15
        }
    }

    function paintCalculateShapeSize() {
        var imageRatio = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        if (idShapeThicknessSlider.value === 1) { paintSymbolSizeFaktor = 0.33 / 3 }
        if (idShapeThicknessSlider.value === 2) { paintSymbolSizeFaktor = 0.66 / 3 }
        if (idShapeThicknessSlider.value === 3) { paintSymbolSizeFaktor = 0.99 / 3 }
        if (idShapeThicknessSlider.value === 4) { paintSymbolSizeFaktor = 1.33 / 3 }
        if (idShapeThicknessSlider.value === 5) { paintSymbolSizeFaktor = 1.66 / 3 }
        if (idShapeThicknessSlider.value === 6) { paintSymbolSizeFaktor = 1.99 / 3 }
        var symbolPathFull = idComboBoxPaintSymbolPicker.icon.source.toString()
        var newSymbolPathArray = symbolPathFull.split("/")
        symbolSourcePath = "/" + symbolSourceFolder + newSymbolPathArray.slice(-1)[0] + ".png"
    }

    function paintCalculateSprayDiameter() {
        var imageRatio = idImageLoadedFreecrop.sourceSize.width / idImageLoadedFreecrop.width
        if (idSprayThicknessSlider.value === 1) { paintRadiusSpray = handleWidth/80 }
        if (idSprayThicknessSlider.value === 2) { paintRadiusSpray = handleWidth/40 }
        if (idSprayThicknessSlider.value === 3) { paintRadiusSpray = handleWidth/25 }
        if (idSprayThicknessSlider.value === 4) { paintRadiusSpray = handleWidth/14 }
        if (idSprayThicknessSlider.value === 5) { paintRadiusSpray = handleWidth/10 }
        if (idSprayThicknessSlider.value === 6) { paintRadiusSpray = handleWidth/6 }
        if (paintRadiusSpray <=1) {
            paintRadiusSpray = 1
        }
    }

    function paintGetBlurRadius() {
        if (idBlurIntensitySlider.value === 1) { paintBlurRadius = 5 }
        if (idBlurIntensitySlider.value === 2) { paintBlurRadius = 17 }
        if (idBlurIntensitySlider.value === 3) { paintBlurRadius = 30 }
        if (idBlurIntensitySlider.value === 4) { paintBlurRadius = 40 }
        if (idBlurIntensitySlider.value === 5) { paintBlurRadius = 50 }
        if (idBlurIntensitySlider.value === 6) { paintBlurRadius = 60 }
    }

    function hexToRGBA(hex){
    //alphaYes can be given as true or false
        var h = "0123456789abcdef"
        var a = h.indexOf(hex[1])*16+h.indexOf(hex[2])
        var r = h.indexOf(hex[3])*16+h.indexOf(hex[4])
        var g = h.indexOf(hex[5])*16+h.indexOf(hex[6])
        var b = h.indexOf(hex[7])*16+h.indexOf(hex[8])
        idSliderColorRed.value = r
        idSliderColorGreen.value = g
        idSliderColorBlue.value = b
        idSliderColorAlpha.value = a
    }

    function getNormalizationCoefficients(srcPts, dstPts, isInverse){
        // needs file - perspectivetransformationhelper.js
        function round(num){
            return Math.round(num*10000000000)/10000000000
        }
        if(isInverse){
            var tmp = dstPts;
            dstPts = srcPts;
            srcPts = tmp;
        }
        var r1 = [srcPts[0], srcPts[1], 1, 0, 0, 0, -1*dstPts[0]*srcPts[0], -1*dstPts[0]*srcPts[1]];
        var r2 = [0, 0, 0, srcPts[0], srcPts[1], 1, -1*dstPts[1]*srcPts[0], -1*dstPts[1]*srcPts[1]];
        var r3 = [srcPts[2], srcPts[3], 1, 0, 0, 0, -1*dstPts[2]*srcPts[2], -1*dstPts[2]*srcPts[3]];
        var r4 = [0, 0, 0, srcPts[2], srcPts[3], 1, -1*dstPts[3]*srcPts[2], -1*dstPts[3]*srcPts[3]];
        var r5 = [srcPts[4], srcPts[5], 1, 0, 0, 0, -1*dstPts[4]*srcPts[4], -1*dstPts[4]*srcPts[5]];
        var r6 = [0, 0, 0, srcPts[4], srcPts[5], 1, -1*dstPts[5]*srcPts[4], -1*dstPts[5]*srcPts[5]];
        var r7 = [srcPts[6], srcPts[7], 1, 0, 0, 0, -1*dstPts[6]*srcPts[6], -1*dstPts[6]*srcPts[7]];
        var r8 = [0, 0, 0, srcPts[6], srcPts[7], 1, -1*dstPts[7]*srcPts[6], -1*dstPts[7]*srcPts[7]];
        var matA = [r1, r2, r3, r4, r5, r6, r7, r8];
        var matB = dstPts;
        var matC;
        try{
            matC = numeric.inv(numeric.dotMMsmall(numeric.transpose(matA), matA));
        }catch(e){
            //console.log(e);
            return [1,0,0,0,1,0,0,0];
        }
        var matD = numeric.dotMMsmall(matC, numeric.transpose(matA));
        var matX = numeric.dotMV(matD, matB);
        for(var i = 0; i < matX.length; i++) {
            matX[i] = round(matX[i]);
        }
        matX[8] = 1;
        return matX
    }

} // end Page
