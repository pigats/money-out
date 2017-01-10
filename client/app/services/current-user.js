import Ember from 'ember';

export default Ember.Service.extend({
    session: Ember.inject.service('session'),
    store: Ember.inject.service('store'),
    user: null,

    load() {
        if(this.get('session.isAuthenticated')) {
            return this.get('store').queryRecord('user', { me: true }).then(user => this.set('user', user)).catch(() => this.get('session').invalidate());
        }
    }
});
