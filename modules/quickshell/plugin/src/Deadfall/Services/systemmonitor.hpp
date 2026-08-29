#pragma once

#include <QFutureWatcher>
#include <QObject>
#include <QQmlEngine>
#include <QTimer>

namespace deadfall {

struct Sample {
    double cpu = 0;
    double mem = 0;
};

class SystemMonitor : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(double cpuUsage READ cpuUsage NOTIFY sampled)
    Q_PROPERTY(double memUsage READ memUsage NOTIFY sampled)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    [[nodiscard]] double cpuUsage() const { return m_last.cpu; }
    [[nodiscard]] double memUsage() const { return m_last.mem; }

    // Reference counting so the timer only runs while something is watching.
    Q_INVOKABLE void watch();
    Q_INVOKABLE void unwatch();

signals:
    void sampled();

private:
    void tick();
    Sample sample();

    QTimer m_timer;
    QFutureWatcher<Sample> m_watcher;
    Sample m_last;
    quint64 m_prevTotal = 0;
    quint64 m_prevIdle = 0;
    int m_watchers = 0;
};

} // namespace deadfall
