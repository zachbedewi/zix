import QtQuick
import Quickshell

import Deadfall.Launcher

// Wraps Quickshell's own DesktopEntries service (parsing, icon resolution,
// terminal-aware launching all handled there already) and adds the one
// thing it doesn't do: fuzzy-ranking the entries against a query.
QtObject {
    id: root

    property FuzzyMatcher matcher: FuzzyMatcher {
    }

    // Always-on: apps are the launcher's default mode, not gated behind a
    // prefix.
    readonly property string prefix: ""

    function query(text) {
        const apps = DesktopEntries.applications.values.filter(e => !e.noDisplay);
        const haystack = apps.map(e => e.name + " " + e.genericName);
        const ranked = root.matcher.rank(text, haystack);

        return ranked.map(i => {
            const entry = apps[i];
            return {
                id: `app:${entry.id}`,
                title: entry.name,
                subtitle: entry.comment.length > 0 ? entry.comment : entry.genericName,
                icon: entry.icon,
                activate: () => entry.execute()
            };
        });
    }
}
