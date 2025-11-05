pragma Singleton
import Quickshell
import qs.services
import qs.modules.common

Singleton {
    id: root

    function closeAllWindows() {
        HyprlandData.windowList.map(w => w.pid).forEach(pid => {
            Quickshell.execDetached(["kill", pid]);
        });
    }

    function rebootToWindows() {
        closeAllWindows();
        Quickshell.execDetached(["fish", "-c", Config.options.ai.cortanaSession ? "cortana -cmd system computer || reboot || loginctl reboot" : "reboot || loginctl reboot"]);
    }

    function suspend() {
        Quickshell.execDetached(["fish", "-c", Config.options.ai.cortanaSession ? "cortana -cmd suspend computer || systemctl suspend || loginctl suspend" : "systemctl suspend || loginctl suspend"]);
    }
    function logout() {
        closeAllWindows();
        Quickshell.execDetached(["pkill", "-i", "Hyprland"]);
    }

    function launchTaskManager() {
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.taskManager}`]);
    }

    function hibernate() {
        Quickshell.execDetached(["bash", "-c", `systemctl hibernate || loginctl hibernate`]);
    }

    function poweroff() {
        closeAllWindows();
        Quickshell.execDetached(["fish", "-c", Config.options.ai.cortanaSession ? "cortana -cmd shutdown computer || systemctl poweroff || loginctl poweroff" : "systemctl poweroff || loginctl poweroff"]);
    }

    function reboot() {
        closeAllWindows();
        Quickshell.execDetached(["fish", "-c", Config.options.ai.cortanaSession ? "cortana -cmd reboot computer || reboot || loginctl reboot" : "reboot || loginctl reboot"]);
    }

    function rebootToFirmware() {
        closeAllWindows();
        Quickshell.execDetached(["bash", "-c", `systemctl reboot --firmware-setup || loginctl reboot --firmware-setup`]);
    }
}
