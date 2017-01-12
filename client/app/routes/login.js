import Ember from 'ember';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
    routeIfAlreadyAuthenticated: 'expenses.index',
    setupController() {
        this._super(...arguments);
        this.controllerFor('application').set('isLogin', true);
    },

    actions: {
        willTransition() {
            this.controllerFor('application').set('isLogin', false);
            this._super(...arguments);
        }
    }
});
