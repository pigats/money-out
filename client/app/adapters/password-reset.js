import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
    pathForType(type) {
        return `users/${type}`;
    },

    createRecord(store, type, snapshot) {
        var data = {};
        var serializer = store.serializerFor(type.modelName);
        var url = this.buildURL(type.modelName, null, snapshot, 'createRecord');

        var method = 'POST';
        if(snapshot.adapterOptions && snapshot.adapterOptions.method) {
        method = snapshot.adapterOptions.method.toUpperCase();
        }
        serializer.serializeIntoHash(data, type, snapshot, { includeId: true });

    
        return this.ajax(url, method, { data: data });
    }
});
