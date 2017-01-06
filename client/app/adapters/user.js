import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
    urlForQueryRecord(query) {
        let url = this._super(...arguments);
        if(query.me) {
            delete query.me;
            url += '/me';
        }
        return url;
    }
});
