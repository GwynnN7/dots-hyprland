import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io

AndroidQuickToggleButton {
    id: root

    name: Translation.tr("Motion Detection")
    statusText: (toggled ? Translation.tr("Motion Detection On") : Translation.tr("Motion Detection Off"))
    toggled: toggled
    buttonIcon: "eye_tracking"

    mainAction: () => {
        root.toggled = !root.toggled
        if (root.toggled) {
            Quickshell.execDetached(["fish", "-c", `cortana -val 1 "settings motiondetection"`])
        } else {
            Quickshell.execDetached(["fish", "-c", `cortana -val 0 "settings motiondetection"`])
        }
    }
    Process {
        id: fetchActiveState
        running: true
        command: ["fish", "-c", 'string match -q "*On*" (cortana "settings motiondetection")']
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode === 0
        }
    }
    StyledToolTip {
        text: Translation.tr("Motion Detection")
    }
}
