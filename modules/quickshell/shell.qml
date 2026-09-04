//@ pragma UseQApplication
//@ pragma ShellId deadfall

import QtQml
import Quickshell

import qs.modules.bar
import qs.modules.launcher
import qs.modules.shell

ShellRoot {
    id: root

    LauncherIpc {}

    Variants {
        model: Quickshell.screens

        Bar {
            required property ShellScreen modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        UnifiedShellPanel {
            required property ShellScreen modelData
            hostScreen: modelData
        }
    }
}
