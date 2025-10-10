pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root

    property string screenshotDir: "/tmp/quickshell-screenshots"

    property color overlayColor: "#77111111"
    property color selectionBorderColor: "#ddffffff"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow

            required property var modelData

            property string screenshotPath: `${root.screenshotDir}/screenshot-${panelWindow.modelData.name}.png`

            property real dragStartX: 0
            property real dragStartY: 0

            property real draggingX: 0
            property real draggingY: 0

            property bool dragging: false
            property var mouseButton: null

            property real regionWidth: Math.abs(draggingX - dragStartX)
            property real regionHeight: Math.abs(draggingY - dragStartY)

            property real regionX: Math.min(dragStartX, draggingX)
            property real regionY: Math.min(dragStartY, draggingY)

            visible: false

            screen: panelWindow.modelData

            WlrLayershell.namespace: "quickshell:screenshot"
            WlrLayershell.layer: WlrLayer.Overlay

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            exclusionMode: ExclusionMode.Ignore

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            Process {
                id: screenshotProcess
                running: true

                command: ["bash", "-c", `mkdir -p ${root.screenshotDir} ` + `&& grim -o ${panelWindow.modelData.name} ${panelWindow.screenshotPath}`]

                onExited: exitCode => {
                    if (exitCode === 0) {
                        panelWindow.visible = true;
                    } else {
                        console.log("Screenshot failed with exit code:", exitCode);
                        Qt.quit();
                    }
                }
            }

            Process {
                id: snipProc

                function snip() {
                    if (panelWindow.regionWidth <= 0 || panelWindow.regionHeight <= 0) {
                        console.warn("Invalid region size, skipping snip");
                        Qt.quit();
                        return;
                    }

                    snipProc.startDetached();
                    Qt.quit();
                }

                command: ["bash", "-c", `magick '${panelWindow.screenshotPath}' ` + `-crop '${Math.round(panelWindow.regionWidth)}x${Math.round(panelWindow.regionHeight)}+${Math.round(panelWindow.regionX)}+${Math.round(panelWindow.regionY)}' - ` + `| ${panelWindow.mouseButton === Qt.LeftButton ? "wl-copy" : "swappy -f -"}`]
            }

            ScreencopyView {
                anchors.fill: parent
                live: false

                captureSource: panelWindow.modelData
                focus: panelWindow.visible

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        Qt.quit();
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    cursorShape: Qt.CrossCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onPressed: mouse => {
                        panelWindow.dragStartX = mouse.x;
                        panelWindow.dragStartY = mouse.y;

                        panelWindow.draggingX = mouse.x;
                        panelWindow.draggingY = mouse.y;

                        panelWindow.dragging = true;
                        panelWindow.mouseButton = mouse.button;
                    }

                    onReleased: mouse => {
                        snipProc.snip();
                    }

                    onPositionChanged: mouse => {
                        if (panelWindow.dragging) {
                            panelWindow.draggingX = mouse.x;
                            panelWindow.draggingY = mouse.y;
                        }
                    }

                    Rectangle {
                        id: darkenOverlay
                        z: 1

                        anchors {
                            left: parent.left
                            top: parent.top
                            leftMargin: panelWindow.regionX - darkenOverlay.border.width
                            topMargin: panelWindow.regionY - darkenOverlay.border.width
                        }

                        width: panelWindow.regionWidth + darkenOverlay.border.width * 2
                        height: panelWindow.regionHeight + darkenOverlay.border.width * 2

                        color: "transparent"
                        border.color: root.overlayColor

                        border.width: Math.max(panelWindow.width, panelWindow.height)

                        // radius: 4
                    }

                    Rectangle {
                        id: selectionBorder
                        z: 2

                        anchors {
                            left: parent.left
                            top: parent.top
                            leftMargin: panelWindow.regionX
                            topMargin: panelWindow.regionY
                        }

                        width: panelWindow.regionWidth
                        height: panelWindow.regionHeight

                        color: "transparent"

                        border.color: root.selectionBorderColor
                        border.width: 2

                        radius: 0
                    }

                    Text {
                        z: 3

                        anchors {
                            bottom: selectionBorder.bottom
                            right: selectionBorder.right
                            margins: 8
                        }

                        visible: panelWindow.regionWidth > 0 && panelWindow.regionHeight > 0

                        text: `${Math.round(panelWindow.regionWidth)} × ${Math.round(panelWindow.regionHeight)}`

                        color: "#ffffff"
                        font.pixelSize: 14

                        style: Text.Outline
                        styleColor: "#000000"
                    }
                }
            }
        }
    }
}
