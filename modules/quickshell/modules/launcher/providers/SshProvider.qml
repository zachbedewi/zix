import QtQuick
import Quickshell
import Quickshell.Io

// Gated behind "ssh ": SSH hosts pulled from ~/.ssh/config would otherwise
// clutter every search alongside apps/calculator/web search.
QtObject {
    id: root

    property var hosts: []
    readonly property string prefix: "ssh "

    // Each `Host` line starts a new block of aliases; HostName/User lines
    // that follow (until the next Host line) apply to all of them, matching
    // ssh_config's own block semantics closely enough for display purposes.
    function parseConfig(text) {
        const hosts = [];
        let current = [];

        for (const line of text.split("\n")) {
            const trimmed = line.trim();

            const hostMatch = trimmed.match(/^Host\s+(.+)$/i);
            if (hostMatch) {
                current = hostMatch[1].split(/\s+/).filter(a => a.length > 0 && !a.includes("*") && !a.includes("?")).map(alias => ({
                            alias,
                            hostName: "",
                            user: ""
                        }));
                hosts.push(...current);
                continue;
            }

            const hostNameMatch = trimmed.match(/^HostName\s+(\S+)$/i);
            if (hostNameMatch) {
                for (const h of current)
                    h.hostName = hostNameMatch[1];
                continue;
            }

            const userMatch = trimmed.match(/^User\s+(\S+)$/i);
            if (userMatch) {
                for (const h of current)
                    h.user = userMatch[1];
            }
        }

        return hosts;
    }
    function query(text) {
        const needle = text.trim().toLowerCase();
        const candidates = needle.length === 0 ? root.hosts : root.hosts.filter(h => h.alias.toLowerCase().includes(needle));

        const prefixMatches = candidates.filter(h => h.alias.toLowerCase().startsWith(needle));
        const substringMatches = candidates.filter(h => !h.alias.toLowerCase().startsWith(needle));
        return prefixMatches.concat(substringMatches).map(root.toResult);
    }
    function toResult(host) {
        return {
            id: `ssh:${host.alias}`,
            title: host.alias,
            subtitle: host.hostName.length > 0 ? (host.user.length > 0 ? `${host.user}@${host.hostName}` : host.hostName) : "SSH host",
            icon: "",
            activate: () => Quickshell.execDetached(["kitty", "ssh", host.alias])
        };
    }

    property FileView file: FileView {
        path: Quickshell.env("HOME") + "/.ssh/config"
        printErrors: false
        watchChanges: true

        onFileChanged: reload()
        onLoadFailed: root.hosts = []
        onLoaded: root.hosts = root.parseConfig(text())
    }
}
