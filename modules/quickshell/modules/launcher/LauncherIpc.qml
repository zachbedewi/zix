import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

// `qs ipc call launcher toggle|open|close`, meant to be bound to a
// compositor key (see modules/hyprland/config/modules/40-binds.lua).
// Wrapped in a plain QtObject so only toggle/open/close are exposed as IPC
// targets — a function declared directly on an IpcHandler is callable via
// IPC, and focusedShellScreen() below is an internal helper, not API.
QtObject {
    id: root

    function focusedShellScreen() {
        for (const screen of Quickshell.screens) {
            if (Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) return screen;
        }
        return Quickshell.screens.length > 0 ? Quickshell.screens[0] : null;
    }

    property IpcHandler handler: IpcHandler {
        target: "launcher"

        function toggle(): void {
            LauncherController.toggle(root.focusedShellScreen());
        }

        function open(): void {
            LauncherController.open(root.focusedShellScreen());
        }

        function close(): void {
            LauncherController.close();
        }
    }
}
