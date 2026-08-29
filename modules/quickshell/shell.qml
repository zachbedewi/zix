//@ pragma UseQApplication
//@ pragma ShellId deadfall

import QtQml
import Quickshell
import Deadfall.Services

import qs.modules.bar

ShellRoot {
    id: root

    Component.onCompleted: {
        SystemMonitor.watch();
        SystemMonitor.sampled.connect(() => {
            console.log(`SystemMonitor: cpu=${SystemMonitor.cpuUsage.toFixed(1)}% mem=${SystemMonitor.memUsage.toFixed(1)}%`);
            SystemMonitor.unwatch();
        });
    }

    Variants {
        model: Quickshell.screens

        Bar {
            required property ShellScreen modelData
            screen: modelData
        }
    }
}
