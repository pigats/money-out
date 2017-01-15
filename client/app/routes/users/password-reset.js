import Ember from 'ember';

export default Ember.Route.extend({
    queryParams: {
        email: {
            refreshModel: true
        }
    },

    model(params) {
        return this.get('store').createRecord('password-reset', params);
    }
});
