import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: root

    readonly property var actions: [
        {
            id: "power:lock",
            title: "Lock",
            subtitle: "Lock the screen",
            icon: "",
            activate: () => Quickshell.execDetached(["hyprlock"])
        },
        {
            id: "power:suspend",
            title: "Suspend",
            subtitle: "Suspend the system",
            icon: "",
            activate: () => Quickshell.execDetached(["systemctl", "suspend"])
        },
        {
            id: "power:logout",
            title: "Logout",
            subtitle: "End the current session",
            icon: "",
            activate: () => Hyprland.dispatch("exit"),
            requiresConfirm: true
        },
        {
            id: "power:reboot",
            title: "Reboot",
            subtitle: "Restart the system",
            icon: "",
            activate: () => Quickshell.execDetached(["systemctl", "reboot"]),
            requiresConfirm: true
        },
        {
            id: "power:shutdown",
            title: "Shutdown",
            subtitle: "Power off the system",
            icon: "",
            activate: () => Quickshell.execDetached(["systemctl", "poweroff"]),
            requiresConfirm: true
        }
    ]

    // Always-on: power actions should be findable by typing their name any
    // time — only 5 possible results, so there's no noise concern.
    readonly property string prefix: ""

    function query(text) {
        const needle = text.trim().toLowerCase();
        if (needle.length === 0)
            return root.actions;

        const prefixMatches = root.actions.filter(a => a.title.toLowerCase().startsWith(needle));
        const substringMatches = root.actions.filter(a => !a.title.toLowerCase().startsWith(needle) && a.title.toLowerCase().includes(needle));
        return prefixMatches.concat(substringMatches);
    }
}
