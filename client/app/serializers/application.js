import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({    serializeAttribute(snapshot, json, key, attributes) {
        if((snapshot.record.get('isNew') || snapshot.changedAttributes()[key]) && snapshot.attr(key)) {
            this._super(...arguments); 
        }
    }
});
