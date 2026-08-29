//@ pragma UseQApplication
//@ pragma ShellId zix

import Quickshell

import qs.modules.bar

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {
            required property ShellScreen modelData
            screen: modelData
        }
    }
}
