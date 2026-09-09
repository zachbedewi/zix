pragma Singleton

import QtQuick
import Quickshell

import qs.modules.launcher.providers

Singleton {
    id: root

    // Providers with a non-empty `prefix` only run when the query starts
    // with it (case-insensitively) — that's what keeps niche providers like
    // clipboard history or SSH hosts from cluttering every search. The
    // first matching prefix wins and runs exclusively; otherwise every
    // always-on provider (empty prefix) runs.
    readonly property var activeProviders: {
        const trimmed = root.queryText.replace(/^\s+/, "");
        for (const provider of root.providers) {
            const prefix = provider.prefix ?? "";
            if (prefix.length > 0 && trimmed.toLowerCase().startsWith(prefix.toLowerCase())) {
                return [provider];
            }
        }
        return root.providers.filter(p => (p.prefix ?? "").length === 0);
    }
    property AppProvider appProvider: AppProvider {
    }
    property CalculatorProvider calculatorProvider: CalculatorProvider {
    }
    property ClipboardProvider clipboardProvider: ClipboardProvider {
    }
    property CommandProvider commandProvider: CommandProvider {
    }
    property EmojiProvider emojiProvider: EmojiProvider {
    }
    property FileSearchProvider fileSearchProvider: FileSearchProvider {
    }

    // A result awaiting a second Enter before it actually runs (see
    // activateSelected). Non-null replaces `results` with a single
    // confirmation entry, which is what makes destructive actions
    // (shutdown, etc.) require two presses instead of one.
    property var pendingConfirm: null
    readonly property string placeholderHint: {
        const prefixes = root.providers.map(p => (p.prefix ?? "").trim()).filter(p => p.length > 0);
        return prefixes.length === 0 ? "Search apps, run a calculation…" : `Search apps, run a calculation, or try ${prefixes.join(", ")}…`;
    }
    property PowerProvider powerProvider: PowerProvider {
    }

    // Add new providers here as they're built; everything else (prefix
    // dispatch, placeholder hint, ranking) is data-driven off this list.
    property var providers: [appProvider, calculatorProvider, powerProvider, webSearchProvider, clipboardProvider, fileSearchProvider, sshProvider, emojiProvider, commandProvider]
    property string queryText: ""
    readonly property var results: {
        if (root.pendingConfirm) {
            const target = root.pendingConfirm;
            return [
                {
                    id: target.id,
                    title: `Press Enter again to confirm: ${target.confirmLabel ?? target.title}`,
                    subtitle: "Escape to cancel",
                    icon: target.icon ?? "",
                    confirmPending: true,
                    activate: target.activate
                }
            ];
        }

        if (root.queryText.trim().length === 0)
            return [];

        let combined = [];
        for (const provider of root.activeProviders) {
            combined = combined.concat(provider.query(root.strippedQuery(provider)));
        }

        // Each provider already returns its own results best-first; blend
        // that ordering with frecency rather than letting frecency override
        // it outright, so a handful of past uses nudges rank without
        // guaranteeing first place.
        const ranked = combined.map((result, index) => ({
                    result,
                    score: 1 / (index + 1) + FrecencyStore.score(result.id)
                }));
        ranked.sort((a, b) => b.score - a.score);

        return ranked.map(r => r.result).slice(0, 30);
    }
    property int selectedIndex: 0
    property SshProvider sshProvider: SshProvider {
    }
    // Compared by name rather than object identity: a ShellScreen read from
    // Quickshell.screens in one place isn't guaranteed to be === one read
    // elsewhere, even for the same output.
    property string targetScreenName: ""
    property bool visible: false
    property WebSearchProvider webSearchProvider: WebSearchProvider {
    }

    function activateSelected() {
        const result = root.results[root.selectedIndex];
        if (!result)
            return;

        if (result.confirmPending) {
            result.activate();
            FrecencyStore.recordUse(result.id);
            root.pendingConfirm = null;
            root.close();
            return;
        }

        if (result.requiresConfirm) {
            root.pendingConfirm = result;
            root.selectedIndex = 0;
            return;
        }

        result.activate();
        FrecencyStore.recordUse(result.id);
        root.close();
    }
    function cancelConfirmOrClose() {
        if (root.pendingConfirm) {
            root.pendingConfirm = null;
        } else {
            root.close();
        }
    }
    function close() {
        root.visible = false;
        root.pendingConfirm = null;
    }
    function moveSelection(delta) {
        if (root.results.length === 0)
            return;
        root.selectedIndex = (root.selectedIndex + delta + root.results.length) % root.results.length;
    }
    function open(screen) {
        root.targetScreenName = screen ? screen.name : "";
        root.queryText = "";
        root.selectedIndex = 0;
        root.pendingConfirm = null;
        root.visible = true;
    }
    function strippedQuery(provider) {
        const prefix = provider.prefix ?? "";
        if (prefix.length === 0)
            return root.queryText;
        return root.queryText.replace(/^\s+/, "").slice(prefix.length);
    }
    function toggle(screen) {
        if (root.visible) {
            root.close();
        } else {
            root.open(screen);
        }
    }

    onQueryTextChanged: {
        root.selectedIndex = 0;
        root.pendingConfirm = null;
    }
}
