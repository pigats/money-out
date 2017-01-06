import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
    session: Ember.inject.service('session'),
    currentUser: Ember.inject.service('current-user'),

    beforeModel() {
        return this.get('currentUser').load();
    },

    sessionAuthenticated() {
        this._super(...arguments);
        return this.get('currentUser').load();
    }
});
