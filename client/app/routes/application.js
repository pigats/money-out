import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
    session: Ember.inject.service('session'),
    me: Ember.inject.service('current-user'),
    routeAfterAuthentication: 'expenses.index',

    beforeModel() {
        this.get('me').load();
        if(this.get('session.isAuthenticated')) {
            this.transitionTo('expenses.index');
        } else {
            this.transitionTo('users.new');
        }
    },

    sessionAuthenticated() {
        let _super = this._super.bind(this);
        this.get('me').load().then(() => _super());
    }
});
