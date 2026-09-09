pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Usage-history ranking for launcher results: how often and how recently
// each result id was activated, persisted so it survives shell restarts.
// Deliberately just a flat JSON file rather than a database — the dataset
// (a few hundred ids at most) never gets big enough to need one.
Singleton {
    id: root

    property var entries: ({})

    // Half-life for the recency decay: an id used this long ago contributes
    // half as much boost as one used just now.
    readonly property real halfLifeMs: 3 * 24 * 60 * 60 * 1000
    readonly property string storeDir: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/deadfall"
    readonly property string storePath: root.storeDir + "/frecency.json"

    function recordUse(id) {
        if (!id)
            return;
        const existing = root.entries[id] || {
            count: 0,
            lastUsed: 0
        };
        const updated = Object.assign({}, root.entries);
        updated[id] = {
            count: existing.count + 1,
            lastUsed: Date.now()
        };
        root.entries = updated;
        file.setText(JSON.stringify(root.entries));
    }

    // A small additive boost, roughly 0..0.5, meant to nudge fuzzy-rank
    // ordering rather than override it: a handful of recent uses should
    // move a result up a few slots, not guarantee first place.
    function score(id) {
        if (!id)
            return 0;
        const entry = root.entries[id];
        if (!entry)
            return 0;
        const recency = Math.pow(0.5, (Date.now() - entry.lastUsed) / root.halfLifeMs);
        return Math.min(entry.count, 20) / 20 * recency * 0.5;
    }

    Component.onCompleted: Quickshell.execDetached(["mkdir", "-p", root.storeDir])

    FileView {
        id: file

        path: root.storePath
        printErrors: false
        watchChanges: false

        onLoadFailed: root.entries = {}
        onLoaded: {
            try {
                root.entries = JSON.parse(text());
            } catch (e) {
                root.entries = {};
            }
        }
    }
}
