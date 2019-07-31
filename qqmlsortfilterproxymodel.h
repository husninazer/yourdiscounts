#ifndef QQMLSORTFILTERPROXYMODEL_H
#define QQMLSORTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QQmlExpression>

class QQmlSortFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString filterRoleName READ filterRoleName WRITE setFilterRoleName NOTIFY filterRoleNameChanged)
    Q_PROPERTY(QString filterPattern READ filterPattern WRITE setFilterPattern NOTIFY filterPatternChanged)
    Q_PROPERTY(PatternSyntax filterPatternSyntax READ filterPatternSyntax WRITE setFilterPatternSyntax NOTIFY filterPatternSyntaxChanged)
    Q_PROPERTY(QVariant filterValue READ filterValue WRITE setFilterValue NOTIFY filterValueChanged)
    Q_PROPERTY(QQmlScriptString filterExpression READ filterExpression WRITE setFilterExpression NOTIFY filterExpressionChanged)

    Q_PROPERTY(QString sortRoleName READ sortRoleName WRITE setSortRoleName NOTIFY sortRoleNameChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder)
    Q_PROPERTY(QQmlScriptString sortExpression READ sortExpression WRITE setSortExpression NOTIFY sortExpressionChanged)

public:
    enum PatternSyntax {
        RegExp = QRegExp::RegExp,
        Wildcard = QRegExp::Wildcard,
        FixedString = QRegExp::FixedString,
        RegExp2 = QRegExp::RegExp2,
        WildcardUnix = QRegExp::WildcardUnix,
        W3CXmlSchema11 = QRegExp::W3CXmlSchema11 };
    Q_ENUMS(PatternSyntax)

    QQmlSortFilterProxyModel(QObject* parent = 0);

    int count() const;

    const QString& filterRoleName() const;
    void setFilterRoleName(const QString& filterRoleName);

    QString filterPattern() const;
    void setFilterPattern(const QString& filterPattern);

    PatternSyntax filterPatternSyntax() const;
    void setFilterPatternSyntax(PatternSyntax patternSyntax);

    const QVariant& filterValue() const;
    void setFilterValue(const QVariant& filterValue);

    const QQmlScriptString& filterExpression() const;
    void setFilterExpression(const QQmlScriptString& filterScriptString);

    const QString& sortRoleName() const;
    void setSortRoleName(const QString& sortRoleName);

    void setSortOrder(Qt::SortOrder sortOrder);

    const QQmlScriptString& sortExpression() const;
    void setSortExpression(const QQmlScriptString& compareScriptString);

    Q_INVOKABLE QVariantMap get(int row);


signals:
    void countChanged();

    void filterRoleNameChanged();
    void filterPatternSyntaxChanged();
    void filterPatternChanged();
    void filterValueChanged();
    void filterExpressionChanged();

    void sortRoleNameChanged();
    void sortExpressionChanged();

protected:
    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const;
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const;

private slots:
    void invalidateFilter();
    void updateFilterRole();
    void updateSortRole();
    void updateRoles();

private:
    QVariantMap modelDataMap(const QModelIndex& modelIndex) const;

    QString m_filterRoleName;
    QString m_sortRoleName;

    QQmlScriptString m_filterScriptString;
    QQmlExpression* m_filterExpression;

    QQmlScriptString m_compareScriptString;
    QQmlExpression* m_compareExpression;
    QVariant m_filterValue;
};

#endif // QQMLSORTFILTERPROXYMODEL_H

