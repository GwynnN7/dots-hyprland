import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io

AndroidQuickToggleButton {
    id: root

    name: Translation.tr("Cortana Lamp")
    statusText: (toggled ? Translation.tr("Light is On") : Translation.tr("Light is Off"))
    toggled: toggled
    buttonIcon: "light"

    mainAction: () => {
        root.toggled = !root.toggled
        if (root.toggled) {
            Quickshell.execDetached(["fish", "-c", `cortana -act on "devices lamp"`])
        } else {
            Quickshell.execDetached(["fish", "-c", `cortana -act off "devices lamp"`])
        }
    }
    Process {
        id: fetchActiveState
        running: true
        command: ["fish", "-c", 'string match -q "*On*" (cortana "devices lamp")']
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode === 0
        }
    }
    StyledToolTip {
        text: Translation.tr("Cortana Lamp")
    }
}
