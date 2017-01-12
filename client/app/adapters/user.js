import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
    urlForQueryRecord(query) {
        let url = this._super(...arguments);
        if(query.me) {
            delete query.me;
            url += '/me';
        }
        return url;
    },

    urlForUpdateRecord(id, modelName, snapshot) {
        let url = this._super(...arguments);
        if(snapshot.adapterOptions && snapshot.adapterOptions.confirm) {
            url += '/confirm';
        }
        return url;
    }
});
