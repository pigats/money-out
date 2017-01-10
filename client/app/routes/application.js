import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
    currentUser: Ember.inject.service('current-user'),
    routeAfterAuthentication: 'expenses.index',

    beforeModel() {
        return this.get('currentUser').load();
    },

    sessionAuthenticated() {
        let _super = this._super.bind(this);
        this.get('currentUser').load().then(() => _super());
    }
});
