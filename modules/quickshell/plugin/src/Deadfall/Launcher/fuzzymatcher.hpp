#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QStringList>

namespace deadfall {

// Stateless fuzzy-ranking utility for launcher providers. Quickshell's
// DesktopEntries already does desktop-entry parsing and launching; the one
// thing left that's worth doing in C++ is re-scoring a candidate list on
// every keystroke, which is cheap here but adds up in JS across hundreds of
// entries.
class FuzzyMatcher : public QObject {
    Q_OBJECT
    QML_ELEMENT

public:
    using QObject::QObject;

    // Returns indices into `haystack`, best match first, for entries where
    // every character of `query` appears in order (case-insensitively).
    // Non-matching entries are omitted. An empty query matches everything
    // in its original order.
    Q_INVOKABLE [[nodiscard]] QList<int> rank(const QString &query, const QStringList &haystack) const;
};

} // namespace deadfall
