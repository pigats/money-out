import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
    me: Ember.inject.service('current-user'),

    setupController() {
        this._super(...arguments);
        this.get('controller').send('filter');
    },

    model() {
        return this.get('me').user.get('expenses');
    }
});
