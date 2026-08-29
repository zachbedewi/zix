#include "systemmonitor.hpp"

#include <QFile>
#include <QRegularExpression>
#include <QTextStream>
#include <QtConcurrent/QtConcurrent>

namespace deadfall {

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent) {
    m_timer.setInterval(2000);
    connect(&m_timer, &QTimer::timeout, this, &SystemMonitor::tick);

    connect(&m_watcher, &QFutureWatcher<Sample>::finished, this, [this] {
        m_last = m_watcher.result();
        emit sampled();
    });
}

void SystemMonitor::watch() {
    if (++m_watchers == 1) {
        m_prevTotal = 0;
        m_prevIdle = 0;
        m_timer.start();
        tick();
    }
}

void SystemMonitor::unwatch() {
    if (m_watchers > 0 && --m_watchers == 0) m_timer.stop();
}

void SystemMonitor::tick() {
    if (m_watcher.isRunning()) return;
    m_watcher.setFuture(QtConcurrent::run([this] { return sample(); }));
}

Sample SystemMonitor::sample() {
    Sample out = m_last;

    QFile stat("/proc/stat");
    if (stat.open(QIODevice::ReadOnly | QIODevice::Text)) {
        const QString line = QString::fromUtf8(stat.readLine());
        const QStringList fields =
            line.trimmed().split(QRegularExpression("\\s+")).mid(1);

        quint64 total = 0;
        for (const QString &field : fields) total += field.toULongLong();

        if (fields.size() >= 5) {
            const quint64 idle = fields[3].toULongLong() + fields[4].toULongLong();
            if (m_prevTotal > 0 && total > m_prevTotal) {
                const quint64 dTotal = total - m_prevTotal;
                const quint64 dIdle = idle - m_prevIdle;
                out.cpu = (1.0 - static_cast<double>(dIdle) / static_cast<double>(dTotal)) * 100.0;
            }
            m_prevTotal = total;
            m_prevIdle = idle;
        }
    }

    QFile meminfo("/proc/meminfo");
    if (meminfo.open(QIODevice::ReadOnly | QIODevice::Text)) {
        quint64 total = 0;
        quint64 available = 0;
        QTextStream in(&meminfo);
        while (!in.atEnd()) {
            const QString line = in.readLine();
            if (line.startsWith("MemTotal:")) {
                total = line.split(QRegularExpression("\\s+")).value(1).toULongLong();
            } else if (line.startsWith("MemAvailable:")) {
                available = line.split(QRegularExpression("\\s+")).value(1).toULongLong();
            }
        }
        if (total > 0) {
            out.mem = static_cast<double>(total - available) / static_cast<double>(total) * 100.0;
        }
    }

    return out;
}

} // namespace deadfall
