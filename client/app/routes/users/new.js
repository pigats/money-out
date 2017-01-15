import Ember from 'ember';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
    routeIfAlreadyAuthenticated: 'expenses.index',

    model() {
        return this.get('store').createRecord('user');
    },

    actions: {
        willTransition() {
            this.get('currentModel').rollbackAttributes();
            this._super(...arguments);
        }
    }
});
