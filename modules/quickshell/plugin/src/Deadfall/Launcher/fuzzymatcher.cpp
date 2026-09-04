#include "fuzzymatcher.hpp"

#include <algorithm>
#include <numeric>

namespace deadfall {

namespace {

constexpr int kNoMatch = -1;
constexpr int kMatchScore = 1;
constexpr int kConsecutiveBonus = 15;
constexpr int kWordBoundaryBonus = 10;
constexpr int kGapPenalty = 1;

bool isWordBoundary(const QString &s, qsizetype pos) {
    if (pos <= 0) return true;
    return !s.at(pos - 1).isLetterOrNumber();
}

// Greedy leftmost subsequence match: each query character is matched to the
// earliest possible position after the previous match, scored with bonuses
// for word boundaries and consecutive runs. Not globally optimal, but cheap
// and good enough for launcher-sized candidate lists re-ranked every keystroke.
int score(const QString &query, const QString &haystack) {
    if (query.isEmpty()) return 0;

    const QString needle = query.toCaseFolded();
    const QString hay = haystack.toCaseFolded();

    int total = 0;
    qsizetype cursor = 0;
    qsizetype lastMatch = -1;

    for (const QChar &qc : needle) {
        const qsizetype found = hay.indexOf(qc, cursor);
        if (found < 0) return kNoMatch;

        total += kMatchScore;
        if (isWordBoundary(hay, found)) total += kWordBoundaryBonus;
        if (lastMatch >= 0) {
            if (found == lastMatch + 1) {
                total += kConsecutiveBonus;
            } else {
                total -= static_cast<int>(found - lastMatch - 1) * kGapPenalty;
            }
        }

        lastMatch = found;
        cursor = found + 1;
    }

    return total;
}

} // namespace

QList<int> FuzzyMatcher::rank(const QString &query, const QStringList &haystack) const {
    QList<int> indices(haystack.size());
    std::iota(indices.begin(), indices.end(), 0);

    if (query.isEmpty()) return indices;

    QList<int> scores(haystack.size());
    for (qsizetype i = 0; i < haystack.size(); ++i) {
        scores[i] = score(query, haystack.at(i));
    }

    QList<int> matched;
    matched.reserve(indices.size());
    for (const int i : indices) {
        if (scores[i] != kNoMatch) matched.append(i);
    }

    std::sort(matched.begin(), matched.end(), [&scores](int a, int b) {
        return scores[a] > scores[b];
    });

    return matched;
}

} // namespace deadfall
