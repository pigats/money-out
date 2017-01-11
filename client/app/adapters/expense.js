import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
    scopeWithUser(url, userId) {
        return url.replace(this.get('namespace'), `${this.get('namespace')}/users/${userId}`);
    },

    urlForCreateRecord(modelName, snapshot) {
        return this.scopeWithUser(this._super(...arguments), snapshot.belongsTo('user', { id: true }));
    },

    urlForQuery(query, modelName) {
        let userId = query.userId;
        delete query.userId;
        return this.scopeWithUser(this._super(...arguments), userId);
    }

});
